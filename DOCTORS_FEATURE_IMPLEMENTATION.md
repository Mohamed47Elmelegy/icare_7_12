# 📋 خطة تنفيذ Doctor Feature

## 📝 نظرة عامة
إنشاء feature كامل للدكاترة (Doctors) مشابه تماماً لـ feature الممرضين (Nurses) الموجود حالياً في المشروع.

---

## ✅ الإجابات على الأسئلة المهمة

| # | السؤال | الإجابة |
|---|---------|---------|
| 1 | هل الـ Doctor سيكون له نفس الخصائص مثل الـ Nurse؟ | **نعم** - نفس الـ properties |
| 2 | هل هناك اختلافات في Services/Prices/Reviews؟ | **لا** - نفس النظام |
| 3 | هل الـ API endpoints مختلفة؟ | **نعم** - `/doctors` بدلاً من `/nurses` |
| 4 | هل نفس الـ Screens؟ | **نعم** - نفس الشاشات بالضبط |
| 5 | هل widgets مختلفة؟ | **لا** - نفس الصفحات والـ widgets |
| 6 | هل نفس الـ naming pattern؟ | **نعم** - `doctor_` بدلاً من `nurse_` |

---

## 🏗️ هيكل الـ Feature الجديد

```
lib/features/doctor/
├── data/
│   ├── data_sources/
│   │   └── doctor_remote_data_source.dart
│   ├── models/
│   │   ├── doctor_model.dart
│   │   └── review_model.dart (نفس الموجود في nurse)
│   └── repositories/
│       └── doctor_model_repository.dart
├── domain/
│   ├── entities/
│   │   └── doctor_entity.dart
│   ├── repositories/
│   │   └── doctor_repository.dart
│   └── use_cases/
│       └── get_all_doctors_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── doctor_event.dart
    │   ├── doctor_state.dart
    │   └── doctors_bloc.dart
    ├── screens/
    │   ├── doctor_details_feedbacks_tap_screen.dart
    │   ├── doctor_details_personal_tap_screen.dart
    │   ├── doctor_details_prices_tap_screen.dart
    │   ├── doctor_details_screen.dart
    │   ├── doctor_details_taps_screens.dart
    │   ├── doctor_tracking.dart
    │   └── vertical_specialists_list.dart
    └── widgets/
        ├── extra_options_for_doctor.dart
        ├── doctor_details_taps.dart
        ├── doctor_extra_options_card.dart
        ├── doctor_profile_details_image.dart
        ├── rate_doctor_bottom_sheet.dart
        ├── rate_doctor_button.dart
        ├── request_button.dart
        ├── small_card_doctor_details.dart
        ├── specialists_list.dart
        ├── vertical_specialist_card.dart
        ├── personal_screen_widgets/
        │   ├── doctor_courses_section.dart
        │   ├── doctor_education_section.dart
        │   ├── doctor_languages_row.dart
        │   └── doctor_publication_section.dart
        └── prices_screen_widgets/
            ├── price_list.dart
            └── service_price_row.dart
```

---

## 📊 الـ Properties في DoctorEntity

بناءً على NurseEntity الموجود، الـ DoctorEntity سيحتوي على:

```dart
class DoctorEntity {
  final int id;
  final UserService? userData;
  final String? doctorId;              // بدلاً من nurseId
  final String? associationCard;
  final String? licence;
  final String? certificate;
  final double? distanceKM;
  final double? distanceM;
  final List<ReviewModel>? reviewList;
  final List<String>? languageList;
  final List<String>? educationList;
  final List<String>? publicationsList;
  final List<String>? coursesList;
  final List<ServicesModel>? servicesList;
}
```

---

## 🔄 التغييرات المطلوبة في Authentication

### 📍 المكان: `lib/features/authentication/`

يجب إضافة نوع جديد للمستخدم:
- **الممرض** (Nurse)
- **المساعد** (Assistant)
- **الدكتور** (Doctor) ← **جديد**

### الملفات التي تحتاج تعديل:

#### 1. User Entity/Model
```dart
// lib/features/authentication/domain/entities/user_entity.dart
enum UserType {
  patient,
  nurse,
  assistant,
  doctor,  // ← إضافة جديدة
  admin
}
```

#### 2. Registration Screens
- إضافة خيار "دكتور" في صفحة اختيار نوع الحساب
- شاشة تسجيل بيانات الدكتور (مشابهة للممرض)

#### 3. Auth Bloc/Events
- إضافة Event لتسجيل الدكتور
- تحديث الـ State للتعامل مع نوع الدكتور

---

## 📁 قائمة الملفات التي سيتم إنشاؤها (40+ ملف)

