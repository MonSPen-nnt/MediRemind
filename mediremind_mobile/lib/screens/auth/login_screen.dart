import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/animated_auth_body.dart';
import '../../widgets/auth/auth_footer_link.dart';
import '../../widgets/auth/auth_form_group.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_scaffold.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, AppRoutes.healthProfileSetup);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AnimatedAuthBody(
          children: [
            const AuthHeader(
              title: 'Chào mừng trở lại',
              subtitle: 'Đăng nhập để xem lịch uống thuốc hôm nay.',
              icon: Icons.waving_hand_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthFormGroup(
              children: [
                AuthTextField(
                  controller: _emailController,
                  label: 'Email hoặc SĐT',
                  hint: 'Nhập email hoặc số điện thoại',
                  icon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Vui lòng nhập email hoặc SĐT'
                      : null,
                ),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onLogin(),
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                    if (v.length < 6) return 'Tối thiểu 6 ký tự';
                    return null;
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.forgotPassword),
                child: const Text('Quên mật khẩu?'),
              ),
            ),
            PrimaryButton(
              label: 'Đăng nhập',
              icon: Icons.login_rounded,
              isLoading: _isLoading,
              onPressed: _onLogin,
            ),
            AuthFooterLink(
              prefix: 'Chưa có tài khoản?',
              linkText: 'Đăng ký ngay',
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
