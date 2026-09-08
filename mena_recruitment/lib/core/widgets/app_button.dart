import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_dimensions.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';

/// The variant of the AppButton to determine its styling.
enum AppButtonVariant { primary, secondary, outline, destructive }

/// A versatile button widget that adheres to the Gulf Maritime & Amber Horizon design system.
class AppButton extends StatefulWidget {
  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The widget displayed inside the button (typically a Text).
  final Widget child;

  /// Whether the button is in a loading state. Shows a CircularProgressIndicator if true.
  final bool isLoading;

  /// Whether the button should stretch to fill its parent's width.
  final bool isFullWidth;

  /// An optional leading icon to display before the child.
  final Widget? leadingIcon;

  /// The visual variant of the button.
  final AppButtonVariant variant;

  const AppButton._({
    Key? key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    required this.variant,
  }) : super(key: key);

  /// Primary button: Navy #0F1E36 background, white text.
  const factory AppButton.primary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading,
    bool isFullWidth,
    Widget? leadingIcon,
  }) = _AppButtonPrimary;

  /// Secondary button: Amber #D97706 background, white text.
  const factory AppButton.secondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading,
    bool isFullWidth,
    Widget? leadingIcon,
  }) = _AppButtonSecondary;

  /// Outline button: Transparent background, #E2E8F0 border, navy text.
  const factory AppButton.outline({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading,
    bool isFullWidth,
    Widget? leadingIcon,
  }) = _AppButtonOutline;

  /// Destructive button: #FEF2F2 background, #FECACA border, #991B1B text.
  const factory AppButton.destructive({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading,
    bool isFullWidth,
    Widget? leadingIcon,
  }) = _AppButtonDestructive;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonPrimary extends AppButton {
  const _AppButtonPrimary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? leadingIcon,
  }) : super._(
          key: key,
          child: child,
          onPressed: onPressed,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          variant: AppButtonVariant.primary,
        );
}

class _AppButtonSecondary extends AppButton {
  const _AppButtonSecondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? leadingIcon,
  }) : super._(
          key: key,
          child: child,
          onPressed: onPressed,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          variant: AppButtonVariant.secondary,
        );
}

class _AppButtonOutline extends AppButton {
  const _AppButtonOutline({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? leadingIcon,
  }) : super._(
          key: key,
          child: child,
          onPressed: onPressed,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          variant: AppButtonVariant.outline,
        );
}

class _AppButtonDestructive extends AppButton {
  const _AppButtonDestructive({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? leadingIcon,
  }) : super._(
          key: key,
          child: child,
          onPressed: onPressed,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          variant: AppButtonVariant.destructive,
        );
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resolve colors and styles based on variant
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = const Color(0xFF0F1E36); // AppColors.primary
        textColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = const Color(0xFFD97706); // AppColors.secondary
        textColor = Colors.white;
        break;
      case AppButtonVariant.outline:
        backgroundColor = _isHovered ? const Color(0xFFF1F5F9) : Colors.transparent;
        textColor = const Color(0xFF0F1E36); // AppColors.primary
        border = Border.all(color: const Color(0xFFE2E8F0), width: 1.5);
        break;
      case AppButtonVariant.destructive:
        backgroundColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFF991B1B);
        border = Border.all(color: const Color(0xFFFECACA), width: 1.0);
        break;
    }

    if (widget.onPressed == null) {
      backgroundColor = backgroundColor.withOpacity(0.5);
      textColor = textColor.withOpacity(0.5);
      if (border != null) {
        border = Border.all(color: border.top.color.withOpacity(0.5), width: border.top.width);
      }
    }

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else if (widget.leadingIcon != null) ...[
          IconTheme(
            data: IconThemeData(color: textColor, size: 20),
            child: widget.leadingIcon!,
          ),
          const SizedBox(width: 8),
        ],
        if (!widget.isLoading)
          DefaultTextStyle(
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Plus Jakarta Sans', // Fallback if AppTypography is generic
            ),
            child: widget.child,
          ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: 52.0, // AppDimensions.buttonHeightPrimary
            width: widget.isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.0), // AppDimensions.radiusButton
              border: border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
