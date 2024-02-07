
class PartialUser {
  final int id;
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;

  PartialUser({required this.id, required this.firstName, required this.lastName, this.profilePictureUrl});

  PartialUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        profilePictureUrl = json['profilePicture'] as String?;

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'profilePicture': profilePictureUrl,
  };
}


///Model to handle
//     "user": {
//         "id": 1,
//         "firstName": "Admin",
//         "lastName": "Admin",
//         "profilePicture": null
//     }