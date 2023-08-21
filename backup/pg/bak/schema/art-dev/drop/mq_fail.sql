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
ALTER TABLE IF EXISTS ONLY mq_fail."redistreamTest" DROP CONSTRAINT IF EXISTS "redistreamTest_pkey";
ALTER TABLE IF EXISTS ONLY mq_fail.civitai_img DROP CONSTRAINT IF EXISTS civitai_img_pkey;
DROP TABLE IF EXISTS mq_fail."redistreamTest";
DROP TABLE IF EXISTS mq_fail.civitai_img;
DROP SCHEMA IF EXISTS mq_fail;
CREATE SCHEMA mq_fail;
SET search_path TO mq_fail;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE mq_fail.civitai_img (
    id public.u64 NOT NULL,
    val bytea NOT NULL,
    ctime public.u64 DEFAULT floor(date_part('epoch'::text, now())) NOT NULL
);
CREATE TABLE mq_fail."redistreamTest" (
    id public.u64 NOT NULL,
    val bytea NOT NULL,
    ctime public.u64 DEFAULT floor(date_part('epoch'::text, now())) NOT NULL
);
ALTER TABLE ONLY mq_fail.civitai_img
    ADD CONSTRAINT civitai_img_pkey PRIMARY KEY (id);
ALTER TABLE ONLY mq_fail."redistreamTest"
    ADD CONSTRAINT "redistreamTest_pkey" PRIMARY KEY (id);