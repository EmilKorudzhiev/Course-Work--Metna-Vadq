class LocationMarkerModel {
  final int id;
  final String type;
  final double latitude;
  final double longitude;

  LocationMarkerModel({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory LocationMarkerModel.fromJson(Map<String, dynamic> json) {
    return LocationMarkerModel(
      id: json['id'],
      type: json['type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'PostMarkerModel{id: $id, type: $type, latitude: $latitude, longitude: $longitude}';
  }
}