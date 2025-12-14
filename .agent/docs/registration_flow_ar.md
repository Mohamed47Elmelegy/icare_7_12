# دليل شامل: التفرقة بين الممرض ومساعد الممرض عند التسجيل

## 📚 نظرة عامة

هذا الدليل يشرح بالتفصيل كيف يتم التفريق بين **الممرض (Nurse)** و**مساعد الممرض (Assistant)** عند إنشاء حساب جديد، وكيف تتغير البيانات المطلوبة والخدمات حسب النوع المختار.

---

## 🎯 الفكرة الأساسية

### المبدأ:
```
عند إنشاء حساب → المستخدم يختار النوع → تتغير الحقول المطلوبة → يتم رفع البيانات المناسبة
```

### الأنواع المتاحة:
| النوع | القيمة في API | البيانات المطلوبة |
|------|---------------|-------------------|
| **ممرض** | `nurse` | License + Certificate + Association Card + Nurse ID |
| **مساعد ممرض** | `assistant` | Related Job ID + Nurse ID فقط |

---

## 🔄 تدفق التسجيل الكامل

### الخطوة 1: اختيار نوع الحساب

```
المستخدم يفتح شاشة التسجيل
        ↓
  يختار "Nurse" أو "Assistant"
        ↓
  النظام يحفظ الاختيار في: authBloc.isNurse
```

**الكود:**
```dart
// في nurse_type.dart
InkWell(
  onTap: () => bloc.add(const SwitchNurseTypeEvent(isNurse: true)),
  child: Text("ممرض")
)

InkWell(
  onTap: () => bloc.add(const SwitchNurseTypeEvent(isNurse: false)),
  child: Text("مساعد ممرض")
)
```

---

### الخطوة 2: تغيير الحقول المطلوبة تلقائياً

#### إذا اختار **Nurse** (ممرض):

**الحقول المطلوبة:**
```dart
✓ Nurse ID (إلزامي)
✓ License (إلزامي)
✓ Certificate (إلزامي)
✓ Association Card (إلزامي)
✗ Related Job ID (مخفي)
```

**الكود:**
```dart
// في create_nurse_account.dart - Lines 273-437
BlocBuilder<AuthBloc, AuthState>(
  builder: (ctx, state) {
    var bloc = AuthBloc.get(ctx);
    
    if (bloc.isNurse) {
      // عرض: License, Certificate, Association Card
      return Column(
        children: [
          // License Upload Field
          UploadField(
            controller: licenceTextEditingController,
            hintText: "رخصة مزاولة المهنة",
            onTap: () async {
              final file = await getImage();
              bloc.add(UpdateNurseRegisterDataEvent(license: file));
            }
          ),
          
          // Certificate Upload Field
          UploadField(
            controller: certificateTextEditingController,
            hintText: "الشهادة",
            onTap: () async {
              final file = await getImage();
              bloc.add(UpdateNurseRegisterDataEvent(certificate: file));
            }
          ),
          
          // Association Card Upload Field
          UploadField(
            controller: associateTextEditingController,
            hintText: "بطاقة النقابة",
            onTap: () async {
              final file = await getImage();
              bloc.add(UpdateNurseRegisterDataEvent(associationCard: file));
            }
          ),
        ],
      );
    }
  }
)
```

#### إذا اختار **Assistant** (مساعد ممرض):

**الحقول المطلوبة:**
```dart
✓ Nurse ID (إلزامي)
✓ Related Job ID (إلزامي)
✗ License (مخفي)
✗ Certificate (مخفي)
✗ Association Card (مخفي)
```

**الكود:**
```dart
// في create_nurse_account.dart - Lines 276-317
if (!bloc.isNurse) {
  // عرض: Related Job ID فقط
  return Column(
    children: [
      UploadField(
        controller: relatedJobCardTextEditingController,
        hintText: "بطاقة العمل المتعلقة",
        onTap: () async {
          final file = await getImage();
          bloc.add(UpdateNurseRegisterDataEvent(relatedJobId: file));
        }
      ),
    ],
  );
}
```

---

### الخطوة 3: التحقق من البيانات (Validation)

