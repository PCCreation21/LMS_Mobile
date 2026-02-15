enum Gender { male, female, other }

enum CustomerStatus { active, inactive }

class RouteLite {
  final String code;
  final String name;

  const RouteLite({required this.code, required this.name});
}

/// ✅ Used when creating a customer (your existing request)
class CreateCustomerRequest {
  final String name;
  final String nic;
  final String phone;
  final String? secondaryPhone;
  final String addressLine1;
  final String street1;
  final String? street2;
  final String? street3;
  final String? email;
  final Gender gender;
  final CustomerStatus status;
  final String routeCode;

  const CreateCustomerRequest({
    required this.name,
    required this.nic,
    required this.phone,
    this.secondaryPhone,
    required this.addressLine1,
    required this.street1,
    this.street2,
    this.street3,
    this.email,
    required this.gender,
    required this.status,
    required this.routeCode,
  });
}

/// ✅ Customer entity for list/profile/update/delete
class Customer {
  final String id; // backend id
  final String nic;
  final String name;
  final String phone;
  final String? secondaryPhone;
  final String address;
  final String? email;
  final Gender gender;
  final String routeCode;
  final DateTime createdDate;
  final CustomerStatus status;

  /// Read-only (system updates)
  final List<String> loanNumbers;

  const Customer({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    this.secondaryPhone,
    required this.address,
    this.email,
    required this.gender,
    required this.routeCode,
    required this.createdDate,
    required this.status,
    required this.loanNumbers,
  });

  Customer copyWith({
    String? nic,
    String? name,
    String? phone,
    String? secondaryPhone,
    String? address,
    String? email,
    Gender? gender,
    String? routeCode,
    DateTime? createdDate,
    CustomerStatus? status,
    List<String>? loanNumbers,
  }) {
    return Customer(
      id: id,
      nic: nic ?? this.nic,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      address: address ?? this.address,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      routeCode: routeCode ?? this.routeCode,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
      loanNumbers: loanNumbers ?? this.loanNumbers,
    );
  }
}

/// ✅ Used in Customer List filtering dropdown
enum CustomerSearchBy { all, nic, name, phone }

/// ✅ Used when updating customer account (only editable fields)
class UpdateCustomerRequest {
  final String id; // customer id
  final String nic; // optional editable, must be unique
  final String name;
  final String phone;
  final String? secondaryPhone;
  final String address;
  final String? email;
  final String routeCode;

  const UpdateCustomerRequest({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    this.secondaryPhone,
    required this.address,
    this.email,
    required this.routeCode,
  });
}
