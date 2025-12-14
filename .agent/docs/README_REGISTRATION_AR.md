# دليل شامل: نظام التسجيل والخدمات في iCare

## 📚 فهرس التوثيق

### 1. **التوثيق الأساسي**
- **[registration_flow_ar.md](./registration_flow_ar.md)** - شرح تفصيلي لعملية التسجيل والتفرقة بين الممرض والمساعد
- **[registration_flow_diagram_ar.md](./registration_flow_diagram_ar.md)** - مخططات بصرية توضيحية

### 2. **توثيق نظام الخدمات**
- **[README_SERVICES_AR.md](./README_SERVICES_AR.md)** - الدليل الرئيسي لنظام الخدمات
- **[services_fetch_documentation_ar.md](./services_fetch_documentation_ar.md)** - شرح تفصيلي لآلية جلب الخدمات
- **[services_flow_diagram_ar.md](./services_flow_diagram_ar.md)** - مخططات تدفق البيانات
- **[api_examples_ar.md](./api_examples_ar.md)** - أمثلة عملية لاستخدام API

---

## 🎯 الإجابة على الأسئلة الرئيسية

### ❓ كيف يتم التفرقة بين الممرض ومساعد الممرض؟

#### الإجابة المختصرة:

```dart
// عند التسجيل، المستخدم يختار النوع
authBloc.isNurse = true;   // ممرض
authBloc.isNurse = false;  // مساعد ممرض

// البيانات المرسلة مختلفة
if (authBloc.isNurse) {
  registerData['user_type'] = 'nurse';
  registerData['license'] = File(...);         // مطلوب
  registerData['certificate'] = File(...);     // مطلوب
  registerData['associationCard'] = File(...); // مطلوب
} else {
  registerData['user_type'] = 'assistant';
  registerData['related_job_id'] = File(...);  // مطلوب
}
```

**التفاصيل الكاملة:** [registration_flow_ar.md](./registration_flow_ar.md)

---

### ❓ كيف تتغير البيانات عند التبديل بين الخيارات؟

#### الآلية:

```
1. المستخدم يضغط على "ممرض" أو "مساعد"
   ↓
2. يتم إرسال Event: SwitchNurseTypeEvent(isNurse: true/false)
   ↓
3. AuthBloc يغير قيمة isNurse
   ↓
4. BlocBuilder يعيد بناء الـ UI تلقائياً
   ↓
5. الحقول المطلوبة تظهر/تختفي بناءً على isNurse
```

**مثال من الكود:**

```dart
// في create_nurse_account.dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (ctx, state) {
    var bloc = AuthBloc.get(ctx);
    
    if (bloc.isNurse) {
      // عرض حقول الممرض
      return Column(
        children: [
          LicenseUploadField(),
          CertificateUploadField(),
          AssociationCardUploadField(),
        ],
      );
    } else {
      // عرض حقول المساعد
      return Column(
        children: [
          RelatedJobIDUploadField(),
        ],
      );
    }
  },
)
```

**التفاصيل الكاملة:** [registration_flow_diagram_ar.md](./registration_flow_diagram_ar.md)

---

### ❓ كيف يتم اختيار الخدمات في صفحة الأسعار؟

#### العملية:

```
1. المستخدم يذهب للبروفايل → تبويب "الأسعار"
   ↓
2. يضغط على أيقونة التعديل
   ↓
3. تظهر قائمة منسدلة بجميع الخدمات المتاحة
   ↓
4. يختار خدمة من القائمة
   ↓
5. يظهر حقل لإدخال السعر
   ↓
6. يدخل السعر ويضغط "حفظ"
   ↓
7. تُضاف الخدمة لقائمته ويتم رفعها للسيرفر
```

**الكود:**

```dart
// في service_list_drop_down.dart
DropdownButton<ServicesModel>(
  hint: Text("اختر خدمة"),
  items: bloc.allServiceList.map((service) {
    return DropdownMenuItem(
      value: service,
      child: Text(service.value),
    );
  }).toList(),
  onChanged: (selected) {
    // حفظ الخدمة المختارة
    bloc.add(ChangeCurrentService(item: selected));
  },
)

// عند إدخال السعر
TextField(
  hintText: "أدخل السعر",
  onChanged: (price) {
    bloc.add(ChangeCurrentService(
      item: currentService,
      txt: price
    ));
  },
)

// عند الحفظ
var item = ServicesModel(
  id: currentService.id,
  value: priceText  // السعر
);

await updateNurseOptionsValue(
  userData: {
    'services': [
      {'id': 1, 'value': '50'},
      {'id': 2, 'value': '100'},
    ]
  }
);
```

