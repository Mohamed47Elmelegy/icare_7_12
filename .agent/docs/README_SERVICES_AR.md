# دليل شامل: نظام الخدمات في تطبيق iCare

## 📚 نظرة عامة

هذا الدليل يشرح بالتفصيل كيفية عمل نظام جلب وإدارة الخدمات (Services) في تطبيق iCare، مع التركيز على الممرضات (Nurses).

---

## 📖 المحتويات

1. [**التوثيق الكامل**](./services_fetch_documentation_ar.md) - شرح تفصيلي لآلية جلب الخدمات
2. [**مخطط التدفق**](./services_flow_diagram_ar.md) - رسم توضيحي لتدفق البيانات
3. [**أمثلة API**](./api_examples_ar.md) - أمثلة عملية لاستخدام API

---

## 🚀 البداية السريعة

### كيف يتم جلب الخدمات؟

```dart
// 1. في AccountBloc
await accountBloc.getAllServiceList(userType: 'nurse');

// 2. الخدمات متاحة الآن في
accountBloc.allServiceList  // List<ServicesModel>
```

### كيف يتم عرض الخدمات؟

```dart
// في ServiceSelector Widget
var services = accountBloc.allServiceList;

ListView.builder(
  itemCount: services.length,
  itemBuilder: (context, index) {
    var service = services[index];
    return ServiceTile(service: service);
  },
);
```

---

## 🔑 المفاهيم الأساسية

### 1. أنواع المقدمين (Provider Types)

| النوع | القيمة في API | الوصف |
|------|---------------|-------|
| ممرضة | `nurse` | تقدم خدمات تمريضية |
| مساعد | `assistant` | يقدم خدمات مساعدة |
| طبيب | `doctor` | يقدم خدمات طبية |

### 2. بنية البيانات (Data Structure)

```dart
class ServicesModel {
  final int id;              // معرّف الخدمة
  final String value;        // الاسم بالعربي
  final String? name;        // الاسم بالإنجليزي
  final String? userType;    // نوع المقدم
}
```

### 3. API Endpoint

```
GET https://admin.i-care.one/api/v1/service/list?user_type={type}
```

**Parameters:**
- `user_type` (اختياري): `nurse`, `assistant`, أو `doctor`

---

## 📋 سيناريوهات الاستخدام

### Scenario 1: مستخدم يبحث عن ممرضة

```
1. المستخدم يفتح شاشة البحث
2. يختار "منرضة" من Provider Type
3. النظام تلقائياً يجلب خدمات الممرضات
4. المستخدم يختار الخدمات المطلوبة (مثلاً: قياس ضغط الدم)
5. يضغط "بحث"
6. يحصل على قائمة بالممرضات التي تقدم هذه الخدمات
```

### Scenario 2: ممرضة تحدث خدماتها

```
1. الممرضة تسجل دخول
2. تذهب إلى صفحة البروفايل
3. تختار "تعديل الخدمات"
4. تحدد الخدمات التي تقدمها
5. تحفظ التغييرات
6. يتم إرسال البيانات للسيرفر
```

---

## 🛤️ مسار البيانات (Data Flow)

```
┌──────────────┐
│ User Action  │ (يختار نوع المقدم)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Search Bloc  │ (SelectProviderTypeEvent)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Account Bloc │ (getAllServiceList)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Data Source  │ (API Call)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ API Server   │ (يرجع الخدمات المفلترة)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Parse Data   │ (ServicesModel)
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Display UI   │ (ServiceSelector)
└──────────────┘
```

---

## 📁 الملفات الرئيسية

### 1. **Presentation Layer**

| الملف | الوظيفة | المسار |
|------|---------|--------|
| `search_screen.dart` | شاشة البحث الرئيسية | `lib/features/search/presentation/screens/` |
| `service_selector.dart` | عنصر اختيار الخدمات | `lib/features/search/presentation/widgets/` |
| `search_bloc.dart` | إدارة حالة البحث | `lib/features/search/presentation/bloc/` |
| `account_bloc.dart` | إدارة بيانات الحساب | `lib/features/account/presentation/bloc/` |

### 2. **Data Layer**

| الملف | الوظيفة | المسار |
|------|---------|--------|
| `account_data_source.dart` | طلبات API | `lib/features/account/data/data_sources/` |
| `search_repository_impl.dart` | منطق البحث | `lib/features/search/data/repositories/` |

### 3. **Domain Layer**

| الملف | الوظيفة | المسار |
|------|---------|--------|
| `services.dart` | نموذج بيانات الخدمة | `lib/features/categories/data/models/` |

---

## 🔍 كود مهم للمراجعة

### 1. جلب الخدمات (Account Bloc)

