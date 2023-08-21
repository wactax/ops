SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
ALTER TABLE IF EXISTS ONLY u.password DROP CONSTRAINT IF EXISTS password_pkey;
ALTER TABLE IF EXISTS ONLY u.log DROP CONSTRAINT IF EXISTS log_pkey;
ALTER TABLE IF EXISTS u.password ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS u.log ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS u.uid;
DROP SEQUENCE IF EXISTS u.password_id_seq;
DROP TABLE IF EXISTS u.password;
DROP SEQUENCE IF EXISTS u.log_id_seq;
DROP TABLE IF EXISTS u.log;
DROP SCHEMA IF EXISTS u;
CREATE SCHEMA u;
SET search_path TO u;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE u.log (
    id public.u64 NOT NULL,
    action public.u16 NOT NULL,
    uid public.u64 NOT NULL,
    val bytea DEFAULT '\x'::bytea NOT NULL,
    ctime public.u64 DEFAULT ceil(date_part('epoch'::text, now())) NOT NULL,
    client_id public.u64 NOT NULL
);
CREATE SEQUENCE u.log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE u.log_id_seq OWNED BY u.log.id;
CREATE TABLE u.password (
    id public.u64 NOT NULL,
    hash public.md5hash NOT NULL,
    ctime public.u64 NOT NULL
);
CREATE SEQUENCE u.password_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE u.password_id_seq OWNED BY u.password.id;
CREATE SEQUENCE u.uid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE ONLY u.log ALTER COLUMN id SET DEFAULT nextval('u.log_id_seq'::regclass);
ALTER TABLE ONLY u.password ALTER COLUMN id SET DEFAULT nextval('u.password_id_seq'::regclass);
ALTER TABLE ONLY u.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);
ALTER TABLE ONLY u.password
    ADD CONSTRAINT password_pkey PRIMARY KEY (id);