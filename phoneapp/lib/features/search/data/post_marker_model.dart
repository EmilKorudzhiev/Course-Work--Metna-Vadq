class PostMarkerModel {
  final int id;
  final double latitude;
  final double longitude;

  PostMarkerModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  factory PostMarkerModel.fromJson(Map<String, dynamic> json) {
    return PostMarkerModel(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'PostMarkerModel{id: $id, latitude: $latitude, longitude: $longitude}';
  }
}