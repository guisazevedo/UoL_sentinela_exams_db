-- Migrations for adding hospital_id / hospital_key for authentication
CREATE TABLE IF NOT EXISTS hospital_credentials (
    hospital_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hospital_key VARCHAR(100) UNIQUE NOT NULL,
    hospital_name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPZ DEFAULT CURRENT_TIMESTAMP
);
