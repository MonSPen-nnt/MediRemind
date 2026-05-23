import { Request, Response } from "express";
import { HealthProfileService } from "../services/healthProfileService";

const service = new HealthProfileService();

export class HealthProfileController {
  static async getById(req: Request, res: Response): Promise<void> {
    const id = Number(req.params.id);

    if (Number.isNaN(id) || id <= 0) {
      res.status(400).json({ message: "Id không hợp lệ." });
      return;
    }

    const profile = await service.getHealthProfile(id);

    if (!profile) {
      res.status(404).json({ message: "Không tìm thấy hồ sơ." });
      return;
    }

    res.json(profile);
  }

  static async create(req: Request, res: Response): Promise<void> {
    try {
      const profile = await service.createHealthProfile(req.body);
      res.status(201).json(profile);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Tạo hồ sơ thất bại." });
    }
  }
}
