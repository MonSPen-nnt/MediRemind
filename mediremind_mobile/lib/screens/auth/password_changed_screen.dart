import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/animated_auth_body.dart';
import '../../widgets/auth/auth_scaffold.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/common/success_burst.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() => _PasswordChangedScreenState();
}

class _PasswordChangedScreenState extends State<PasswordChangedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _icon;

  @override
  void initState() {
    super.initState();
    _icon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _icon.dispose();
    super.dispose();
  }

  void _backToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AuthScaffold(
      showBackButton: false,
      child: AnimatedAuthBody(
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: SuccessBurst(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _icon,
                  curve: AppAnimations.bounce,
                ),
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.successLight,
                        AppColors.success.withValues(alpha: 0.3),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ShaderMask(
            shaderCallback: (b) => AppColors.titleGradient.createShader(b),
            blendMode: BlendMode.srcIn,
            child: Text(
              'Hoàn tất!',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.successLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
            ),
            child: Text(
              'Mật khẩu đã được cập nhật.\nĐăng nhập để tiếp tục sử dụng MediRemind.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Đăng nhập ngay',
            icon: Icons.login_rounded,
            onPressed: () => _backToLogin(context),
          ),
        ],
      ),
    );
  }
}
