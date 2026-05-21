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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng ký thành công!')),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AnimatedAuthBody(
          children: [
            const AuthHeader(
              title: 'Tạo tài khoản',
              subtitle: 'Bắt đầu hành trình uống thuốc đúng giờ.',
              icon: Icons.person_add_rounded,
              stepLabel: 'BƯỚC 1 / 2',
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthFormGroup(
              children: [
                AuthTextField(
                  controller: _nameController,
                  label: 'Họ và tên',
                  icon: Icons.badge_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nhập họ tên' : null,
                ),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nhập email';
                    if (!v.contains('@')) return 'Email không hợp lệ';
                    return null;
                  },
                ),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
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
                    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
                    if (v.length < 6) return 'Tối thiểu 6 ký tự';
                    return null;
                  },
                ),
                AuthTextField(
                  controller: _confirmController,
                  label: 'Xác nhận mật khẩu',
                  icon: Icons.verified_user_outlined,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onRegister(),
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => v != _passwordController.text
                      ? 'Mật khẩu không khớp'
                      : null,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Đăng ký',
              icon: Icons.check_circle_outline_rounded,
              isLoading: _isLoading,
              onPressed: _onRegister,
            ),
            AuthFooterLink(
              prefix: 'Đã có tài khoản?',
              linkText: 'Đăng nhập',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
