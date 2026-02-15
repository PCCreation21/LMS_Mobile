import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_system/features/auth/presentation/forgot_password_page.dart';
import 'package:loan_management_system/features/auth/presentation/new_password_page.dart';
import 'package:loan_management_system/features/customer/presentation/create_customer_page.dart';
import 'package:loan_management_system/features/customer/presentation/customer_list_page.dart';
import 'package:loan_management_system/features/customer/presentation/customer_profile_page.dart';
import 'package:loan_management_system/features/customer/presentation/update_customer_page.dart';
import 'package:loan_management_system/features/dashboard/presentation/home_page.dart';
import 'package:loan_management_system/features/loan/presentation/issue_loan_page.dart';

import '../features/splash/presentation/splash_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/auth/presentation/login_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/new-password',
        builder: (context, state) => const NewPasswordPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/customers/create',
        builder: (context, state) => const CreateCustomerPage(),
      ),
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomerListPage(),
      ),
      GoRoute(
        path: '/customers/:id',
        builder: (context, state) =>
            CustomerProfilePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/customers/:id/update',
        builder: (context, state) =>
            UpdateCustomerPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/loans/issue',
        builder: (context, state) => const IssueLoanPage(),
      ),
    ],
  );
});
