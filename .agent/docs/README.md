# 📚 دليل التوثيق الشامل - تطبيق iCare

## 🎯 مرحباً!

هذا هو الدليل الشامل لفهم نظام **التسجيل** و**الخدمات** في تطبيق iCare. التوثيق مكتوب بالعربية ومنظم بشكل تدريجي من المبتدئ إلى المحترف.

---

## 📖 فهرس التوثيق الكامل

### 🔐 القسم الأول: نظام التسجيل والتفرقة

| الملف | المستوى | الوصف |
|------|---------|-------|
| **[README_REGISTRATION_AR.md](./README_REGISTRATION_AR.md)** | 🟢 مبتدئ | نقطة البداية - يجيب على جميع الأسئلة |
| **[registration_flow_diagram_ar.md](./registration_flow_diagram_ar.md)** | 🟢 مبتدئ | مخططات بصرية توضيحية |
| **[registration_flow_ar.md](./registration_flow_ar.md)** | 🟡 متوسط | شرح تفصيلي بالكود |

#### 📌 ماذا ستتعلم؟

- ✅ كيف يتم التفريق بين **الممرض** و**مساعد الممرض**
- ✅ كيف تتغير البيانات المطلوبة عند التبديل
- ✅ كيف يتم رفع البيانات المختلفة للسيرفر
- ✅ كيف يتم اختيار الخدمات وتحديد الأسعار

---

### 🛠️ القسم الثاني: نظام الخدمات

| الملف | المستوى | الوصف |
|------|---------|-------|
| **[README_SERVICES_AR.md](./README_SERVICES_AR.md)** | 🟢 مبتدئ | الدليل الرئيسي للخدمات |
| **[services_flow_diagram_ar.md](./services_flow_diagram_ar.md)** | 🟢 مبتدئ | مخططات تدفق البيانات |
| **[services_fetch_documentation_ar.md](./services_fetch_documentation_ar.md)** | 🟡 متوسط | شرح آلية جلب الخدمات |
| **[api_examples_ar.md](./api_examples_ar.md)** | 🔴 متقدم | أمثلة API عملية |

#### 📌 ماذا ستتعلم؟

- ✅ كيف يتم جلب الخدمات من API
- ✅ كيف يتم فلترة الخدمات حسب نوع المستخدم
- ✅ كيف يتم عرض واختيار الخدمات
- ✅ كيف يتم استخدام الخدمات في البحث

---

## 🚀 البداية السريعة

### إذا كنت مبتدئاً → ابدأ من هنا:

#### 1️⃣ **فهم التسجيل والفروقات**

```
اقرأ بالترتيب:
1. README_REGISTRATION_AR.md (20 دقيقة)
2. registration_flow_diagram_ar.md (10 دقائق)
```

**ستتعلم:**
- كيف يسجل الممرض حساب
- كيف يسجل المساعد حساب
- ما الفرق بينهما

#### 2️⃣ **فهم نظام الخدمات**

```
اقرأ بالترتيب:
1. README_SERVICES_AR.md (20 دقيقة)
2. services_flow_diagram_ar.md (10 دقائق)
```

**ستتعلم:**
- من أين تأتي الخدمات
- كيف يتم اختيار الخدمات
- كيف يتم البحث بالخدمات

---

### إذا كنت مطوراً → اذهب مباشرة إلى:

#### 📁 **الكود والتفاصيل التقنية**

```
اقرأ:
1. registration_flow_ar.md
2. services_fetch_documentation_ar.md
3. api_examples_ar.md
```

**ستجد:**
- أمثلة كود كاملة
- شرح الـ Events والـ States
- أمثلة API Requests/Responses
- نصائح دebugging

---

## 🎓 مسارات تعليمية موصى بها

### 🟢 للمبتدئين (0-2 شهر خبرة)

```
اليوم 1: فهم التسجيل
├─ README_REGISTRATION_AR.md
└─ registration_flow_diagram_ar.md

اليوم 2: فهم الخدمات
├─ README_SERVICES_AR.md
└─ services_flow_diagram_ar.md

اليوم 3: تطبيق عملي
└─ جرّب تسجيل حساب مع الكود مفتوح
```

### 🟡 للمطورين المتوسطين (2-6 شهر خبرة)

```
اليوم 1: التفاصيل التقنية للتسجيل
└─ registration_flow_ar.md

اليوم 2: التفاصيل التقنية للخدمات
└─ services_fetch_documentation_ar.md

اليوم 3: API والتكامل
└─ api_examples_ar.md
```

