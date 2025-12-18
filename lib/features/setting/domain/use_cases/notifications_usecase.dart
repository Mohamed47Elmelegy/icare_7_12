import 'package:icare/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/setting/domain/repositories/settings_repository.dart';

class GetAllNotificationsUseCase {
  final SettingsRepository settingsRepository;

  GetAllNotificationsUseCase({required this.settingsRepository});

  Future<Either<Failure, List<NotificationsEntity>>> call() async {
    return await settingsRepository.getAllNotifications();
  }
}
