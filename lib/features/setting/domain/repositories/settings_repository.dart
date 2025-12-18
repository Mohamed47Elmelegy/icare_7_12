import 'package:icare/core/error/failure.dart';
import 'package:icare/features/setting/domain/entities/about_us.dart';
import 'package:icare/features/setting/domain/entities/notifications_entity.dart';
import 'package:icare/features/setting/domain/entities/privacy.dart';
import 'package:icare/features/setting/domain/entities/refund_policy.dart';
import 'package:icare/features/setting/domain/entities/terms.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, List<AboutUs>>> getAboutUsData();
  Future<Either<Failure, List<RefundPolicy>>> getRefundPolicyData();
  Future<Either<Failure, List<Terms>>> getTermsData();
  Future<Either<Failure, List<Privacy>>> getPrivacyData();

  /// user settings
  Future<Either<Failure, List<NotificationsEntity>>> getAllNotifications();
}
