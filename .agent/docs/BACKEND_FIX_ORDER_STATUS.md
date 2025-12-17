# Backend Fix Required - Order Status Issue

## المشكلة
عند إنشاء طلب جديد عبر `/api/v1/orders/store`، الـ backend يتجاهل حقل `status` المُرسل من الـ Flutter app ويستخدم `ONGOING` كـ default value.

## التأثير
- الطلبات الجديدة تظهر مباشرة في "Current Orders" بدلاً من "Notifications"
- الممرض لا يستطيع قبول أو رفض الطلب
- تجربة المستخدم سيئة

## الحل المطلوب في الـ Backend

### في `OrderController.php` (أو ما يعادله):

```php
public function store(Request $request) {
    // قبل:
    $order = Order::create([
        'user_id' => $request->user_id,
        'nurse_id' => $request->nurse_id,
        'status' => 'ONGOING', // ❌ Hard-coded default
        // ...
    ]);
    
    // بعد:
    $order = Order::create([
        'user_id' => $request->user_id,
        'nurse_id' => $request->nurse_id,
        'status' => $request->status ?? 'PENDING', // ✅ احترام القيمة المُرسلة
        // أو
        'status' => $request->order_status ?? 'PENDING',
        // ...
    ]);
}
```

### في الـ Migration (إذا كان الـ default في الـ database):

```php
// قبل:
$table->string('status')->default('ONGOING'); // ❌

// بعد:
$table->string('status')->default('PENDING'); // ✅
```

## الـ Request المُرسل من Flutter

```json
{
  "user_id": "123",
  "nurse_id": "456",
  "status": "PENDING",
  "order_status": "PENDING",
  "payment_type": "cash",
  "payment_status": "pending",
  ...
}
```

## التحقق من الحل

بعد التعديل، جرب:
1. إنشاء طلب جديد من الـ app
2. تحقق من الـ database: `SELECT * FROM orders ORDER BY id DESC LIMIT 1;`
3. الـ status يجب أن يكون `PENDING` وليس `ONGOING`

## الأولوية
🔴 **عالية** - يؤثر على core functionality

## التاريخ
2025-12-17
