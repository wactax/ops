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
DROP TRIGGER IF EXISTS trigger_civitai_img ON bot.civitai_img;
DROP INDEX IF EXISTS bot."task.hash";
DROP INDEX IF EXISTS bot."task.cid.rid";
DROP INDEX IF EXISTS bot."meta.hash";
DROP INDEX IF EXISTS bot."civitai_img.url";
ALTER TABLE IF EXISTS ONLY bot.task DROP CONSTRAINT IF EXISTS task_pkey;
ALTER TABLE IF EXISTS ONLY bot.meta DROP CONSTRAINT IF EXISTS meta_pkey;
ALTER TABLE IF EXISTS ONLY bot.meta DROP CONSTRAINT IF EXISTS meta_hash_key;
ALTER TABLE IF EXISTS ONLY bot.civitai_user DROP CONSTRAINT IF EXISTS civitai_user_pkey;
ALTER TABLE IF EXISTS ONLY bot.civitai_post DROP CONSTRAINT IF EXISTS civitai_review_pkey;
ALTER TABLE IF EXISTS ONLY bot.civitai_img DROP CONSTRAINT IF EXISTS civitai_img_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult DROP CONSTRAINT IF EXISTS adult_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult_mc DROP CONSTRAINT IF EXISTS adult_mc_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult_hw DROP CONSTRAINT IF EXISTS adult_hw_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult_google DROP CONSTRAINT IF EXISTS adult_google_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult_deepai DROP CONSTRAINT IF EXISTS adult_deepai_pkey;
ALTER TABLE IF EXISTS ONLY bot.adult_baidu DROP CONSTRAINT IF EXISTS adult_baidu_pkey;
ALTER TABLE IF EXISTS bot.task ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS bot.meta ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS bot.task_id_seq;
DROP TABLE IF EXISTS bot.task;
DROP SEQUENCE IF EXISTS bot.meta_id_seq;
DROP TABLE IF EXISTS bot.meta;
DROP TABLE IF EXISTS bot.civitai_user;
DROP TABLE IF EXISTS bot.civitai_post;
DROP TABLE IF EXISTS bot.civitai_img;
DROP SEQUENCE IF EXISTS bot.civitai_img_id_seq;
DROP TABLE IF EXISTS bot.adult_mc;
DROP TABLE IF EXISTS bot.adult_hw;
DROP TABLE IF EXISTS bot.adult_google;
DROP TABLE IF EXISTS bot.adult_deepai;
DROP TABLE IF EXISTS bot.adult_baidu;
DROP TABLE IF EXISTS bot.adult;
DROP FUNCTION IF EXISTS bot.trigger_civitai_img();
DROP SCHEMA IF EXISTS bot;
CREATE SCHEMA bot;
SET search_path TO bot;
CREATE OR REPLACE FUNCTION bot.trigger_civitai_img() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO bot.task (cid, rid, priority) VALUES (1, NEW.id, round(log(1.3,4+NEW.star))-5)
        ON CONFLICT (cid, rid) DO NOTHING;
ELSIF (TG_OP = 'DELETE') THEN
        DELETE FROM bot.task WHERE rid = OLD.id AND cid = 1;
