class SearchSuggestionModel {
  final String name;
  final String? namePreferred;
  final String placeFormatted;
  final String mapboxId;
  final String featureType;
  final String? address;
  final String? fullAddress;

  SearchSuggestionModel(this.name, this.placeFormatted, this.mapboxId, this.featureType, this.address, this.fullAddress, this.namePreferred);

  SearchSuggestionModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        namePreferred = json['name_preferred'] as String?,
        placeFormatted = json['place_formatted'] as String,
        mapboxId = json['mapbox_id'] as String,
        featureType = json['feature_type'] as String,
        address = json['address'] as String?,
        fullAddress = json['full_address'] as String?;
@override
  String toString() {
    return 'SearchSuggestionModel{name: $name, placeFormatted: $placeFormatted, mapboxId: $mapboxId, featureType: $featureType, address: $address, fullAddress: $fullAddress}';
  }
}
