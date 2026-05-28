import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

const defaultHost =
  process.env.PG_HOST || process.env.PGHOST || "host.docker.internal";
const pool = new Pool({
  host: defaultHost,
  port: Number(process.env.PG_PORT ?? 5432),
  database: process.env.PG_DATABASE ?? "duanflutter",
  user: process.env.PG_USER ?? "postgres",
  password: process.env.PG_PASSWORD ?? "password",
});

export async function testConnection(): Promise<void> {
  console.log(
    `PostgreSQL connecting to host=${defaultHost} port=${process.env.PG_PORT ?? 5432} database=${process.env.PG_DATABASE ?? "duanflutter"}`,
  );
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
