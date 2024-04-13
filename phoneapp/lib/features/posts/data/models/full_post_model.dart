import 'package:MetnaVadq/features/user/data/partial_user_model.dart';

class FullPostModel {
  final int id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final bool isLiked;
  final PartialUserModel user;

  FullPostModel(this.id, this.date, this.latitude, this.longitude, this.description, this.imageUrl, this.user, this.isLiked);

  FullPostModel.fromJson(Map<String, dynamic> json)
: id = json['id'] as int,
  date = DateTime.parse(json['date']).toLocal(),
  latitude = json['latitude'] as double,
  longitude = json['longitude'] as double,
  description = json['text'] as String,
  imageUrl = json['fishCatchImage'] as String,
  isLiked = json['liked'] as bool,
  user = PartialUserModel.fromJson(json['user']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'latitude' : latitude,
    'longitude' : longitude,
    'text' : description,
    'fishCatchImage' : imageUrl,
    'user' : user.toJson()
  };

  FullPostModel copyWith({required bool isLiked}) {
    return FullPostModel(id, date, latitude, longitude, description, imageUrl, user, isLiked);
  }

}

///Model to handle
//{
//     "id": 1,
//     "date": "2024-01-18T07:20:22.601+00:00",
//     "latitude": 56.544,
//     "longitude": 69.01199999999994,
//     "text": "Some text data",
//     "fishCatchImage": "beffd0c7-a241-48e7-9d30-0acd8e9dc3db",
//     "user": {
//        ...
//     },
//     "comments": []
// }