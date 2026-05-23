import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/auth_background.dart';
import '../../controllers/health_profile_controller.dart';
import '../../models/health_profile.dart';

/// Màn chính sau khi hoàn tất hồ sơ — placeholder.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HealthProfileController();
  HealthProfile? _profile;
  String? _message;
  bool _isLoading = false;

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final profile = await _controller.fetchProfile('1');
      setState(() {
        _profile = profile;
        _message = 'Đã tải hồ sơ từ backend.';
      });
    } catch (error) {
      setState(() {
        _message = 'Lỗi khi tải hồ sơ: $error';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createSampleProfile() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final profile = await _controller.createSampleProfile();
      setState(() {
        _profile = profile;
        _message = 'Đã tạo hồ sơ mẫu và lưu vào backend.';
      });
    } catch (error) {
      setState(() {
        _message = 'Lỗi khi tạo hồ sơ: $error';
      });
    } finally {
      setState(() => _isLoading = false);
    }
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
                      'Bước tiếp theo: kết nối backend và gọi API từ Flutter.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_profile != null) ...[
                      Text(
                        'Tên: ${_profile!.displayName}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Tuổi: ${_profile!.age ?? 'Không có'}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    if (_message != null) ...[
                      Text(
                        _message!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else ...[
                      ElevatedButton(
                        onPressed: _createSampleProfile,
                        child: const Text('Tạo hồ sơ mẫu vào backend'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Tải hồ sơ mẫu từ backend'),
                      ),
                    ],
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
