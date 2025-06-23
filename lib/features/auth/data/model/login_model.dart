class LoginSuccessModel {
  final User user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  LoginSuccessModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return LoginSuccessModel(
      user: User.fromJson(json['user']),
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}

class User {
  final int id;
  final String fName;
  final String lName;
  final String nationailNumber;
  final String phoneNumber;
  final String email;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.fName,
    required this.lName,
    required this.nationailNumber,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fName: json['FName'],
      lName: json['LName'],
      nationailNumber: json['NationailNumber'],
      phoneNumber: json['PhoneNumber'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FName': fName,
      'LName': lName,
      'NationailNumber': nationailNumber,
      'PhoneNumber': phoneNumber,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
