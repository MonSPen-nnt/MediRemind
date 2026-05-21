import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/animated_auth_body.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_scaffold.dart';
import '../../widgets/auth/otp_input.dart';
import '../../widgets/auth/primary_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String _code = '';
  bool _isLoading = false;

  Future<void> _verify() async {
    if (_code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đủ 4 số mã xác nhận')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushNamed(
      context,
      AppRoutes.createNewPassword,
      arguments: widget.email,
    );
  }

  void _resend() {
    _otpKey.currentState?.clear();
    setState(() => _code = '');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi lại mã')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email.isNotEmpty ? widget.email : 'email của bạn';

    return AuthScaffold(
      child: AnimatedAuthBody(
        children: [
          const AuthHeader(
            title: 'Xác minh email',
            subtitle: 'Nhập mã OTP chúng tôi vừa gửi.',
            icon: Icons.mark_email_read_outlined,
            stepLabel: 'BƯỚC 2 / 3',
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight.withValues(alpha: 0.8),
                  AppColors.accentSoft.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.email_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          OtpInput(
            key: _otpKey,
            onCompleted: (code) => setState(() => _code = code),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Xác nhận',
            icon: Icons.verified_rounded,
            isLoading: _isLoading,
            onPressed: _verify,
          ),
          Center(
            child: TextButton(
              onPressed: _resend,
              child: const Text('Gửi lại mã'),
            ),
          ),
        ],
      ),
    );
  }
}
