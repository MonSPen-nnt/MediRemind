# MediRemind Backend

Backend này dùng Express + TypeScript và kết nối PostgreSQL bằng `pg`.

## Thiết lập

1. Tạo cơ sở dữ liệu PostgreSQL:

```sql
CREATE DATABASE mediremind;

\c mediremind

CREATE TABLE health_profiles (
  id SERIAL PRIMARY KEY,
  display_name TEXT NOT NULL,
  date_of_birth DATE,
  gender TEXT,
  height_cm NUMERIC NOT NULL,
  weight_kg NUMERIC NOT NULL,
  blood_type TEXT,
  allergies TEXT NOT NULL,
  conditions JSONB NOT NULL,
  emergency_name TEXT NOT NULL,
  emergency_phone TEXT NOT NULL
);
```

2. Copy `backend/.env.example` thành `backend/.env` và cập nhật thông tin kết nối.

3. Cài đặt phụ thuộc:

```bash
cd backend
npm install
```

4. Chạy server trong môi trường phát triển:

```bash
npm run dev
```

## API

- `GET /api/health-profile/:id` - lấy hồ sơ theo `id`
- `POST /api/health-profile` - tạo hồ sơ mới

Ví dụ body POST:

```json
{
  "displayName": "Nguyen Van A",
  "dateOfBirth": "1990-06-15",
  "gender": "Male",
  "heightCm": 170,
  "weightKg": 68,
  "bloodType": "O+",
  "allergies": "Không",
  "conditions": ["Tăng huyết áp"],
  "emergencyName": "Le Thi B",
  "emergencyPhone": "+84912345678"
}
```

## Frontend Flutter

Flutter đã được bổ sung lớp:

- `lib/data/remote/health_profile_remote_data_source.dart`
- `lib/data/repositories/health_profile_repository.dart`
- `lib/services/health_profile_service.dart`
- `lib/controllers/health_profile_controller.dart`

và `HomeScreen` đã cập nhật để gọi API backend.
