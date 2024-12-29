class ChangePasswordModel {
  final String email;
  final String oldPassword;
  final String newPassword;

  ChangePasswordModel({
    required this.email,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "old_password": oldPassword,
      "new_password": newPassword,
    };
  }
}