END IF;
RETURN NULL;
END;
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE bot.adult (
    id public.u64 NOT NULL,
    baidu public.i8 DEFAULT '-1'::integer NOT NULL,
    hw public.i8 DEFAULT '-1'::integer NOT NULL,
    pd public.i8 DEFAULT '-1'::integer NOT NULL,
    nudenet public.i8 DEFAULT '-1'::integer NOT NULL,
    nsfwjs public.i8 DEFAULT '-1'::integer NOT NULL,
    mc public.i8 DEFAULT '-1'::integer NOT NULL
);
CREATE TABLE bot.adult_baidu (
    id public.u64 NOT NULL,
    sexy public.u8 NOT NULL,
    porn public.u8 NOT NULL,
    kind public.u8[] NOT NULL,
    kind_p public.u8[] NOT NULL
);
CREATE TABLE bot.adult_deepai (
    id public.u64 NOT NULL,
    score public.u8 NOT NULL,
    detect json NOT NULL
);
CREATE TABLE bot.adult_google (
    id public.u64 NOT NULL,
    tag public.u64[] NOT NULL,
    tag_score public.u8[] NOT NULL,
    medical public.u8 NOT NULL,
    violence public.u8 NOT NULL,
    adult public.u8 NOT NULL,
    racy public.u8 NOT NULL,
    spoof public.u8 NOT NULL
);
CREATE TABLE bot.adult_hw (
    id public.u64 NOT NULL,
    terrorism public.u8[] NOT NULL,
    sexy public.u8 NOT NULL,
    porn public.u8 NOT NULL,
    politics json
);
CREATE TABLE bot.adult_mc (
    id public.u64 NOT NULL,
    adult public.u8 NOT NULL,
    everyone public.u8 NOT NULL,
    teen public.u8 NOT NULL
);
COMMENT ON TABLE bot.adult_mc IS 'moderatecontent.com';
CREATE SEQUENCE bot.civitai_img_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE bot.civitai_img (
    id public.u64 DEFAULT nextval('bot.civitai_img_id_seq'::regclass) NOT NULL,
    post_id public.u64 NOT NULL,
    sampler_id public.u32 NOT NULL,
    w public.u32 NOT NULL,
    h public.u32 NOT NULL,
    gen_w public.u32 NOT NULL,
    gen_h public.u32 NOT NULL,
    step public.u16 NOT NULL,
    prompt_id public.u64,
    nprompt_id public.u64,
    meta_id public.u64,
    genway_id public.u32,
    laugh public.u64 NOT NULL,
    star public.u64 NOT NULL,
    hate public.u64 NOT NULL,
    cry public.u64 NOT NULL,
    seed public.u64,
    url public.md5hash,
    res_file_id_li public.u64[] DEFAULT '{}'::public.u64[] NOT NULL,
    miss public.u64[] DEFAULT '{}'::public.u64[] NOT NULL,
    user_id public.u64 DEFAULT 0 NOT NULL,
    "time" public.u64 DEFAULT (date_part('epoch'::text, now()))::bigint NOT NULL,
    rid public.u64 DEFAULT 0 NOT NULL,
    cfg public.u16 DEFAULT 0 NOT NULL
);
CREATE TABLE bot.civitai_post (
    id public.u64 NOT NULL,
    model_id public.u64 NOT NULL,
    user_id public.u64 NOT NULL,
    "time" public.u64 NOT NULL,
    txt text NOT NULL,
    rating public.u8 NOT NULL
);
CREATE TABLE bot.civitai_user (
    id bigint NOT NULL,
    val text NOT NULL
);
CREATE TABLE bot.meta (
    id bigint NOT NULL,
    val text NOT NULL,
    hash public.md5hash
);
CREATE SEQUENCE bot.meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE bot.meta_id_seq OWNED BY bot.meta.id;
CREATE TABLE bot.task (
    id public.u64 NOT NULL,
    hash public.md5hash,
    cid public.u8 NOT NULL,
    rid public.u64 NOT NULL,
    priority public.u8 DEFAULT 0,
    face public.u64 DEFAULT 0,
    qdrant public.u64 DEFAULT 0,
    adult public.i8 DEFAULT '-1'::integer NOT NULL,
    "time" public.u64 DEFAULT (date_part('epoch'::text, now()))::bigint NOT NULL,
    iaa public.i8 DEFAULT '-1'::integer NOT NULL
);
COMMENT ON TABLE bot.task IS 'null 是 完成， 0 是未开始， 有值为开始时间，timeout之后会重试，并增加err，err>10 就放弃重试。成功会将err清空。当update的时候，如果err没有变化，会推送给订阅者实现实时触发。';
CREATE SEQUENCE bot.task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE bot.task_id_seq OWNED BY bot.task.id;
ALTER TABLE ONLY bot.meta ALTER COLUMN id SET DEFAULT nextval('bot.meta_id_seq'::regclass);
ALTER TABLE ONLY bot.task ALTER COLUMN id SET DEFAULT nextval('bot.task_id_seq'::regclass);
ALTER TABLE ONLY bot.adult_baidu
    ADD CONSTRAINT adult_baidu_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.adult_deepai
    ADD CONSTRAINT adult_deepai_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.adult_google
    ADD CONSTRAINT adult_google_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.adult_hw
    ADD CONSTRAINT adult_hw_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.adult_mc
    ADD CONSTRAINT adult_mc_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.adult
    ADD CONSTRAINT adult_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.civitai_img
    ADD CONSTRAINT civitai_img_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.civitai_post
    ADD CONSTRAINT civitai_review_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.civitai_user
    ADD CONSTRAINT civitai_user_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.meta
    ADD CONSTRAINT meta_hash_key UNIQUE (hash);
ALTER TABLE ONLY bot.meta
    ADD CONSTRAINT meta_pkey PRIMARY KEY (id);
ALTER TABLE ONLY bot.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX "civitai_img.url" ON bot.civitai_img USING btree (url);
CREATE UNIQUE INDEX "meta.hash" ON bot.meta USING btree (hash);
CREATE UNIQUE INDEX "task.cid.rid" ON bot.task USING btree (cid, rid);
CREATE INDEX IF NOT EXISTS "task.hash" ON bot.task USING btree (hash);
CREATE TRIGGER trigger_civitai_img AFTER INSERT OR DELETE ON bot.civitai_img FOR EACH ROW EXECUTE FUNCTION bot.trigger_civitai_img();