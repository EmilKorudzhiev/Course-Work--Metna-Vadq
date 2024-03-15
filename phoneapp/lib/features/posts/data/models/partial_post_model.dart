class PartialPostModel {
  final int id;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String imageUrl;

  PartialPostModel(this.id, this.date, this.latitude, this.longitude, this.imageUrl);

  PartialPostModel.fromJson(Map<String, dynamic> json)
  : id = json['id'] as int,
    date = DateTime.parse(json['date']),
    latitude = json['latitude'] as double,
    longitude = json['longitude'] as double,
    imageUrl = json['fishCatchImage'] as String;

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'latitude' : latitude,
    'longitude' : longitude,
    'fishCatchImage' : imageUrl,
  };

}
