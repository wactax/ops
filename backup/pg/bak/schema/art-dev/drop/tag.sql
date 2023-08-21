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
ALTER TABLE IF EXISTS ONLY tag.tag DROP CONSTRAINT IF EXISTS tag_val_key;
ALTER TABLE IF EXISTS ONLY tag.tag DROP CONSTRAINT IF EXISTS tag_pkey;
ALTER TABLE IF EXISTS tag.tag ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS tag.tag_id_seq;
DROP TABLE IF EXISTS tag.tag;
DROP SCHEMA IF EXISTS tag;
CREATE SCHEMA tag;
SET search_path TO tag;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE tag.tag (
    id bigint NOT NULL,
    val text NOT NULL
);
CREATE SEQUENCE tag.tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE tag.tag_id_seq OWNED BY tag.tag.id;
ALTER TABLE ONLY tag.tag ALTER COLUMN id SET DEFAULT nextval('tag.tag_id_seq'::regclass);
ALTER TABLE ONLY tag.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
ALTER TABLE ONLY tag.tag
    ADD CONSTRAINT tag_val_key UNIQUE (val);