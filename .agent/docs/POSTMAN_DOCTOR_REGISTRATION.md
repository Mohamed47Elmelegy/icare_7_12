# Postman Collection for Doctor Registration - I-Care

## 📍 API Endpoint

```
POST https://admin.i-care.one/api/v1/auth/signup
```

---

## 🔧 Headers

```
Content-Type: multipart/form-data
Accept: application/json
```

---

## 📦 Body (form-data)

### Basic Information:
```
name: د. أحمد محمد
phone: 01234567890
email: doctor.test@example.com
password: Test@123456
user_type: doctor
country_code: +20
status: online
is_male: 1
```

### Location Information:
```
city: القاهرة
governorate: القاهرة
address: شارع التحرير، وسط البلد
latitude: 30.0444
longitude: 31.2357
```

### Professional Information:
```
specialties_id: 1
languages: ["العربية","الإنجليزية"]
education: ["بكالوريوس الطب والجراحة - جامعة القاهرة 2015","ماجستير الجراحة العامة 2020"]
publications: ["بحث في الجراحة الحديثة - مجلة الطب المصرية 2021"]
courses: ["دورة الإنعاش القلبي الرئوي - 2022","دورة الجراحة بالمنظار - 2023"]
```

### Device Information:
```
device_info: {"platform":"postman","version":"1.0","device":"test"}
```

---

## 📄 Files (Optional - for testing without files, skip these)

```
avatar: [Choose File] - image/jpeg or image/png
license_practice: [Choose File] - application/pdf or image/*
graduation_certificate: [Choose File] - application/pdf or image/*
identification_card: [Choose File] - image/jpeg or image/png
association_card: [Choose File] - application/pdf or image/*
```

---

## 🎯 Postman Setup Instructions

### Method 1: Using Postman GUI

1. **Create New Request**
   - Method: `POST`
   - URL: `https://admin.i-care.one/api/v1/auth/signup`

2. **Set Headers**
   - Go to "Headers" tab
   - Add: `Accept: application/json`
   - Note: `Content-Type` will be set automatically for form-data

3. **Set Body**
   - Go to "Body" tab
   - Select "form-data"
   - Add all fields from above (text fields)

4. **Add Files (Optional)**
   - For each file field, change type from "Text" to "File"
   - Click "Select Files" and choose your files

5. **Send Request**

---

## 📋 Expected Response

### Success (200 OK):
```json
{
  "status": true,
  "message": "Registration Successful.",
  "user": {
    "id": 123,
    "name": "د. أحمد محمد",
    "email": "doctor.test@example.com",
    "phone": "01234567890",
    "user_type": "doctor",
    "specialties_id": 1,
    "status": "pending",
    "is_male": 1,
    "city": "القاهرة",
    "governorate": "القاهرة",
    "created_at": "2025-12-17T21:48:00.000000Z",
    "updated_at": "2025-12-17T21:48:00.000000Z"
  },
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer"
}
```

### Error - User Already Exists (400):
```json
{
  "status": false,
  "message": "User already exists",
  "errors": {
    "phone": ["The phone has already been taken."]
  }
}
```

### Error - Validation Failed (422):
```json
{
  "status": false,
  "message": "Validation failed",
  "errors": {
    "phone": ["The phone field is required."],
    "user_type": ["The user_type field is required."]
  }
}
```

---

## 🔍 Testing Scenarios

### Scenario 1: Minimal Registration (No Files)
```
Required fields only:
- name
- phone
- password
- user_type: doctor
- specialties_id
```

### Scenario 2: Complete Registration (With Files)
```
All fields + files:
- All basic fields
- All location fields
- All professional fields
- All file uploads
```

### Scenario 3: Test Duplicate Phone
```
Use same phone number twice to test error handling
```

---

## 🛠️ cURL Command (Alternative)

```bash
curl -X POST "https://admin.i-care.one/api/v1/auth/signup" \
  -H "Accept: application/json" \
  -F "name=د. أحمد محمد" \
  -F "phone=01234567890" \
  -F "email=doctor.test@example.com" \
  -F "password=Test@123456" \
  -F "user_type=doctor" \
  -F "specialties_id=1" \
  -F "country_code=+20" \
  -F "status=online" \
  -F "is_male=1" \
  -F "city=القاهرة" \
  -F "governorate=القاهرة" \
  -F "address=شارع التحرير" \
  -F "latitude=30.0444" \
  -F "longitude=31.2357" \
  -F 'languages=["العربية","الإنجليزية"]' \
  -F 'education=["بكالوريوس الطب"]' \
  -F 'publications=["بحث في الجراحة"]' \
  -F 'courses=["دورة الإنعاش"]' \
  -F 'device_info={"platform":"curl","version":"1.0"}'
```

---

## 📝 Notes

1. **Phone Number**: Use a unique phone number for each test
2. **specialties_id**: Check available specialties first via `GET /api/v1/specialties/list`
3. **Files**: Optional for testing, but recommended for production
4. **device_info**: Can be any valid JSON object
5. **Status**: User will be "pending" until admin approval

---

## 🔗 Related Endpoints

### Get Specialties List:
```
GET https://admin.i-care.one/api/v1/specialties/list
```

### Login After Registration:
```
POST https://admin.i-care.one/api/v1/auth/login
Body:
{
  "phone": "01234567890",
  "password": "Test@123456"
}
```

---

**Created:** 2025-12-17  
**Version:** 1.0
