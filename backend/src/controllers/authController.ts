import { Request, Response } from "express";
import { FirebaseAuthDto } from "../dtos/authDto";
import { AuthService } from "../services/authService";
import { isFirebaseSetupError } from "../services/firebaseAdminService";

const service = new AuthService();

export class AuthController {
  static async authenticateWithFirebase(
    req: Request,
    res: Response,
  ): Promise<void> {
    const { idToken, fullName } = req.body as FirebaseAuthDto;

    if (!idToken) {
      res.status(400).json({ message: "Firebase ID token is required." });
      return;
    }

    try {
      const user = await service.authenticateWithFirebase(idToken, fullName);
      res.status(200).json({
        user: {
          user_id: user.user_id,
          firebaseUid: user.firebaseUid,
          email: user.email,
          fullName: user.fullName,
          emailVerified: user.emailVerified,
        },
      });
    } catch (error) {
      if (isFirebaseSetupError(error)) {
        res.status(503).json({ message: (error as Error).message });
        return;
      }
      res.status(401).json({ message: (error as Error).message });
    }
  }
}

