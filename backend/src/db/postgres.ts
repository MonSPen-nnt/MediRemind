import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const pool = new Pool({
  host: process.env.PG_HOST ?? "localhost",
  port: Number(process.env.PG_PORT ?? 5432),
  database: process.env.PG_DATABASE ?? "duanflutter",
  user: process.env.PG_USER ?? "postgres",
  password: process.env.PG_PASSWORD ?? "password",
});

export async function testConnection(): Promise<void> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT current_database() AS database_name, current_schema() AS schema_name",
    );
    const info = result.rows[0];
    console.log(
      `PostgreSQL connected successfully. database=${info.database_name} schema=${info.schema_name}`,
    );
  } finally {
    client.release();
  }
}

export default pool;
