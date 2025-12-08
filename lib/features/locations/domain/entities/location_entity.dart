import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable{
  final int id;
  final String address1;
  final String address2;
  final String country;
  final String phone;
  final String firstName;
  final String lastName;
  final String email;
  final String state;
  final String postCode;
  final String type;
  final double lat;
  final double long;
  final String? locationType;
  final List<dynamic>? hours;
  const LocationEntity({required this.address1,required this.address2,required this.country,required this.phone,required this.id,
    required this.type,required this.long,required this.lat,
    required this.state,required this.firstName,required this.lastName,required this.email,
    required this.postCode,
    this.hours,
    this.locationType,
  });

  @override
  List<Object?> get props => [id,phone];


}

class AddressEntity{
  final LocationEntity? shippingAddress;
  final LocationEntity? billingAddress;

  const AddressEntity({
    required this.shippingAddress,
    required this.billingAddress,
});
}