# 🔍 Backend Token Verification Checklist

## ✅ Verify Backend Sends Token

### 1. Check Login API Response

**Endpoint**: `POST /api/v1/auth/login`

**Expected Response**:
```json
{
  "status": true,
  "user": {
    "id": 300,
    "name": "User Name",
    "email": "user@example.com",
    "user_type": "nurse",
    ...
  },
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."  // ← REQUIRED
}
```

**Alternative Response Format**:
```json
{
  "status": true,
  "user": {...},
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."  // ← Also supported
}
```

---

## 🔧 Backend Implementation (Laravel)

### AuthController.php - Login Method

```php
public function login(Request $request)
{
    $credentials = $request->only('phone', 'password');
    
    if (!$token = auth()->attempt($credentials)) {
        return response()->json([
            'status' => false,
            'message' => 'Unauthorized'
        ], 401);
    }
    
    return response()->json([
        'status' => true,
        'user' => auth()->user(),
        'token' => $token,  // ← IMPORTANT: Include token
    ]);
}
```

### Alternative with Sanctum/Passport

```php
public function login(Request $request)
{
    $credentials = $request->only('phone', 'password');
    
    if (!Auth::attempt($credentials)) {
        return response()->json([
            'status' => false,
            'message' => 'Unauthorized'
        ], 401);
    }
    
    $user = Auth::user();
    $token = $user->createToken('icare-app')->accessToken;
    
    return response()->json([
        'status' => true,
        'user' => $user,
        'access_token' => $token,  // ← IMPORTANT: Include token
    ]);
}
```

---

## 🧪 Test Backend Response

### Using Postman/Insomnia

```bash
POST https://admin.i-care.one/api/v1/auth/login
Content-Type: application/json

{
  "phone": "1123876422",
  "password": "1123876422"
}
```

**Check Response**:
- ✅ Status: 200 OK
- ✅ Contains `"status": true`
- ✅ Contains `"user": {...}`
- ✅ Contains `"token"` or `"access_token"`

---

## 🐛 Common Backend Issues

### Issue 1: Token Not Included in Response
**Symptom**: App shows "⚠️ No API token found in response"

**Fix**:
```php
// Make sure to return token in response
return response()->json([
    'status' => true,
    'user' => $user,
    'token' => $token,  // ← Add this
]);
```

### Issue 2: Wrong Token Type
**Symptom**: Still getting "Unauthenticated" errors

**Check**:
- Ensure you're using JWT or Sanctum/Passport
- Ensure token is properly signed
- Check token expiry time

### Issue 3: Middleware Not Applied
**Symptom**: Some endpoints work, others don't

**Fix**:
```php
// In routes/api.php
Route::middleware('auth:api')->group(function () {
    Route::get('/orders/{userId}', [OrderController::class, 'getAllOrders']);
    Route::post('/orders/update', [OrderController::class, 'updateOrder']);
    // ... other protected routes
});
```

---

## 📝 Verify Token in Database

### For JWT (tymon/jwt-auth)

```bash
# Check config
php artisan config:cache

# Generate new secret if needed
php artisan jwt:secret
```

### For Sanctum

```bash
# Publish config
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Run migrations
php artisan migrate
```

### For Passport

```bash
# Install Passport
php artisan passport:install

# Generate keys
php artisan passport:keys
```

---

## 🔐 Verify Token Validation

### Test Token Validation Endpoint

```bash
GET https://admin.i-care.one/api/v1/user/info
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

**Expected Response**:
```json
{
  "status": true,
  "data": {
    "id": 300,
    "name": "User Name",
    ...
  }
}
```

---

## 📊 Backend Logs to Check

### Enable Query Logging (Laravel)

```php
// In AppServiceProvider.php
public function boot()
{
    if (config('app.debug')) {
        \DB::listen(function($query) {
            \Log::info(
                $query->sql,
                $query->bindings,
                $query->time
            );
        });
    }
}
```

### Check Laravel Logs

```bash
tail -f storage/logs/laravel.log
```

Look for:
- Authentication attempts
- Token generation
- Token validation failures

---

## ✅ Final Checklist

- [ ] Login API returns `token` or `access_token`
- [ ] Token is valid JWT/Sanctum/Passport token
- [ ] Protected routes use `auth:api` middleware
- [ ] Token validation works on test endpoint
- [ ] Token has reasonable expiry time (e.g., 24 hours)
- [ ] Refresh token mechanism exists (optional but recommended)

---

## 🚨 If Backend Doesn't Send Token

### Contact Backend Developer

Provide them with:
1. This checklist
2. Expected response format
3. Current response format
4. Error logs from app

### Temporary Workaround (NOT RECOMMENDED)

```dart
// In saveLocalData() - ONLY FOR TESTING
if (bodyData['token'] == null && bodyData['access_token'] == null) {
  debugPrint("⚠️ WARNING: No token in response, using dummy token");
  // This will still fail on actual API calls
}
```

---

**Remember**: The app CANNOT work without a proper authentication token from the backend!
