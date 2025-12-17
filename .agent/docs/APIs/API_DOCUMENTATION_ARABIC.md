# توثيق APIs لتطبيق I-Care
## دليل شامل لجميع واجهات برمجة التطبيقات (APIs)

---

## 📋 جدول المحتويات

1. [المصادقة والمستخدمين](#1-المصادقة-والمستخدمين)
2. [الممرضين](#2-الممرضين)
3. [الأطباء](#3-الأطباء)
4. [الطلبات والحجوزات](#4-الطلبات-والحجوزات)
5. [الإشعارات](#5-الإشعارات)
6. [المستخدمين والملفات الشخصية](#6-المستخدمين-والملفات-الشخصية)
7. [العناوين](#7-العناوين)
8. [المدفوعات والمحفظة](#8-المدفوعات-والمحفظة)
9. [التصنيفات والإعدادات](#9-التصنيفات-والإعدادات)
10. [تتبع الأداء](#10-تتبع-الأداء)
11. [الخدمات العامة](#11-الخدمات-العامة)

---

## 1. المصادقة والمستخدمين

### 1.1 تسجيل الدخول
- **المسار:** `POST /api/v1/auth/login`
- **الوصف:** تسجيل دخول المستخدم
- **المدخلات:**
  ```json
  {
    "phone": "string (required)",
    "password": "string (required)"
  }
  ```
- **المخرجات:**
  ```json
  {
    "message": "Successfully login",
    "status": true,
    "user": { ... }
  }
  ```

### 1.2 التسجيل
- **المسار:** `POST /api/v1/auth/signup`
- **الوصف:** تسجيل مستخدم جديد
- **المدخلات:**
  ```json
  {
    "name": "string",
    "phone": "string (required)",
    "email": "string",
    "country_code": "string (default: +20)",
    "address": "string",
    "city": "string",
    "governorate": "string",
    "status": "string (default: offline)",
    "user_type": "string (required: customer/nurse/assistant/doctor)",
    "is_male": "string (0/1)",
    "latitude": "string",
    "longitude": "string",
    "avatar": "file",
    "specialties_id": "integer (for nurse/doctor)",
    "languages": "json",
    "education": "json",
    "publications": "json",
    "courses": "json",
    "identification_card": "file (for nurse/assistant)",
    "license_practice": "file (for nurse)",
    "graduation_certificate": "file (for nurse)",
    "association_card": "file (for nurse)",
    "related_job_id": "file (for assistant)"
  }
  ```
- **المخرجات:**
  ```json
  {
    "status": true,
    "message": "Registration Successful.",
    "user": { ... }
  }
  ```

### 1.3 تسجيل الدخول الاجتماعي
- **المسار:** `POST /api/v1/auth/social-login`
- **الوصف:** تسجيل الدخول باستخدام حسابات التواصل الاجتماعي
- **المدخلات:**
  ```json
  {
    "email": "string (required)",
    "name": "string",
    "provider": "string",
    "user_type": "string"
  }
  ```

### 1.4 الحصول على معلومات المستخدم
- **المسار:** `GET /api/v1/auth/user`
- **الوصف:** الحصول على معلومات المستخدم الحالي
- **المتطلبات:** `auth:api` middleware

### 1.5 تسجيل الخروج
- **المسار:** `GET /api/v1/auth/logout`
- **الوصف:** تسجيل خروج المستخدم
- **المتطلبات:** `auth:api` middleware

### 1.6 تحديث كلمة المرور
- **المسار:** `POST /api/v1/auth/password/reset`
- **الوصف:** إعادة تعيين كلمة المرور
- **المدخلات:**
  ```json
  {
    "id": "integer",
    "email": "string",
    "password": "string (required)"
  }
  ```

### 1.7 إرسال OTP
- **المسار:** `POST /api/v1/send-otp`
- **الوصف:** إرسال رمز التحقق OTP
- **المدخلات:**
  ```json
  {
    "phone": "string (required)",
    "otp": "string (required)"
  }
  ```

### 1.8 تحديث كلمة المرور للمستخدم
- **المسار:** `POST /api/v1/user/renew/password`
- **الوصف:** تحديث كلمة مرور المستخدم
- **المدخلات:**
  ```json
  {
    "id": "integer",
    "email": "string",
    "password": "string (required)"
  }
  ```

---

## 2. الممرضين

### 2.1 الحصول على قائمة الممرضين
- **المسار:** `GET /api/v1/nurses/{page}`
- **الوصف:** الحصول على قائمة الممرضين مع المسافة
- **المعاملات:**
  - `page`: رقم الصفحة (1 للبحث عن الأقرب)
  - Query Parameters: `lat`, `long`
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "user": { ... },
        "reviews": [ ... ],
        "distanceKm": "string",
        "distanceMe": "string"
      }
    ]
  }
  ```

### 2.2 تقييم الممرض
- **المسار:** `POST /api/v1/nurse/rate`
- **الوصف:** إضافة تقييم للممرض
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "nurse_id": "integer (required)",
    "rating": "integer (required)",
    "comment": "string"
  }
  ```

### 2.3 تحديث خيارات الممرض
- **المسار:** `POST /api/v1/nurse/options`
- **الوصف:** تحديث معلومات الممرض (اللغات، التعليم، المنشورات، الدورات)
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "languages": "json",
    "education": "json",
    "publications": "json",
    "courses": "json",
    "emergency_contacts": "json",
    "services": "json"
  }
  ```

### 2.4 الحصول على قائمة الخدمات
- **المسار:** `GET /api/v1/service/list`
- **الوصف:** الحصول على قائمة الخدمات المتاحة
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [ ... ]
  }
  ```

### 2.5 طلب صلاحية تعديل ملف المريض (الممرض)
- **المسار:** `POST /api/v1/patient_access`
- **الوصف:** طلب صلاحية الممرض لتعديل ملف المريض (عند الوصول ضمن 4 كم)
- **المدخلات:**
  ```json
  {
    "latitude": "double (required)",
    "longitude": "double (required)"
  }
  ```

### 2.6 منح صلاحية تعديل ملف المريض
- **المسار:** `POST /api/v1/give_access`
- **الوصف:** منح الممرض صلاحية تعديل ملف المريض

---

## 3. الأطباء

### 3.1 الحصول على قائمة الأطباء
- **المسار:** `GET /api/v1/doctors/{page}`
- **الوصف:** الحصول على قائمة الأطباء مع المسافة
- **المعاملات:**
  - `page`: رقم الصفحة (1 للبحث عن الأقرب)
  - Query Parameters: `lat`, `long`
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "user": { ... },
        "reviews": [ ... ],
        "distanceKm": "string",
        "distanceMe": "string"
      }
    ]
  }
  ```

### 3.2 الحصول على معلومات الطبيب
- **المسار:** `GET /api/v1/doctor/info/{id}`
- **الوصف:** الحصول على معلومات تفصيلية عن طبيب معين
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "user": { ... },
        "reviews": [ ... ],
        "specialties": [ ... ]
      }
    ]
  }
  ```

### 3.3 تقييم الطبيب
- **المسار:** `POST /api/v1/doctor/rate`
- **الوصف:** إضافة تقييم للطبيب
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "doctor_id": "integer (required)",
    "rating": "integer (required)",
    "comment": "string"
  }
  ```

### 3.4 تحديث خيارات الطبيب
- **المسار:** `POST /api/v1/doctor/options`
- **الوصف:** تحديث معلومات الطبيب
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "languages": "json",
    "education": "json",
    "publications": "json",
    "courses": "json",
    "emergency_contacts": "json",
    "specialties_id": "integer"
  }
  ```

### 3.5 الحصول على قائمة التخصصات
- **المسار:** `GET /api/v1/specialties/list`
- **الوصف:** الحصول على قائمة التخصصات الطبية
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [ ... ]
  }
  ```

### 3.6 طلب صلاحية تعديل ملف المريض (الطبيب)
- **المسار:** `POST /api/v1/doctor/patient_access`
- **الوصف:** طلب صلاحية الطبيب لتعديل ملف المريض (عند الوصول ضمن 4 كم)
- **المدخلات:**
  ```json
  {
    "latitude": "double (required)",
    "longitude": "double (required)"
  }
  ```

### 3.7 منح صلاحية تعديل ملف المريض (الطبيب)
- **المسار:** `POST /api/v1/doctor/give_access`
- **الوصف:** منح الطبيب صلاحية تعديل ملف المريض

---

## 4. الطلبات والحجوزات

### 4.1 إنشاء طلب جديد
- **المسار:** `POST /api/v1/orders/store`
- **الوصف:** إنشاء طلب حجز جديد
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "nurse_id": "integer (optional)",
    "doctor_id": "integer (optional)",
    "address": "string",
    "current_status": "string (PENDING/ONGOING/COMPLETED/CANCELLED)",
    "payment_type": "string (cash/card/online)",
    "grand_total": "decimal",
    "coupon_discount": "decimal",
    "arrival_date": "date",
    "desc": "string",
    "lat": "decimal",
    "lng": "decimal"
  }
  ```
- **المخرجات:**
  ```json
  {
    "success": true,
    "message": "Your order has been placed successfully",
    "order_id": "integer"
  }
  ```

### 4.2 الحصول على طلبات المستخدم
- **المسار:** `GET /api/v1/orders/{userID}`
- **الوصف:** الحصول على جميع طلبات المستخدم (مريض/ممرض/طبيب)
- **المخرجات:**
  ```json
  {
    "success": true,
    "data": [
      {
        "id": "integer",
        "user_id": "integer",
        "nurse_id": "integer",
        "doctor_id": "integer",
        "order_status": "string",
        "user_name": "string",
        "nurse_name": "string",
        "doctor_name": "string",
        "lat": "string",
        "lng": "string",
        ...
      }
    ]
  }
  ```

### 4.3 تحديث حالة الطلب
- **المسار:** `POST /api/v1/orders/update/status/`
- **الوصف:** تحديث حالة الطلب
- **المدخلات:**
  ```json
  {
    "booking_id": "integer (required)",
    "status": "string (required: PENDING/ACCEPTED/ONGOING/COMPLETED/CANCELLED)"
  }
  ```
- **الحالات المتاحة:**
  - `PENDING`: في الانتظار
  - `ACCEPTED`: تم القبول
  - `ONGOING`: قيد التنفيذ
  - `COMPLETED`: مكتمل
  - `CANCELLED`: ملغي

### 4.4 تحديث بيانات الطلب
- **المسار:** `POST /api/v1/orders/update`
- **الوصف:** تحديث بيانات الطلب
- **المتطلبات:** `auth:api` middleware
- **المدخلات:**
  ```json
  {
    "order_id": "integer (required)",
    "arrival_date": "date",
    "delivery_status": "string"
  }
  ```

### 4.5 إلغاء الطلب
- **المسار:** `DELETE /api/v1/orders/cancel/{orderID}`
- **الوصف:** إلغاء طلب معين
- **المتطلبات:** `auth:api` middleware

### 4.6 الحصول على الضريبة
- **المسار:** `GET /api/v1/tax`
- **الوصف:** الحصول على نسبة الضريبة
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": "decimal"
  }
  ```

### 4.7 إنشاء طلب إقامة
- **المسار:** `POST /api/v1/request/send`
- **الوصف:** إنشاء طلب إقامة جديد
- **المدخلات:**
  ```json
  {
    "nurse_id": "integer (optional)",
    "status": "string (pending/approved/rejected/completed)",
    "user_note": "string",
    "case_description": "string",
    "range_number": "string",
    "date_val": "date",
    "monthly_salary": "decimal",
    "start_date": "date",
    "end_date": "date",
    "is_urgent": "boolean",
    "latitude": "decimal",
    "longitude": "decimal",
    "address": "string",
    "phone": "string"
  }
  ```

### 4.8 إرسال طلب إقامة للشركات الأقرب
- **المسار:** `POST /api/v1/request/send-to-companies/{requestId}`
- **الوصف:** إرسال طلب إقامة للشركات الأقرب تلقائياً

### 4.9 إرسال عرض شركة على طلب إقامة
- **المسار:** `POST /api/v1/request/company-offer`
- **الوصف:** إرسال عرض من شركة على طلب إقامة
- **المدخلات:**
  ```json
  {
    "request_id": "integer (required)",
    "company_id": "integer (required)",
    "offer_price": "decimal (required)",
    "nurse_id": "integer (optional)",
    "offer_notes": "string",
    "proposed_start_date": "date",
    "proposed_end_date": "date"
  }
  ```

### 4.10 الحصول على عروض طلب إقامة
- **المسار:** `GET /api/v1/request/offers/{requestId}`
- **الوصف:** الحصول على جميع العروض المقدمة على طلب إقامة
- **المخرجات:**
  ```json
  {
    "success": true,
    "request": { ... },
    "offers": [ ... ]
  }
  ```

### 4.11 قبول عرض طلب إقامة
- **المسار:** `POST /api/v1/request/offer/accept`
- **الوصف:** قبول عرض على طلب إقامة وإنشاء طلب تلقائياً
- **المدخلات:**
  ```json
  {
    "offer_id": "integer (required)"
  }
  ```

---

## 5. الإشعارات

### 5.1 الحصول على إشعارات المستخدم
- **المسار:** `GET /api/v1/notifications/{user_id}`
- **الوصف:** الحصول على جميع إشعارات المستخدم
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "title": "string",
        "content": "string",
        "type": "string (order/request/offer)",
        "user_id": "integer",
        "nurse_id": "integer",
        "doctor_id": "integer",
        "order_id": "integer",
        "created_at": "datetime",
        "user": { ... },
        "order": { ... },
        "request": { ... }
      }
    ],
    "status": true,
    "message": "string",
    "count": "integer"
  }
  ```

### 5.2 إرسال إشعار Push
- **المسار:** `POST /api/v1/send-notification`
- **الوصف:** إرسال إشعار push لمستخدم معين
- **المدخلات:**
  ```json
  {
    "user_id": "integer (required)",
    "msg": "string (required)"
  }
  ```

### 5.3 إرسال إشعار لجميع المرضى
- **المسار:** `POST /api/v1/send-notification/all-patients`
- **الوصف:** إرسال إشعار لجميع المرضى
- **المدخلات:**
  ```json
  {
    "msg": "string (required)",
    "title": "string (optional, default: Icare)"
  }
  ```

### 5.4 إرسال إشعار لجميع الممرضين
- **المسار:** `POST /api/v1/send-notification/all-nurses`
- **الوصف:** إرسال إشعار لجميع الممرضين
- **المدخلات:**
  ```json
  {
    "msg": "string (required)",
    "title": "string (optional, default: Icare)"
  }
  ```

### 5.5 إرسال إشعار لجميع الأطباء
- **المسار:** `POST /api/v1/send-notification/all-doctors`
- **الوصف:** إرسال إشعار لجميع الأطباء
- **المدخلات:**
  ```json
  {
    "msg": "string (required)",
    "title": "string (optional, default: Icare)"
  }
  ```

### 5.6 التحقق من الأوردرات المفقودة في الإشعارات
- **المسار:** `GET /api/v1/notifications/check-missing-orders/{user_id?}`
- **الوصف:** التحقق من وجود أوردرات مفقودة في الإشعارات
- **المخرجات:**
  ```json
  {
    "status": true,
    "total_notifications": "integer",
    "missing_orders_count": "integer",
    "found_orders_count": "integer",
    "missing_orders": [ ... ],
    "found_orders_sample": [ ... ]
  }
  ```

### 5.7 تصحيح إشعارات المستخدم
- **المسار:** `GET /api/v1/notifications/debug/{user_id}`
- **الوصف:** الحصول على معلومات تصحيحية عن إشعارات المستخدم

---

## 6. المستخدمين والملفات الشخصية

### 6.1 الحصول على معلومات المستخدم
- **المسار:** `GET /api/v1/user/info/{id}`
- **الوصف:** الحصول على معلومات مستخدم معين
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "name": "string",
        "email": "string",
        "phone": "string",
        "user_type": "string",
        ...
      }
    ]
  }
  ```

### 6.2 تحديث ملف المستخدم
- **المسار:** `POST /api/v1/user/update/{userID}`
- **الوصف:** تحديث بيانات ملف المستخدم
- **المدخلات:**
  ```json
  {
    "name": "string",
    "email": "string",
    "phone": "string",
    "address": "string",
    "city": "string",
    "governorate": "string",
    "latitude": "string",
    "longitude": "string",
    "allergies": "array (optional)",
    "type": "string (optional)",
    "value": "string (optional)"
  }
  ```

### 6.3 تحديث حالة المستخدم
- **المسار:** `POST /api/v1/user/update/status/{status}/{userID}`
- **الوصف:** تحديث حالة المستخدم (online/offline)
- **المعاملات:**
  - `status`: الحالة (online/offline)
  - `userID`: معرف المستخدم

### 6.4 تحديث صورة الملف الشخصي
- **المسار:** `POST /api/v1/user/update/img/{userID}/profile`
- **الوصف:** تحديث صورة الملف الشخصي
- **المدخلات:**
  - `avatar`: ملف الصورة (multipart/form-data)

### 6.5 تحديث صورة عامة
- **المسار:** `POST /api/v1/update/img/{userID}/{kind}`
- **الوصف:** تحديث صورة حسب النوع
- **المتطلبات:** `auth:api` middleware
- **المعاملات:**
  - `userID`: معرف المستخدم
  - `kind`: نوع الصورة (seller_license/logo)

### 6.6 تحديث موقع المستخدم
- **المسار:** `POST /api/v1/user/update/location/{userID}`
- **الوصف:** تحديث موقع GPS للمستخدم
- **المدخلات:**
  ```json
  {
    "latitude": "decimal (required)",
    "longitude": "decimal (required)",
    "online_status": "string (optional: available/busy)"
  }
  ```

### 6.7 الحصول على جميع المستخدمين
- **المسار:** `GET /api/v1/users`
- **الوصف:** الحصول على قائمة جميع المستخدمين
- **المتطلبات:** `auth:api` middleware

### 6.8 الحصول على جميع المستندات
- **المسار:** `GET /api/v1/documents/{userID}`
- **الوصف:** الحصول على جميع مستندات المستخدم
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "user_id": "integer",
        "file_original_name": "string",
        "file_name": "string",
        "approved": "string",
        "type": "string"
      }
    ]
  }
  ```

