import 'package:icare/core/di/injection_core.dart';
import 'package:icare/features/account/di/injection_account.dart';
import 'package:icare/features/authentication/di/injection_auth.dart';
import 'package:icare/features/booking/di/injection_booking.dart';
import 'package:icare/features/categories/di/injection_categories.dart';
import 'package:icare/features/chat/di/injection_chat.dart';
import 'package:icare/features/doctor/di/injection_doctor.dart';
import 'package:icare/features/locations/di/injection_locations.dart';
import 'package:icare/features/nurse/di/injection_nurse.dart';
import 'package:icare/features/root_app/di/injection_root.dart';
import 'package:icare/features/search/di/injection_search.dart';
import 'package:icare/features/setting/di/injection_settings.dart';
import 'package:icare/core/di/injection_coordinators.dart';

// Re-export sl so it's available from this container
export 'package:icare/core/di/injection_core.dart' show sl;

// Standalone init function that orchestrates all modules
Future<void> init() async {
  // 1. Core Infrastructure (Network, Storage, etc.) - Must be first
  await initCoreDependencies();

  // 2. Feature Modules
  initRootDependencies();
  initAuthDependencies();
  initAccountDependencies();
  initBookingDependencies();
  initSettingsDependencies();
  initLocationsDependencies();
  initCategoriesDependencies();
  initNurseDependencies();
  initDoctorDependencies();
  initSearchDependencies();
  initChatDependencies();

  // 3. Coordinators (Business Flow Layer) - Must be after feature blocs
  initCoordinators();
}
