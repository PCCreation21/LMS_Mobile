import '../domain/customer_models.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomerById(String id);

  /// Update existing customer (NIC uniqueness should be handled by controller/UI)
  Future<Customer> updateCustomer(Customer updated);

  Future<void> deleteCustomer(String id);

  /// ✅ Helper for NIC uniqueness check (useful for update form)
  Future<bool> isNicUnique(String nic, {String? excludeCustomerId});
}

class FakeCustomerRepository implements CustomerRepository {
  final List<Customer> _db = [
    Customer(
      id: "1",
      nic: "199512345678",
      name: "Amara Perera",
      phone: "+94 77 123 4567",
      secondaryPhone: "+94 71 111 2222",
      address: "45 Temple Road, Colombo 06",
      email: "amara@email.com",
      gender: Gender.female,
      routeCode: "R001",
      createdDate: DateTime(2024, 4, 20),
      status: CustomerStatus.active,
      loanNumbers: const ["LN-00012", "LN-00018"],
    ),
    Customer(
      id: "2",
      nic: "1988223456789",
      name: "Kamal Silva",
      phone: "+94 76 234 5678",
      address: "78 Beach Road, Negombo",
      gender: Gender.male,
      routeCode: "R004",
      createdDate: DateTime(2024, 3, 10),
      status: CustomerStatus.active,
      loanNumbers: const ["LN-00021"],
    ),
    Customer(
      id: "3",
      nic: "199234567890",
      name: "Nimal Fernando",
      phone: "+94 75 345 6789",
      address: "123 Main Street, Kandy",
      gender: Gender.male,
      routeCode: "R003",
      createdDate: DateTime(2024, 1, 2),
      status: CustomerStatus.inactive,
      loanNumbers: const [],
    ),
  ];

  @override
  Future<List<Customer>> getCustomers() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_db);
  }

  @override
  Future<Customer> getCustomerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final idx = _db.indexWhere((x) => x.id == id);
    if (idx == -1) {
      throw StateError("Customer not found for id: $id");
    }
    return _db[idx];
  }

  @override
  Future<Customer> updateCustomer(Customer updated) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _db.indexWhere((x) => x.id == updated.id);
    if (idx == -1) {
      throw StateError(
        "Cannot update. Customer not found for id: ${updated.id}",
      );
    }

    _db[idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final idx = _db.indexWhere((x) => x.id == id);
    if (idx == -1) {
      throw StateError("Cannot delete. Customer not found for id: $id");
    }

    _db.removeAt(idx);
  }

  @override
  Future<bool> isNicUnique(String nic, {String? excludeCustomerId}) async {
    await Future.delayed(const Duration(milliseconds: 120));

    final n = nic.trim().toLowerCase();
    return !_db.any(
      (c) =>
          c.nic.trim().toLowerCase() == n &&
          (excludeCustomerId == null || c.id != excludeCustomerId),
    );
  }
}