### 6.9 تحديث مستند
- **المسار:** `POST /api/v1/update/document/{userID}`
- **الوصف:** تحديث مستند للمستخدم
- **المدخلات:**
  ```json
  {
    "id": "integer (optional)",
    "imgAttributeName": "string (required)",
    "document": "file (required)"
  }
  ```

### 6.10 حذف مستند
- **المسار:** `DELETE /api/v1/delete/document/{doc_id}`
- **الوصف:** حذف مستند معين
- **المتطلبات:** `auth:api` middleware

---

## 7. العناوين

### 7.1 الحصول على عناوين المستخدم
- **المسار:** `GET /api/v1/user/{userID}/locations`
- **الوصف:** الحصول على جميع عناوين المستخدم
- **المتطلبات:** `auth:api` middleware
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "user_id": "integer",
        "address": "string",
        "city": "string",
        "phone": "string",
        "postal_code": "string",
        "country": "string",
        "type": "string",
        "lat": "string",
        "long": "string"
      }
    ]
  }
  ```

### 7.2 إضافة عنوان جديد
- **المسار:** `POST /api/v1/user/{userID}/locations/add`
- **الوصف:** إضافة عنوان جديد للمستخدم
- **المتطلبات:** `auth:api` middleware
- **المدخلات:**
  ```json
  {
    "address": "string (required)",
    "city": "string (required)",
    "phone": "string (required)",
    "postal_code": "string",
    "country": "string",
    "type": "string (default: work)",
    "lat": "string",
    "long": "string"
  }
  ```

### 7.3 تحديث عنوان
- **المسار:** `POST /api/v1/user/locations/update/{locationID}`
- **الوصف:** تحديث عنوان موجود
- **المتطلبات:** `auth:api` middleware
- **المدخلات:**
  ```json
  {
    "address": "string",
    "city": "string",
    "phone": "string",
    "postal_code": "string",
    "country": "string",
    "type": "string",
    "lat": "string",
    "long": "string"
  }
  ```

### 7.4 حذف عنوان
- **المسار:** `DELETE /api/v1/user/locations/remove/{locationID}`
- **الوصف:** حذف عنوان معين
- **المتطلبات:** `auth:api` middleware

---

## 8. المدفوعات والمحفظة

### 8.1 الحصول على معاملات المستخدم
- **المسار:** `GET /api/v1/transactions/{userID}`
- **الوصف:** الحصول على جميع معاملات المستخدم
- **المتطلبات:** `auth:api` middleware
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "user_id": "integer",
        "provider_id": "integer",
        "order_id": "integer",
        "amount": "decimal",
        "type": "string",
        "created_at": "datetime"
      }
    ],
    "status": true
  }
  ```