**الدالة:**
```dart
// في create_nurse_account.dart - Lines 467-485
validateForm({BuildContext? context, required AuthBloc bloc}) {
  // التحقق الأساسي
  if (phoneTextEditingController.text.isEmpty) return false;
  
  if (emailTextEditingController.text.isEmpty || 
      !emailTextEditingController.text.contains("@")) {
    if (context != null) {
      SnackBarBuilder.showFeedBackMessage(
        context, 
        translate("toast.email_invalid"), 
        Colors.red
      );
    }
    return false;
  }
  
  // التحقق حسب النوع
  if (bloc.isNurse) {
    // للممرض: يجب رفع 3 ملفات
    if (associateTextEditingController.text.isEmpty ||
        licenceTextEditingController.text.isEmpty ||
        certificateTextEditingController.text.isEmpty) {
      return false;
    }
  } else if (!bloc.isNurse) {
    // للمساعد: يجب رفع ملف واحد
    if (relatedJobCardTextEditingController.text.isEmpty) {
      return false;
    }
  }
  
  // التحقق من الحقول المشتركة
  if (firstNameTextEditingController.text.isNotEmpty &&
      passwordTextEditingController.text.isNotEmpty &&
      nurseIDTextEditingController.text.isNotEmpty) {
    return true;
  }
  
  return false;
}
```

---

### الخطوة 4: تجميع البيانات للرفع

**الملف:** `register.dart` - Lines 86-149

```dart
Map<String, dynamic> registerData = {
  // البيانات الأساسية (مشتركة)
  'name': nameTextEditingController.text.trim(),
  'email': emailTextEditingController.text.trim(),
  'phone': phoneTextEditingController.text.trim(),
  'password': passwordTextEditingController.text.trim(),
  'city': locationsBloc.city,
  'governorate': locationsBloc.governorate,
  'latitude': locationsBloc.currentCheckOutLocation!.lat,
  'longitude': locationsBloc.currentCheckOutLocation!.long,
  'address': "...",
  'country_code': '',
  'status': 'online',
  'is_male': authBloc.isWomen ? "0" : "1",
};

// إضافة البيانات حسب النوع
if (Util.getUserType() == UserEnum.NURSE.name.toLowerCase()) {
  // تحديد user_type
  registerData['user_type'] = authBloc.isNurse ? "nurse" : "assistant";
  
  // الملفات (للاثنين)
  if (authBloc.nurseID != null) {
    registerData['nurseID'] = authBloc.nurseID;
  }
  
  // للممرض فقط
  if (authBloc.isNurse) {
    if (authBloc.license != null) {
      registerData['license'] = authBloc.license;
    }
    if (authBloc.certificate != null) {
      registerData['certificate'] = authBloc.certificate;
    }
    if (authBloc.associationCard != null) {
      registerData['associationCard'] = authBloc.associationCard;
    }
  } else {
    // للمساعد فقط
    if (authBloc.relatedJobId != null) {
      registerData['related_job_id'] = authBloc.relatedJobId;
    }
  }
  
  // بيانات إضافية (اختيارية)
  if (authBloc.avatar != null) {
    registerData['avatar'] = authBloc.avatar;
  }
  if (authBloc.languageList != null) {
    registerData['languages'] = jsonEncode(authBloc.languageList);
  }
  if (authBloc.educationList != null) {
    registerData['education'] = jsonEncode(authBloc.educationList);
  }
  if (authBloc.publicationsList != null) {
    registerData['publications'] = jsonEncode(authBloc.publicationsList);
  }
  if (authBloc.coursesList != null) {
    registerData['courses'] = jsonEncode(authBloc.coursesList);
  }
}

// إرسال البيانات
authBloc.add(RegisterEvent(user: registerData));
```

---

### الخطوة 5: إرسال البيانات للسيرفر

**API Call:**
```dart
// في authentication_data_source.dart - Lines 68-82
Future<AuthResponse> registerNewUser({
  required Map<String, dynamic> userData
}) async {
  var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.REGISTER_URL));
  
  // إضافة الحقول النصية
  request.fields['name'] = userData['name'];
  request.fields['email'] = userData['email'];
  request.fields['phone'] = userData['phone'];
  request.fields['password'] = userData['password'];
  request.fields['user_type'] = userData['user_type']; // "nurse" أو "assistant"
  
  // إضافة الملفات
  if (userData['nurseID'] != null) {
    var file = await http.MultipartFile.fromPath('nurseID', userData['nurseID'].path);
    request.files.add(file);
  }
  
  if (userData['user_type'] == 'nurse') {
    // ملفات الممرض
    if (userData['license'] != null) {
      var file = await http.MultipartFile.fromPath('license', userData['license'].path);
      request.files.add(file);
    }
    if (userData['certificate'] != null) {
      var file = await http.MultipartFile.fromPath('certificate', userData['certificate'].path);
      request.files.add(file);
    }
    if (userData['associationCard'] != null) {
      var file = await http.MultipartFile.fromPath('associationCard', userData['associationCard'].path);
      request.files.add(file);
    }
  } else {
    // ملفات المساعد
    if (userData['related_job_id'] != null) {
      var file = await http.MultipartFile.fromPath('related_job_id', userData['related_job_id'].path);
      request.files.add(file);
    }
  }
  
  // إرسال الطلب
  var response = await request.send();
  var res = await http.Response.fromStream(response);
  
  return AuthResponse.fromJson(jsonDecode(res.body));
}
```

