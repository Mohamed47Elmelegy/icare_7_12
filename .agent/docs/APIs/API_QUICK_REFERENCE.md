# مرجع سريع لـ APIs - تطبيق I-Care

## 🔐 المصادقة
| Method | Endpoint | الوصف |
|--------|----------|-------|
| POST | `/api/v1/auth/login` | تسجيل الدخول |
| POST | `/api/v1/auth/signup` | التسجيل |
| POST | `/api/v1/auth/social-login` | تسجيل دخول اجتماعي |
| GET | `/api/v1/auth/user` | معلومات المستخدم الحالي |
| GET | `/api/v1/auth/logout` | تسجيل الخروج |
| POST | `/api/v1/auth/password/reset` | إعادة تعيين كلمة المرور |
| POST | `/api/v1/send-otp` | إرسال OTP |
| POST | `/api/v1/user/renew/password` | تحديث كلمة المرور |

## 👨‍⚕️ الأطباء
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/doctors/{page}` | قائمة الأطباء |
| GET | `/api/v1/doctor/info/{id}` | معلومات الطبيب |
| POST | `/api/v1/doctor/rate` | تقييم الطبيب |
| POST | `/api/v1/doctor/options` | تحديث خيارات الطبيب |
| GET | `/api/v1/specialties/list` | قائمة التخصصات |
| POST | `/api/v1/doctor/patient_access` | طلب صلاحية تعديل ملف المريض |
| POST | `/api/v1/doctor/give_access` | منح صلاحية تعديل ملف المريض |

## 👩‍⚕️ الممرضين
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/nurses/{page}` | قائمة الممرضين |
| POST | `/api/v1/nurse/rate` | تقييم الممرض |
| POST | `/api/v1/nurse/options` | تحديث خيارات الممرض |
| GET | `/api/v1/service/list` | قائمة الخدمات |
| POST | `/api/v1/patient_access` | طلب صلاحية تعديل ملف المريض |
| POST | `/api/v1/give_access` | منح صلاحية تعديل ملف المريض |

## 📋 الطلبات والحجوزات
| Method | Endpoint | الوصف |
|--------|----------|-------|
| POST | `/api/v1/orders/store` | إنشاء طلب جديد |
| GET | `/api/v1/orders/{userID}` | طلبات المستخدم |
| POST | `/api/v1/orders/update/status/` | تحديث حالة الطلب |
| POST | `/api/v1/orders/update` | تحديث بيانات الطلب |
| DELETE | `/api/v1/orders/cancel/{orderID}` | إلغاء الطلب |
| GET | `/api/v1/tax` | الحصول على الضريبة |
| POST | `/api/v1/request/send` | إنشاء طلب إقامة |
| POST | `/api/v1/request/send-to-companies/{requestId}` | إرسال طلب للشركات الأقرب |
| POST | `/api/v1/request/company-offer` | إرسال عرض شركة |
| GET | `/api/v1/request/offers/{requestId}` | عروض طلب إقامة |
| POST | `/api/v1/request/offer/accept` | قبول عرض |

## 🔔 الإشعارات
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/notifications/{user_id}` | إشعارات المستخدم |
| POST | `/api/v1/send-notification` | إرسال إشعار push |
| POST | `/api/v1/send-notification/all-patients` | إرسال لجميع المرضى |
| POST | `/api/v1/send-notification/all-nurses` | إرسال لجميع الممرضين |
| POST | `/api/v1/send-notification/all-doctors` | إرسال لجميع الأطباء |
| GET | `/api/v1/notifications/check-missing-orders/{user_id?}` | التحقق من الأوردرات المفقودة |
| GET | `/api/v1/notifications/debug/{user_id}` | تصحيح الإشعارات |

## 👤 المستخدمين والملفات الشخصية
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/user/info/{id}` | معلومات المستخدم |
| POST | `/api/v1/user/update/{userID}` | تحديث ملف المستخدم |
| POST | `/api/v1/user/update/status/{status}/{userID}` | تحديث حالة المستخدم |
| POST | `/api/v1/user/update/img/{userID}/profile` | تحديث صورة الملف الشخصي |
| POST | `/api/v1/update/img/{userID}/{kind}` | تحديث صورة عامة |
| POST | `/api/v1/user/update/location/{userID}` | تحديث موقع GPS |
| GET | `/api/v1/users` | قائمة جميع المستخدمين |
| GET | `/api/v1/documents/{userID}` | مستندات المستخدم |
| POST | `/api/v1/update/document/{userID}` | تحديث مستند |
| DELETE | `/api/v1/delete/document/{doc_id}` | حذف مستند |

