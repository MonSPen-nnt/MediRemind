import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
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
  final _authController = AuthController();
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

    try {
      await _authController.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.healthProfileSetup);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AnimatedAuthBody(
          children: [
            const AuthHeader(
              title: 'Chao mung tro lai',
              subtitle: 'Dang nhap de xem lich uong thuoc hom nay.',
              icon: Icons.waving_hand_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthFormGroup(
              children: [
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'email@example.com',
                  icon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nhap email';
                    if (!v.contains('@')) return 'Email khong hop le';
                    return null;
                  },
                ),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Mat khau',
                  hint: 'Nhap mat khau',
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
                    if (v == null || v.isEmpty) return 'Nhap mat khau';
                    if (v.length < 6) return 'Toi thieu 6 ky tu';
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
                child: const Text('Quen mat khau?'),
              ),
            ),
            PrimaryButton(
              label: 'Dang nhap',
              icon: Icons.login_rounded,
              isLoading: _isLoading,
              onPressed: _onLogin,
            ),
            AuthFooterLink(
              prefix: 'Chua co tai khoan?',
              linkText: 'Dang ky ngay',
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}

