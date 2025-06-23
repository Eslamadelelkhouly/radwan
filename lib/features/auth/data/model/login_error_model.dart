class LoginErrorModel {
  final List<String>? email;
  final List<String>? password;

  LoginErrorModel({
    this.email,
    this.password,
  });

  factory LoginErrorModel.fromJson(Map<String, dynamic> json) {
    return LoginErrorModel(
      email: json['email'] != null ? List<String>.from(json['email']) : null,
      password:
          json['password'] != null ? List<String>.from(json['password']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    };
  }
}
