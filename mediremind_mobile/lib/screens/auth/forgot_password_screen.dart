import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/animated_auth_body.dart';
import '../../widgets/auth/auth_footer_link.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_scaffold.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushNamed(
      context,
      AppRoutes.verification,
      arguments: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AnimatedAuthBody(
          children: [
            const AuthHeader(
              title: 'Quên mật khẩu',
              subtitle: 'Chúng tôi gửi mã 4 số về email đã đăng ký.',
              icon: Icons.lock_reset_rounded,
              stepLabel: 'KHÔI PHỤC',
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _sendCode(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nhập email';
                if (!v.contains('@')) return 'Email không hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Gửi mã xác nhận',
              icon: Icons.send_rounded,
              isLoading: _isLoading,
              onPressed: _sendCode,
            ),
            AuthFooterLink(
              prefix: 'Nhớ mật khẩu?',
              linkText: 'Đăng nhập',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
