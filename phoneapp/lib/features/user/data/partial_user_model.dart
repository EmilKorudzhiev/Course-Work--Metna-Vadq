class PartialUserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;
  final bool? followingHim;
  final int? followersCount;
  final int? catchCount;

  PartialUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePictureUrl,
    this.followingHim,
    this.followersCount,
    this.catchCount,
  });

  PartialUserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        profilePictureUrl = json['profilePicture'] as String?,
        followingHim = json['followingHim'] as bool?,
        followersCount = json['followersCount'] as int?,
        catchCount = json['catchCount'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'profilePicture': profilePictureUrl,
        'followingHim': followingHim,
        'followersCount': followersCount,
        'catchCount': catchCount,
      };
}

///Model to handle
//     "user": {
//         "id": 1,
//         "firstName": "Admin",
//         "lastName": "Admin",
//         "profilePicture": null
//     }