---

## 🎨 صفحة الأسعار وتحديد الخدمات

### كيف يتم اختيار الخدمات؟

#### الموقع: صفحة البروفايل → تبويب الأسعار

**الملف:** `nurse_profile_prices_tap_screen.dart`

```dart
class NurseProfilePricesTapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        var list = bloc.servicesList; // الخدمات المحفوظة للمستخدم
        
        return Column(
          children: [
            // إذا كان وضع التعديل مفعل
            if (bloc.enableUpdate) ...[
              // عرض قائمة اختيار الخدمة
              ServicesListDropDown(width: double.infinity),
              SizedBox(height: 20),
            ],
            
            // عرض الخدمات المحفوظة
            if (list != null && list.isNotEmpty) ...[
              ListView.separated(
                itemCount: list.length,
                itemBuilder: (ctx, index) {
                  var item = list[index];
                  
                  // البحث عن تفاصيل الخدمة من allServiceList
                  int ind = bloc.allServiceList.indexWhere(
                    (element) => item.id == element.id
                  );
                  
                  if (ind == -1) return SizedBox.shrink();
                  
                  // عرض الخدمة مع السعر
                  return ServicePriceRowWithModify(
                    serviceID: bloc.allServiceList[ind].id,
                    serviceName: bloc.allServiceList[ind].value,
                    price: item.value, // السعر المحفوظ
                  );
                },
                separatorBuilder: (ctx, index) => Divider(height: 25),
              ),
            ],
          ],
        );
      },
    );
  }
}
```

---

### عنصر اختيار الخدمة والسعر

**الملف:** `service_list_drop_down.dart`

```dart
class ServicesListDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (ctx, state) {
        var bloc = AccountBloc.get(ctx);
        var list = bloc.allServiceList; // جميع الخدمات المتاحة
        
        if (list.isEmpty) return SizedBox.shrink();
        
        var currentItem = bloc.currentService;
        
        return Column(
          children: [
            // 1. Dropdown لاختيار الخدمة
            DropdownButton<ServicesModel>(
              value: null,
              hint: Text(
                currentItem == null 
                  ? "اختر خدمة" 
                  : currentItem.value
              ),
              items: list.map<DropdownMenuItem<ServicesModel>>((item) {
                return DropdownMenuItem<ServicesModel>(
                  value: item,
                  child: Text(item.value),
                );
              }).toList(),
              onChanged: (ServicesModel? newValue) {
                // حفظ الخدمة المختارة
                bloc.add(ChangeCurrentService(item: newValue!));
              },
            ),
            
            // 2. إذا تم اختيار خدمة، عرض حقل السعر
            if (currentItem != null) ...[
              SizedBox(height: 10),
              TextField(
                hintText: "أدخل السعر",
                onChanged: (val) {
                  // حفظ السعر
                  bloc.add(ChangeCurrentService(
                    item: currentItem, 
                    txt: val.trim()
                  ));
                },
              ),
              SizedBox(height: 20),
            ],
          ],
        );
      },
    );
  }
}
```

---

### حفظ الخدمة والسعر

**الملف:** `save_profile_btn.dart` - Lines 56-69

```dart
// عند الضغط على زر الحفظ
if (bloc.currentService != null && bloc.priceTxt != null) {
  // إنشاء ServicesModel جديد بالسعر
  var item = ServicesModel(
    id: bloc.currentService!.id,
    value: bloc.priceTxt.toString() // السعر كنص
  );
  
  // إضافة للقائمة المحلية
  bloc.servicesList ??= [];
  int index = bloc.servicesList!.indexWhere((e) => e.id == item.id);
  
  if (index != -1) {
    // تحديث السعر إذا كانت الخدمة موجودة
    bloc.servicesList![index] = item;
  } else {
    // إضافة خدمة جديدة
    bloc.servicesList!.add(item);
  }
  
  // رفع للسيرفر
  await UserServiceRemoteDataSource.updateNurseOptionsValue(
    userData: {
      'services': convertServiceToIDS(bloc.servicesList!),
    }
  );
}
```

