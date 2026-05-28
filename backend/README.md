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
- `POST /api/auth/register` - đăng ký tài khoản

### Tạo bảng users

Trước khi dùng đăng ký, tạo bảng `users` trong database PostgreSQL theo schema hiện tại của bạn:

```sql
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20),
  role user_role NOT NULL DEFAULT 'PATIENT',
  avatar_url TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);
```

### Ví dụ Postman để test đăng ký

URL:

```text
POST http://localhost:3001/api/auth/register
```

Body (JSON):

```json
{
  "email": "user@example.com",
  "password": "123456"
}
```

Response thành công:

```json
{
  "id": 1,
  "email": "user@example.com"
}
```

### Ví dụ body POST hồ sơ sức khỏe

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

## Docker

Docker Compose đã cấu hình sẵn backend và PostgreSQL.

### Chạy bằng Docker

Từ thư mục gốc của repository:

```bash
docker compose up --build
```

### Truy cập

- Backend: `http://localhost:3001`
- PostgreSQL: `localhost:5432`

### Docker Compose cấu hình

Docker Compose sẽ dùng các giá trị môi trường:

- `PG_HOST=postgres`
- `PG_PORT=5432`
- `PG_DATABASE=mediremind`
- `PG_USER=postgres`
- `PG_PASSWORD=123456`
- `PORT=3001`

Nếu bạn muốn dùng dữ liệu khác, chỉnh `docker-compose.yml` hoặc `backend/.env`.

## Frontend Flutter

Flutter đã được bổ sung lớp:

- `lib/data/remote/health_profile_remote_data_source.dart`
- `lib/data/repositories/health_profile_repository.dart`
- `lib/services/health_profile_service.dart`
- `lib/controllers/health_profile_controller.dart`

và `HomeScreen` đã cập nhật để gọi API backend.
