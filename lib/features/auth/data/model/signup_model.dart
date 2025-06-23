class SignUpModel {
  final User user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  SignUpModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
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
  final String fName;
  final String lName;
  final String nationailNumber;
  final String phoneNumber;
  final String email;
  final String updatedAt;
  final String createdAt;
  final int id;

  User({
    required this.fName,
    required this.lName,
    required this.nationailNumber,
    required this.phoneNumber,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fName: json['FName'],
      lName: json['LName'],
      nationailNumber: json['NationailNumber'],
      phoneNumber: json['PhoneNumber'],
      email: json['email'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FName': fName,
      'LName': lName,
      'NationailNumber': nationailNumber,
      'PhoneNumber': phoneNumber,
      'email': email,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
