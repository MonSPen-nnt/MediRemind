import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onCompleted,
    this.length = 4,
  });

  final ValueChanged<String> onCompleted;
  final int length;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    for (final f in _focusNodes) {
      f.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  String get value => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final last = digits.length.clamp(0, widget.length) - 1;
      if (last >= 0) _focusNodes[last].requestFocus();
    } else if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    final code = this.value;
    if (code.length == widget.length) widget.onCompleted(code);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        final filled = _controllers[index].text.isNotEmpty;
        final focused = _focusNodes[index].hasFocus;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 68,
          height: 76,
          decoration: BoxDecoration(
            gradient: filled || focused
                ? LinearGradient(
                    colors: [
                      AppColors.primaryLight,
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: filled || focused ? null : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
            border: Border.all(
              color: focused
                  ? AppColors.primary
                  : filled
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
              width: focused ? 2.5 : 1.5,
            ),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) => _onChanged(index, v),
          ),
        );
      }),
    );
  }
}
