import pool from "../db/postgres";
import { HealthProfile, HealthProfileRow } from "../models/healthProfile";

function mapRowToModel(row: HealthProfileRow): HealthProfile {
  return {
    id: row.id,
    displayName: row.display_name,
    dateOfBirth: row.date_of_birth,
    gender: row.gender,
    heightCm: row.height_cm,
    weightKg: row.weight_kg,
    bloodType: row.blood_type,
    allergies: row.allergies,
    conditions: row.conditions ? JSON.parse(row.conditions) : [],
    emergencyName: row.emergency_name,
    emergencyPhone: row.emergency_phone,
  };
}

export class HealthProfileRepository {
  async findById(id: number): Promise<HealthProfile | null> {
    const result = await pool.query<HealthProfileRow>(
      "SELECT * FROM health_profiles WHERE id = $1",
      [id],
    );

    if (result.rowCount === 0) {
      return null;
    }

    return mapRowToModel(result.rows[0]);
  }

  async create(profile: HealthProfile): Promise<HealthProfile> {
    const result = await pool.query<HealthProfileRow>(
      `INSERT INTO health_profiles
        (display_name, date_of_birth, gender, height_cm, weight_kg, blood_type, allergies, conditions, emergency_name, emergency_phone)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [
        profile.displayName,
        profile.dateOfBirth,
        profile.gender,
        profile.heightCm,
        profile.weightKg,
        profile.bloodType,
        profile.allergies,
        JSON.stringify(profile.conditions),
        profile.emergencyName,
        profile.emergencyPhone,
      ],
    );

    return mapRowToModel(result.rows[0]);
  }
}
