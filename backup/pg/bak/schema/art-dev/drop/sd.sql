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
DROP TRIGGER IF EXISTS res_ver_down_trigger ON sd.res_ver;
DROP INDEX IF EXISTS sd.res_file_res_id_idx;
DROP INDEX IF EXISTS sd.res_file_alias_val_idx;
ALTER TABLE IF EXISTS ONLY sd.word_res_ver DROP CONSTRAINT IF EXISTS word_res_ver_word_id_res_ver_id_key;
ALTER TABLE IF EXISTS ONLY sd.word_res_ver DROP CONSTRAINT IF EXISTS word_res_ver_pkey;
ALTER TABLE IF EXISTS ONLY sd.word DROP CONSTRAINT IF EXISTS res_word_val_key;
ALTER TABLE IF EXISTS ONLY sd.word DROP CONSTRAINT IF EXISTS res_word_pkey;
ALTER TABLE IF EXISTS ONLY sd.res_ver DROP CONSTRAINT IF EXISTS res_ver_res_id_rid_key;
ALTER TABLE IF EXISTS ONLY sd.res_ver DROP CONSTRAINT IF EXISTS res_ver_pkey;
ALTER TABLE IF EXISTS ONLY sd.res DROP CONSTRAINT IF EXISTS res_pkey;
ALTER TABLE IF EXISTS ONLY sd.res_file DROP CONSTRAINT IF EXISTS res_file_pkey;
ALTER TABLE IF EXISTS ONLY sd.res_file_failed DROP CONSTRAINT IF EXISTS res_file_failed_pkey;
ALTER TABLE IF EXISTS ONLY sd.res_file_downed DROP CONSTRAINT IF EXISTS res_file_downed_pkey;
ALTER TABLE IF EXISTS ONLY sd.res DROP CONSTRAINT IF EXISTS res_cid_rid_key;
ALTER TABLE IF EXISTS ONLY sd.res_file_alias DROP CONSTRAINT IF EXISTS res_alias_pkey;
ALTER TABLE IF EXISTS ONLY sd.kind DROP CONSTRAINT IF EXISTS kind_pkey;
ALTER TABLE IF EXISTS ONLY sd.ext DROP CONSTRAINT IF EXISTS ext_val_key;
ALTER TABLE IF EXISTS ONLY sd.ext DROP CONSTRAINT IF EXISTS ext_pkey;
ALTER TABLE IF EXISTS sd.word_res_ver ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.word ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.res_ver ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.res_file ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.res ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.kind ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS sd.ext ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS sd.word_res_ver_id_seq;
DROP TABLE IF EXISTS sd.word_res_ver;
DROP SEQUENCE IF EXISTS sd.res_word_id_seq;
DROP TABLE IF EXISTS sd.word;
DROP SEQUENCE IF EXISTS sd.res_ver_id_seq;
DROP TABLE IF EXISTS sd.res_ver;
DROP SEQUENCE IF EXISTS sd.res_id_seq;
DROP SEQUENCE IF EXISTS sd.res_file_id_seq;
DROP TABLE IF EXISTS sd.res_file_failed;
DROP TABLE IF EXISTS sd.res_file_downed;
DROP TABLE IF EXISTS sd.res_file_alias;
DROP TABLE IF EXISTS sd.res_file;
DROP TABLE IF EXISTS sd.res;
DROP SEQUENCE IF EXISTS sd.kind_id_seq;
DROP TABLE IF EXISTS sd.kind;
DROP SEQUENCE IF EXISTS sd.ext_id_seq;
DROP TABLE IF EXISTS sd.ext;
DROP FUNCTION IF EXISTS sd.update_res_ver_down();
DROP SCHEMA IF EXISTS sd;
CREATE SCHEMA sd;
SET search_path TO sd;
CREATE OR REPLACE FUNCTION sd.update_res_ver_down() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF TG_OP = 'UPDATE' THEN 
    IF OLD.down != NEW.down THEN 
UPDATE sd.res SET down = down - OLD.down + NEW.down WHERE sd.res.id = OLD.res_id; 
    END IF;
  ELSIF TG_OP = 'INSERT' THEN
UPDATE sd.res SET down = down + NEW.down WHERE sd.res.id = NEW.res_id; 
  ELSIF TG_OP = 'DELETE' THEN
UPDATE sd.res SET down = down - OLD.down WHERE sd.res.id = OLD.res_id; 
  END IF;
  RETURN NEW;
