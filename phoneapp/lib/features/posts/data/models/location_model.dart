import 'package:MetnaVadq/features/user/data/partial_user_model.dart';

class LocationModel {
  final int id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final PartialUserModel user;
  final String type;

  LocationModel(this.id, this.date, this.latitude, this.longitude, this.description, this.imageUrl, this.user, this.type);

  LocationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
  date = DateTime.parse(json['date']).toLocal(),
  latitude = json['latitude'] as double,
  longitude = json['longitude'] as double,
  description = json['description'] as String,
  imageUrl = json['locationImageId'] as String,
  user = PartialUserModel.fromJson(json['user']),
  type = json['type'] as String;

  Map<String, dynamic> toJson() => {
  'id': id,
  'date': date,
  'latitude' : latitude,
  'longitude' : longitude,
  'text' : description,
  'fishCatchImage' : imageUrl,
  'user' : user.toJson(),
  'type' : type
  };

  LocationModel copyWith({required bool isLiked}) {
  return LocationModel(id, date, latitude, longitude, description, imageUrl, user, type);
  }

}