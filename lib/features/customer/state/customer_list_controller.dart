import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/customer_repository.dart';
import '../domain/customer_models.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return FakeCustomerRepository(); // swap with ApiCustomerRepository later
});

final customerListProvider =
    StateNotifierProvider<CustomerListController, CustomerListState>((ref) {
      final repo = ref.watch(customerRepositoryProvider);
      return CustomerListController(repo)..load();
    });

class CustomerListState {
  final bool isLoading;
  final String? error;

  final List<Customer> all;
  final List<Customer> filtered;

  final CustomerSearchBy searchBy;
  final String query;

  const CustomerListState({
    this.isLoading = false,
    this.error,
    this.all = const [],
    this.filtered = const [],
    this.searchBy = CustomerSearchBy.all,
    this.query = "",
  });

  CustomerListState copyWith({
    bool? isLoading,
    String? error,
    List<Customer>? all,
    List<Customer>? filtered,
    CustomerSearchBy? searchBy,
    String? query,
  }) {
    return CustomerListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchBy: searchBy ?? this.searchBy,
      query: query ?? this.query,
    );
  }
}

class CustomerListController extends StateNotifier<CustomerListState> {
  CustomerListController(this._repo) : super(const CustomerListState());
  final CustomerRepository _repo;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _repo.getCustomers();
      state = state.copyWith(isLoading: false, all: data, filtered: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to load customers",
      );
    }
  }

  void setSearchBy(CustomerSearchBy v) {
    state = state.copyWith(searchBy: v);
  }

  void setQuery(String v) {
    state = state.copyWith(query: v);
  }

  void applySearch() {
    final q = state.query.trim().toLowerCase();
    if (q.isEmpty) {
      state = state.copyWith(filtered: state.all);
      return;
    }

    bool match(Customer c) {
      final nic = c.nic.toLowerCase();
      final name = c.name.toLowerCase();
      final phone = c.phone.toLowerCase();
      switch (state.searchBy) {
        case CustomerSearchBy.nic:
          return nic.contains(q);
        case CustomerSearchBy.name:
          return name.contains(q);
        case CustomerSearchBy.phone:
          return phone.contains(q);
        case CustomerSearchBy.all:
          return nic.contains(q) || name.contains(q) || phone.contains(q);
      }
    }

    state = state.copyWith(filtered: state.all.where(match).toList());
  }

  /// NIC uniqueness check when editing NIC
  bool isNicUnique(String nic, {required String excludeCustomerId}) {
    final n = nic.trim().toLowerCase();
    return !state.all.any(
      (c) => c.id != excludeCustomerId && c.nic.trim().toLowerCase() == n,
    );
  }

  Future<bool> updateCustomer(Customer updated) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final saved = await _repo.updateCustomer(updated);
      final newAll = [...state.all];
      final idx = newAll.indexWhere((x) => x.id == saved.id);
      newAll[idx] = saved;

      state = state.copyWith(isLoading: false, all: newAll);
      applySearch(); // re-apply filter using current query
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to update customer",
      );
      return false;
    }
  }

  Future<bool> deleteCustomer(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.deleteCustomer(id);
      final newAll = state.all.where((x) => x.id != id).toList();
      state = state.copyWith(isLoading: false, all: newAll);
      applySearch();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to delete customer",
      );
      return false;
    }
  }
}
