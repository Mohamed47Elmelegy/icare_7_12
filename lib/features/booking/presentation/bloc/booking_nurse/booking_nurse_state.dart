import 'package:equatable/equatable.dart';
import 'package:icare/features/authentication/data/models/user_service_model.dart';

abstract class BookingNurseState extends Equatable {
  const BookingNurseState();

  @override
  List<Object?> get props => [];
}

class BookingNurseInitial extends BookingNurseState {}

class BookingNurseLoading extends BookingNurseState {}

class BookingNurseLoaded extends BookingNurseState {
  final UserServiceModel patientData;

  const BookingNurseLoaded(this.patientData);

  @override
  List<Object?> get props => [patientData];
}

class BookingNurseError extends BookingNurseState {
  final String message;

  const BookingNurseError(this.message);

  @override
  List<Object?> get props => [message];
}
