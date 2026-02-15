import 'package:flutter_riverpod/legacy.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
      (ref) => DashboardController(),
    );

class DashboardState {
  final String userName;
  final String userEmail;

  DashboardState({required this.userName, required this.userEmail});

  factory DashboardState.initial() =>
      DashboardState(userName: "John Doe", userEmail: "john.doe@email.com");
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(DashboardState.initial());
}