### 🔴 للمطورين المحترفين (6+ شهر خبرة)

```
مباشرة:
1. اقرأ الكود في الملفات مع التوثيق جنباً إلى جنب
2. استخدم api_examples_ar.md كمرجع
3. راجع registration_flow_ar.md عند الحاجة
```

---

## 📋 جدول المحتويات التفصيلي

### 🔐 التسجيل والتفرقة

<details>
<summary><b>README_REGISTRATION_AR.md</b> - الدليل الرئيسي</summary>

**المحتوى:**
- الإجابة على جميع الأسئلة الشائعة
- أمثلة عملية كاملة
- جداول مقارنة
- نصائح استكشاف الأخطاء
- قائمة الملفات الرئيسية

**وقت القراءة:** 20-30 دقيقة
</details>

<details>
<summary><b>registration_flow_diagram_ar.md</b> - المخططات البصرية</summary>

**المحتوى:**
- مخطط تدفق التسجيل
- مقارنة الحقول المطلوبة
- تدفق رفع البيانات
- تدفق الخدمات والأسعار
- مخططات ASCII art

**وقت القراءة:** 10-15 دقيقة
</details>

<details>
<summary><b>registration_flow_ar.md</b> - الشرح التفصيلي</summary>

**المحتوى:**
- دورة الحياة الكاملة للتسجيل
- شرح كل خطوة بالكود
- التحقق من البيانات (Validation)
- تجميع البيانات للرفع
- صفحة الأسعار بالتفصيل
- جدول مقارنة شامل

**وقت القراءة:** 30-40 دقيقة
</details>

---

### 🛠️ الخدمات

<details>
<summary><b>README_SERVICES_AR.md</b> - الدليل الرئيسي</summary>

**المحتوى:**
- نظرة عامة على النظام
- البداية السريعة
- أسئلة شائعة (FAQ)
- استكشاف الأخطاء
- نصائح للمطورين

**وقت القراءة:** 20-30 دقيقة
</details>

<details>
<summary><b>services_flow_diagram_ar.md</b> - مخططات التدفق</summary>

**المحتوى:**
- التدفق خطوة بخطوة (Login → Services → Search)
- نقاط الـ Debug المهمة
- شرح الأنواع المستخدمة
- جدول ملخص

**وقت القراءة:** 10-15 دقيقة
</details>

<details>
<summary><b>services_fetch_documentation_ar.md</b> - الشرح التفصيلي</summary>

**المحتوى:**
- مسار البيانات الكامل
- شرح كل طبقة (Presentation, Data, Domain)
- أمثلة كود مع أرقام الأسطر
- ملاحظات مهمة

**وقت القراءة:** 30-40 دقيقة
</details>

<details>
<summary><b>api_examples_ar.md</b> - أمثلة API</summary>

**المحتوى:**
- أمثلة Login
- أمثلة جلب الخدمات
- أمثلة تحديث البيانات
- أمثلة Postman/cURL
- جدول ملخص Endpoints

**وقت القراءة:** 20-30 دقيقة
</details>

---

## 🔍 البحث السريع

### أريد أن أعرف...

#### ❓ كيف يختلف الممرض عن المساعد؟