END;
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE sd.ext (
    id smallint NOT NULL,
    val character varying(255) NOT NULL
);
CREATE SEQUENCE sd.ext_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.ext_id_seq OWNED BY sd.ext.id;
CREATE TABLE sd.kind (
    id public.u16 NOT NULL,
    val character varying(255)
);
CREATE SEQUENCE sd.kind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.kind_id_seq OWNED BY sd.kind.id;
CREATE TABLE sd.res (
    id public.u64 NOT NULL,
    name character varying(255) NOT NULL,
    cid public.u8 NOT NULL,
    rid public.u64 NOT NULL,
    down public.u64 DEFAULT 0 NOT NULL,
    ctime public.u64 DEFAULT (date_part('epoch'::text, now()))::bigint NOT NULL,
    utime public.u64 DEFAULT (date_part('epoch'::text, now()))::bigint NOT NULL,
    nsfw public.i8 DEFAULT '-1'::integer NOT NULL,
    kind_id public.u16
);
CREATE TABLE sd.res_file (
    id public.u64 NOT NULL,
    res_ver_id public.u64 NOT NULL,
    size public.u64 NOT NULL,
    name character varying(255) NOT NULL,
    rid public.u64 NOT NULL,
    auto_v2 public.u64 NOT NULL,
    sha256 bytea NOT NULL,
    blake3 bytea NOT NULL,
    ext_id public.u32 NOT NULL,
    res_id public.u64 NOT NULL
);
CREATE TABLE sd.res_file_alias (
    id public.u64 NOT NULL,
    val text NOT NULL
);
CREATE TABLE sd.res_file_downed (
    id public.u64 NOT NULL
);
CREATE TABLE sd.res_file_failed (
    id public.u64 NOT NULL
);
CREATE SEQUENCE sd.res_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.res_file_id_seq OWNED BY sd.res_file.id;
CREATE SEQUENCE sd.res_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.res_id_seq OWNED BY sd.res.id;
CREATE TABLE sd.res_ver (
    id public.u64 NOT NULL,
    res_id public.u64 NOT NULL,
    rid public.u64 NOT NULL,
    "time" public.u64 DEFAULT (date_part('epoch'::text, now()))::bigint NOT NULL,
    down public.u64 DEFAULT 0 NOT NULL,
    name character varying(255) NOT NULL
);
CREATE SEQUENCE sd.res_ver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.res_ver_id_seq OWNED BY sd.res_ver.id;
CREATE TABLE sd.word (
    id bigint NOT NULL,
    val character varying(255) NOT NULL
);
CREATE SEQUENCE sd.res_word_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.res_word_id_seq OWNED BY sd.word.id;
CREATE TABLE sd.word_res_ver (
    id bigint NOT NULL,
    word_id public.u64 NOT NULL,
    res_ver_id public.u64 NOT NULL
);
CREATE SEQUENCE sd.word_res_ver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE sd.word_res_ver_id_seq OWNED BY sd.word_res_ver.id;
ALTER TABLE ONLY sd.ext ALTER COLUMN id SET DEFAULT nextval('sd.ext_id_seq'::regclass);
ALTER TABLE ONLY sd.kind ALTER COLUMN id SET DEFAULT nextval('sd.kind_id_seq'::regclass);
ALTER TABLE ONLY sd.res ALTER COLUMN id SET DEFAULT nextval('sd.res_id_seq'::regclass);
ALTER TABLE ONLY sd.res_file ALTER COLUMN id SET DEFAULT nextval('sd.res_file_id_seq'::regclass);
ALTER TABLE ONLY sd.res_ver ALTER COLUMN id SET DEFAULT nextval('sd.res_ver_id_seq'::regclass);
ALTER TABLE ONLY sd.word ALTER COLUMN id SET DEFAULT nextval('sd.res_word_id_seq'::regclass);
ALTER TABLE ONLY sd.word_res_ver ALTER COLUMN id SET DEFAULT nextval('sd.word_res_ver_id_seq'::regclass);
ALTER TABLE ONLY sd.ext
    ADD CONSTRAINT ext_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.ext
    ADD CONSTRAINT ext_val_key UNIQUE (val);
ALTER TABLE ONLY sd.kind
    ADD CONSTRAINT kind_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res_file_alias
    ADD CONSTRAINT res_alias_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res
    ADD CONSTRAINT res_cid_rid_key UNIQUE (cid, rid);
ALTER TABLE ONLY sd.res_file_downed
    ADD CONSTRAINT res_file_downed_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res_file_failed
    ADD CONSTRAINT res_file_failed_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res_file
    ADD CONSTRAINT res_file_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res
    ADD CONSTRAINT res_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res_ver
    ADD CONSTRAINT res_ver_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.res_ver
    ADD CONSTRAINT res_ver_res_id_rid_key UNIQUE (res_id, rid);
ALTER TABLE ONLY sd.word
    ADD CONSTRAINT res_word_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.word
    ADD CONSTRAINT res_word_val_key UNIQUE (val);
ALTER TABLE ONLY sd.word_res_ver
    ADD CONSTRAINT word_res_ver_pkey PRIMARY KEY (id);
ALTER TABLE ONLY sd.word_res_ver
    ADD CONSTRAINT word_res_ver_word_id_res_ver_id_key UNIQUE (word_id, res_ver_id);
CREATE INDEX IF NOT EXISTS res_file_alias_val_idx ON sd.res_file_alias USING btree (val);
CREATE INDEX IF NOT EXISTS res_file_res_id_idx ON sd.res_file USING btree (res_id);
CREATE TRIGGER res_ver_down_trigger AFTER INSERT OR DELETE OR UPDATE OF down ON sd.res_ver FOR EACH ROW EXECUTE FUNCTION sd.update_res_ver_down();