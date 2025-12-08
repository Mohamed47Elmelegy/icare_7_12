class LocationMapEntity {
  final double lat;
  final double long;
  final String city;
  final String postalCode;
  final String street;
  final String country;
  final String address;
  LocationMapEntity(
      {required this.lat,
      required this.long,
      required this.address,
      required this.city,
      required this.country,
      required this.postalCode,
      required this.street});
}