## 📍 العناوين
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/user/{userID}/locations` | عناوين المستخدم |
| POST | `/api/v1/user/{userID}/locations/add` | إضافة عنوان |
| POST | `/api/v1/user/locations/update/{locationID}` | تحديث عنوان |
| DELETE | `/api/v1/user/locations/remove/{locationID}` | حذف عنوان |

## 💰 المدفوعات والمحفظة
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/transactions/{userID}` | معاملات المستخدم |
| GET | `/api/v1/wallet/balance/{id}` | رصيد المحفظة |
| GET | `/api/v1/wallet/history/{id}` | سجل شحن المحفظة |
| POST | `/api/v1/kashierWebhook` | Webhook للدفع |
| POST | `/api/v1/coupon/apply` | تطبيق كوبون خصم |

## ⚙️ التصنيفات والإعدادات
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/banners` | البانرات |
| GET | `/api/v1/categories/{user_lang}` | التصنيفات |
| GET | `/api/v1/publications/{type}` | المنشورات |
| GET | `/api/v1/allergies` | الحساسيات |
| GET | `/api/v1/settings` | الإعدادات |
| GET | `/api/v1/about-us` | من نحن |
| GET | `/api/v1/privacy` | سياسة الخصوصية |
| GET | `/api/v1/terms` | الشروط والأحكام |
| GET | `/api/v1/governorates` | المحافظات |
| GET | `/api/v1/cities` | المدن |
| GET | `/api/v1/policies/seller` | سياسات البائع |
| GET | `/api/v1/policies/support` | سياسات الدعم |
| GET | `/api/v1/policies/return` | سياسات الإرجاع |

## 📊 تتبع الأداء

### الممرضين
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/nurse-performance/{nurseId}` | أداء الممرض |
| GET | `/api/v1/nurse-performance/fastest/list` | أسرع الممرضين |
| GET | `/api/v1/nurse-performance/all` | أداء جميع الممرضين |
| GET | `/api/v1/order-tracking/{orderId}` | تتبع طلب ممرض |

### الأطباء
| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/v1/doctor-performance/{doctorId}` | أداء الطبيب |
| GET | `/api/v1/doctor-performance/fastest/list` | أسرع الأطباء |
| GET | `/api/v1/doctor-performance/all` | أداء جميع الأطباء |
| GET | `/api/v1/doctor-order-tracking/{orderId}` | تتبع طلب طبيب |

## 🛠️ الخدمات العامة
| Method | Endpoint | الوصف |
|--------|----------|-------|
| POST | `/api/csv/upload` | رفع ملف CSV |
| GET | `/api/v1/clear-cache` | مسح الكاش |
| GET | `/api/v1/test` | اختبار API |

---

## 📌 ملاحظات

### Base URL
```
http://your-domain.com/api
```

### Authentication Header
```
Authorization: Bearer {token}
```

### حالات الطلب
- `PENDING` - في الانتظار
- `ACCEPTED` - تم القبول
- `ONGOING` - قيد التنفيذ
- `COMPLETED` / `DONE` - مكتمل
- `CANCELLED` - ملغي

### أنواع المستخدمين
- `customer` - مريض
- `nurse` - ممرض
- `assistant` - مساعد
- `doctor` - طبيب
- `admin` - مدير
- `agent` - وكيل

---

**الإصدار:** 1.0  
**التاريخ:** 2025-01-24

