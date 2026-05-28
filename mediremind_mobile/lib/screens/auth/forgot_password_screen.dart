import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
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
  final _authController = AuthController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _authController.sendPasswordResetEmail(_emailController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Da gui email khoi phuc mat khau.')),
      );
      Navigator.pop(context);
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
              title: 'Quen mat khau',
              subtitle: 'Firebase se gui lien ket dat lai mat khau ve email.',
              icon: Icons.lock_reset_rounded,
              stepLabel: 'KHOI PHUC',
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _sendResetEmail(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Nhap email';
                if (!v.contains('@')) return 'Email khong hop le';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            PrimaryButton(
              label: 'Gui email khoi phuc',
              icon: Icons.send_rounded,
              isLoading: _isLoading,
              onPressed: _sendResetEmail,
            ),
            AuthFooterLink(
              prefix: 'Nho mat khau?',
              linkText: 'Dang nhap',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

