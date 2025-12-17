# تقرير إصلاح مشكلة الطلبات المكررة

## 📋 المشكلة الأصلية
عند إنشاء طلب حجز جديد، كان يتم إرسال **طلبين (2 requests)** للسيرفر، مما يؤدي لظهور طلبين في الـ dashboard والإشعارات.

---

## 🔍 السبب الجذري

### 1. **Workaround خاطئ**
كان الكود يحتوي على workaround يرسل طلب ثانٍ بعد إنشاء الطلب:
```dart
// ❌ الكود القديم
if (data.orderID != null && data.orderID!.isNotEmpty) {
  await updateOrderUseCase(
      data: {'booking_id': data.orderID, 'status': 'PENDING'});
}
```

### 2. **عدم توافق أسماء الحقول مع الـ Backend**
كان Flutter يرسل حقول بأسماء مختلفة عن المتوقع في الـ Backend:

| Flutter (قديم) | Backend يتوقع | الحالة |
|----------------|---------------|--------|
| `long` | `lng` | ❌ خطأ |
| `status` | `current_status` | ❌ خطأ |
| `order_status` | `current_status` | ❌ خطأ |

---

## ✅ الحلول المُطبقة

### **التعديل 1: إزالة الـ Workaround**
**الملف:** `lib/features/booking/presentation/bloc/order_bloc.dart`

```dart
// ✅ الكود الجديد - بدون طلب ثانٍ
addNewOrder(AddOrderEvent event, emit) async {
  emit(SendNewBookingRequestLoadingState());
  try {
    var orderData =
        collectOrderData(payment: event.payment, orderData: event.orderData);
    var res = await addOrderUseCase(data: orderData);
    res.fold((l) {
      emit(OrderErrorState(errors: l.toString()));
    }, (data) async {
      if (data.state == true) {
        // ✅ لا يوجد طلب ثانٍ
        emit(AssignOrderSuccessfullyState());
      } else {
        emit(OrderErrorState(errors: data.msg.toString()));
      }
    });
  } catch (e) {
    debugPrint("addNewOrderError: $e");
    emit(OrderErrorState(errors: e.toString()));
  }
}
```

### **التعديل 2: توحيد أسماء الحقول مع الـ Backend**
**الملف:** `lib/features/booking/presentation/bloc/order_bloc.dart`

```dart
// ✅ الكود الجديد - متوافق مع Backend API
Map<String, dynamic> collectOrderData(
    {required PaymentOption payment,
    required Map<String, dynamic> orderData}) {
  String desc = "";
  for (var i in orderServiceList) {
    desc += "${i.name}: ${i.value}${translate("icare.le")} ";
  }
  var data = {
    'user_id': Util.getUserID(),
    'nurse_id': orderData['nurse_id'],
    'city': "",
    'payment_type': "cash",
    'payment_status': 'pending',
    'grand_total': "0.0",
    'coupon_discount': "0",
    'arrival_date': "",
    'desc': desc,
    'address': orderData['address'] ?? '',
    'lat': orderData['lat'] ?? '',
    'lng': orderData['long'] ?? '',  // ✅ تم التعديل: 'long' → 'lng'
    'current_status': 'PENDING'  // ✅ تم التعديل: استخدام 'current_status'
  };
  return data;
}
```

---

## 📊 مقارنة قبل وبعد

### **قبل الإصلاح:**
```
إنشاء طلب
    ↓
Request 1: POST /api/v1/orders/store
    ↓
Request 2: POST /api/v1/orders/update/status  ← مشكلة!
    ↓
طلبين في الـ database
```

### **بعد الإصلاح:**
```
إنشاء طلب
    ↓
Request 1: POST /api/v1/orders/store (مع current_status=PENDING)
    ↓
طلب واحد فقط في الـ database ✅
```

---

## 🎯 التوافق مع Backend API

