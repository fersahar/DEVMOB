class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String location;
  final DateTime birthDate;
  final String email;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.birthDate,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'location': location,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      location: map['location'],
      birthDate: DateTime.parse(map['birthDate']),
      email: map['email'],
    );
  }
}