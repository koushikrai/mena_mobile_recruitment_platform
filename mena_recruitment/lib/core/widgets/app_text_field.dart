import 'package:flutter/material.dart';

/// Styled input field following the design system.
class AppTextField extends StatefulWidget {
  /// Optional label displayed above the field.
  final String? label;

  /// Optional hint text inside the field.
  final String? hint;

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Whether to obscure the text (e.g., for passwords).
  final bool obscureText;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// Optional prefix icon.
  final Widget? prefixIcon;

  /// Optional suffix icon.
  final Widget? suffixIcon;

  /// Optional prefix widget (e.g., for currency selectors).
  final Widget? prefixWidget;

  /// Error text to display and trigger the error state.
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    Color borderColor = const Color(0xFFE4DADB);
    if (hasError) {
      borderColor = Colors.red;
    } else if (_isFocused) {
      borderColor = const Color(0xFF990000); // Navy primary
    }

    List<BoxShadow>? shadows;
    if (_isFocused && !hasError) {
      shadows = [
        const BoxShadow(
          color: Color.fromRGBO(15, 30, 54, 0.08),
          spreadRadius: 3,
          blurRadius: 0,
        )
      ];
    } else if (_isFocused && hasError) {
      shadows = [
        const BoxShadow(
          color: Color.fromRGBO(244, 67, 54, 0.08),
          spreadRadius: 3,
          blurRadius: 0,
        )
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF990000),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: shadows,
          ),
          child: Row(
            children: [
              if (widget.prefixWidget != null) widget.prefixWidget!,
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: widget.prefixIcon!,
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: (widget.prefixIcon == null && widget.prefixWidget == null) ? 16.0 : 0.0,
                      vertical: 14.0,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF990000),
                  ),
                ),
              ),
              if (widget.suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: widget.suffixIcon!,
                ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
