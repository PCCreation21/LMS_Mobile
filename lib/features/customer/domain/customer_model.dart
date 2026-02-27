class Customer {
  final int id;
  final String nic;
  final String customerName;
  final String phoneNumber;
  final String address;
  final String routeCode;
  final String? email;
  final String? gender;
  final String? secondaryPhoneNumber;
  final String status;

  Customer({
    required this.id,
    required this.nic,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.routeCode,
    this.email,
    this.gender,
    this.secondaryPhoneNumber,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      nic: json['nic'] ?? '',
      customerName: json['customerName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      routeCode: json['routeCode'] ?? '',
      email: json['email'],
      gender: json['gender'],
      secondaryPhoneNumber: json['secondaryPhoneNumber'],
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() => {
        'nic': nic,
        'customerName': customerName,
        'phoneNumber': phoneNumber,
        'address': address,
        'routeCode': routeCode,
        'email': email,
        'gender': gender,
        'secondaryPhoneNumber': secondaryPhoneNumber,
      };
}
