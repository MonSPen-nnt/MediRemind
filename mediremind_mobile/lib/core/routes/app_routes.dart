import 'package:flutter/material.dart';

import '../../screens/auth/create_new_password_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/password_changed_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/verification_screen.dart';
import '../../screens/family/add_family_member_screen.dart';
import '../../screens/family/family_link_screen.dart';
import '../../screens/family/family_member_detail_screen.dart';
import '../../screens/health_profile/health_profile_setup_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/welcome/welcome_screen.dart';
import '../../models/app_user.dart';
import '../../models/family_member.dart';
import '../../models/health_profile.dart';
import 'fade_slide_route.dart';

abstract final class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verification = '/verification';
  static const String createNewPassword = '/create-new-password';
  static const String passwordChanged = '/password-changed';
  static const String healthProfileSetup = '/health-profile-setup';
  static const String home = '/home';
  static const String familyLink = '/family-link';
  static const String addFamilyMember = '/family-add';
  static const String familyMemberDetail = '/family-detail';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return fadeSlideRoute(page: const WelcomeScreen(), settings: settings);
      case login:
        return fadeSlideRoute(page: const LoginScreen(), settings: settings);
      case register:
        return fadeSlideRoute(page: const RegisterScreen(), settings: settings);
      case forgotPassword:
        return fadeSlideRoute(
          page: const ForgotPasswordScreen(),
          settings: settings,
        );
      case verification:
        final email = settings.arguments as String? ?? '';
        return fadeSlideRoute(
          page: VerificationScreen(email: email),
          settings: settings,
        );
      case createNewPassword:
        final email = settings.arguments as String? ?? '';
        return fadeSlideRoute(
          page: CreateNewPasswordScreen(email: email),
          settings: settings,
        );
      case passwordChanged:
        return fadeSlideRoute(
          page: const PasswordChangedScreen(),
          settings: settings,
        );
      case healthProfileSetup:
        return fadeSlideRoute(
          page: const HealthProfileSetupScreen(),
          settings: settings,
        );
      case home:
        final arguments = settings.arguments;
        final profile = arguments is HealthProfile ? arguments : null;
        final user = arguments is AppUser ? arguments : null;
        return fadeSlideRoute(
          page: HomeScreen(profile: profile, user: user),
          settings: settings,
        );
      case familyLink:
        return fadeSlideRoute(page: const FamilyLinkScreen(), settings: settings);
      case addFamilyMember:
        return fadeSlideRoute(
          page: const AddFamilyMemberScreen(),
          settings: settings,
        );
      case familyMemberDetail:
        final member = settings.arguments as FamilyMember?;
        if (member == null) {
          return fadeSlideRoute(
            page: const FamilyLinkScreen(),
            settings: settings,
          );
        }
        return fadeSlideRoute(
          page: FamilyMemberDetailScreen(member: member),
          settings: settings,
        );
      default:
        return fadeSlideRoute(page: const WelcomeScreen(), settings: settings);
    }
  }
}
