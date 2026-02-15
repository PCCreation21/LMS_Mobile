import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../onboarding/state/onboarding_storage.dart';
import '../../../app/widgets/app_logo.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () async {
      final storage = ref.read(onboardingStorageProvider);
      final seen = await storage.hasSeenOnboarding();

      if (!mounted) return;

      // ✅ if onboarding already seen -> go login
      // ✅ else -> show onboarding
      context.go(seen ? '/login' : '/onboarding');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding_bg.png',
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  AppLogo(size: 170, showText: true),
                  SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