### 8.2 الحصول على رصيد المحفظة
- **المسار:** `GET /api/v1/wallet/balance/{id}`
- **الوصف:** الحصول على رصيد محفظة المستخدم
- **المتطلبات:** `auth:api` middleware
- **المخرجات:**
  ```json
  {
    "balance": "decimal"
  }
  ```

### 8.3 الحصول على سجل شحن المحفظة
- **المسار:** `GET /api/v1/wallet/history/{id}`
- **الوصف:** الحصول على سجل شحن المحفظة
- **المتطلبات:** `auth:api` middleware
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "user_id": "integer",
        "amount": "decimal",
        "payment_method": "string",
        "created_at": "datetime"
      }
    ]
  }
  ```

### 8.4 Webhook للدفع (Kashier)
- **المسار:** `POST /api/v1/kashierWebhook`
- **الوصف:** استقبال إشعارات الدفع من Kashier

### 8.5 تطبيق كوبون خصم
- **المسار:** `POST /api/v1/coupon/apply`
- **الوصف:** تطبيق كوبون خصم
- **المتطلبات:** `auth:api` middleware
- **المدخلات:**
  ```json
  {
    "code": "string (required)"
  }
  ```
- **المخرجات:**
  ```json
  {
    "success": true,
    "discount": { ... },
    "message": "Coupon code applied successfully"
  }
  ```

---

## 9. التصنيفات والإعدادات

### 9.1 الحصول على البانرات
- **المسار:** `GET /api/v1/banners`
- **الوصف:** الحصول على قائمة البانرات
- **المخرجات:**
  ```json
  {
    "status": true,
    "sliders": [
      {
        "id": "integer",
        "title": "string",
        "meta_img": "string",
        ...
      }
    ]
  }
  ```

### 9.2 الحصول على التصنيفات
- **المسار:** `GET /api/v1/categories/{user_lang}`
- **الوصف:** الحصول على قائمة التصنيفات
- **المعاملات:**
  - `user_lang`: اللغة (ar/en)
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "id": "integer",
        "name": "string",
        "banner": "string",
        ...
      }
    ]
  }
  ```

