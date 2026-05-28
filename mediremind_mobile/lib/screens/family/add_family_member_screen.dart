import 'package:flutter/material.dart';

import '../../core/theme/app_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/primary_button.dart';
import '../../widgets/common/glass_surface.dart';
import '../../widgets/common/staggered_entrance.dart';
import '../../widgets/family/family_invite_sheet.dart';
import '../../widgets/family/family_section_header.dart';
import '../../widgets/family/permission_toggle_card.dart';
import '../../widgets/family/relationship_selector.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final AnimationController _fabEnter;

  String? _relationship;
  bool _canView = true;
  bool _canAlert = true;
  bool _canEdit = false;
  bool _isSending = false;

  static const _relationships = [
    'Bố',
    'Mẹ',
    'Con',
    'Vợ/Chồng',
    'Anh/Chị/Em',
    'Ông/Bà',
    'Khác',
  ];

  static const _relationshipIcons = {
    'Bố': Icons.man_2_outlined,
    'Mẹ': Icons.woman_2_outlined,
    'Con': Icons.child_care_outlined,
    'Vợ/Chồng': Icons.favorite_outline_rounded,
    'Anh/Chị/Em': Icons.people_outline_rounded,
    'Ông/Bà': Icons.elderly_outlined,
    'Khác': Icons.person_outline_rounded,
  };

  @override
  void initState() {
    super.initState();
    _fabEnter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _fabEnter.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;
    if (_relationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn mối quan hệ')),
      );
      return;
    }

    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.send_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã gửi lời mời đến ${_nameController.text.trim()}',
              ),
            ),
          ],
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var stagger = 0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Column(
              children: [
                StaggeredEntrance(
                  index: stagger++,
                  child: _buildAppBar(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 110),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StaggeredEntrance(
                            index: stagger++,
                            child: GlassSurface(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FamilySectionHeader(
                                    title: 'Thông tin người thân',
                                    icon: Icons.contact_phone_rounded,
                                    accent: AppColors.secondary,
                                    trailing: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person_add_rounded,
                                        color: AppColors.secondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Nhập SĐT đã đăng ký MediRemind hoặc sẽ mời cài app',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(height: 1.4),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  AuthTextField(
                                    controller: _nameController,
                                    label: 'Họ và tên',
                                    hint: 'Tên người thân',
                                    icon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    validator: (v) =>
                                        v == null || v.trim().isEmpty
                                            ? 'Nhập họ tên'
                                            : null,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  AuthTextField(
                                    controller: _phoneController,
                                    label: 'Số điện thoại',
                                    hint: '09xx xxx xxx',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    validator: (v) {
                                      if (v == null || v.trim().length < 9) {
                                        return 'Số điện thoại không hợp lệ';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  RelationshipSelector(
                                    options: _relationships,
                                    icons: _relationshipIcons,
                                    selected: _relationship,
                                    onSelected: (v) =>
                                        setState(() => _relationship = v),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          StaggeredEntrance(
                            index: stagger++,
                            child: GlassSurface(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FamilySectionHeader(
                                    title: 'Quyền truy cập',
                                    icon: Icons.shield_rounded,
                                    accent: AppColors.primary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Chọn những gì người thân được phép làm',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(height: 1.4),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  PermissionToggleCard(
                                    title: 'Xem lịch uống thuốc',
                                    subtitle: 'Theo dõi giờ uống hàng ngày',
                                    icon: Icons.calendar_month_outlined,
                                    value: _canView,
                                    onChanged: (v) =>
                                        setState(() => _canView = v),
                                  ),
                                  PermissionToggleCard(
                                    title: 'Nhận cảnh báo',
                                    subtitle: 'Khi quên uống hoặc trễ giờ',
                                    icon: Icons.notifications_active_outlined,
                                    value: _canAlert,
                                    tint: AppColors.accentWarm,
                                    onChanged: (v) =>
                                        setState(() => _canAlert = v),
                                  ),
                                  PermissionToggleCard(
                                    title: 'Chỉnh sửa lịch',
                                    subtitle: 'Thêm / sửa nhắc nhở thay bạn',
                                    icon: Icons.edit_calendar_outlined,
                                    value: _canEdit,
                                    tint: AppColors.accent,
                                    onChanged: (v) =>
                                        setState(() => _canEdit = v),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          StaggeredEntrance(
                            index: stagger++,
                            child: _QrAltButton(
                              onTap: () => FamilyInviteSheet.show(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _fabEnter,
                curve: AppAnimations.easeOut,
              )),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.backgroundBottom.withValues(alpha: 0),
                      AppColors.backgroundBottom.withValues(alpha: 0.95),
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: PrimaryButton(
                    label: 'Gửi lời mời liên kết',
                    icon: Icons.send_rounded,
                    isLoading: _isSending,
                    onPressed: _sendInvite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.6),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) =>
                      AppColors.titleGradient.createShader(b),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Thêm người thân',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Text(
                  'Mời người thân cùng theo dõi sức khỏe',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrAltButton extends StatefulWidget {
  const _QrAltButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_QrAltButton> createState() => _QrAltButtonState();
}

class _QrAltButtonState extends State<_QrAltButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hover;

  @override
  void initState() {
    super.initState();
    _hover = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hover,
      builder: (_, __) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentSoft.withValues(
                      alpha: 0.5 + _hover.value * 0.3,
                    ),
                    AppColors.primarySoft,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.accent,
                      size: 26 + _hover.value * 2,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Hoặc mời bằng mã / QR',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
