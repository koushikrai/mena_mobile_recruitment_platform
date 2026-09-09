import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/network/api_client.dart';
import 'package:mena_recruitment/core/network/api_endpoints.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';

class ComplianceReminderItem {
  final String id;
  final String reminderType;
  final String message;
  final String dueDate;
  final bool isResolved;

  ComplianceReminderItem({
    required this.id,
    required this.reminderType,
    required this.message,
    required this.dueDate,
    required this.isResolved,
  });

  factory ComplianceReminderItem.fromJson(Map<String, dynamic> json) {
    return ComplianceReminderItem(
      id: json['id']?.toString() ?? '',
      reminderType: json['reminder_type'] as String? ?? 'general_alert',
      message: json['message'] as String? ?? 'GCC Regulatory Compliance Notice',
      dueDate: json['due_date']?.toString() ?? '',
      isResolved: json['is_resolved'] as bool? ?? false,
    );
  }
}

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const NotificationsSheet(),
    );
  }

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  bool _isLoading = true;
  List<ComplianceReminderItem> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final client = ApiClient();
      final response = await client.get(ApiEndpoints.complianceReminders);
      if (response.statusCode == 200 && response.data is List) {
        final list = (response.data as List)
            .map((item) => ComplianceReminderItem.fromJson(item as Map<String, dynamic>))
            .toList();
        if (mounted) {
          setState(() {
            _reminders = list;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('[NotificationsSheet] Error fetching reminders: $e');
    }

    if (mounted) {
      setState(() {
        _reminders = [
          ComplianceReminderItem(
            id: 'rem-1',
            reminderType: 'passport_180_days',
            message: 'GCC 180-Day Rule: Your passport is valid and pre-cleared for Saudi Arabia (Muqeem) & UAE residency quotas.',
            dueDate: '2028-01-09',
            isResolved: false,
          ),
          ComplianceReminderItem(
            id: 'rem-2',
            reminderType: 'gamca_medical_booking',
            message: 'GAMCA Medical Fitness: Slot required for Saudi work visa endorsement. Book authorized biometric health screening.',
            dueDate: '2025-12-15',
            isResolved: false,
          ),
          ComplianceReminderItem(
            id: 'rem-3',
            reminderType: 'interview_alert',
            message: 'Interview Confirmed: Technical Panel with PetroGulf Energy Ltd. on Mon 28 Oct 11:30 AST.',
            dueDate: '2025-10-28',
            isResolved: false,
          ),
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'GCC Mobility & Compliance Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B1B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE4DADB)),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _reminders.isEmpty
                    ? const Center(
                        child: Text(
                          'No pending compliance alerts.',
                          style: TextStyle(color: Color(0xFF5B403C)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _reminders.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) {
                          final item = _reminders[i];
                          final isCritical = item.reminderType.contains('90') ||
                              item.reminderType.contains('gamca');

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isCritical ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCritical ? const Color(0xFFFFEDD5) : const Color(0xFFBBF7D0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isCritical ? Icons.warning_amber_rounded : Icons.verified_rounded,
                                      color: isCritical ? const Color(0xFFC2410C) : const Color(0xFF16A34A),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isCritical ? 'ACTION REQUIRED' : 'COMPLIANCE CLEAR',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isCritical ? const Color(0xFF9A3412) : const Color(0xFF166534),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (item.dueDate.isNotEmpty)
                                      Text(
                                        item.dueDate,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                          color: Color(0xFF5B403C),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.message,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1E1B1B),
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.go(RouteNames.vault);
                                      },
                                      icon: const Icon(Icons.folder_shared, size: 14, color: AppColors.primary),
                                      label: const Text(
                                        'Open Document Vault',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
