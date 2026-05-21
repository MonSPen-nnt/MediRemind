import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/animated_auth_body.dart';
import '../../widgets/auth/auth_form_group.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_scaffold.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/primary_button.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.passwordChanged,
      (route) => route.settings.name == AppRoutes.welcome,
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
              title: 'Mật khẩu mới',
              subtitle: 'Chọn mật khẩu dễ nhớ và an toàn.',
              icon: Icons.key_rounded,
              stepLabel: 'BƯỚC 3 / 3',
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthFormGroup(
              children: [
                AuthTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu mới',
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
                  icon: Icons.lock_reset_outlined,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _resetPassword(),
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
              label: 'Hoàn tất',
              icon: Icons.check_rounded,
              isLoading: _isLoading,
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
