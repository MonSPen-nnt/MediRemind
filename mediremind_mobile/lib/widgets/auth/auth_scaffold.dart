import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../common/glass_surface.dart';
import 'auth_background.dart';

class AuthScaffold extends StatefulWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = true,
    this.onBack,
    this.useGlassCard = true,
  });

  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool useGlassCard;

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: AppAnimations.normal,
    )..forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _enter, curve: AppAnimations.easeOut);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: FadeTransition(
              opacity: fade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.showBackButton)
                    _BackButton(onBack: widget.onBack),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 8,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: widget.useGlassCard
                              ? GlassSurface(child: widget.child)
                              : widget.child,
                        ),
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

class _BackButton extends StatelessWidget {
  const _BackButton({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: Colors.white.withValues(alpha: 0.55),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: SizedBox(
              width: AppTheme.minTouchTarget,
              height: AppTheme.minTouchTarget,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
