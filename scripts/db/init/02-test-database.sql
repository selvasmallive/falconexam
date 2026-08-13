-- A separate database for integration tests, so a test run can truncate freely without destroying
-- the developer's local data. Integration tests that need real isolation should still prefer
-- Testcontainers; this exists for fast local iteration.

SELECT 'CREATE DATABASE falconexam_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'falconexam_test') \gexec

\connect falconexam_test

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
