import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

import '../state/dashboard_controller.dart';
import 'widgets/feature_card.dart';
import 'widgets/recent_payment_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboarding_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "GOLDEN CASH",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.userName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                state.userEmail,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Welcome to Golden Cash",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    "Finance System",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage loans and collections efficiently.",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  FeatureCard(
                    icon: Icons.person,
                    title: "Customer Management",
                    description: "Create and manage customer accounts.",
                    primaryButton: "Create Customer",
                    secondaryButton: "View Customers",
                    onPrimaryPressed: () => context.push('/customers/create'),
                    onSecondaryPressed: () => context.push('/customers'),
                  ),

                  const SizedBox(height: 16),

                  FeatureCard(
                    icon: Icons.attach_money,
                    title: "Loan Management",
                    description: "Issue loans and track repayments.",
                    primaryButton: "Issue Loan",
                    secondaryButton: "View Loans",
                    onPrimaryPressed: () => context.push('/loans/issue'),
                  ),

                  const SizedBox(height: 16),

                  FeatureCard(
                    icon: Icons.wallet,
                    title: "Wallet",
                    description: "Track rental payments.",
                    primaryButton: "Rental Payment View",
                    secondaryButton: "Route Collection Tracking",
                  ),

                  const SizedBox(height: 16),

                  FeatureCard(
                    icon: Icons.location_on,
                    title: "Route Management",
                    description: "View collection routes.",
                    primaryButton: "View Routes",
                  ),

                  const SizedBox(height: 16),

                  FeatureCard(
                    icon: Icons.money,
                    title: "Loan Package Management",
                    description: "Configure Loan Packages.",
                    primaryButton: "View Loan Packages",
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Recent Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const RecentPaymentTile(
                    name: "Anna Perera",
                    date: "Apr 24, 2024",
                    amount: "\$150",
                    method: "Cash",
                  ),
                  const RecentPaymentTile(
                    name: "Ravi Senanayake",
                    date: "Apr 24, 2024",
                    amount: "\$200",
                    method: "Card",
                  ),
                  const RecentPaymentTile(
                    name: "Kasun Fernando",
                    date: "Apr 23, 2024",
                    amount: "\$5,000",
                    method: "Loan",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.push('/customers');
          }
        },
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}
