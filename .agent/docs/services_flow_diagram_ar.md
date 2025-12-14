# مخطط تدفق جلب الخدمات (Services Flow Diagram)

## 📊 التدفق العام

```
┌─────────────────────────────────────────────────────────────────┐
│                    1. تسجيل الدخول (Login)                      │
│                                                                 │
│  POST /api/v1/auth/login                                        │
│  { "phone": "1123876422", "password": "1123876422" }            │
│                                                                 │
│  Response: { "user": { "id": 441, "user_type": "nurse" } }      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│              2. فتح شاشة البحث (Open Search Screen)             │
│                                                                 │
│  File: search_screen.dart                                       │
│  - عرض خيارات البحث                                            │
│  - عرض Provider Type Selector                                  │
│  - عرض Service Selector                                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│         3. اختيار نوع المقدم (Select Provider Type)              │
│                                                                 │
│  Widget: ProviderTypeSelector                                   │
│  Options: Nurse | Assistant | Doctor                           │
│                                                                 │
│  User selects: "Nurse" ✓                                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│           4. إصدار Event (Dispatch Event)                       │
│                                                                 │
│  SearchBloc.add(                                                │
│    SelectProviderTypeEvent(providerType: "nurse")               │
│  )                                                              │
│                                                                 │
│  State → ProviderTypeSelectedState                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│        5. استماع للحالة (Listen to State)                        │
│                                                                 │
│  BlocListener in search_screen.dart:                            │
│                                                                 │
│  if (state is ProviderTypeSelectedState) {                      │
│    accountBloc.getAllServiceList(                               │
│      userType: state.providerType  // "nurse"                   │
│    );                                                           │
│  }                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│      6. طلب الخدمات من AccountBloc                               │
│                                                                 │
│  File: account_bloc.dart                                        │
│  Function: getAllServiceList({ userType: "nurse" })             │
│                                                                 │
│  - Check if user is logged in ✓                                 │
│  - Call remote data source                                      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│       7. استدعاء API (Call Remote API)                          │
│                                                                 │
│  File: account_data_source.dart                                 │
│  Function: getAllServicesList({ userType: "nurse" })            │
│                                                                 │
│  URL: https://admin.i-care.one/api/v1/service/list              │
│       ?user_type=nurse                                          │
│                                                                 │
│  Headers: {                                                     │
│    "Content-Type": "application/json",                          │
│    "ID": "441",                                                 │
│    "user_type": "nurse"                                         │
│  }                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│          8. استجابة API (API Response)                          │
│                                                                 │
│  {                                                              │
│    "status": true,                                              │
│    "data": [                                                    │
│      {                                                          │
│        "id": 1,                                                 │
│        "value": "قياس ضغط الدم",                                │
│        "name": "Blood Pressure",                                │
│        "user_type": "nurse"                                     │
│      },                                                         │
│      { ... more services ... }                                  │
│    ]                                                            │
│  }                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│        9. تحويل البيانات (Parse Response)                       │
│                                                                 │
│  ServicesModel.listModelFromJson(data)                          │
│                                                                 │
│  Result: List<ServicesModel> [                                  │
│    ServicesModel(id: 1, value: "قياس ضغط الدم", ...),          │
│    ServicesModel(id: 2, value: "قياس السكر", ...),             │
│    ...                                                          │
│  ]                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│         10. حفظ في Bloc (Save in Bloc)                          │
│                                                                 │
│  accountBloc.allServiceList = parsedServices;                   │
│                                                                 │
│  Debug: "📋 Loaded 15 services for user_type: nurse"            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│         11. عرض الخدمات (Display Services)                       │
│                                                                 │
│  Widget: ServiceSelector                                        │
│  File: service_selector.dart                                    │
│                                                                 │
│  BlocBuilder<SearchBloc, SearchState>(                          │
│    var servicesList = accountBloc.allServiceList;               │
│                                                                 │
│    ListView.builder(                                            │
│      itemCount: servicesList.length,  // 15                     │
│      itemBuilder: (context, index) {                            │
│        // عرض كل خدمة مع checkbox                               │
│      }                                                          │
│    )                                                            │
│  )                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│        12. اختيار الخدمات (Select Services)                      │
│                                                                 │
│  User clicks on services:                                       │
│  ☑ قياس ضغط الدم                                               │
│  ☑ قياس السكر                                                  │
│  ☐ حقن                                                         │
│                                                                 │
│  SearchBloc.selectedServices = [                                │
│    ServicesModel(id: 1, ...),                                   │
│    ServicesModel(id: 2, ...)                                    │
│  ]                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│           13. البحث بالخدمات (Search with Services)              │
│                                                                 │
│  User clicks "Search" button                                    │
│                                                                 │
│  SearchBloc.add(                                                │
│    SearchByFiltersEvent(                                        │
│      filters: SearchFilterEntity(                               │
│        userType: "nurse",                                       │
│        serviceIds: [1, 2],  // IDs of selected services         │
│        latitude: 37.4219983,                                    │
│        longitude: -122.084                                      │
│      )                                                          │
│    )                                                            │
│  )                                                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│          14. البحث في Repository                                │
│                                                                 │
│  File: search_repository_impl.dart                              │
│  Function: searchByFilters(filters)                             │
│                                                                 │
│  - Filter by userType: "nurse" ✓                                │
│  - Filter by serviceIds: [1, 2] ✓                               │
│  - Filter by location radius ✓                                  │
│  - Sort by distance                                             │
│                                                                 │
│  Result: List of matching nurses                                │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│           15. عرض النتائج (Display Results)                      │
│                                                                 │
│  Widget: SearchListWidget                                       │
│                                                                 │
│  Shows list of nurses that:                                     │
│  ✓ Are type "nurse"                                             │
│  ✓ Offer selected services (قياس ضغط الدم, قياس السكر)          │
│  ✓ Are within search radius                                     │
│  ✓ Sorted by distance from user                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 تدفق البيانات بالتفصيل

### المرحلة 1: تحضير البيانات
```
User Login → Get user_type → Store in session
```

### المرحلة 2: طلب الخدمات
```
Select Provider Type → Trigger Event → Call API → Get Services
```

### المرحلة 3: عرض واختيار
```
Display Services → User selects → Save selection
```

### المرحلة 4: البحث والفلترة
```
Apply filters → Search in repository → Return results
```

---

## 📦 الأنواع المستخدمة (Data Types)

### ServicesModel
```dart
class ServicesModel {
  final int id;
  final String value;      // الاسم بالعربي
  final String? name;      // الاسم بالإنجليزي
  final String? userType;  // nurse, assistant, doctor
}
```

### SearchFilterEntity
```dart
class SearchFilterEntity {
  final String? userType;        // "nurse", "assistant", "doctor"
  final List<int>? serviceIds;   // [1, 2, 3]
  final double? latitude;
  final double? longitude;
  final double? searchRadius;    // بالكيلومتر
}
```

---

## 🎯 الملخص السريع

| الخطوة | الوصف | الملف |
|-------|-------|------|
| 1 | اختيار نوع المقدم | `search_screen.dart` |
| 2 | طلب الخدمات | `account_bloc.dart` |
| 3 | استدعاء API | `account_data_source.dart` |
| 4 | استقبال البيانات | `account_data_source.dart` |
| 5 | حفظ البيانات | `account_bloc.dart` |
| 6 | عرض القائمة | `service_selector.dart` |
| 7 | اختيار الخدمات | `search_bloc.dart` |
| 8 | البحث بالفلاتر | `search_repository_impl.dart` |

---

## 🔍 Debug Points

عند تتبع المشاكل، راقب هذه النقاط:

```
✓ Line 30 in search_screen.dart
  → Debug: "🔄 Reloading services for: nurse"

✓ Line 194 in account_data_source.dart
  → Debug: "🔍 Fetching services for user_type: nurse"

✓ Line 199 in account_data_source.dart
  → Debug: "📥 getAllServicesList Response: 200"

✓ Line 380 in account_bloc.dart
  → Debug: "📋 Loaded 15 services for user_type: nurse"
```

---

## ⚠️ نقاط مهمة

1. **الفلترة من API**: الخدمات مفلترة من Backend حسب `user_type`
2. **التحديث التلقائي**: عند تغيير النوع، تتحدث القائمة تلقائياً
3. **لا يوجد تخزين دائم**: البيانات في الذاكرة فقط (RAM)
4. **الاتصال مطلوب**: يجب وجود إنترنت لجلب الخدمات
