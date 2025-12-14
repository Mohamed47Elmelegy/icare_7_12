# أمثلة على استخدام API للخدمات

## 📋 جدول المحتويات
1. [تسجيل الدخول](#1-تسجيل-الدخول)
2. [جلب جميع الخدمات](#2-جلب-جميع-الخدمات)
3. [جلب خدمات الممرضات](#3-جلب-خدمات-الممرضات)
4. [جلب خدمات المساعدين](#4-جلب-خدمات-المساعدين)
5. [جلب خدمات الأطباء](#5-جلب-خدمات-الأطباء)
6. [رفع/تحديث خدمات الممرضة](#6-رفعتحديث-خدمات-الممرضة)

---

## 1. تسجيل الدخول

### Request
```http
POST https://admin.i-care.one/api/v1/auth/login
Content-Type: application/json

{
    "phone": "1123876422",
    "password": "1123876422"
}
```

### Response
```json
{
    "message": "Successfully login",
    "status": true,
    "user": {
        "id": 441,
        "referred_by": null,
        "provider_id": null,
        "user_type": "nurse",
        "is_male": 1,
        "name": "hossa",
        "email": "tesstt@gmail.com",
        "email_verified_at": null,
        "verification_code": null,
        "avatar": "uploads/all/1728217763177.jpg",
        "avatar_original": null,
        "address": "الولايات المتحدة--Google Building 43-California",
        "country": null,
        "governorate": "الغربية",
        "city": "",
        "status": "online",
        "edit_nurse_mode": "0",
        "postal_code": null,
        "phone": "1123876422",
        "country_code": "",
        "latitude": "37.4219983",
        "longitude": "-122.084",
        "un_read_notification": "",
        "banned": 0,
        "referral_code": null,
        "created_at": "2024-10-06T12:29:23.000000Z",
        "updated_at": "2025-12-10T11:15:30.000000Z"
    }
}
```

**ملاحظة**: احفظ `user.id` و `user.user_type` لاستخدامهما في الطلبات القادمة

---

## 2. جلب جميع الخدمات

### Request (بدون فلترة)
```http
GET https://admin.i-care.one/api/v1/service/list
Content-Type: application/json
ID: 441
user_type: nurse
```

### Response
```json
{
    "status": true,
    "data": [
        {
            "id": 1,
            "value": "قياس ضغط الدم",
            "name": "Blood Pressure Measurement",
            "user_type": "nurse",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "updated_at": "2024-01-01T00:00:00.000000Z"
        },
        {
            "id": 2,
            "value": "قياس السكر",
            "name": "Glucose Measurement",
            "user_type": "nurse",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "updated_at": "2024-01-01T00:00:00.000000Z"
        },
        {
            "id": 10,
            "value": "كشف عام",
            "name": "General Checkup",
            "user_type": "doctor",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "updated_at": "2024-01-01T00:00:00.000000Z"
        }
        // ... المزيد من الخدمات
    ]
}
```

**ملاحظة**: هذا يرجع **جميع** الخدمات لجميع الأنواع

---

## 3. جلب خدمات الممرضات فقط

### Request
```http
GET https://admin.i-care.one/api/v1/service/list?user_type=nurse
Content-Type: application/json
ID: 441
user_type: nurse
```

### Response
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
        },
        {
            "id": 3,
            "value": "حقن عضلي",
            "name": "Intramuscular Injection",
            "user_type": "nurse"
        },
        {
            "id": 4,
            "value": "حقن وريدي",
            "name": "Intravenous Injection",
            "user_type": "nurse"
        },
        {
            "id": 5,
            "value": "تركيب كانيولا",
            "name": "IV Cannulation",
            "user_type": "nurse"
        },
        {
            "id": 6,
            "value": "تضميد الجروح",
            "name": "Wound Dressing",
            "user_type": "nurse"
        },
        {
            "id": 7,
            "value": "إزالة الغرز",
            "name": "Suture Removal",
            "user_type": "nurse"
        },
        {
            "id": 8,
            "value": "تركيب قسطرة بولية",
            "name": "Urinary Catheterization",
            "user_type": "nurse"
        },
        {
            "id": 9,
            "value": "رعاية منزلية",
            "name": "Home Care",
            "user_type": "nurse"
        }
    ]
}
```

**ملاحظة**: فقط الخدمات التي `user_type = "nurse"`

---

## 4. جلب خدمات المساعدين فقط

### Request
```http
GET https://admin.i-care.one/api/v1/service/list?user_type=assistant
Content-Type: application/json
ID: 441
user_type: nurse
```

### Response
```json
{
    "status": true,
    "data": [
        {
            "id": 20,
            "value": "مساعدة في الحركة",
            "name": "Mobility Assistance",
            "user_type": "assistant"
        },
        {
            "id": 21,
            "value": "مساعدة في الاستحمام",
            "name": "Bathing Assistance",
            "user_type": "assistant"
        },
        {
            "id": 22,
            "value": "مساعدة في تناول الطعام",
            "name": "Feeding Assistance",
            "user_type": "assistant"
        },
        {
            "id": 23,
            "value": "مرافقة المريض",
            "name": "Patient Companionship",
            "user_type": "assistant"
        }
    ]
}
```

---

## 5. جلب خدمات الأطباء فقط

### Request
```http
GET https://admin.i-care.one/api/v1/service/list?user_type=doctor
Content-Type: application/json
ID: 441
user_type: nurse
```

### Response
```json
{
    "status": true,
    "data": [
        {
            "id": 30,
            "value": "كشف عام",
            "name": "General Checkup",
            "user_type": "doctor"
        },
        {
            "id": 31,
            "value": "استشارة طبية",
            "name": "Medical Consultation",
            "user_type": "doctor"
        },
        {
            "id": 32,
            "value": "كشف باطني",
            "name": "Internal Medicine",
            "user_type": "doctor"
        },
        {
            "id": 33,
            "value": "كشف أطفال",
            "name": "Pediatric Checkup",
            "user_type": "doctor"
        }
    ]
}
```

---

## 6. رفع/تحديث خدمات الممرضة

### Scenario: ممرضة تريد تحديث خدماتها

### Request
```http
POST https://admin.i-care.one/api/v1/nurse/update
Content-Type: application/json
ID: 441
user_type: nurse

{
    "user_id": 441,
    "services": [
        {
            "id": 1,
            "value": "قياس ضغط الدم"
        },
        {
            "id": 2,
            "value": "قياس السكر"
        },
        {
            "id": 5,
            "value": "تركيب كانيولا"
        }
    ]
}
```

**ملاحظة**: 
- يتم إرسال `id` و `value` لكل خدمة
- يتم استبدال الخدمات القديمة بالخدمات الجديدة

### Response
```json
{
    "status": true,
    "message": "Services updated successfully",
    "data": {
        "user_id": 441,
        "services": [
            {
                "id": 1,
                "value": "قياس ضغط الدم",
                "name": "Blood Pressure Measurement"
            },
            {
                "id": 2,
                "value": "قياس السكر",
                "name": "Glucose Measurement"
            },
            {
                "id": 5,
                "value": "تركيب كانيولا",
                "name": "IV Cannulation"
            }
        ]
    }
}
```

---

## 💡 أمثلة عملية في الكود

### مثال 1: جلب خدمات حسب نوع المستخدم الحالي

```dart
// في account_bloc.dart
Future<void> loadMyServices() async {
  // سيستخدم user_type من المستخدم الحالي تلقائياً
  await getAllServiceList();
  
  // allServiceList الآن تحتوي على خدمات نوع المستخدم الحالي
  print("Loaded ${allServiceList.length} services");
}
```

### مثال 2: جلب خدمات نوع محدد

```dart
// في account_bloc.dart
Future<void> loadNurseServices() async {
  // جلب خدمات الممرضات فقط
  await getAllServiceList(userType: 'nurse');
  
  print("Loaded ${allServiceList.length} nurse services");
}
```

### مثال 3: عرض الخدمات في UI

```dart
// في service_selector.dart
Widget build(BuildContext context) {
  return BlocBuilder<AccountBloc, AccountState>(
    builder: (context, state) {
      var accountBloc = AccountBloc.get(context);
      var services = accountBloc.allServiceList;
      
      if (services.isEmpty) {
        return Text('لا توجد خدمات متاحة');
      }
      
      return ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          var service = services[index];
          return ListTile(
            title: Text(service.name ?? service.value),
            subtitle: Text(service.value),
          );
        },
      );
    },
  );
}
```

### مثال 4: تحديث خدمات الممرضة

```dart
// في account_bloc.dart
Future<void> updateMyServices(List<ServicesModel> selectedServices) async {
  // تحويل القائمة إلى صيغة API
  var servicesData = convertServiceToIDS(selectedServices);
  
  // إرسال للسيرفر
  await UserServiceRemoteDataSource.updateNurseOptionsValue(
    userData: {
      'services': servicesData,
    }
  );
  
  // تحديث القائمة المحلية
  servicesList = selectedServices;
}

List<Map<String, dynamic>> convertServiceToIDS(List<ServicesModel> services) {
  return services.map((service) => {
    'id': service.id,
    'value': service.value,
  }).toList();
}
```

---

## 🔧 استخدام Postman أو cURL

### Postman Collection

#### 1. Login Request
```
Method: POST
URL: https://admin.i-care.one/api/v1/auth/login
Headers:
  Content-Type: application/json
Body (raw JSON):
{
    "phone": "1123876422",
    "password": "1123876422"
}
```

#### 2. Get Nurse Services
```
Method: GET
URL: https://admin.i-care.one/api/v1/service/list?user_type=nurse
Headers:
  Content-Type: application/json
  ID: 441
  user_type: nurse
```

### cURL Examples

#### Login
```bash
curl -X POST https://admin.i-care.one/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "1123876422",
    "password": "1123876422"
  }'
