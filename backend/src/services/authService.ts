import { User } from "../models/user";
import { UserRepository } from "../repositories/userRepository";
import { FirebaseAdminService } from "./firebaseAdminService";

export class AuthService {
  constructor(
    private readonly repository = new UserRepository(),
    private readonly firebaseAdmin = new FirebaseAdminService(),
  ) {}

  async authenticateWithFirebase(
    idToken: string,
    fullName?: string,
  ): Promise<User> {
    const decodedToken = await this.firebaseAdmin.verifyIdToken(idToken);
    const email = decodedToken.email;

    if (!email) {
      throw new Error("Firebase token does not contain an email.");
    }

    const firebaseUser: User = {
      firebaseUid: decodedToken.uid,
      email,
      fullName:
        fullName?.trim() ||
        decodedToken.name ||
        email.substring(0, email.indexOf("@")),
      emailVerified: decodedToken.email_verified ?? false,
    };

    const existingByUid = await this.repository.findByFirebaseUid(
      decodedToken.uid,
    );
    if (existingByUid) {
      return this.repository.updateFirebaseLogin(firebaseUser);
    }

    const existingByEmail = await this.repository.findByEmail(email);
    if (existingByEmail) {
      return this.repository.linkFirebaseUser(firebaseUser);
    }

    return this.repository.create(firebaseUser, "FIREBASE_AUTH");
  }
}

