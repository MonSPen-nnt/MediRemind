import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/auth_background.dart';

/// Màn chính sau khi hoàn tất hồ sơ — placeholder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Hồ sơ đã sẵn sàng!',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Bước tiếp theo: màn nhắc uống thuốc\nsẽ được phát triển tại đây.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