```

#### Get Nurse Services
```bash
curl -X GET "https://admin.i-care.one/api/v1/service/list?user_type=nurse" \
  -H "Content-Type: application/json" \
  -H "ID: 441" \
  -H "user_type: nurse"
```

#### Get All Services
```bash
curl -X GET "https://admin.i-care.one/api/v1/service/list" \
  -H "Content-Type: application/json" \
  -H "ID: 441" \
  -H "user_type: nurse"
```

---

## 📊 جدول ملخص API Endpoints

| Endpoint | Method | Parameters | Description |
|----------|--------|------------|-------------|
| `/api/v1/auth/login` | POST | phone, password | تسجيل الدخول |
| `/api/v1/service/list` | GET | - | جميع الخدمات |
| `/api/v1/service/list?user_type=nurse` | GET | user_type | خدمات الممرضات |
| `/api/v1/service/list?user_type=assistant` | GET | user_type | خدمات المساعدين |
| `/api/v1/service/list?user_type=doctor` | GET | user_type | خدمات الأطباء |
| `/api/v1/nurse/update` | POST | user_id, services | تحديث خدمات الممرضة |

---

## ⚠️ ملاحظات مهمة

### Headers المطلوبة
جميع الطلبات (ما عدا Login) تحتاج:
```
Content-Type: application/json
ID: <user_id>
user_type: <user_type>
```

### Query Parameters
- `user_type`: اختياري، يفلتر النتائج حسب النوع
- القيم المسموحة: `nurse`, `assistant`, `doctor`

### Response Format
جميع الاستجابات تحتوي:
```json
{
    "status": true/false,
    "data": [...] أو {},
    "message": "رسالة" (اختياري)
}
```

---

## 🎯 الخلاصة

1. **جلب جميع الخدمات**: `GET /service/list`
2. **جلب خدمات محددة**: `GET /service/list?user_type=nurse`
3. **تحديث الخدمات**: `POST /nurse/update` مع `services` array

**الممرضات** يمكنهم:
- ✅ عرض خدمات الممرضات فقط
- ✅ اختيار خدمات من القائمة
- ✅ تحديث خدماتهم الخاصة
- ✅ البحث عن ممرضات أخريات بنفس الخدمات
