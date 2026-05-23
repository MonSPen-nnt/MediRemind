import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const pool = new Pool({
  host: process.env.PG_HOST ?? "localhost",
  port: Number(process.env.PG_PORT ?? 5432),
  database: process.env.PG_DATABASE ?? "mediremind",
  user: process.env.PG_USER ?? "postgres",
  password: process.env.PG_PASSWORD ?? "password",
});

export async function testConnection(): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query("SELECT 1");
    console.log("PostgreSQL connected successfully.");
  } finally {
    client.release();
  }
}

export default pool;