### Domain Layer (5 ملفات)
- ✅ `doctor_entity.dart`
- ✅ `doctor_repository.dart`
- ✅ `get_all_doctors_usecase.dart`
- ✅ `rate_doctor_usecase.dart`
- ✅ `get_doctor_by_id_usecase.dart`

### Data Layer (3 ملفات)
- ✅ `doctor_model.dart`
- ✅ `doctor_remote_data_source.dart`
- ✅ `doctor_model_repository.dart`

### Presentation - Bloc (3 ملفات)
- ✅ `doctor_event.dart`
- ✅ `doctor_state.dart`
- ✅ `doctors_bloc.dart`

### Presentation - Screens (7 ملفات)
- ✅ `doctor_details_screen.dart`
- ✅ `doctor_details_taps_screens.dart`
- ✅ `doctor_details_personal_tap_screen.dart`
- ✅ `doctor_details_prices_tap_screen.dart`
- ✅ `doctor_details_feedbacks_tap_screen.dart`
- ✅ `doctor_tracking.dart`
- ✅ `vertical_specialists_list.dart`

### Presentation - Widgets (18 ملف)
#### Main Widgets
- ✅ `extra_options_for_doctor.dart`
- ✅ `doctor_details_taps.dart`
- ✅ `doctor_extra_options_card.dart`
- ✅ `doctor_profile_details_image.dart`
- ✅ `rate_doctor_bottom_sheet.dart`
- ✅ `rate_doctor_button.dart`
- ✅ `request_button.dart`
- ✅ `small_card_doctor_details.dart`
- ✅ `specialists_list.dart`
- ✅ `vertical_specialist_card.dart`

#### Personal Screen Widgets
- ✅ `doctor_courses_section.dart`
- ✅ `doctor_education_section.dart`
- ✅ `doctor_languages_row.dart`
- ✅ `doctor_publication_section.dart`

#### Prices Screen Widgets
- ✅ `price_list.dart`
- ✅ `service_price_row.dart`

---

## 🔧 التعديلات في ملفات Authentication

### الملفات التي تحتاج تعديل:

#### 1. User Entity
📁 `lib/features/authentication/domain/entities/user_entity.dart`
- إضافة `doctor` في enum UserType

#### 2. User Model
📁 `lib/features/authentication/data/models/user_service_model.dart`
- تحديث fromJson/toJson للتعامل مع doctor type

#### 3. Registration Flow
📁 `lib/features/authentication/presentation/screens/`
- تعديل شاشة اختيار نوع الحساب
- إضافة/تعديل شاشة تسجيل بيانات الدكتور

#### 4. Auth Bloc
📁 `lib/features/authentication/presentation/bloc/`
- `auth_event.dart` - إضافة RegisterDoctorEvent
- `auth_state.dart` - إضافة states للدكتور
- `auth_bloc.dart` - إضافة handler للدكتور

#### 5. Translation Files
📁 `assets/i18n/`
- `ar.json` - إضافة ترجمات الدكتور
- `en.json` - إضافة ترجمات الدكتور

---

## 🌐 API Endpoints المطلوبة

### Backend Changes Needed:

```
GET    /api/doctors              - جلب جميع الدكاترة
GET    /api/doctors/{id}         - جلب دكتور معين
POST   /api/doctors/{id}/rate    - تقييم دكتور
GET    /api/doctors/nearby       - الدكاترة القريبين
POST   /api/auth/register/doctor - تسجيل دكتور جديد
```

---

## 📝 Translation Keys المطلوبة

### Arabic (ar.json)
```json
{
  "doctor": {
    "doctor": "دكتور",
    "doctors": "الدكاترة",
    "find_doctor": "ابحث عن دكتور",
    "doctor_details": "تفاصيل الدكتور",
    "rate_doctor": "قيم الدكتور",
    "no_doctors_found": "لا يوجد دكاترة",
    "nearby_doctors": "دكاترة قريبين",
    ...
  }
}
```

### English (en.json)
```json
{
  "doctor": {
    "doctor": "Doctor",
    "doctors": "Doctors",
    "find_doctor": "Find a Doctor",
    "doctor_details": "Doctor Details",
    "rate_doctor": "Rate Doctor",
    "no_doctors_found": "No doctors found",
    "nearby_doctors": "Nearby Doctors",
    ...
  }
}
```

---

## 🎯 خطوات التنفيذ بالترتيب

### Phase 1: Domain Layer ✅
1. إنشاء `doctor_entity.dart`
2. إنشاء `doctor_repository.dart` (interface)
3. إنشاء Use Cases

### Phase 2: Data Layer ✅
4. إنشاء `doctor_model.dart`
5. إنشاء `doctor_remote_data_source.dart`
6. إنشاء `doctor_model_repository.dart` (implementation)

