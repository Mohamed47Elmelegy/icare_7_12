# توثيق جلب الخدمات للممرضات (Nurses) في التطبيق

## نظرة عامة
هذا المستند يشرح كيفية جلب الخدمات (Services) المتاحة للممرضات والمساعدين والأطباء في التطبيق.

---

## 🔍 تدفق البيانات (Data Flow)

### 1. نقطة البداية - شاشة البحث (Search Screen)
**الملف**: `lib/features/search/presentation/screens/search_screen.dart`

عندما يختار المستخدم نوع المقدم (Provider Type)، يتم تحميل الخدمات تلقائياً:

```dart
// السطر 28-32 في search_screen.dart
if (state is ProviderTypeSelectedState) {
  final accountBloc = context.read<AccountBloc>();
  accountBloc.getAllServiceList(userType: state.providerType);
  debugPrint("🔄 Reloading services for: ${state.providerType}");
}
```

**أنواع المقدمين المتاحة:**
- `nurse` - ممرضة
- `assistant` - مساعد
- `doctor` - دطبيب

---

### 2. جلب الخدمات من AccountBloc
**الملف**: `lib/features/account/presentation/bloc/account_bloc.dart`

الدالة المسؤولة عن جلب الخدمات:

```dart
// السطر 366-381 في account_bloc.dart
List<ServicesModel> allServiceList = [];

getAllServiceList({String? userType}) async {
  if (!Util.checkUser()) return;

  // الحصول على نوع المستخدم من البيانات الحالية إذا لم يتم توفيره
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

**كيف تعمل:**
1. تتحقق من وجود مستخدم مسجل دخول
2. إذا لم يتم تمرير `userType`، تستخدم النوع من المستخدم الحالي
3. تطلب الخدمات من `UserServiceRemoteDataSource`
4. تحفظ النتيجة في `allServiceList`

---

### 3. طلب API - جلب الخدمات
**الملف**: `lib/features/account/data/data_sources/account_data_source.dart`

الدالة المسؤولة عن استدعاء API:

```dart
// السطر 187-215 في account_data_source.dart
static Future<List<ServicesModel>> getAllServicesList({String? userType}) async {
  try {
    // بناء URL مع معامل user_type إذا تم توفيره
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
      debugPrint("✅ Loaded ${services.length} services" + 
          (userType != null ? " for $userType" : ""));
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

---

### 4. عنوان API (API Endpoint)
**الملف**: `lib/core/strings/api/api_url.dart`

```dart
static const String SERVICES = '${BASE_URL}service/list';
```

**الطلب الكامل:**
```
GET https://admin.i-care.one/api/v1/service/list?user_type=nurse
```

**المعاملات (Query Parameters):**
- `user_type` (اختياري): نوع المستخدم (`nurse`, `assistant`, `doctor`)

**الهيدر (Headers):**
```dart
ApiUrl.headerAuth = {
  'Content-Type': 'application/json',
  'ID': '<user_id>',
  'user_type': '<user_type>',
}
```

---

### 5. عرض الخدمات - Service Selector Widget
**الملف**: `lib/features/search/presentation/widgets/service_selector.dart`

يعرض قائمة الخدمات المتاحة:

```dart
// السطر 34-41 في service_selector.dart
var accountBloc = AccountBloc.get(ctx);
var searchBloc = SearchBloc.get(ctx);

// الخدمات مفلترة بالفعل حسب user_type من API
var servicesList = accountBloc.allServiceList;

if (accountBloc.allServiceList.isEmpty) return const SizedBox.shrink();
```

**المميزات:**
- يعرض عدد الخدمات المتاحة للنوع المختار
- يسمح باختيار خدمات متعددة
- يعرض رسالة إذا لم تكن هناك خدمات متاحة
- يحتفظ بالخدمات المختارة في `searchBloc.selectedServices`

---

## 📊 مثال عملي - كيفية جلب خدمات الممرضات

### الخطوة 1: تسجيل الدخول
```dart
POST https://admin.i-care.one/api/v1/auth/login
{
    "phone": "1123876422",
    "password": "1123876422"
}
```

**الاستجابة:**
```json
{
    "status": true,
    "user": {
        "id": 441,
        "user_type": "nurse",
        "name": "hossa",
        // ... بقية البيانات
    }
}
```

### الخطوة 2: جلب خدمات الممرضات
```dart
GET https://admin.i-care.one/api/v1/service/list?user_type=nurse
Headers: {
  "Content-Type": "application/json",
  "ID": "441",
  "user_type": "nurse"
}
```

**الاستجابة المتوقعة:**
```json
{
    "status": true,
    "data": [
        {
            "id": 1,
            "value": "قياس ضغط الدم",
            "name": "Blood Pressure Measurement",
            "user_type": "nurse"
        },
        {
            "id": 2,
            "value": "قياس السكر",
            "name": "Glucose Measurement",
            "user_type": "nurse"
        }
        // ... المزيد من الخدمات
    ]
}
```

---

## 🔄 دورة الحياة الكاملة (Complete Life Cycle)

```
1. المستخدم يفتح شاشة البحث
   ↓
2. المستخدم يختار نوع المقدم (مثل: nurse)
   ↓
3. SearchBloc يصدر event: ProviderTypeSelectedEvent
   ↓
4. SearchScreen يستمع ويطلب جلب الخدمات
   ↓
5. AccountBloc.getAllServiceList(userType: "nurse")
   ↓
6. UserServiceRemoteDataSource.getAllServicesList(userType: "nurse")
   ↓
7. HTTP GET Request إلى API
   ↓
8. API يرجع الخدمات المتاحة للممرضات فقط
   ↓
9. البيانات تحول إلى List<ServicesModel>
   ↓
10. تحفظ في accountBloc.allServiceList
   ↓
11. ServiceSelector يعرض القائمة
   ↓
12. المستخدم يختار الخدمات المطلوبة
   ↓
13. الخدمات المختارة تحفظ في searchBloc.selectedServices
```

---

## 📝 ملاحظات مهمة

### 1. الفلترة التلقائية
الخدمات يتم فلترتها من جانب الـ API بناءً على `user_type`:
- إذا كان المستخدم `nurse`، سيحصل فقط على خدمات الممرضات
- إذا كان `doctor`، سيحصل فقط على خدمات الأطباء

### 2. التحديث التلقائي
عند تغيير نوع المقدم في شاشة البحث، يتم تحديث قائمة الخدمات تلقائياً:

```dart
// search_screen.dart - Line 28
if (state is ProviderTypeSelectedState) {
  accountBloc.getAllServiceList(userType: state.providerType);
}
```

### 3. التخزين المؤقت
الخدمات المحملة تبقى في الذاكرة في `accountBloc.allServiceList` ولا يتم إعادة تحميلها إلا عند:
- تغيير نوع المقدم
- إعادة تشغيل التطبيق

---

## 🛠️ كيفية إضافة خدمة جديدة (للمطورين)

### في جانب Backend:
1. إضافة الخدمة في قاعدة البيانات مع تحديد `user_type`
2. التأكد من أن API يرجع الخدمة الجديدة

### في جانب التطبيق:
لا يوجد شيء للتعديل! النظام يجلب الخدمات تلقائياً من API.

---

## 🔍 استكشاف الأخطاء (Troubleshooting)

### المشكلة: لا تظهر خدمات
**الحلول:**
1. تحقق من أن المستخدم مسجل دخول
2. تحقق من أن `user_type` صحيح في بيانات المستخدم
3. افحص الـ console logs للتأكد من نجاح API call
4. تحقق من أن API يرجع بيانات صحيحة

### المشكلة: تظهر خدمات خاطئة
**الحلول:**
1. تحقق من قيمة `userType` في الطلب
2. تأكد من أن API يفلتر بشكل صحيح
3. افحص `allServiceList` في debugger

---

## 📚 الملفات ذات الصلة

| الملف | الوظيفة |
|------|---------|
| `search_screen.dart` | شاشة البحث الرئيسية |
| `service_selector.dart` | عنصر اختيار الخدمات |
| `account_bloc.dart` | إدارة حالة الخدمات |
| `account_data_source.dart` | استدعاء API |
| `search_repository_impl.dart` | البحث بالفلاتر |
| `api_url.dart` | عناوين API |

---

## 🎯 الخلاصة

النظام يعمل بشكل تلقائي:
1. عند اختيار نوع المقدم → يتم جلب الخدمات المخصصة له
2. الخدمات مفلترة من API حسب `user_type`
3. المستخدم يختار الخدمات المطلوبة
4. البحث يستخدم الخدمات المختارة للفلترة

**لا يحتاج المطور إلى تعديل أي شيء** طالما API يعمل بشكل صحيح!
