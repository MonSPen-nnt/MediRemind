import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/auth/secondary_button.dart';
import '../../widgets/brand/brand_logo.dart';
import '../../widgets/common/feature_pill.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _curve(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: AppAnimations.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  FadeTransition(
                    opacity: _curve(0, 0.45),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(_curve(0, 0.45)),
                      child: Column(
                        children: [
                          const PulsingLogo(child: BrandLogo(size: 128)),
                          const SizedBox(height: AppSpacing.xl),
                          ShaderMask(
                            shaderCallback: (b) =>
                                AppColors.titleGradient.createShader(b),
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              'MediRemind',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Trợ lý nhắc uống thuốc\ncho cả gia đình',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: const [
                              FeaturePill(
                                icon: Icons.accessibility_new_rounded,
                                label: 'Dễ dùng',
                                tint: AppColors.primary,
                              ),
                              FeaturePill(
                                icon: Icons.schedule_rounded,
                                label: 'Đúng giờ',
                                tint: AppColors.secondary,
                              ),
                              FeaturePill(
                                icon: Icons.favorite_rounded,
                                label: 'An tâm',
                                tint: AppColors.accent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _curve(0.4, 0.9),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.18),
                        end: Offset.zero,
                      ).animate(_curve(0.4, 0.9)),
                      child: Column(
                        children: [
                          PrimaryButton(
                            label: 'Đăng nhập',
                            icon: Icons.login_rounded,
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.login,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SecondaryButton(
                            label: 'Tạo tài khoản mới',
                            icon: Icons.person_add_alt_1_rounded,
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.register,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Miễn phí · Bảo mật · Không quảng cáo',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