### 9.3 الحصول على جميع المنشورات
- **المسار:** `GET /api/v1/publications/{type}`
- **الوصف:** الحصول على المنشورات حسب النوع
- **المعاملات:**
  - `type`: نوع المنشور (customer/patient/nurse)
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "title": "string",
        "desc": "string",
        "html_desc": "string",
        "banner": "string",
        "video_url": "string"
      }
    ]
  }
  ```

### 9.4 الحصول على جميع الحساسيات
- **المسار:** `GET /api/v1/allergies`
- **الوصف:** الحصول على قائمة الحساسيات
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [ ... ]
  }
  ```

### 9.5 الحصول على الإعدادات
- **المسار:** `GET /api/v1/settings`
- **الوصف:** الحصول على إعدادات التطبيق
- **المخرجات:**
  ```json
  {
    "data": [
      {
        "key": "string",
        "value": "string",
        ...
      }
    ]
  }
  ```

### 9.6 الحصول على معلومات من نحن
- **المسار:** `GET /api/v1/about-us`
- **الوصف:** الحصول على معلومات "من نحن"
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [ ... ]
  }
  ```

### 9.7 الحصول على سياسة الخصوصية
- **المسار:** `GET /api/v1/privacy`
- **الوصف:** الحصول على سياسة الخصوصية
- **المتطلبات:** `auth:api` middleware

### 9.8 الحصول على الشروط والأحكام
- **المسار:** `GET /api/v1/terms`
- **الوصف:** الحصول على الشروط والأحكام
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [ ... ]
  }
  ```

