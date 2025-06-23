class SignupErrorModel {
  final List<String>? fName;
  final List<String>? lName;
  final List<String>? nationailNumber;
  final List<String>? phoneNumber;
  final List<String>? email;
  final List<String>? password;

  SignupErrorModel({
    this.fName,
    this.lName,
    this.nationailNumber,
    this.phoneNumber,
    this.email,
    this.password,
  });

  factory SignupErrorModel.fromJson(Map<String, dynamic> json) {
    return SignupErrorModel(
      fName: (json['FName'] as List?)?.map((e) => e.toString()).toList(),
      lName: (json['LName'] as List?)?.map((e) => e.toString()).toList(),
      nationailNumber: (json['NationailNumber'] as List?)?.map((e) => e.toString()).toList(),
      phoneNumber: (json['PhoneNumber'] as List?)?.map((e) => e.toString()).toList(),
      email: (json['email'] as List?)?.map((e) => e.toString()).toList(),
      password: (json['password'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FName': fName,
      'LName': lName,
      'NationailNumber': nationailNumber,
      'PhoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }
}
