class CityEntity {
  final int id;
  final String title;
  final int governorateId;
  final double latitude;
  final double longitude;

  const CityEntity({
    required this.id,
    required this.title,
    required this.governorateId,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CityEntity(id: $id, title: $title, governorateId: $governorateId, lat: $latitude, lng: $longitude)';
}