### 9.9 الحصول على جميع المحافظات
- **المسار:** `GET /api/v1/governorates`
- **الوصف:** الحصول على قائمة المحافظات
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "name": "string",
        "name_ar": "string",
        ...
      }
    ]
  }
  ```

### 9.10 الحصول على جميع المدن
- **المسار:** `GET /api/v1/cities`
- **الوصف:** الحصول على قائمة المدن
- **المخرجات:**
  ```json
  {
    "status": true,
    "data": [
      {
        "id": "integer",
        "name": "string",
        "name_ar": "string",
        "governorate_id": "integer",
        ...
      }
    ]
  }
  ```

### 9.11 الحصول على سياسات البائع
- **المسار:** `GET /api/v1/policies/seller`
- **الوصف:** الحصول على سياسات البائع

### 9.12 الحصول على سياسات الدعم
- **المسار:** `GET /api/v1/policies/support`
- **الوصف:** الحصول على سياسات الدعم

### 9.13 الحصول على سياسات الإرجاع
- **المسار:** `GET /api/v1/policies/return`
- **الوصف:** الحصول على سياسات الإرجاع

---

## 10. تتبع الأداء

### 10.1 أداء الممرض

#### 10.1.1 الحصول على أداء الممرض
- **المسار:** `GET /api/v1/nurse-performance/{nurseId}`
- **الوصف:** الحصول على إحصائيات أداء ممرض معين
- **Query Parameters:**
  - `start_date`: تاريخ البداية (Y-m-d)
  - `end_date`: تاريخ النهاية (Y-m-d)
- **المخرجات:**
  ```json
  {
    "success": true,
    "data": {
      "nurse": {
        "id": "integer",
        "name": "string"
      },
      "period": {
        "start_date": "date",
        "end_date": "date"
      },
      "orders": {
        "total": "integer",
        "completed": "integer",
        "ongoing": "integer"
      },
      "average_times": {
        "response_time": "decimal (minutes)",
        "travel_time": "decimal (minutes)",
        "total_time": "decimal (minutes)"
      },
      "fastest_times": { ... },
      "slowest_times": { ... }
    }
  }
  ```

#### 10.1.2 الحصول على أسرع الممرضين
- **المسار:** `GET /api/v1/nurse-performance/fastest/list`
- **الوصف:** الحصول على قائمة أسرع الممرضين
- **Query Parameters:**
  - `limit`: عدد النتائج (default: 10)
  - `start_date`: تاريخ البداية
  - `end_date`: تاريخ النهاية
- **المخرجات:**
  ```json
  {
    "success": true,
    "data": [
      {
        "nurse_id": "integer",
        "nurse_name": "string",
        "average_total_time": "decimal (minutes)",
        "average_response_time": "decimal (minutes)",
        "average_travel_time": "decimal (minutes)",
        "total_orders": "integer",
        "fastest_time": "decimal (minutes)"
      }
    ]
  }
  ```

#### 10.1.3 الحصول على أداء جميع الممرضين
- **المسار:** `GET /api/v1/nurse-performance/all`
- **الوصف:** الحصول على تقرير شامل لجميع الممرضين
- **Query Parameters:**
  - `start_date`: تاريخ البداية
  - `end_date`: تاريخ النهاية
- **المخرجات:**
  ```json
  {
    "success": true,
    "data": [
      {
        "nurse_id": "integer",
        "nurse_name": "string",
        "total_orders": "integer",
        "completed_orders": "integer",
        "average_response_time": "decimal (minutes)",
        "rank": "integer"
      }
    ]
  }
  ```

#### 10.1.4 تتبع طلب ممرض
- **المسار:** `GET /api/v1/order-tracking/{orderId}`
- **الوصف:** الحصول على تفاصيل تتبع طلب معين
- **المخرجات:**
  ```json
  {
    "success": true,
    "data": {
      "order_id": "integer",
      "order_code": "string",
      "order_status": "string",
      "patient": { ... },
      "nurse": { ... },
      "timeline": {
        "request_received_at": "datetime",
        "request_accepted_at": "datetime",
        "nurse_started_at": "datetime",
        "nurse_arrived_at": "datetime"
      },
      "times": {
        "response_time": {
          "seconds": "integer",
          "minutes": "decimal",
          "formatted": "string"
        },
        "travel_time": { ... },
        "total_response_time": { ... }
      }
    }
  }
  ```

### 10.2 أداء الأطباء

#### 10.2.1 الحصول على أداء الطبيب
- **المسار:** `GET /api/v1/doctor-performance/{doctorId}`
- **الوصف:** الحصول على إحصائيات أداء طبيب معين
- **Query Parameters:**
  - `start_date`: تاريخ البداية (Y-m-d)
  - `end_date`: تاريخ النهاية (Y-m-d)
- **المخرجات:** (نفس هيكل أداء الممرض)

#### 10.2.2 الحصول على أسرع الأطباء
- **المسار:** `GET /api/v1/doctor-performance/fastest/list`
- **الوصف:** الحصول على قائمة أسرع الأطباء
- **Query Parameters:**
  - `limit`: عدد النتائج (default: 10)
  - `start_date`: تاريخ البداية
  - `end_date`: تاريخ النهاية

#### 10.2.3 الحصول على أداء جميع الأطباء
- **المسار:** `GET /api/v1/doctor-performance/all`
- **الوصف:** الحصول على تقرير شامل لجميع الأطباء
- **Query Parameters:**
  - `start_date`: تاريخ البداية
  - `end_date`: تاريخ النهاية

#### 10.2.4 تتبع طلب طبيب
- **المسار:** `GET /api/v1/doctor-order-tracking/{orderId}`
- **الوصف:** الحصول على تفاصيل تتبع طلب معين للطبيب

---

## 11. الخدمات العامة

### 11.1 رفع ملف CSV
- **المسار:** `POST /api/csv/upload`
- **الوصف:** رفع ملف CSV ومعالجته
- **المدخلات:**
  - `csv_file`: ملف CSV (multipart/form-data)
- **المخرجات:**
  ```json
  {
    "data": { ... }
  }
  ```

### 11.2 مسح الكاش
- **المسار:** `GET /api/v1/clear-cache`
- **الوصف:** مسح كاش التطبيق

### 11.3 اختبار API
- **المسار:** `GET /api/v1/test`
- **الوصف:** اختبار API

---

## 📝 ملاحظات مهمة

### أنواع المستخدمين (user_type)
- `customer`: مريض
- `nurse`: ممرض
- `assistant`: مساعد
- `doctor`: طبيب
- `admin`: مدير
- `agent`: وكيل

### حالات الطلب (order_status)
- `PENDING`: في الانتظار
- `ACCEPTED`: تم القبول
- `ONGOING`: قيد التنفيذ
- `COMPLETED` / `DONE`: مكتمل
- `CANCELLED`: ملغي

### أنواع الإشعارات (notification type)
- `order`: إشعار طلب
- `request`: إشعار طلب إقامة
- `offer`: إشعار عرض

### أنواع الدفع (payment_type)
- `cash`: نقدي
- `card`: بطاقة
- `online`: عبر الإنترنت

### Base URL
```
http://your-domain.com/api
```

### Authentication
بعض APIs تتطلب مصادقة باستخدام `auth:api` middleware. يجب إرسال token في header:
```
Authorization: Bearer {token}
```

---

## 🔐 الأمان

- جميع APIs التي تتطلب مصادقة يجب أن تحتوي على token في header
- يجب التحقق من صحة البيانات المدخلة قبل الإرسال
- يجب استخدام HTTPS في الإنتاج

---

## 📞 الدعم

للمزيد من المعلومات أو المساعدة، يرجى التواصل مع فريق الدعم.

---

**آخر تحديث:** 2025-01-24
**الإصدار:** 1.0

