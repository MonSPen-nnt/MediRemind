import pool from "../db/postgres";
import { User, UserRow } from "../models/user";

function mapRowToModel(row: UserRow): User {
  return {
    user_id: row.user_id,
    firebaseUid: row.firebase_uid ?? undefined,
    email: row.email,
    fullName: row.full_name,
    emailVerified: row.email_verified,
  };
}

export class UserRepository {
  async findByFirebaseUid(firebaseUid: string): Promise<User | null> {
    const result = await pool.query<UserRow>(
      "SELECT user_id, firebase_uid, email, full_name, password_hash, email_verified FROM users WHERE firebase_uid = $1 AND deleted_at IS NULL",
      [firebaseUid],
    );

    if (result.rowCount === 0) {
      return null;
    }

    return mapRowToModel(result.rows[0]);
  }

  async findByEmail(email: string): Promise<User | null> {
    const result = await pool.query<UserRow>(
      "SELECT user_id, firebase_uid, email, full_name, password_hash, email_verified FROM users WHERE email = $1 AND deleted_at IS NULL",
      [email],
    );

    if (result.rowCount === 0) {
      return null;
    }

    return mapRowToModel(result.rows[0]);
  }

  async create(user: User, passwordHash: string): Promise<User> {
    const result = await pool.query<UserRow>(
      "INSERT INTO users (firebase_uid, email, password_hash, full_name, email_verified, is_verified, last_login_at) VALUES ($1, $2, $3, $4, $5, $5, CURRENT_TIMESTAMP) RETURNING user_id, firebase_uid, email, full_name, password_hash, email_verified",
      [
        user.firebaseUid ?? null,
        user.email,
        passwordHash,
        user.fullName,
        user.emailVerified ?? false,
      ],
    );

    return mapRowToModel(result.rows[0]);
  }

  async linkFirebaseUser(user: User): Promise<User> {
    const result = await pool.query<UserRow>(
      "UPDATE users SET firebase_uid = $1, full_name = $2, email_verified = $3, is_verified = $3, last_login_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE email = $4 AND deleted_at IS NULL RETURNING user_id, firebase_uid, email, full_name, password_hash, email_verified",
      [
        user.firebaseUid,
        user.fullName,
        user.emailVerified ?? false,
        user.email,
      ],
    );

    return mapRowToModel(result.rows[0]);
  }

  async updateFirebaseLogin(user: User): Promise<User> {
    const result = await pool.query<UserRow>(
      "UPDATE users SET full_name = $1, email_verified = $2, is_verified = $2, last_login_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE firebase_uid = $3 AND deleted_at IS NULL RETURNING user_id, firebase_uid, email, full_name, password_hash, email_verified",
      [user.fullName, user.emailVerified ?? false, user.firebaseUid],
    );

    return mapRowToModel(result.rows[0]);
  }
}

