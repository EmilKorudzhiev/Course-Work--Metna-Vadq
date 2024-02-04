class UserModel {
  final BigInt id;
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;

  UserModel({required this.id, required this.firstName, required this.lastName, this.profilePictureUrl});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as BigInt,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        profilePictureUrl = json['profilePicture'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'profilePicture': profilePictureUrl,
  };
}