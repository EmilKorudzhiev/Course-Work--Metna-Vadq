class MakePostRequestModel {
  final String description;
  final double latitude;
  final double longitude;

  MakePostRequestModel(
      {required this.description,
      required this.latitude,
      required this.longitude});

  String toJson() {
    return '{"text": "$description", "latitude": $latitude, "longitude": $longitude}';
  }
}
