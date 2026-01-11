class GovernorateEntity {
  final int id;
  final String title;
  final double latitude;
  final double longitude;

  const GovernorateEntity({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GovernorateEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GovernorateEntity(id: $id, title: $title, lat: $latitude, lng: $longitude)';
}
