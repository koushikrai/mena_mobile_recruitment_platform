import 'package:flutter/material.dart';

/// The variant of the AppButton to determine its styling.
enum AppButtonVariant { primary, secondary, outline, destructive }

/// Alias for compatibility with widgets expecting ButtonType
typedef ButtonType = AppButtonVariant;

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

  /// Optional custom background color
  final Color? customBgColor;

  /// Optional custom text color
  final Color? customTextColor;

  const AppButton._({
    Key? key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    required this.variant,
    this.customBgColor,
    this.customTextColor,
  }) : super(key: key);

  /// Convenient default constructor supporting text, child, type, backgroundColor, and textColor
  factory AppButton({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? leadingIcon,
    AppButtonVariant variant = AppButtonVariant.primary,
    AppButtonVariant? type,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final Widget effectiveChild = child ?? Text(text ?? '');
    return AppButton._(
      key: key,
      child: effectiveChild,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      variant: type ?? variant,
      customBgColor: backgroundColor,
      customTextColor: textColor,
    );
  }

  /// Primary button: Navy #990000 background, white text.
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
    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = widget.customBgColor ?? const Color(0xFF990000);
        textColor = widget.customTextColor ?? Colors.white;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = widget.customBgColor ?? const Color(0xFF6E0000);
        textColor = widget.customTextColor ?? Colors.white;
        break;
      case AppButtonVariant.outline:
        backgroundColor = widget.customBgColor ??
            (_isHovered ? const Color(0xFFF1F5F9) : Colors.transparent);
        textColor = widget.customTextColor ?? const Color(0xFF990000);
        border = Border.all(color: const Color(0xFFE4DADB), width: 1.5);
        break;
      case AppButtonVariant.destructive:
        backgroundColor = widget.customBgColor ?? const Color(0xFFFEF2F2);
        textColor = widget.customTextColor ?? const Color(0xFF991B1B);
        border = Border.all(color: const Color(0xFFFECACA), width: 1.0);
        break;
    }

    if (widget.onPressed == null) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      textColor = textColor.withValues(alpha: 0.5);
      if (border != null) {
        border = Border.all(
          color: border.top.color.withValues(alpha: 0.5),
          width: border.top.width,
        );
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
              fontFamily: 'Plus Jakarta Sans',
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
            height: 52.0,
            width: widget.isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
              border: border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
