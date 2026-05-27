import { Router } from "express";
import { AuthController } from "../controllers/authController";

const router = Router();

router.post("/firebase", AuthController.authenticateWithFirebase);

export default router;

