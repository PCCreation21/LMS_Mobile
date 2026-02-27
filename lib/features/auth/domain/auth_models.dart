class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class LoginResponse {
  final String token;
  final String username;
  final String email;
  final String role;
  final List<String> permissions;

  LoginResponse({
    required this.token,
    required this.username,
    required this.email,
    required this.role,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? json['username'] ?? '',
      role: json['role'] ?? '',
      permissions: (json['permissions'] as List?)?.cast<String>() ?? [],
    );
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      };
}
