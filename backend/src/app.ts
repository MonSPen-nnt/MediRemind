import express from "express";
import cors from "cors";
import healthProfileRoutes from "./routes/healthProfileRoutes";
import authRoutes from "./routes/authRoutes";

const app = express();

app.use(cors());
app.use(express.json());
app.get("/", (_req, res) => {
  res.json({ message: "MediRemind backend is running." });
});
app.use("/api/health-profile", healthProfileRoutes);
app.use("/api/auth", authRoutes);

export default app;
