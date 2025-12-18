import 'package:icare/features/authentication/domain/entities/user_entity.dart';

class AuthResponse {
  String? msg;
  UserService? user;
  bool? isFailed;
  bool? isSuccess;
  bool? isLoad;
  AuthResponse(
      {this.msg, this.user, this.isLoad, this.isSuccess, this.isFailed});
}
