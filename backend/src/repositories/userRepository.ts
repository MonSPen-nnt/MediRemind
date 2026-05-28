import pool from "../db/postgres";
import { User, UserRow } from "../models/user";

function mapRowToModel(row: UserRow): User {
  return {
    user_id: row.user_id,
    email: row.email,
    fullName: row.full_name,
  };
}

export class UserRepository {
  async findByEmail(email: string): Promise<User | null> {
    const result = await pool.query<UserRow>(
      "SELECT user_id, email, full_name, password_hash FROM users WHERE email = $1",
      [email],
    );

    if (result.rowCount === 0) {
      return null;
    }

    return mapRowToModel(result.rows[0]);
  }

  async create(user: User, hashedPassword: string): Promise<User> {
    const result = await pool.query<UserRow>(
      "INSERT INTO users (email, password_hash, full_name) VALUES ($1, $2, $3) RETURNING user_id, email, full_name",
      [user.email, hashedPassword, user.fullName],
    );

    return mapRowToModel(result.rows[0]);
  }
}
