export interface HealthProfile {
  id?: number;
  displayName: string;
  dateOfBirth?: string | null;
  gender?: string | null;
  heightCm: number;
  weightKg: number;
  bloodType?: string | null;
  allergies: string;
  conditions: string[];
  emergencyName: string;
  emergencyPhone: string;
}

export interface HealthProfileRow {
  id: number;
  display_name: string;
  date_of_birth: string | null;
  gender: string | null;
  height_cm: number;
  weight_kg: number;
  blood_type: string | null;
  allergies: string;
  conditions: string;
  emergency_name: string;
  emergency_phone: string;
}
