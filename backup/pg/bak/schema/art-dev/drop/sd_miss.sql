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
ALTER TABLE IF EXISTS ONLY sd_miss.miss DROP CONSTRAINT IF EXISTS miss_pkey;
ALTER TABLE IF EXISTS ONLY sd_miss.miss DROP CONSTRAINT IF EXISTS miss_kind_id_hash_key;
ALTER TABLE IF EXISTS ONLY sd_miss.kind DROP CONSTRAINT IF EXISTS kind_val_key;
ALTER TABLE IF EXISTS sd_miss.miss ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd_miss.kind ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS sd_miss.miss_id_seq;
DROP TABLE IF EXISTS sd_miss.miss;
DROP SEQUENCE IF EXISTS sd_miss.kind_id_seq;
DROP TABLE IF EXISTS sd_miss.kind;
DROP SCHEMA IF EXISTS sd_miss;
CREATE SCHEMA sd_miss;
SET search_path TO sd_miss;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE sd_miss.kind (
    id bigint NOT NULL,
    val character varying(255) NOT NULL
);
CREATE SEQUENCE sd_miss.kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd_miss.kind_id_seq OWNED BY sd_miss.kind.id;
CREATE TABLE sd_miss.miss (
    id bigint NOT NULL,
    kind_id public.u8 NOT NULL,
    hash bytea,
    name_li text[] DEFAULT '{}'::text[] NOT NULL
);
CREATE SEQUENCE sd_miss.miss_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd_miss.miss_id_seq OWNED BY sd_miss.miss.id;
ALTER TABLE ONLY sd_miss.kind ALTER COLUMN id SET DEFAULT nextval('sd_miss.kind_id_seq'::regclass);
ALTER TABLE ONLY sd_miss.miss ALTER COLUMN id SET DEFAULT nextval('sd_miss.miss_id_seq'::regclass);
ALTER TABLE ONLY sd_miss.kind
    ADD CONSTRAINT kind_val_key UNIQUE (val);
ALTER TABLE ONLY sd_miss.miss
    ADD CONSTRAINT miss_kind_id_hash_key UNIQUE (kind_id, hash);
ALTER TABLE ONLY sd_miss.miss
    ADD CONSTRAINT miss_pkey PRIMARY KEY (id);