```dart
// lib/features/account/presentation/bloc/account_bloc.dart
// Lines 366-381

List<ServicesModel> allServiceList = [];

getAllServiceList({String? userType}) async {
  if (!Util.checkUser()) return;

  // استخدام نوع المستخدم الحالي إذا لم يتم توفيره
  if (userType == null && currentUser?.userType != null) {
    userType = currentUser!.userType;
    debugPrint("🔍 Using current user type: $userType");
  }

  allServiceList = await UserServiceRemoteDataSource.getAllServicesList(
      userType: userType);

  debugPrint(
      "📋 Loaded ${allServiceList.length} services for user_type: ${userType ?? 'all'}");
}
```

### 2. طلب API (Data Source)

```dart
// lib/features/account/data/data_sources/account_data_source.dart
// Lines 187-215

static Future<List<ServicesModel>> getAllServicesList({String? userType}) async {
  try {
    // بناء URL مع فلتر user_type
    String url = ApiUrl.SERVICES;
    if (userType != null && userType.isNotEmpty) {
      url = '$url?user_type=$userType';
      debugPrint("🔍 Fetching services for user_type: $userType");
    }

    var response = await http.get(Uri.parse(url), headers: ApiUrl.headerAuth);
    debugPrint("📥 getAllServicesList Response: ${response.statusCode}");

    var decodedData = jsonDecode(response.body);
    if (decodedData['status'] == true) {
      var services = ServicesModel.listModelFromJson(jsonEncode(decodedData['data']));
      debugPrint("✅ Loaded ${services.length} services");
      return services;
    } else {
      return [];
    }
  } catch (e) {
    debugPrint("❌ Error in getAllServicesList: $e");
    return [];
  }
}
```

### 3. الاستماع للتغييرات (Search Screen)

```dart
// lib/features/search/presentation/screens/search_screen.dart
// Lines 25-46

BlocListener<SearchBloc, SearchState>(
  listener: (context, state) {
    // إعادة تحميل الخدمات عند تغيير نوع المقدم
    if (state is ProviderTypeSelectedState) {
      final accountBloc = context.read<AccountBloc>();
      accountBloc.getAllServiceList(userType: state.providerType);
      debugPrint("🔄 Reloading services for: ${state.providerType}");
    }

    if (state is SearchSuccessState) {
      SnackBarBuilder.showFeedBackMessage(
        context,
        '${translate("search.found")} ${state.results.length} ${translate("search.results")}',
        Colors.green,
      );
    }
  },
  // ...
)
```

### 4. عرض الخدمات (Service Selector)

```dart
// lib/features/search/presentation/widgets/service_selector.dart
// Lines 34-42

BlocBuilder<SearchBloc, SearchState>(
  builder: (ctx, searchState) {
    var accountBloc = AccountBloc.get(ctx);
    var searchBloc = SearchBloc.get(ctx);

    // الخدمات مفلترة من API
    var servicesList = accountBloc.allServiceList;

    if (accountBloc.allServiceList.isEmpty) 
      return const SizedBox.shrink();
    
    // ... عرض القائمة
  },
)
```

---

## 🎯 أسئلة شائعة (FAQ)

### س1: كيف يتم فلترة الخدمات حسب نوع المقدم؟

**ج:** الفلترة تحدث في Backend (API). عندما ترسل `user_type=nurse` في الطلب، الـ API يرجع فقط الخدمات التي `user_type = "nurse"`.

```dart
// في الكود
getAllServiceList(userType: 'nurse');

// في API
GET /service/list?user_type=nurse

// النتيجة: فقط خدمات الممرضات
```

---

### س2: هل يمكن جلب خدمات أكثر من نوع في نفس الوقت؟

**ج:** لا، API الحالي يدعم نوع واحد فقط في كل طلب. إذا أردت خدمات متعددة:

```dart
// خيار 1: طلبات منفصلة
var nurseServices = await getAllServicesList(userType: 'nurse');
var doctorServices = await getAllServicesList(userType: 'doctor');

// خيار 2: جلب الكل ثم الفلترة محلياً
var allServices = await getAllServicesList(); // بدون user_type
var nurseServices = allServices.where((s) => s.userType == 'nurse').toList();
```

---

### س3: متى يتم تحديث قائمة الخدمات؟

**ج:** القائمة تتحدث في هذه الحالات:
1. عند فتح شاشة البحث أول مرة
2. عند تغيير نوع المقدم
3. عند إعادة تشغيل التطبيق

**لا تتحدث** تلقائياً في الخلفية.

---

### س4: كيف أضيف خدمة جديدة؟

**ج:** الخدمات تُدار من Backend:

1. أضف الخدمة في قاعدة البيانات:
```sql
INSERT INTO services (value, name, user_type) 
VALUES ('خدمة جديدة', 'New Service', 'nurse');
```

2. التطبيق سيجلبها تلقائياً في المرة القادمة!

