import app from "./app";
import dotenv from "dotenv";
import { testConnection } from "./db/postgres";

dotenv.config();

const port = Number(process.env.PORT ?? 3001);

testConnection()
  .then(() => {
    app.listen(port, () => {
      console.log(`MediRemind backend listening on http://localhost:${port}`);
    });
  })
  .catch((error) => {
    console.error("PostgreSQL connection failed:", error);
    process.exit(1);
  });