**التفاصيل الكاملة:** [registration_flow_ar.md](./registration_flow_ar.md#-صفحة-الأسعار-وتحديد-الخدمات)

---

### ❓ كيف يتم جلب الخدمات بناءً على النوع؟

```dart
// عند فتح صفحة الأسعار
accountBloc.getAllServiceList();

// الدالة داخل AccountBloc
getAllServiceList({String? userType}) async {
  // استخدام نوع المستخدم الحالي إذا لم يتم توفيره
  if (userType == null && currentUser?.userType != null) {
    userType = currentUser!.userType;  // "nurse" أو "assistant"
  }

  // طلب API مع الفلتر
  allServiceList = await UserServiceRemoteDataSource.getAllServicesList(
    userType: userType
  );
}

// في Data Source
static Future<List<ServicesModel>> getAllServicesList({
  String? userType
}) async {
  String url = ApiUrl.SERVICES;
  
  if (userType != null && userType.isNotEmpty) {
    url = '$url?user_type=$userType';  // فلترة بناءً على النوع
  }

  var response = await http.get(Uri.parse(url), headers: ApiUrl.headerAuth);
  
  var decodedData = jsonDecode(response.body);
  if (decodedData['status'] == true) {
    return ServicesModel.listModelFromJson(jsonEncode(decodedData['data']));
  }
  
  return [];
}
```

**النتيجة:**
- **ممرض**: يحصل فقط على خدمات الممرضات
- **مساعد**: يحصل فقط على خدمات المساعدين

**التفاصيل الكاملة:** [services_fetch_documentation_ar.md](./services_fetch_documentation_ar.md)

---

## 🔄 التدفق الكامل - من التسجيل إلى البحث

```
┌─────────────────────────────────────────────────────────────┐
│         مرحلة 1: التسجيل (Registration)                     │
├─────────────────────────────────────────────────────────────┤
│  1. اختيار النوع: ممرض أو مساعد                            │
│  2. ملء البيانات المطلوبة (تختلف حسب النوع)                │
│  3. رفع الملفات المطلوبة (تختلف حسب النوع)                 │
│  4. إرسال للسيرفر مع user_type                              │
│  5. الموافقة من الإدارة                                     │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│        مرحلة 2: تحديد الخدمات (Services Selection)         │
├─────────────────────────────────────────────────────────────┤
│  1. تسجيل الدخول                                            │
│  2. الذهاب للبروفايل → تبويب الأسعار                        │
│  3. جلب الخدمات المتاحة (مفلترة حسب user_type)              │
│  4. اختيار الخدمات وتحديد الأسعار                           │
│  5. حفظ ورفع للسيرفر                                        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│         مرحلة 3: البحث والحجز (Search & Booking)           │
├─────────────────────────────────────────────────────────────┤
│  1. مستخدم آخر يفتح شاشة البحث                             │
│  2. يختار نوع المقدم (ممرض/مساعد)                          │
│  3. يختار الخدمات المطلوبة                                  │
│  4. النظام يبحث ويفلتر بناءً على:                           │
│     - user_type                                             │
│     - service_ids                                           │
│     - location                                              │
│  5. عرض النتائج مع الأسعار                                  │
│  6. حجز الخدمة                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 جدول مقارنة شامل

| العنصر | الممرض (Nurse) | المساعد (Assistant) | ملاحظات |
|-------|----------------|---------------------|---------|
| **user_type** | `"nurse"` | `"assistant"` | يُحدد عند التسجيل |
| **License** | ✅ إلزامي | ❌ غير مطلوب | ملف |
| **Certificate** | ✅ إلزامي | ❌ غير مطلوب | ملف |
| **Association Card** | ✅ إلزامي | ❌ غير مطلوب | ملف |
| **Nurse ID** | ✅ إلزامي | ✅ إلزامي | ملف |
| **Related Job ID** | ❌ غير مطلوب | ✅ إلزامي | ملف |
| **الخدمات المتاحة** | خدمات الممرضات | خدمات المساعدين | من API |
| **تحديد الأسعار** | ✅ نعم | ✅ نعم | في صفحة الأسعار |
| **البحث** | ✅ ممكن | ✅ ممكن | حسب الخدمات |

---

## 📁 الملفات الرئيسية

### 1. **التسجيل (Registration)**

| الملف | الوصف | السطور المهمة |
|------|-------|---------------|
| `nurse_type.dart` | عنصر اختيار Nurse/Assistant | 26, 40 |
| `create_nurse_account.dart` | شاشة التسجيل الرئيسية | 273-437 |
| `register.dart` | تجميع وإرسال البيانات | 86-149 |
| `auth_bloc.dart` | إدارة حالة التسجيل | 288-292 |
| `auth_event.dart` | Event: SwitchNurseTypeEvent | 92-93 |

### 2. **الخدمات (Services)**

| الملف | الوصف | السطور المهمة |
|------|-------|---------------|
| `nurse_profile_prices_tap_screen.dart` | صفحة الأسعار | 16-44 |
| `service_list_drop_down.dart` | اختيار الخدمة والسعر | 36-86 |
| `account_bloc.dart` | جلب وحفظ الخدمات | 366-426 |
| `account_data_source.dart` | API للخدمات | 187-215 |

### 3. **البحث (Search)**

| الملف | الوصف | السطور المهمة |
|------|-------|---------------|
| `search_screen.dart` | شاشة البحث | 28-32 |
| `service_selector.dart` | اختيار الخدمات للبحث | 34-265 |
| `search_repository_impl.dart` | منطق البحث والفلترة | 23-83 |

---

## 🎯 أمثلة عملية

### مثال 1: تسجيل ممرض جديد

```dart
// 1. المستخدم يختار "ممرض"
authBloc.add(SwitchNurseTypeEvent(isNurse: true));

// 2. يملأ البيانات ويرفع الملفات
Map<String, dynamic> registerData = {
  'name': 'أحمد محمد',
  'email': 'ahmed@example.com',
  'phone': '01234567890',
  'password': '123456',
  'user_type': 'nurse',
  'license': File('/path/to/license.jpg'),
  'certificate': File('/path/to/certificate.jpg'),
  'associationCard': File('/path/to/card.jpg'),
  'nurseID': File('/path/to/id.jpg'),
};

// 3. إرسال للسيرفر
authBloc.add(RegisterEvent(user: registerData));

// 4. بعد الموافقة والدخول، يحدد خدماته:
accountBloc.getAllServiceList();  // جلب خدمات الممرضات

// 5. يختار خدمة ويحدد السعر
accountBloc.add(ChangeCurrentService(
  item: ServicesModel(id: 1, value: 'قياس ضغط الدم'),
  txt: '50'
));

// 6. يحفظ
await updateNurseOptionsValue(
  userData: {
    'services': [{'id': 1, 'value': '50'}]
  }
);
```

### مثال 2: تسجيل مساعد ممرض

```dart
// 1. المستخدم يختار "مساعد ممرض"
authBloc.add(SwitchNurseTypeEvent(isNurse: false));

// 2. يملأ البيانات (ملفات مختلفة)
Map<String, dynamic> registerData = {
  'name': 'فاطمة علي',
  'email': 'fatma@example.com',
  'phone': '01987654321',
  'password': '123456',
  'user_type': 'assistant',  // مختلف
  'related_job_id': File('/path/to/job_id.jpg'),  // بدلاً من license
  'nurseID': File('/path/to/id.jpg'),
};

// 3. نفس بقية الخطوات
authBloc.add(RegisterEvent(user: registerData));
```

### مثال 3: بحث عن ممرضة

```dart
// 1. المستخدم يفتح شاشة البحث
// 2. يختار نوع المقدم
searchBloc.add(SelectProviderTypeEvent(providerType: 'nurse'));

// 3. يتم جلب خدمات الممرضات تلقائياً
accountBloc.getAllServiceList(userType: 'nurse');

// 4. يختار الخدمات المطلوبة
searchBloc.add(SelectServiceEvent(services: [
  ServicesModel(id: 1, value: 'قياس ضغط الدم'),
  ServicesModel(id: 2, value: 'قياس السكر'),
]));

// 5. يضغط بحث
searchBloc.add(SearchByFiltersEvent(
  filters: SearchFilterEntity(
    userType: 'nurse',
    serviceIds: [1, 2],
    latitude: 30.0444,
    longitude: 31.2357,
  )
));

// 6. النتائج: ممرضات تقدم هذه الخدمات فقط
```

---

## 🔍 استكشاف الأخطاء

### المشكلة 1: الحقول لا تتغير عند التبديل

**الحل:**
```dart
// تأكد من أن BlocBuilder موجود
BlocBuilder<AuthBloc, AuthState>(
  builder: (ctx, state) {
    var bloc = AuthBloc.get(ctx);
    // استخدم bloc.isNurse هنا
  }
)

// تأكد من إرسال Event
bloc.add(SwitchNurseTypeEvent(isNurse: true/false));
```

### المشكلة 2: الخدمات لا تظهر

**الحل:**
```dart
// تأكد من استدعاء getAllServiceList
await accountBloc.getAllServiceList();

// تحقق من Debug Logs
debugPrint("Services count: ${allServiceList.length}");

// تحقق من API response
debugPrint("Response: ${response.statusCode}");
```

### المشكلة 3: السعر لا يُحفظ

**الحل:**
```dart
// تأكد من إدخال السعر
if (bloc.currentService == null || bloc.priceTxt == null) {
  // خطأ: لم يتم إدخال السعر
  return;
}

// تأكد من الحفظ
await updateNurseOptionsValue(
  userData: {
    'services': convertServiceToIDS(servicesList)
  }
);
```

---

## 💡 نصائح للمطورين

### 1. استخدم Debug Logs

```dart
debugPrint("🔹 isNurse: ${bloc.isNurse}");
debugPrint("🔹 user_type: ${registerData['user_type']}");
debugPrint("🔹 Services count: ${allServiceList.length}");
debugPrint("🔹 Selected services: ${selectedServices.length}");
```

### 2. تحقق من البيانات قبل الإرسال

```dart
// التحقق من الملفات
if (bloc.isNurse) {
  assert(bloc.license != null, 'License is required for nurses');
  assert(bloc.certificate != null, 'Certificate is required');
  assert(bloc.associationCard != null, 'Association card is required');
} else {
  assert(bloc.relatedJobId != null, 'Related job ID is required for assistants');
}
```

### 3. استخدم Enums بدلاً من Strings

```dart
enum UserType {
  nurse,
  assistant,
  customer
}

// بدلاً من
if (userType == 'nurse') { ... }

// استخدم
if (userType == UserType.nurse) { ... }
```

---

## 📚 المراجع السريعة

### API Endpoints

```
POST /api/v1/auth/register          - تسجيل مستخدم جديد
GET  /api/v1/service/list           - جلب جميع الخدمات
GET  /api/v1/service/list?user_type=nurse - خدمات الممرضات
POST /api/v1/nurse/update           - تحديث بيانات الممرضة
```

### Events المهمة

```dart
SwitchNurseTypeEvent(isNurse: bool)
RegisterEvent(user: Map<String, dynamic>)
SelectProviderTypeEvent(providerType: String)
SelectServiceEvent(services: List<ServicesModel>)
ChangeCurrentService(item: ServicesModel, txt: String?)
SearchByFiltersEvent(filters: SearchFilterEntity)
```

### States المهمة

```dart
RegisterLoadingState()
RegisterSuccessState()
RegisterFailedState()
ProviderTypeSelectedState(providerType)
SearchSuccessState(results)
```

---

## 🎓 للتعلم أكثر

### اقرأ التوثيق بالترتيب:

1. **للمبتدئين**:
   - [registration_flow_diagram_ar.md](./registration_flow_diagram_ar.md) ← ابدأ من هنا
   - [services_flow_diagram_ar.md](./services_flow_diagram_ar.md)

2. **للمستوى المتوسط**:
   - [registration_flow_ar.md](./registration_flow_ar.md)
   - [services_fetch_documentation_ar.md](./services_fetch_documentation_ar.md)

3. **للمطورين**:
   - [api_examples_ar.md](./api_examples_ar.md)
   - قراءة الكود المباشر في الملفات

---

## ✅ الخلاصة النهائية

### المفاهيم الأساسية:

1. **التفرقة عند التسجيل**:
   - `isNurse` boolean يتحكم في النوع
   - UI تتغير ديناميكياً
   - البيانات المرسلة مختلفة

2. **الخدمات**:
   - تُجلب بعد التسجيل
   - مفلترة حسب `user_type`
   - يحددها المستخدم في صفحة الأسعار

3. **البحث**:
   - يستخدم `user_type` للفلترة
   - يستخدم `service_ids` للتدقيق
   - النتائج مرتبة حسب المسافة

### الخطوات الأساسية:

```
التسجيل → تحديد الخدمات → البحث والحجز
```

---

**📅 آخر تحديث:** 2025-12-14  
**👨‍💻 نسخة التوثيق:** 1.0

🎉 **الآن أنت تفهم النظام بالكامل!**