---

### تحويل الخدمات لصيغة API

```dart
// في account_bloc.dart - Lines 417-426
convertServiceToIDS(List<ServicesModel> listP) {
  var list = [];
  for (var i in listP) {
    list.add({
      'id': i.id,
      'value': i.value, // السعر
    });
  }
  return list;
}
```

**النتيجة المرسلة للـ API:**
```json
{
  "user_id": 441,
  "services": [
    {
      "id": 1,
      "value": "50" // السعر
    },
    {
      "id": 5,
      "value": "100"
    }
  ]
}
```

---

## 📊 جدول مقارنة شامل

| العنصر | الممرض (Nurse) | المساعد (Assistant) |
|-------|----------------|---------------------|
| **user_type** | `"nurse"` | `"assistant"` |
| **Nurse ID** | ✅ إلزامي | ✅ إلزامي |
| **License** | ✅ إلزامي | ❌ غير مطلوب |
| **Certificate** | ✅ إلزامي | ❌ غير مطلوب |
| **Association Card** | ✅ إلزامي | ❌ غير مطلوب |
| **Related Job ID** | ❌ غير مطلوب | ✅ إلزامي |
| **Languages** | ✅ اختياري | ✅ اختياري |
| **Education** | ✅ اختياري | ✅ اختياري |
| **Publications** | ✅ اختياري | ✅ اختياري |
| **Courses** | ✅ اختياري | ✅ اختياري |
| **الخدمات** | ✅ يحددها بعد التسجيل | ✅ يحددها بعد التسجيل |

---

## 🔄 تدفق الخدمات الكامل

```
1. التسجيل
   ↓
   المستخدم يسجل بدون خدمات (services = null)
   
2. بعد الموافقة
   ↓
   المستخدم يسجل دخول
   
3. الذهاب للبروفايل
   ↓
   تبويب "الأسعار"
   
4. تفعيل وضع التعديل
   ↓
   الضغط على أيقونة التعديل
   
5. اختيار الخدمات
   ↓
   - اختيار خدمة من القائمة المنسدلة
   - إدخال السعر
   - الضغط على "حفظ"
   
6. الحفظ
   ↓
   - الخدمة تضاف لـ servicesList محلياً
   - يتم رفعها للسيرفر
   - تظهر في قائمة الخدمات
   
7. البحث
   ↓
   المستخدمون الآخرون يمكنهم البحث عن هذه الممرضة
   باستخدام الخدمات التي حددتها
```

---

## 💡 ملخص التدفق الكامل

### 1. التسجيل
```dart
User chooses: Nurse/Assistant
    ↓
Different fields appear
    ↓
User uploads required documents
    ↓
Data sent to server with user_type
```

### 2. الخدمات
```dart
After login → Profile → Prices Tab
    ↓
Enable edit mode
    ↓
Select service from dropdown (allServiceList)
    ↓
Enter price
    ↓
Save → Added to servicesList
    ↓
Uploaded to server
```

### 3. البحث
```dart
Other users search
    ↓
Filter by user_type = "nurse"
    ↓
Filter by service IDs
    ↓
Results show nurses offering those services
```

---

## 🎯 الخلاصة

### النقاط الرئيسية:

1. **التفرقة في التسجيل**:
   - `authBloc.isNurse` يحدد النوع
   - الحقول تتغير ديناميكياً بناءً على النوع
   - البيانات المرفوعة مختلفة لكل نوع

2. **التفرقة في الخدمات**:
   - كلاهما يحصل على نفس قائمة الخدمات من API
   - الفلترة تتم بناءً على `user_type` في البحث
   - السعر يتم تحديده من صفحة الأسعار

3. **رفع البيانات**:
   - `registerData['user_type']` يحدد النوع
   - الملفات المرفقة مختلفة
   - الخدمات تُحدد بعد التسجيل

---

## 📁 الملفات الرئيسية

| الملف | الوظيفة |
|------|---------|
| `nurse_type.dart` | عنصر اختيار Nurse/Assistant |
| `create_nurse_account.dart` | شاشة التسجيل الرئيسية |
| `register.dart` | تجميع وإرسال البيانات |
| `auth_bloc.dart` | إدارة حالة التسجيل |
| `nurse_profile_prices_tap_screen.dart` | صفحة الأسعار |
| `service_list_drop_down.dart` | اختيار الخدمة والسعر |
| `account_bloc.dart` | إدارة الخدمات والحفظ |

---

**تم إنشاء هذا الدليل في:** 2025-12-14
