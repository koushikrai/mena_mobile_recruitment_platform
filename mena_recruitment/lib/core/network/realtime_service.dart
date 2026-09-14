import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'realtime_event.dart';


enum RealtimeConnectionStatus {
  disconnected,
  connecting,
  connected,
}

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;

  RealtimeService._internal();

  WebSocketChannel? _channel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String tokenKey = 'jwt_access_token';

  RealtimeConnectionStatus _status = RealtimeConnectionStatus.disconnected;
  RealtimeConnectionStatus get status => _status;

  final _statusController = StreamController<RealtimeConnectionStatus>.broadcast();
  Stream<RealtimeConnectionStatus> get statusStream => _statusController.stream;

  final _eventController = StreamController<RealtimeEvent>.broadcast();
  Stream<RealtimeEvent> get events => _eventController.stream;

  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _manualDisconnect = false;
  final Set<String> _subscribedTopics = {};

  String get _wsBaseUrl {
    const customUrl = String.fromEnvironment('WS_BASE_URL');
    if (customUrl.isNotEmpty) return customUrl;

    return 'wss://mena-mobile-recruitment-platform.onrender.com/api/v1/ws';
  }

  void _setStatus(RealtimeConnectionStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      _statusController.add(_status);
      debugPrint('[Realtime] Status changed: $_status');
    }
  }

  Future<void> connect({String? customToken}) async {
    if (_status == RealtimeConnectionStatus.connected || _status == RealtimeConnectionStatus.connecting) {
      return;
    }

    _manualDisconnect = false;
    _setStatus(RealtimeConnectionStatus.connecting);

    try {
      final token = customToken ?? await _storage.read(key: tokenKey);
      final uriStr = token != null && token.isNotEmpty
          ? '$_wsBaseUrl?token=$token'
          : _wsBaseUrl;

      final uri = Uri.parse(uriStr);
      debugPrint('[Realtime] Connecting to $uri ...');

      _channel = WebSocketChannel.connect(uri);

      // Wait for channel ready
      await _channel!.ready;

      _setStatus(RealtimeConnectionStatus.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();

      // Re-subscribe to any saved topics
      for (final topic in _subscribedTopics) {
        subscribeTopic(topic);
      }

      _channel!.stream.listen(
        (message) => _onMessageReceived(message),
        onError: (error) {
          debugPrint('[Realtime] WebSocket error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('[Realtime] WebSocket stream closed');
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('[Realtime] Connection failed: $e');
      _handleDisconnect();
    }
  }

  void _onMessageReceived(dynamic message) {
    try {
      if (message is! String) return;
      final json = jsonDecode(message) as Map<String, dynamic>;

      if (json['type'] == 'pong') {
        // Heartbeat ack
        return;
      }

      final event = RealtimeEvent.fromJson(json);
      if (event != null) {
        debugPrint('[Realtime] Event received: ${event.runtimeType}');
        _eventController.add(event);
      }
    } catch (e) {
      debugPrint('[Realtime] Message parse error: $e (raw: $message)');
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
      if (_status == RealtimeConnectionStatus.connected && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'ping', 'timestamp': DateTime.now().toIso8601String()}));
        } catch (e) {
          debugPrint('[Realtime] Heartbeat send failed: $e');
        }
      }
    });
  }

  void _handleDisconnect() {
    _heartbeatTimer?.cancel();
    _setStatus(RealtimeConnectionStatus.disconnected);

    if (!_manualDisconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    // Exponential backoff: 1s, 2s, 4s, 8s ... max 30s
    final delaySeconds = (_reconnectAttempts > 5) ? 30 : (1 << (_reconnectAttempts - 1));
    debugPrint('[Realtime] Reconnecting in $delaySeconds seconds (attempt $_reconnectAttempts)...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!_manualDisconnect && _status == RealtimeConnectionStatus.disconnected) {
        connect();
      }
    });
  }

  void subscribeTopic(String topic) {
    _subscribedTopics.add(topic);
    if (_status == RealtimeConnectionStatus.connected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'subscribe', 'topic': topic}));
        debugPrint('[Realtime] Subscribed to topic: $topic');
      } catch (e) {
        debugPrint('[Realtime] Failed to subscribe to topic $topic: $e');
      }
    }
  }

  void unsubscribeTopic(String topic) {
    _subscribedTopics.remove(topic);
    if (_status == RealtimeConnectionStatus.connected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'type': 'unsubscribe', 'topic': topic}));
      } catch (_) {}
    }
  }

  Future<void> disconnect() async {
    _manualDisconnect = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    try {
      await _channel?.sink.close(ws_status.goingAway);
    } catch (_) {}

    _setStatus(RealtimeConnectionStatus.disconnected);
  }

  void dispose() {
    disconnect();
    _statusController.close();
    _eventController.close();
  }
}
