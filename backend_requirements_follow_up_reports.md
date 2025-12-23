# Backend Requirements: Follow-up Reports Feature

## Overview
This document outlines the required API endpoints and data models for the Follow-up Reports feature, allowing nurses to update patient vital signs and medical information during bookings, while providing patients with appropriate visibility of their health data.

---

## 1. Nurse - Create/Update Follow-up Report

### Endpoint
```
POST /api/follow-up-reports
PUT /api/follow-up-reports/{reportId}
```

### Authentication
- **Required**: Yes (Nurse role only)
- **Authorization**: Bearer Token

### Request Body (multipart/form-data)
```json
{
  "bookingId": "string (required)",
  "patientId": "string (required)",
  "heartRate": "number (optional)",
  "bloodPressure": "string (optional, format: '120/80')",
  "height": "number (optional, in cm)",
  "weight": "number (optional, in kg)",
  "pulseRate": "number (optional)",
  "description": "string (optional, nurse notes - NOT visible to patient)",
  "prescriptionImage": "file (optional, image file - NOT visible to patient)"
}
```

### Response (Success - 200/201)
```json
{
  "success": true,
  "message": "Follow-up report created/updated successfully",
  "data": {
    "reportId": "string",
    "bookingId": "string",
    "patientId": "string",
    "heartRate": "number",
    "bloodPressure": "string",
    "height": "number",
    "weight": "number",
    "pulseRate": "number",
    "description": "string",
    "prescriptionImageUrl": "string",
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "nurseId": "string",
    "nurseName": "string"
  }
}
```

### Response (Error - 400/403/404)
```json
{
  "success": false,
  "message": "Error description",
  "errors": []
}
```

### Validation Rules
- At least one vital sign field must be provided
- `bloodPressure` format: "systolic/diastolic" (e.g., "120/80")
- `height` must be between 50-250 cm
- `weight` must be between 10-300 kg
- `heartRate` must be between 40-200 bpm
- `pulseRate` must be between 40-200 bpm
- Only the nurse assigned to the booking can create/update reports
- Image file types: jpg, jpeg, png, pdf (max size: 5MB)

---

## 2. Patient - Get Follow-up Reports

### Endpoint
```
GET /api/patients/follow-up-reports
GET /api/patients/follow-up-reports/{reportId}
```

### Authentication
- **Required**: Yes (Patient role only)
- **Authorization**: Bearer Token

### Query Parameters (for list endpoint)
```
?page=1&limit=10&bookingId=string
```

### Response (Success - 200)
```json
{
  "success": true,
  "data": [
    {
      "reportId": "string",
      "bookingId": "string",
      "heartRate": "number",
      "bloodPressure": "string",
      "height": "number",
      "weight": "number",
      "pulseRate": "number",
      "createdAt": "timestamp",
      "updatedAt": "timestamp",
      "nurseId": "string",
      "nurseName": "string"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalRecords": 50,
    "limit": 10
  }
}
```

### Important Notes for Patient Response
**The following fields MUST NOT be included in patient responses:**
- ❌ `description` (nurse notes)
- ❌ `prescriptionImageUrl` (prescription image)

These fields are **ONLY** visible to nurses and admins.

---

## 3. Nurse - Get Follow-up Reports (Full Access)

### Endpoint
```
GET /api/nurses/follow-up-reports
GET /api/nurses/follow-up-reports/{reportId}
```

### Authentication
- **Required**: Yes (Nurse role only)
- **Authorization**: Bearer Token

### Query Parameters
```
?page=1&limit=10&patientId=string&bookingId=string
```

### Response (Success - 200)
```json
{
  "success": true,
  "data": [
    {
      "reportId": "string",
      "bookingId": "string",
      "patientId": "string",
      "patientName": "string",
      "heartRate": "number",
      "bloodPressure": "string",
      "height": "number",
      "weight": "number",
      "pulseRate": "number",
      "description": "string (NURSE ONLY)",
      "prescriptionImageUrl": "string (NURSE ONLY)",
      "createdAt": "timestamp",
      "updatedAt": "timestamp",
      "nurseId": "string",
      "nurseName": "string"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalRecords": 50,
    "limit": 10
  }
}
```

---

## 4. Database Schema Suggestion

### Table: `follow_up_reports`

```sql
CREATE TABLE follow_up_reports (
  id VARCHAR(255) PRIMARY KEY,
  booking_id VARCHAR(255) NOT NULL,
  patient_id VARCHAR(255) NOT NULL,
  nurse_id VARCHAR(255) NOT NULL,
  
  -- Vital Signs (visible to patient)
  heart_rate INT,
  blood_pressure VARCHAR(20),
  height DECIMAL(5,2),
  weight DECIMAL(5,2),
  pulse_rate INT,
  
  -- Nurse Only Fields (NOT visible to patient)
  description TEXT,
  prescription_image_url VARCHAR(500),
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (patient_id) REFERENCES users(id),
  FOREIGN KEY (nurse_id) REFERENCES users(id),
  
  INDEX idx_patient_id (patient_id),
  INDEX idx_booking_id (booking_id),
  INDEX idx_nurse_id (nurse_id)
);
```

---

## 5. Security & Privacy Requirements

### Access Control
1. **Nurses** can:
   - Create follow-up reports for their assigned bookings
   - Update their own reports
   - View all fields including `description` and `prescriptionImageUrl`

2. **Patients** can:
   - View ONLY their own reports
   - See ONLY vital signs (heart rate, blood pressure, height, weight, pulse rate)
   - **CANNOT** see `description` or `prescriptionImageUrl`

3. **Admins** can:
   - View all reports with full access to all fields

### Data Privacy
- Implement role-based response filtering
- Ensure `description` and `prescriptionImageUrl` are **never** returned in patient API responses
- Log all access to follow-up reports for audit purposes

---

## 6. Additional Notes

### Image Upload
- Store prescription images securely (e.g., AWS S3, Google Cloud Storage)
- Generate signed URLs with expiration for nurse access
- Implement virus scanning for uploaded files

### Notifications
- Notify patient when a new follow-up report is created
- Notification should mention vital signs update, NOT the description

### Integration with Existing Booking Flow
- Follow-up reports should be linked to completed or ongoing bookings
- Consider adding a flag to bookings table: `has_follow_up_report` (boolean)

---

## Contact
For any questions or clarifications, please contact the mobile development team.

**Document Version**: 1.0  
**Date**: 2025-12-20  
**Prepared by**: Mobile Development Team
