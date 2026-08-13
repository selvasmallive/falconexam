-- Runs once, when the postgres volume is first created.
-- Cloud SQL for PostgreSQL supports both of these; keep this file in sync with the Terraform
-- database configuration in Milestone 6 so local and cloud schemas start identically.

-- gen_random_uuid() for the non-sequential public identifiers every entity requires.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Case-insensitive text for email and external-identity lookups.
CREATE EXTENSION IF NOT EXISTS citext;
