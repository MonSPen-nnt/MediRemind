import fs from "fs";
import path from "path";

import admin from "firebase-admin";

export const FIREBASE_SETUP_MESSAGE =
  "Firebase Admin chua duoc cau hinh. Tai file JSON tu Firebase Console (project mediremind-79) va dat vao backend/secrets/ (ten file bat ky, vi du *-firebase-adminsdk-*.json), roi chay: docker compose restart backend";

function loadServiceAccountFromFile(filePath: string): admin.ServiceAccount {
  const absolutePath = path.isAbsolute(filePath)
    ? filePath
    : path.resolve(process.cwd(), filePath);
  const raw = fs.readFileSync(absolutePath, "utf8");
  const json = JSON.parse(raw) as {
    project_id: string;
    client_email: string;
    private_key: string;
  };

  return {
    projectId: json.project_id,
    clientEmail: json.client_email,
    privateKey: json.private_key,
  };
}

function findServiceAccountFile(): string | null {
  const configuredPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
  const candidatePaths = [
    configuredPath,
    path.resolve(process.cwd(), "secrets/firebase-service-account.json"),
    path.resolve(process.cwd(), "firebase-service-account.json"),
  ].filter((value): value is string => Boolean(value));

  for (const filePath of candidatePaths) {
    if (fs.existsSync(filePath)) {
      return filePath;
    }
  }

  const secretsDir = path.resolve(process.cwd(), "secrets");
  if (!fs.existsSync(secretsDir)) {
    return null;
  }

  const jsonFiles = fs
    .readdirSync(secretsDir)
    .filter((name) => name.endsWith(".json"));

  const adminsdkFile = jsonFiles.find((name) =>
    name.includes("firebase-adminsdk"),
  );
  if (adminsdkFile) {
    return path.join(secretsDir, adminsdkFile);
  }

  return jsonFiles.length === 1 ? path.join(secretsDir, jsonFiles[0]) : null;
}

function getFirebaseApp(): admin.app.App {
  if (admin.apps.length > 0) {
    return admin.app();
  }

  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n");

  if (projectId && clientEmail && privateKey) {
    return admin.initializeApp({
      credential: admin.credential.cert({
        projectId,
        clientEmail,
        privateKey,
      }),
    });
  }

  const serviceAccountFile = findServiceAccountFile();
  if (serviceAccountFile) {
    const account = loadServiceAccountFromFile(serviceAccountFile);
    return admin.initializeApp({
      credential: admin.credential.cert(account),
    });
  }

  throw new Error(FIREBASE_SETUP_MESSAGE);
}

export class FirebaseAdminService {
  private authInstance: admin.auth.Auth | null = null;

  private get auth(): admin.auth.Auth {
    this.authInstance ??= getFirebaseApp().auth();
    return this.authInstance;
  }

  verifyIdToken(idToken: string): Promise<admin.auth.DecodedIdToken> {
    return this.auth.verifyIdToken(idToken, true);
  }
}

export function isFirebaseSetupError(error: unknown): boolean {
  return error instanceof Error && error.message === FIREBASE_SETUP_MESSAGE;
}