### **الحقول المُرسلة الآن:**
```json
{
  "user_id": "188",
  "nurse_id": "208",
  "city": "",
  "payment_type": "cash",
  "payment_status": "pending",
  "grand_total": "0.0",
  "coupon_discount": "0",
  "arrival_date": "",
  "desc": "خدمة تمريض",
  "address": "123 Main St",
  "lat": "30.0444",
  "lng": "31.2357",
  "current_status": "PENDING"
}
```

### **التوافق مع Backend Documentation:**
✅ `current_status` - يطابق المتوقع  
✅ `lng` - يطابق المتوقع  
✅ `payment_type` - يطابق المتوقع  
✅ `grand_total` - يطابق المتوقع  

---

## 🧪 كيفية الاختبار

### **1. اختبار من التطبيق:**
```bash
# 1. Hot reload التطبيق
flutter run -d emulator-5554

# 2. إنشاء طلب جديد من الـ app
# 3. تحقق من الـ console logs
# 4. تأكد من عدم وجود طلب ثانٍ
```

### **2. اختبار من الـ Database:**
```sql
-- قبل إنشاء الطلب
SELECT COUNT(*) FROM orders;

-- إنشاء طلب من الـ app

-- بعد إنشاء الطلب
SELECT COUNT(*) FROM orders;
-- يجب أن يزيد العدد بـ 1 فقط (وليس 2)

-- التحقق من الـ status
SELECT id, user_id, nurse_id, order_status, created_at 
FROM orders 
ORDER BY id DESC 
LIMIT 1;
-- order_status يجب أن يكون 'PENDING'
```

### **3. اختبار من الـ Network Logs:**
```bash
# في Android Studio
# View → Tool Windows → App Inspection → Network Inspector
# أو استخدم Charles Proxy / Proxyman

# تأكد من:
# ✅ طلب واحد فقط إلى /api/v1/orders/store
# ❌ لا يوجد طلب إلى /api/v1/orders/update/status
```

---

## ⚠️ ملاحظات مهمة

### **1. Backend قد يحتاج تعديل**
إذا كان الـ Backend لا يزال يُنشئ الطلبات بـ status = `ONGOING` بدلاً من `PENDING`:

**يجب التحقق من:**
- `OrderController.php` - دالة `store()`
- `Order.php` Model - `$fillable` و `$attributes`
- Database Migration - default value

**راجع الملف:** `.agent/docs/BACKEND_CHECKLIST.md`

### **2. الحقول المُستقبلة من Backend**
الـ Backend يُرجع `order_status` في الـ response:
```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "order_status": "PENDING",  // ← اسم الحقل في الـ response
      ...
    }
  ]
}
```

الـ Flutter يقرأه بشكل صحيح في `OrderModel.fromJson()`:
```dart
status: jsonObject['order_status'],  // ✅ صحيح
```

---

## 📁 الملفات المُعدلة

1. ✅ `lib/features/booking/presentation/bloc/order_bloc.dart`
   - حذف الـ workaround (طلب ثانٍ)
   - تعديل `collectOrderData()` لتوافق Backend API

2. ✅ `.agent/docs/BACKEND_FIX_ORDER_STATUS.md`
   - توثيق المشكلة للـ backend team

3. ✅ `.agent/docs/BACKEND_CHECKLIST.md`
   - دليل شامل للتحقق من الـ backend

---

## ✅ النتيجة المتوقعة

بعد هذه التعديلات:
- ✅ طلب واحد فقط يُرسل للسيرفر
- ✅ لا توجد طلبات مكررة في الـ dashboard
- ✅ لا توجد إشعارات مكررة
- ✅ الطلبات تُنشأ بـ status = `PENDING` (إذا كان الـ backend صحيح)
- ✅ الممرض يستطيع قبول أو رفض الطلب

---

## 🚀 الخطوات التالية

1. ✅ **اختبر التطبيق الآن** - تأكد من اختفاء المشكلة
2. 🔍 **تحقق من الـ Backend** - إذا لا تزال الطلبات تُنشأ بـ `ONGOING`
3. 📊 **راقب الـ Production** - تأكد من عدم وجود side effects

---

**التاريخ:** 2025-12-17  
**الحالة:** ✅ تم الإصلاح  
**الأولوية:** 🔴 عالية
