class UserRequestModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String password; // need to be hashed
  final String pin; // need to be hashed
  final String currency;

  UserRequestModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.pin,
    required this.currency,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    "phoneNumber":phoneNumber,
    'password': password,
    'pin': pin,
    'currency': currency,
  };

  factory UserRequestModel.fromMap(Map<String, dynamic> map) => UserRequestModel(
    name: map['name'],
    email: map['email'],
    phoneNumber: map["phoneNumber"],
    password: map['password'],
    pin: map['pin'],
    currency: map['currency'],
  );
}
