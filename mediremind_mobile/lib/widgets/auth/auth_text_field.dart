import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.validator,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focus;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(() {
      setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _focused ? 1.01 : 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focus,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        style: const TextStyle(
          fontSize: AppTheme.fontSizeBody,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 8),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: AppDecorations.iconBadge(
                tint: _focused ? AppColors.primary : AppColors.textMuted,
              ),
              child: Icon(
                widget.icon,
                size: 22,
                color: _focused ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: widget.suffix,
        ),
      ),
      ),
    );
  }
}
