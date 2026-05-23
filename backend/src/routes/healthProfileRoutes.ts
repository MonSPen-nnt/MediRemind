import { Router } from "express";
import { HealthProfileController } from "../controllers/healthProfileController";

const router = Router();

router.get("/:id", HealthProfileController.getById);
router.post("/", HealthProfileController.create);

export default router;
