export interface User {
  user_id?: string;
  firebaseUid?: string;
  email: string;
  fullName: string;
  emailVerified?: boolean;
}

export interface UserRow {
  user_id: string;
  firebase_uid: string | null;
  email: string;
  full_name: string;
  password_hash: string;
  email_verified: boolean;
}