### Phase 3: Presentation - BLoC ✅
7. إنشاء `doctor_event.dart`
8. إنشاء `doctor_state.dart`
9. إنشاء `doctors_bloc.dart`

### Phase 4: Presentation - Screens ✅
10. إنشاء شاشات Doctor Details
11. إنشاء شاشة Tracking
12. إنشاء Vertical List

### Phase 5: Presentation - Widgets ✅
13. إنشاء جميع الـ widgets المطلوبة

### Phase 6: Authentication Updates 🔄
14. تعديل User Entity/Model
15. تعديل Registration Screens
16. تعديل Auth Bloc

### Phase 7: Integration & Testing 🧪
17. تعديل Dependency Injection
18. إضافة Routes
19. إضافة Translations
20. Testing

---

## 📦 Dependency Injection

### الملف: `lib/injection_container.dart`

يجب إضافة:
```dart
// Doctor Feature
sl.registerLazySingleton<DoctorRemoteDataSource>(
  () => DoctorRemoteDataSourceImpl(dio: sl())
);
sl.registerLazySingleton<DoctorRepository>(
  () => DoctorRepositoryImpl(remoteDataSource: sl())
);
sl.registerLazySingleton(() => GetAllDoctorsUseCase(sl()));
sl.registerLazySingleton(() => RateDoctorUseCase(sl()));

// Doctor Bloc
sl.registerFactory(
  () => DoctorBloc(
    getAllDoctorsUseCase: sl(),
    rateDoctorUseCase: sl(),
  )
);
```

---

## 🗺️ Routing

إضافة routes جديدة للدكاترة:
```dart
static const String doctorsList = '/doctors-list';
static const String doctorDetails = '/doctor-details';
static const String doctorTracking = '/doctor-tracking';
```

---

## ⚙️ Configuration Files

لا يوجد تغييرات مطلوبة في:
- ❌ `pubspec.yaml` - نفس الـ dependencies
- ❌ `analysis_options.yaml`
- ❌ Android/iOS configs

---

## 🎨 Assets

قد نحتاج إضافة:
- `assets/images/doctor_placeholder.png`
- `assets/icons/doctor_icon.svg`
- أي أيقونات خاصة بالدكاترة

---

## 📊 الفرق بين Nurse و Doctor

| Feature | Nurse | Doctor |
|---------|-------|--------|
| API Endpoint | `/nurses` | `/doctors` |
| User Type | `nurse` or `assistant` | `doctor` |
| Translation Key | `nurse.*` | `doctor.*` |
| File Prefix | `nurse_` | `doctor_` |
| Entity Name | `NurseEntity` | `DoctorEntity` |
| Bloc Name | `NurseBloc` | `DoctorBloc` |

---

## ✅ Checklist النهائي

### Domain Layer
- [ ] doctor_entity.dart
- [ ] doctor_repository.dart
- [ ] get_all_doctors_usecase.dart
- [ ] rate_doctor_usecase.dart

### Data Layer
- [ ] doctor_model.dart
- [ ] doctor_remote_data_source.dart
- [ ] doctor_model_repository.dart

### Presentation
- [ ] doctor_event.dart
- [ ] doctor_state.dart
- [ ] doctors_bloc.dart
- [ ] جميع الـ screens (7 files)
- [ ] جميع الـ widgets (18 files)

### Authentication
- [ ] تعديل UserType enum
- [ ] تعديل User Model
- [ ] تعديل Registration screens
- [ ] تعديل Auth Bloc

### Integration
- [ ] Dependency Injection
- [ ] Routing
- [ ] Translations (AR/EN)
- [ ] Testing

---

## 🚀 البداية

بعد موافقتك، سنبدأ بـ:
1. ✅ إنشاء Domain Layer
2. ✅ إنشاء Data Layer
3. ✅ إنشاء Presentation Layer
4. ✅ تعديل Authentication
5. ✅ Integration

---

## 📌 ملاحظات مهمة

1. **Clean Architecture**: الالتزام بنفس البنية المستخدمة في Nurse feature
2. **Code Reusability**: بعض الـ widgets قد تكون قابلة للمشاركة (مثل ReviewModel)
3. **Testing**: يجب كتابة Unit Tests للـ Use Cases والـ BLoC
4. **Error Handling**: نفس آلية معالجة الأخطاء المستخدمة في Nurse
5. **State Management**: استخدام BLoC pattern
6. **API Integration**: التأكد من جاهزية الـ Backend endpoints

---

**آخر تحديث:** 8 ديسمبر 2025  
**الحالة:** جاهز للتنفيذ ⚡
