import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/customer_models.dart';

final createCustomerControllerProvider =
    StateNotifierProvider<CreateCustomerController, CreateCustomerState>(
      (ref) => CreateCustomerController(ref),
    );

class CreateCustomerState {
  final bool isLoading;
  final String? error;

  final List<RouteLite> routes; // for dropdown

  const CreateCustomerState({
    this.isLoading = false,
    this.error,
    this.routes = const [],
  });

  CreateCustomerState copyWith({
    bool? isLoading,
    String? error,
    List<RouteLite>? routes,
  }) {
    return CreateCustomerState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      routes: routes ?? this.routes,
    );
  }

  factory CreateCustomerState.initial() => const CreateCustomerState(
    routes: [
      RouteLite(code: "R001", name: "Colombo Central"),
      RouteLite(code: "R002", name: "Galle Main Road"),
      RouteLite(code: "R003", name: "Kandy City"),
    ],
  );
}

class CreateCustomerController extends StateNotifier<CreateCustomerState> {
  CreateCustomerController(this.ref) : super(CreateCustomerState.initial());
  final Ref ref;

  Future<bool> submit(CreateCustomerRequest req) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));

      // fake success
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to create customer",
      );
      return false;
    }
  }
}