👉 **[README_REGISTRATION_AR.md](./README_REGISTRATION_AR.md#-جدول-مقارنة-شامل)**

---

#### ❓ كيف أسجل ممرض جديد؟

👉 **[registration_flow_ar.md](./registration_flow_ar.md#-تدفق-التسجيل-الكامل)**

---

#### ❓ كيف تُجلب الخدمات؟

👉 **[services_fetch_documentation_ar.md](./services_fetch_documentation_ar.md#-تدفق-البيانات-data-flow)**

---

#### ❓ كيف يحدد المستخدم أسعار خدماته؟

👉 **[registration_flow_ar.md](./registration_flow_ar.md#-صفحة-الأسعار-وتحديد-الخدمات)**

---

#### ❓ ما هي API Endpoints المتاحة؟

👉 **[api_examples_ar.md](./api_examples_ar.md#-جدول-ملخص-api-endpoints)**

---

#### ❓ كيف أحل مشكلة معينة؟

👉 **[README_SERVICES_AR.md](./README_SERVICES_AR.md#-استكشاف-الأخطاء-troubleshooting)**  
👉 **[README_REGISTRATION_AR.md](./README_REGISTRATION_AR.md#-استكشاف-الأخطاء)**

---

## 🎯 حالات استخدام شائعة

### 1. **مطور جديد في المشروع**

```
أنت هنا لأول مرة؟

ابدأ من:
1. README_REGISTRATION_AR.md
2. README_SERVICES_AR.md

ثم:
3. راجع الكود مع registration_flow_ar.md مفتوح
4. جرّب أمثلة من api_examples_ar.md
```

---

### 2. **أريد إضافة ميزة جديدة**

```
تريد إضافة ميزة للتسجيل:
→ راجع registration_flow_ar.md

تريد إضافة ميزة للخدمات:
→ راجع services_fetch_documentation_ar.md

تريد تعديل API:
→ راجع api_examples_ar.md
```

---

### 3. **أحل bug معين**

```
مشكلة في التسجيل:
1. راجع README_REGISTRATION_AR.md - قسم استكشاف الأخطاء
2. راجع registration_flow_diagram_ar.md لفهم التدفق
3. ضع breakpoints حسب المخطط

مشكلة في الخدمات:
1. راجع README_SERVICES_AR.md - قسم Troubleshooting
2. راجع services_flow_diagram_ar.md - نقاط Debug
3. تتبع Debug Logs
```

---

### 4. **أكتب تست (Test)**

```
للتسجيل:
→ راجع أمثلة الكود في registration_flow_ar.md
→ استخدم registerData examples

للخدمات:
→ راجع api_examples_ar.md
→ استخدم API examples للـ mock data
```

---

## 📊 إحصائيات التوثيق

| المقياس | القيمة |
|---------|--------|
| عدد الملفات | 7 |
| عدد الكلمات | ~15,000 |
| وقت القراءة الكامل | ~3 ساعات |
| عدد الأمثلة | 20+ |
| عدد المخططات | 10+ |
| اللغة | العربية 100% |

---

## 🛠️ كيف تساهم في التوثيق؟

### وجدت خطأ؟

1. افتح الملف المناسب
2. صحح الخطأ
3. اذكر التغيير في commit message

### لديك إضافة؟

1. حدد الملف المناسب
2. أضف المعلومة في القسم المناسب
3. تأكد من التنسيق متسق

### أفكار جديدة؟

- أضف ملف جديد في `.agent/docs/`
- اتبع نفس أسلوب التنسيق
- أضفه لهذا الفهرس

---

## 📚 مصطلحات مهمة

| المصطلح | بالإنجليزية | الشرح |
|---------|-------------|--------|
| ممرض | Nurse | مقدم خدمة صحية مرخص |
| مساعد ممرض | Assistant | مساعد مقدم الخدمة |
| خدمة | Service | نوع الخدمة المقدمة (مثل قياس ضغط) |
| سعر | Price | تكلفة الخدمة |
| تسجيل | Registration | إنشاء حساب جديد |
| بحث | Search | البحث عن مقدمي الخدمة |
| فلترة | Filter | تصفية النتائج |
| رفع | Upload | إرسال البيانات للسيرفر |

---

## 🎓 موارد إضافية

### للتعلم أكثر عن Flutter BLoC:

- [BLoC Documentation](https://bloclibrary.dev/)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

### للتعلم أكثر عن HTTP/APIs:

- [HTTP Package Documentation](https://pub.dev/packages/http)
- [REST API Best Practices](https://restfulapi.net/)

---

## ✅ قائمة التحقق للمطورين الجدد

قبل البدء بالتطوير، تأكد من:

- [ ] قرأت `README_REGISTRATION_AR.md`
- [ ] قرأت `README_SERVICES_AR.md`
- [ ] فهمت الفرق بين Nurse و Assistant
- [ ] فهمت كيف تُجلب الخدمات
- [ ] جربت مثال واحد على الأقل
- [ ] أعرف أين أبحث عن الحلول عند مواجهة مشكلة

---

## 🎉 الخلاصة

هذا التوثيق الشامل يغطي:

✅ **نظام التسجيل** - من البداية للنهاية  
✅ **نظام الخدمات** - الجلب والعرض والبحث  
✅ **التفرقة بين الأنواع** - ممرض × مساعد  
✅ **أمثلة عملية** - للتطبيق المباشر  
✅ **حل المشاكل** - troubleshooting guides  

**ابدأ الآن** → [README_REGISTRATION_AR.md](./README_REGISTRATION_AR.md)

---

**📅 تاريخ الإنشاء:** 2025-12-14  
**👨‍💻 الإصدار:** 1.0  
**📝 اللغة:** العربية

💙 **نتمنى لك رحلة برمجة موفقة!**
