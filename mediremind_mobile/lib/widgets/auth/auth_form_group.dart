import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Gom nhiều ô nhập thành một khối — giảm stagger, gọn animation.
class AuthFormGroup extends StatelessWidget {
  const AuthFormGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          children[i],
        ],
      ],
    );
  }
}
