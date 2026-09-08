import 'package:flutter/material.dart';

/// Stages for the relocation stepper.
enum RelocationStage {
  applied,
  screening,
  interview,
  offer,
  visaProcessing,
  flight
}

/// A 6-stage relocation stepper widget.
class StepperPipeline extends StatefulWidget {
  /// The current stage of the pipeline.
  final RelocationStage currentStage;

  /// Whether to display in a compact horizontal mode. If false, it displays vertically.
  final bool compactMode;

  const StepperPipeline({
    Key? key,
    required this.currentStage,
    this.compactMode = true,
  }) : super(key: key);

  @override
  State<StepperPipeline> createState() => _StepperPipelineState();
}

class _StepperPipelineState extends State<StepperPipeline> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _stageNames = [
    'Applied', 'Screening', 'Interview', 'Offer', 'Visa', 'Flight'
  ];

  final List<IconData> _stageIcons = [
    Icons.check_circle_outline,
    Icons.search,
    Icons.people_outline,
    Icons.description_outlined,
    Icons.airplane_ticket_outlined,
    Icons.flight_takeoff,
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compactMode) {
      return _buildHorizontal();
    }
    return _buildVertical();
  }

  Widget _buildHorizontal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_stageNames.length, (index) {
        final isLast = index == _stageNames.length - 1;
        return Expanded(
          child: Row(
            children: [
              _buildNode(index),
              if (!isLast)
                Expanded(child: _buildLine(index)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_stageNames.length, (index) {
        final isLast = index == _stageNames.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildNode(index),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: 2,
                    height: 40,
                    child: _buildLine(index, vertical: true),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _stageNames[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: index == widget.currentStage.index ? FontWeight.w600 : FontWeight.w500,
                  color: _getTextColor(index),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNode(int index) {
    final status = _getStatus(index);
    
    if (status == 1) { // Current
      return ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF6E0000), // Amber
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFDE68A), width: 3), // Light amber border
          ),
          child: Icon(_stageIcons[index], size: 12, color: Colors.white),
        ),
      );
    } else if (status == 0) { // Completed
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF059669), // Emerald
          shape: BoxShape.circle,
        ),
        child: Icon(_stageIcons[index], size: 12, color: Colors.white),
      );
    } else { // Future
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
        ),
        child: Icon(_stageIcons[index], size: 12, color: const Color(0xFF94A3B8)),
      );
    }
  }

  Widget _buildLine(int index, {bool vertical = false}) {
    final status = _getStatus(index);
    // If current or past, line is solid emerald. If future, dashed grey.
    if (status <= 0) { // Solid line
      return Container(
        height: vertical ? null : 2,
        width: vertical ? 2 : null,
        color: const Color(0xFF059669), // Emerald
      );
    } else { // Dashed line
      return LayoutBuilder(
        builder: (context, constraints) {
          final length = vertical ? constraints.maxHeight : constraints.maxWidth;
          final dashCount = (length / (2 * 4)).floor();
          return Flex(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: vertical ? 2 : 4,
                height: vertical ? 4 : 2,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFCBD5E1)),
                ),
              );
            }),
          );
        },
      );
    }
  }

  /// 0 = completed, 1 = current, 2 = future
  int _getStatus(int index) {
    if (index < widget.currentStage.index) return 0;
    if (index == widget.currentStage.index) return 1;
    return 2;
  }

  Color _getTextColor(int index) {
    if (index < widget.currentStage.index) return const Color(0xFF059669);
    if (index == widget.currentStage.index) return const Color(0xFF6E0000);
    return const Color(0xFF64748B);
  }
}
