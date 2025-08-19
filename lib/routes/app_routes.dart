import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/rewards_center/rewards_center.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/lending_screen/lending_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String login = '/login-screen';
  static const String rewardsCenter = '/rewards-center';
  static const String dashboard = '/dashboard';
  static const String transactionHistory = '/transaction-history';
  static const String onboardingFlow = '/onboarding-flow';
  static const String lending = '/lending-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    rewardsCenter: (context) => const RewardsCenter(),
    dashboard: (context) => const Dashboard(),
    transactionHistory: (context) => const TransactionHistory(),
    onboardingFlow: (context) => const OnboardingFlow(),
    lending: (context) => const LendingScreen(),
    // TODO: Add your other routes here
  };
}
