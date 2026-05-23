export interface User {
  user_id?: string;
  email: string;
  fullName: string;
}

export interface UserRow {
  user_id: string;
  email: string;
  full_name: string;
  password_hash: string;
}
