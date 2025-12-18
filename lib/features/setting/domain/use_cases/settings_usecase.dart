import 'package:icare/features/setting/domain/entities/about_us.dart';
import 'package:icare/features/setting/domain/entities/privacy.dart';
import 'package:icare/features/setting/domain/entities/refund_policy.dart';
import 'package:icare/features/setting/domain/entities/terms.dart';
import 'package:dartz/dartz.dart';
import 'package:icare/core/error/failure.dart';
import 'package:icare/features/setting/domain/repositories/settings_repository.dart';

class GetTermsUseCase {
  final SettingsRepository termsRepository;

  GetTermsUseCase({required this.termsRepository});

  Future<Either<Failure, List<Terms>>> call() async {
    return await termsRepository.getTermsData();
  }
}

class GetRefundPolicyUseCase {
  final SettingsRepository refundPolicyRepository;

  GetRefundPolicyUseCase({required this.refundPolicyRepository});

  Future<Either<Failure, List<RefundPolicy>>> call() async {
    return await refundPolicyRepository.getRefundPolicyData();
  }
}

class GetPrivacyUseCase {
  final SettingsRepository privacyRepository;

  GetPrivacyUseCase({required this.privacyRepository});

  Future<Either<Failure, List<Privacy>>> call() async {
    return await privacyRepository.getPrivacyData();
  }
}

class GetAboutUsUseCase {
  final SettingsRepository aboutUsRepository;

  GetAboutUsUseCase({required this.aboutUsRepository});

  Future<Either<Failure, List<AboutUs>>> call() async {
    return await aboutUsRepository.getAboutUsData();
  }
}