---

### س5: لماذا لا تظهر الخدمات؟

**ج:** تحقق من:

```dart
// 1. هل المستخدم مسجل دخول؟
if (!Util.checkUser()) return; // ✗ لا يجلب الخدمات

// 2. هل API يرجع بيانات؟
debugPrint("📥 Response: ${response.statusCode}"); // يجب أن يكون 200

// 3. هل البيانات صحيحة؟
debugPrint("Data: ${decodedData['status']}"); // يجب أن يكون true

// 4. هل القائمة فارغة؟
debugPrint("Services count: ${allServiceList.length}"); // > 0
```

---

## 🔧 تصحيح الأخطاء (Debugging)

### تتبع Debug Logs

عند تشغيل التطبيق، ابحث عن هذه الرسائل في Console:

```
✓ 🔄 Reloading services for: nurse
  → المستخدم اختار نوع المقدم

✓ 🔍 Fetching services for user_type: nurse
  → بدأ طلب API

✓ 📥 getAllServicesList Response: 200
  → API أجاب بنجاح

✓ ✅ Loaded 15 services for nurse
  → تم تحميل 15 خدمة

✓ 📋 Loaded 15 services for user_type: nurse
  → تم حفظ الخدمات في Bloc
```

### إذا ظهرت أخطاء:

```
✗ ❌ Error in getAllServicesList: ...
  → خطأ في الاتصال أو معالجة البيانات

✗ Response: 401/403
  → مشكلة في التوثيق (Headers)

✗ Response: 500
  → مشكلة في السيرفر

✗ Services count: 0
  → لا توجد خدمات أو فشل التحميل
```

---

## 💡 نصائح للمطورين

### 1. استخدم Debug Prints

```dart
getAllServiceList({String? userType}) async {
  debugPrint("🔹 START: getAllServiceList");
  debugPrint("🔹 userType: $userType");
  
  // ... الكود
  
  debugPrint("🔹 END: Loaded ${allServiceList.length} services");
}
```

### 2. تحقق من الحالة قبل العرض

```dart
Widget build(BuildContext context) {
  if (accountBloc.allServiceList.isEmpty) {
    return Center(child: Text('لا توجد خدمات'));
  }
  
  return ListView.builder(/* ... */);
}
```

### 3. استخدم Try-Catch

```dart
try {
  await getAllServiceList(userType: 'nurse');
} catch (e) {
  debugPrint("Error loading services: $e");
  // عرض رسالة خطأ للمستخدم
}
```

---

## 📊 إحصائيات الكود

| المقياس | القيمة |
|---------|--------|
| عدد الملفات الرئيسية | 8 |
| سطور كود API | ~30 |
| سطور كود Bloc | ~15 |
| سطور كود UI | ~265 |
| API Endpoints المستخدمة | 2 |

---

## 🔐 الأمان

### Headers المطلوبة

```dart
ApiUrl.headerAuth = {
  'Content-Type': 'application/json',
  'ID': '<user_id>',           // من تسجيل الدخول
  'user_type': '<user_type>',  // من تسجيل الدخول
}
```

**⚠️ مهم**: لا ترسل طلبات بدون Headers، وإلا ستحصل على 401 Unauthorized.

---

## 🎓 للتعلم أكثر

### اقرأ هذه الملفات بالترتيب:

1. **[التوثيق الكامل](./services_fetch_documentation_ar.md)** ← ابدأ من هنا
2. **[مخطط التدفق](./services_flow_diagram_ar.md)** ← لفهم التدفق
3. **[أمثلة API](./api_examples_ar.md)** ← للتطبيق العملي

### مصادر إضافية:

- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [HTTP Package](https://pub.dev/packages/http)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

---

## 📞 الدعم

إذا واجهت مشاكل:

1. راجع [FAQ](#-أسئلة-شائعة-faq)
2. تحقق من [Debug Logs](#تتبع-debug-logs)
3. راجع [أمثلة API](./api_examples_ar.md)

---

## 📝 الخلاصة النهائية

### الخدمات في iCare:

✅ **تُجلب** من API حسب نوع المقدم  
✅ **تُعرض** في ServiceSelector  
✅ **يُختار** منها المستخدم  
✅ **تُستخدم** في البحث والفلترة  

### العملية كلها:

```
Login → Choose Type → Load Services → Select → Search → Results
```

### الملفات الرئيسية:

1. `account_bloc.dart` - جلب وحفظ
2. `account_data_source.dart` - API
3. `search_screen.dart` - استماع
4. `service_selector.dart` - عرض

---

**تم إنشاء هذا الدليل في:** ديسمبر 2024  
**آخر تحديث:** 2025-12-14

---

🎉 **مبروك!** الآن أنت تفهم نظام الخدمات بالكامل!
