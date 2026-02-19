import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.pageName,
  });

  final int currentIndex;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) context.go('/home');
        if (index == 1) context.push('/customers');
        if (index == 2) context.push('/loans');
        if (index == 3) context.push('/route-collections');
        if (index == 4) context.push('/routes');
        if (index == 5) context.push('/loan-packages');
      },
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customer"),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Loan"),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Route"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Packages"),
      ],
    );
  }
}
