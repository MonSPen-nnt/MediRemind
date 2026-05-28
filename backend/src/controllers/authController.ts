import { Request, Response } from "express";
import { AuthService } from "../services/authService";

const service = new AuthService();

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    const { email, password, fullName } = req.body as {
      email?: string;
      password?: string;
      fullName?: string;
    };

    if (!email || !password || !fullName) {
      res
        .status(400)
        .json({ message: "Email, mật khẩu và họ tên là bắt buộc." });
      return;
    }

    try {
      const user = await service.register(email, password, fullName);
      res.status(201).json({ user_id: user.user_id, email: user.email });
    } catch (error) {
      res.status(400).json({ message: (error as Error).message });
    }
  }
}
