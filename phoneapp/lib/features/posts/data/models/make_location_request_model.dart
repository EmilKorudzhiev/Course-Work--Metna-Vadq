class MakeLocationRequestModel {
  final String description;
  final String type;
  final double latitude;
  final double longitude;

  MakeLocationRequestModel(
      {required this.description,
        required this.type,
        required this.latitude,
        required this.longitude});

  String toJson() {
    return '{"description": "$description", "type": "$type", "latitude": $latitude, "longitude": $longitude}';
  }
}
