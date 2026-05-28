import { HealthProfile } from "../models/healthProfile";
import { HealthProfileRepository } from "../repositories/healthProfileRepository";

export class HealthProfileService {
  constructor(private readonly repository = new HealthProfileRepository()) {}

  async getHealthProfile(id: number): Promise<HealthProfile | null> {
    return this.repository.findById(id);
  }

  async createHealthProfile(profile: HealthProfile): Promise<HealthProfile> {
    return this.repository.create(profile);
  }
}
