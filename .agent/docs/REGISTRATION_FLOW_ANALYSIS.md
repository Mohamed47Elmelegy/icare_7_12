# تحليل شامل لعملية التسجيل في تطبيق I-Care

## 📋 جدول المحتويات
1. [طرق التسجيل المتاحة](#1-طرق-التسجيل-المتاحة)
2. [تفاصيل API للتسجيل](#2-تفاصيل-api-للتسجيل)
3. [Headers المطلوبة](#3-headers-المطلوبة)
4. [سيناريو التسجيل للطبيب](#4-سيناريو-التسجيل-للطبيب)
5. [الملاحظات والتوصيات](#5-الملاحظات-والتوصيات)

---

## 1. طرق التسجيل المتاحة

### 1.1 التسجيل العادي (Standard Registration)
**المسار:** `POST /api/v1/auth/signup`

#### أنواع المستخدمين المدعومة:
1. **Customer (مريض)** - النوع الافتراضي
2. **Nurse (ممرض/ممرضة)**
3. **Assistant (مساعد/مساعدة)**
4. **Doctor (طبيب/طبيبة)**

#### البيانات الأساسية المطلوبة:
```json
{
  "name": "string (required)",
  "phone": "string (required)",
  "email": "string (optional)",
  "password": "string (required)",
  "user_type": "string (required: customer/nurse/assistant/doctor)",
  "is_male": "string (0 للإناث / 1 للذكور)",
  "country_code": "string (default: +20)",
  "status": "string (default: offline)"
}
```

#### البيانات الجغرافية:
```json
{
  "city": "string",
  "governorate": "string",
  "address": "string",
  "latitude": "string",
  "longitude": "string"
}
```

#### البيانات الإضافية للممرضين والأطباء:
```json
{
  "languages": "json array",
  "education": "json array",
  "publications": "json array",
  "courses": "json array",
  "specialties_id": "integer (للأطباء فقط)"
}
```

#### المستندات المطلوبة:

**للممرضين (Nurse):**
- `identification_card` (file) - بطاقة الهوية
- `license_practice` (file) - رخصة مزاولة المهنة
- `graduation_certificate` (file) - شهادة التخرج
- `association_card` (file) - بطاقة النقابة
- `avatar` (file) - الصورة الشخصية

**للأطباء (Doctor):**
- `identification_card` (file) - بطاقة الهوية
- `license_practice` (file) - رخصة مزاولة المهنة
- `graduation_certificate` (file) - شهادة التخرج
- `association_card` (file) - بطاقة النقابة
- `avatar` (file) - الصورة الشخصية

**للمساعدين (Assistant):**
- `identification_card` (file) - بطاقة الهوية
- `related_job_id` (file) - بطاقة العمل ذات الصلة
- `avatar` (file) - الصورة الشخصية

---

### 1.2 تسجيل الدخول الاجتماعي (Social Login)
**المسار:** `POST /api/v1/auth/social-login`

#### البيانات المطلوبة:
```json
{
  "email": "string (required)",
  "name": "string",
  "provider": "string (google/facebook/apple)",
  "user_type": "string (default: customer)"
}
```

---

## 2. تفاصيل API للتسجيل

### 2.1 Endpoint التسجيل العادي
```
POST https://admin.i-care.one/api/v1/auth/signup
```

### 2.2 نوع الطلب (Request Type)
- **Method:** `POST`
- **Content-Type:** `multipart/form-data` (لأن هناك ملفات)

### 2.3 كيفية الإرسال في الكود

#### في `authentication_data_source.dart`:
```dart
Future<AuthResponse> registerUser(Map<String, dynamic> userData) async {
  try {
    // إنشاء MultipartRequest لإرسال الملفات
    var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.REGISTER_URL));
    
    // إضافة device_info
    request.fields['device_info'] = jsonEncode(await ApiUrl.secureData());
    
    // إضافة البيانات النصية
    if (userData['name'] != null) 
      request.fields['name'] = userData['name'];
    if (userData['email'] != null) 
      request.fields['email'] = userData['email'];
    if (userData['phone'] != null) 
      request.fields['phone'] = userData['phone'];
    
    // تعيين user_type (مهم جداً!)
    request.fields['user_type'] = userData['user_type'] ?? "customer";
    
    // إضافة البيانات الجغرافية
    if (userData['city'] != null) 
      request.fields['city'] = userData['city'];
    if (userData['governorate'] != null) 
      request.fields['governorate'] = userData['governorate'];
    if (userData['address'] != null) 
      request.fields['address'] = userData['address'];
    if (userData['latitude'] != null) 
      request.fields['latitude'] = userData['latitude'].toString();
    if (userData['longitude'] != null) 
      request.fields['longitude'] = userData['longitude'].toString();
    
    // إضافة البيانات الإضافية
    if (userData['country_code'] != null) 
      request.fields['country_code'] = userData['country_code'];
    if (userData['status'] != null) 
      request.fields['status'] = userData['status'];
    if (userData['password'] != null) 
      request.fields['password'] = userData['password'];
    if (userData['is_male'] != null) 
      request.fields['is_male'] = userData['is_male'];
    
    // إضافة البيانات المهنية (للممرضين والأطباء)
    if (userData['languages'] != null) 
      request.fields['languages'] = userData['languages'];
    if (userData['education'] != null) 
      request.fields['education'] = userData['education'];
    if (userData['publications'] != null) 
      request.fields['publications'] = userData['publications'];
    if (userData['courses'] != null) 
      request.fields['courses'] = userData['courses'];
    
    // إضافة الملفات
    if (userData['license'] != null) {
      var file = await http.MultipartFile.fromPath(
        'license_practice', 
        userData['license'].path
      );
      request.files.add(file);
    }
    
    if (userData['certificate'] != null) {
      var file = await http.MultipartFile.fromPath(
        'graduation_certificate', 
        userData['certificate'].path
      );
      request.files.add(file);
    }
    
    if (userData['nurseID'] != null) {
      var file = await http.MultipartFile.fromPath(
        'identification_card', 
        userData['nurseID'].path
      );
      request.files.add(file);
    }
    
    if (userData['associationCard'] != null) {
      var file = await http.MultipartFile.fromPath(
        'association_card', 
        userData['associationCard'].path
      );
      request.files.add(file);
    }
    
    if (userData['avatar'] != null) {
      var file = await http.MultipartFile.fromPath(
        'avatar', 
        userData['avatar'].path
      );
      request.files.add(file);
    }
    
    // إضافة Headers
    request.headers.addAll(ApiUrl.headerAuth);
    
    // إرسال الطلب
    var streamedResponse = await request.send();
    var res = await http.Response.fromStream(streamedResponse);
    
    // معالجة الاستجابة
    var decodedData = jsonDecode(res.body);
    if (decodedData['status']) {
      await Util.saveLocalData(decodedData);
      return AuthResponse(
        user: UserServiceModel.fromJson(decodedData['user']),
        msg: translate("toast.signup"),
        isSuccess: true
      );
    }
    
    return AuthResponse(
      user: null, 
      msg: translate("toast.oops"), 
      isFailed: true
    );
  } catch (e) {
    return AuthResponse(
      user: null, 
      msg: translate("toast.oops"), 
      isFailed: true
    );
  }
}
```

### 2.4 الاستجابة المتوقعة (Response)

#### نجاح التسجيل:
```json
{
  "status": true,
  "message": "Registration Successful.",
  "user": {
    "id": 123,
    "name": "اسم المستخدم",
    "email": "user@example.com",
    "phone": "01234567890",
    "user_type": "doctor",
    "status": "pending",
    ...
  },
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer"
}
```

#### فشل التسجيل:
```json
{
  "status": false,
  "message": "User already exists",
  "errors": {
    "phone": ["The phone has already been taken."],
    "email": ["The email has already been taken."]
  }
}
```

---

## 3. Headers المطلوبة

### 3.1 Headers للتسجيل (Signup)
```dart
// في ApiUrl.headerAuth
Map<String, String> get headerAuth => {
  "Content-Type": "multipart/form-data",
  "Accept": "application/json",
  "X-Requested-With": "XMLHttpRequest",
};
```

### 3.2 Headers لتسجيل الدخول (Login)
```dart
// في authentication_data_source.dart - loginUser
headers: {
  "Content-Type": "application/json",
}
```

### 3.3 Headers للطلبات المصادق عليها (Authenticated Requests)
```dart
// بعد تسجيل الدخول
headers: {
  "Content-Type": "application/json",
  "Authorization": "Bearer {access_token}",
  "Accept": "application/json",
}
```

### 3.4 كيفية استلام وحفظ الـ Token

#### من الاستجابة (Response Body):
```dart
// في loginUser و registerUser
final Map<String, dynamic> bodyData = json.decode(response.body);

// محاولة الحصول على التوكن من الـ body
String? token = bodyData['access_token'] ?? bodyData['token'];

// إذا لم يكن موجود في الـ body، ابحث في الـ headers
if (token == null) {
  String? headerToken = response.headers['authorization'] ?? 
                        response.headers['Authorization'];
  if (headerToken != null) {
    if (headerToken.startsWith("Bearer ")) {
      token = headerToken.substring(7);
    }
  }
  bodyData['access_token'] = token;
}

// حفظ البيانات محلياً
await Util.saveLocalData(bodyData);
```

#### حفظ البيانات في SharedPreferences:
```dart
// في Util.saveLocalData
static Future<void> saveLocalData(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // حفظ التوكن
  if (data['access_token'] != null) {
    await prefs.setString('access_token', data['access_token']);
  }
  
  // حفظ بيانات المستخدم
  if (data['user'] != null) {
    await prefs.setString('user', jsonEncode(data['user']));
    await prefs.setInt('user_id', data['user']['id']);
    await prefs.setString('user_type', data['user']['user_type']);
  }
}
```

#### استخدام التوكن في الطلبات:
```dart
// في ApiUrl أو في data sources
static Future<Map<String, String>> getAuthHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  
  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${token ?? ''}",
    "Accept": "application/json",
  };
}
```

---

## 4. سيناريو التسجيل للطبيب

### 4.1 الخطوات الحالية في التطبيق

#### الخطوة 1: اختيار نوع المستخدم
في `register.dart` - يوجد `PatientKindListDropDown`:
```dart
// المستخدم يختار: مريض / ممرض / طبيب
const PatientKindListDropDown()
```

هذا يقوم بتحديث `AuthBloc`:
```dart
// في AuthBloc
bool isDoctor = false;  // يتم تحديثه عند اختيار "طبيب"
bool isNurse = false;   // يتم تحديثه عند اختيار "ممرض"
```

#### الخطوة 2: إدخال البيانات الأساسية
```dart
// في register.dart
- الاسم (name)
- الجنس (is_male)
- رقم الهاتف (phone)
- البريد الإلكتروني (email)
- كلمة المرور (password)
- المحافظة (governorate)
- المدينة (city)
- العنوان (address + lat/long)
```

#### الخطوة 3: الانتقال للخطوة التالية
عند الضغط على زر "التسجيل":
```dart
// في register.dart - onPressed
if (authBloc.isDoctor) {
  registerData['user_type'] = "doctor";
  // إضافة البيانات الإضافية للطبيب
}
```

#### الخطوة 4: إكمال البيانات (إذا كان طبيب/ممرض)
الانتقال إلى `CompleteNurseRegisterDataScreen`:
```dart
// في next_step_nurse_register.dart
- رفع الصورة الشخصية (avatar)
- رفع رخصة المزاولة (license_practice)
- رفع شهادة التخرج (graduation_certificate)
- رفع بطاقة الهوية (identification_card)
- رفع بطاقة النقابة (association_card)
- إضافة اللغات (languages)
- إضافة التعليم (education)
- إضافة المنشورات (publications)
- إضافة الدورات (courses)
- اختيار التخصص (specialties_id) - للأطباء فقط
```

### 4.2 المشاكل الحالية

#### مشكلة 1: عدم وجود صفحة منفصلة للأطباء
حالياً يستخدم الأطباء نفس صفحة الممرضين `CompleteNurseRegisterDataScreen`.

**الحل المقترح:**
- إنشاء صفحة منفصلة `CompleteDoctorRegisterDataScreen`
- أو تعديل الصفحة الحالية لتدعم كلا النوعين

#### مشكلة 2: عدم وجود حقل التخصص للأطباء
الأطباء يحتاجون لاختيار التخصص `specialties_id`.

**الحل المقترح:**
- إضافة dropdown لاختيار التخصص من API: `GET /api/v1/specialties/list`
- حفظ `specialties_id` في `registerData`

#### مشكلة 3: الخلط في تحديد user_type
في `register.dart` السطر 110:
```dart
await Util.getUserType() ==(UserEnum.DOCTOR.name.toLowerCase());
```
هذا السطر خاطئ ولا يفعل شيء.

**الحل الصحيح:**
```dart
if (authBloc.isDoctor) {
  registerData['user_type'] = "doctor";
  // ... باقي البيانات
}
```

### 4.3 السيناريو المثالي للتسجيل كطبيب

#### الخطوة 1: صفحة التسجيل الأساسية
```
RegisterScreen
├── اختيار نوع المستخدم: [مريض | ممرض | طبيب]
├── الاسم
├── الجنس
├── رقم الهاتف
├── البريد الإلكتروني
├── كلمة المرور
├── المحافظة
├── المدينة
└── العنوان (مع الموقع)
```

#### الخطوة 2: صفحة إكمال بيانات الطبيب
```
CompleteDoctorRegisterDataScreen (جديدة)
├── الصورة الشخصية
├── رخصة مزاولة المهنة
├── شهادة التخرج
├── بطاقة الهوية
├── بطاقة النقابة
├── اختيار التخصص (Dropdown من API)
├── اللغات (قائمة قابلة للتعديل)
├── التعليم (قائمة قابلة للتعديل)
├── المنشورات (قائمة قابلة للتعديل)
└── الدورات (قائمة قابلة للتعديل)
```

#### الخطوة 3: إرسال البيانات للـ API
```dart
Map<String, dynamic> doctorRegisterData = {
  // البيانات الأساسية
  'name': 'د. أحمد محمد',
  'phone': '01234567890',
  'email': 'doctor@example.com',
  'password': '********',
  'user_type': 'doctor',  // مهم جداً!
  'is_male': '1',
  'country_code': '+20',
  'status': 'online',
  
  // البيانات الجغرافية
  'city': 'القاهرة',
  'governorate': 'القاهرة',
  'address': 'شارع...',
  'latitude': '30.0444',
  'longitude': '31.2357',
  
  // البيانات المهنية
  'specialties_id': 5,  // مثلاً: جراحة
  'languages': jsonEncode(['العربية', 'الإنجليزية']),
  'education': jsonEncode([
    {'degree': 'بكالوريوس طب', 'university': 'جامعة القاهرة', 'year': '2015'}
  ]),
  'publications': jsonEncode([
    {'title': 'بحث في...', 'journal': 'مجلة...', 'year': '2020'}
  ]),
  'courses': jsonEncode([
    {'name': 'دورة في...', 'provider': 'جهة...', 'year': '2021'}
  ]),
  
  // الملفات
  'avatar': File('path/to/avatar.jpg'),
  'license': File('path/to/license.pdf'),
  'certificate': File('path/to/certificate.pdf'),
  'nurseID': File('path/to/id_card.jpg'),  // بطاقة الهوية
  'associationCard': File('path/to/association.jpg'),
};

// إرسال للـ API
authBloc.add(RegisterEvent(user: doctorRegisterData));
```

#### الخطوة 4: معالجة الاستجابة
```dart
// في AuthBloc
if (response.status == true) {
  // حفظ التوكن والبيانات
  await Util.saveLocalData(response.data);
  
  // التوجيه لصفحة الانتظار (Pending Approval)
  emit(RegistrationPendingState(
    message: "تم التسجيل بنجاح. في انتظار موافقة الإدارة."
  ));
} else {
  emit(RegisterFailedState(
    message: response.message ?? "حدث خطأ في التسجيل"
  ));
}
```

---

## 5. الملاحظات والتوصيات

### 5.1 ملاحظات على الكود الحالي

#### ✅ نقاط قوة:
1. استخدام `MultipartRequest` لإرسال الملفات
2. التحقق من صحة البيانات قبل الإرسال
3. معالجة الأخطاء بشكل جيد
4. حفظ البيانات محلياً بعد النجاح

#### ⚠️ نقاط تحتاج تحسين:
1. **عدم وجود صفحة منفصلة للأطباء**
   - حالياً يستخدم الأطباء نفس صفحة الممرضين
   
2. **عدم إرسال specialties_id للأطباء**
   - الأطباء يحتاجون لتحديد التخصص
   
3. **الخلط في تحديد user_type**
   - السطر 110 في register.dart يحتوي على كود خاطئ
   
4. **عدم التحقق من نوع الملفات وحجمها**
   - يجب التحقق قبل الإرسال

### 5.2 توصيات للتحسين

#### 1. إنشاء صفحة منفصلة للأطباء
```dart
// ملف جديد: complete_doctor_register.dart
class CompleteDoctorRegisterDataScreen extends StatelessWidget {
  // نفس الحقول الموجودة في صفحة الممرض
  // + إضافة حقل التخصص
}
```

#### 2. إضافة اختيار التخصص
```dart
// widget جديد: doctor_specialty_dropdown.dart
class DoctorSpecialtyDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        var bloc = AuthBloc.get(context);
        return DropdownButton<int>(
          value: bloc.selectedSpecialtyId,
          items: bloc.specialtiesList.map((specialty) {
            return DropdownMenuItem(
              value: specialty['id'],
              child: Text(specialty['name']),
            );
          }).toList(),
          onChanged: (value) {
            bloc.add(UpdateSpecialtyEvent(specialtyId: value));
          },
        );
      },
    );
  }
}
```

#### 3. تحسين معالجة الأخطاء
```dart
// إضافة رسائل خطأ أكثر وضوحاً
if (decodedData.toString().contains("already")) {
  String errorMsg = "المستخدم موجود بالفعل";
  if (decodedData['errors'] != null) {
    if (decodedData['errors']['phone'] != null) {
      errorMsg = "رقم الهاتف مسجل مسبقاً";
    } else if (decodedData['errors']['email'] != null) {
      errorMsg = "البريد الإلكتروني مسجل مسبقاً";
    }
  }
  return AuthResponse(user: null, msg: errorMsg, isFailed: true);
}
```

#### 4. إضافة التحقق من الملفات
```dart
// قبل إضافة الملف
if (userData['license'] != null) {
  File file = userData['license'];
  
  // التحقق من الحجم (مثلاً: أقل من 5 ميجا)
  int fileSizeInBytes = await file.length();
  if (fileSizeInBytes > 5 * 1024 * 1024) {
    throw Exception("حجم الملف كبير جداً");
  }
  
  // التحقق من النوع
  String extension = file.path.split('.').last.toLowerCase();
  if (!['pdf', 'jpg', 'jpeg', 'png'].contains(extension)) {
    throw Exception("نوع الملف غير مدعوم");
  }
  
  var multipartFile = await http.MultipartFile.fromPath(
    'license_practice', 
    file.path
  );
  request.files.add(multipartFile);
}
```

#### 5. تحسين حفظ واستخدام التوكن
```dart
// إنشاء class منفصل لإدارة التوكن
class TokenManager {
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
  
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
  
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
  
  static Future<Map<String, String>> getAuthHeaders() async {
    String? token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token ?? ''}",
      "Accept": "application/json",
    };
  }
}
```

### 5.3 خطة التنفيذ المقترحة

#### المرحلة 1: إصلاح المشاكل الحالية
1. ✅ إصلاح السطر 110 في register.dart
2. ✅ التأكد من إرسال user_type بشكل صحيح
3. ✅ التحقق من حفظ واستخدام التوكن

#### المرحلة 2: إضافة ميزات الأطباء
1. 📝 إنشاء صفحة منفصلة للأطباء
2. 📝 إضافة اختيار التخصص
3. 📝 جلب قائمة التخصصات من API
4. 📝 إضافة حقل specialties_id في registerData

#### المرحلة 3: التحسينات
1. 📝 إضافة التحقق من الملفات
2. 📝 تحسين رسائل الأخطاء
3. 📝 إضافة مؤشرات التقدم
4. 📝 إضافة معاينة للملفات المرفوعة

---

## 📌 ملخص سريع

### طرق التسجيل:
1. **تسجيل عادي:** `POST /api/v1/auth/signup`
2. **تسجيل اجتماعي:** `POST /api/v1/auth/social-login`

### أنواع المستخدمين:
- `customer` - مريض
- `nurse` - ممرض
- `assistant` - مساعد
- `doctor` - طبيب

### Headers المطلوبة:
- **للتسجيل:** `Content-Type: multipart/form-data`
- **لتسجيل الدخول:** `Content-Type: application/json`
- **للطلبات المصادق عليها:** `Authorization: Bearer {token}`

### التوكن:
- يأتي في الاستجابة كـ `access_token` أو في header `Authorization`
- يجب حفظه في SharedPreferences
- يستخدم في كل الطلبات المصادق عليها

### المشاكل الحالية:
1. عدم وجود صفحة منفصلة للأطباء
2. عدم إرسال specialties_id للأطباء
3. خطأ في تحديد user_type (السطر 110)

---

**تاريخ التحديث:** 2025-12-17
**الإصدار:** 1.0
