import bcrypt from "bcryptjs";
import { User } from "../models/user";
import { UserRepository } from "../repositories/userRepository";

export class AuthService {
  constructor(private readonly repository = new UserRepository()) {}

  async register(
    email: string,
    password: string,
    fullName: string,
  ): Promise<User> {
    const existing = await this.repository.findByEmail(email);
    if (existing) {
      throw new Error("Email đã được đăng ký.");
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    return this.repository.create({ email, fullName }, hashedPassword);
  }
}
