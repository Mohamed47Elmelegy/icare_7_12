# Backend Checklist - إصلاح مشكلة Order Status

## 📋 الملفات المطلوب فحصها

### 1️⃣ **OrderController.php** (الأهم)
**المسار المتوقع:**
```
app/Http/Controllers/Api/V1/OrderController.php
أو
app/Http/Controllers/OrderController.php
```

---

## 🔍 **ما الذي تبحث عنه؟**

### **في دالة `store()` أو `create()`**

#### ❌ **الكود الخطأ (المشكلة):**
```php
public function store(Request $request)
{
    $order = Order::create([
        'user_id' => $request->user_id,
        'nurse_id' => $request->nurse_id,
        'status' => 'ONGOING',  // ← المشكلة هنا! Hard-coded
        'payment_type' => $request->payment_type,
        'grand_total' => $request->grand_total,
        // ...
    ]);
    
    return response()->json([
        'success' => true,
        'order_id' => $order->id,
    ]);
}
```

#### ✅ **الكود الصحيح (الحل):**
```php
public function store(Request $request)
{
    $order = Order::create([
        'user_id' => $request->user_id,
        'nurse_id' => $request->nurse_id,
        // ✅ استخدم القيمة المُرسلة من الـ app
        'status' => $request->status ?? 'PENDING',
        // أو إذا كان الحقل اسمه order_status:
        // 'status' => $request->order_status ?? 'PENDING',
        'payment_type' => $request->payment_type,
        'grand_total' => $request->grand_total,
        // ...
    ]);
    
    return response()->json([
        'success' => true,
        'order_id' => $order->id,
    ]);
}
```

---

### 2️⃣ **Order Model** (app/Models/Order.php)

#### ❌ **المشكلة المحتملة:**
```php
class Order extends Model
{
    protected $fillable = [
        'user_id',
        'nurse_id',
        // 'status',  // ← إذا مش موجود في fillable!
        'payment_type',
        // ...
    ];
    
    // أو
    protected $attributes = [
        'status' => 'ONGOING',  // ← Default value خطأ
    ];
}
```

#### ✅ **الحل:**
```php
class Order extends Model
{
    protected $fillable = [
        'user_id',
        'nurse_id',
        'status',  // ✅ تأكد إنه موجود
        'order_status',  // ✅ إذا كنت بتستخدم الاثنين
        'payment_type',
        'payment_status',
        'grand_total',
        'address',
        'lat',
        'long',
        'desc',
        // ...
    ];
    
    // ✅ Default value صحيح
    protected $attributes = [
        'status' => 'PENDING',
    ];
}
```

---

### 3️⃣ **Database Migration**

**ابحث عن الملف:**
```
database/migrations/YYYY_MM_DD_HHMMSS_create_orders_table.php
```

#### ❌ **المشكلة:**
```php
Schema::create('orders', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id');
    $table->foreignId('nurse_id');
    $table->string('status')->default('ONGOING');  // ← خطأ!
    // ...
});
```

#### ✅ **الحل:**
```php
Schema::create('orders', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id');
    $table->foreignId('nurse_id');
    $table->string('status')->default('PENDING');  // ✅ صح
    // ...
});
```

**⚠️ مهم:** إذا عدلت الـ migration، لازم تعمل:
```bash
# إنشاء migration جديد للتعديل
php artisan make:migration update_orders_status_default

# في الملف الجديد:
public function up()
{
    Schema::table('orders', function (Blueprint $table) {
        $table->string('status')->default('PENDING')->change();
    });
}
```

---

## 🧪 **كيف تختبر التعديلات؟**

### **الطريقة 1: استخدام Postman/Insomnia**

```http
POST https://admin.i-care.one/api/v1/orders/store
Content-Type: application/json
ID: YOUR_USER_ID

{
  "user_id": "188",
  "nurse_id": "208",
  "status": "PENDING",
  "order_status": "PENDING",
  "payment_type": "cash",
  "payment_status": "pending",
  "grand_total": "0.0",
  "coupon_discount": "0",
  "arrival_date": "",
  "desc": "Test order",
  "address": "Test address",
  "lat": "30.0444",
  "long": "31.2357"
}
```

**النتيجة المتوقعة:**
```json
{
  "success": true,
  "order_id": "123",
  "message": "Order created successfully"
}
```

### **الطريقة 2: فحص الـ Database مباشرة**

```sql
-- بعد إنشاء طلب جديد من الـ app
SELECT id, user_id, nurse_id, status, created_at 
FROM orders 
ORDER BY id DESC 
LIMIT 1;

-- النتيجة المتوقعة:
-- status = 'PENDING' (وليس 'ONGOING')
```

---

## 📝 **Logging للتحقق**

أضف هذا الكود في الـ Controller للتأكد:

```php
public function store(Request $request)
{
    // ✅ أضف logging
    \Log::info('Order Store Request:', [
        'status_from_request' => $request->status,
        'order_status_from_request' => $request->order_status,
        'all_data' => $request->all(),
    ]);
    
    $order = Order::create([
        'user_id' => $request->user_id,
        'nurse_id' => $request->nurse_id,
        'status' => $request->status ?? 'PENDING',
        // ...
    ]);
    
    // ✅ تحقق من القيمة المحفوظة
    \Log::info('Order Created:', [
        'order_id' => $order->id,
        'saved_status' => $order->status,
    ]);
    
    return response()->json([
        'success' => true,
        'order_id' => $order->id,
    ]);
}
```

**شوف الـ logs في:**
```bash
storage/logs/laravel.log
```

---

## ✅ **Checklist النهائي**

- [ ] فتحت `OrderController.php`
- [ ] وجدت دالة `store()` أو `create()`
- [ ] تأكدت إن `status` بياخد القيمة من `$request->status`
- [ ] فتحت `Order.php` Model
- [ ] تأكدت إن `status` موجود في `$fillable`
- [ ] تأكدت إن `$attributes['status']` = `'PENDING'`
- [ ] فحصت الـ migration
- [ ] عدلت الـ default value لو لازم
- [ ] اختبرت بـ Postman
- [ ] فحصت الـ Database
- [ ] اختبرت من الـ Flutter app
- [ ] تأكدت إن الطلب يُنشأ بـ status = PENDING

---

## 🚨 **مشاكل محتملة أخرى**

### **المشكلة 1: Validation**
```php
// إذا كان فيه validation يرفض PENDING
$request->validate([
    'status' => 'required|in:ONGOING,COMPLETED',  // ← خطأ!
]);

// ✅ الحل:
$request->validate([
    'status' => 'nullable|in:PENDING,ONGOING,COMPLETED,CANCELLED',
]);
```

### **المشكلة 2: Observer/Event**
```php
// إذا كان فيه Observer يغير الـ status
class OrderObserver
{
    public function creating(Order $order)
    {
        $order->status = 'ONGOING';  // ← خطأ!
    }
}

// ✅ الحل: احذف السطر ده أو عدله
```

### **المشكلة 3: Database Trigger**
```sql
-- إذا كان فيه trigger في الـ database
CREATE TRIGGER set_order_status 
BEFORE INSERT ON orders
FOR EACH ROW
SET NEW.status = 'ONGOING';  -- ← خطأ!

-- ✅ الحل: احذف الـ trigger
DROP TRIGGER IF EXISTS set_order_status;
```

---

## 📞 **إذا احتجت مساعدة**

1. ابعتلي محتوى ملف `OrderController.php`
2. ابعتلي محتوى ملف `Order.php` Model
3. ابعتلي الـ migration file
4. ابعتلي الـ logs من `storage/logs/laravel.log`

---

**آخر تحديث:** 2025-12-17
