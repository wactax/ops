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
CREATE SCHEMA public;
SET search_path TO public;
COMMENT ON SCHEMA public IS 'standard public schema';
CREATE OR REPLACE FUNCTION public.client_new(client_id public.u64, ip bytea, browser_name character varying, browser_ver public.u32, os_name character varying, os_ver public.u32, device_vendor character varying, device_model character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  now u64;
browser_id u32;
os_id u32;
device_id u32;
BEGIN
  IF browser_name != '' THEN
    SELECT id INTO browser_id
    FROM browser
    WHERE name = browser_name
      AND ver = browser_ver;
IF browser_id IS NULL THEN
      INSERT INTO browser (name, ver)
        VALUES (browser_name, browser_ver)
      ON CONFLICT (name, ver)
        DO NOTHING
      RETURNING id INTO browser_id;
END IF;
ELSE
    browser_id = 0;
END IF;
IF os_name != '' THEN
    WITH e AS (
INSERT INTO os (name, ver)
        VALUES (os_name, os_ver)
      ON CONFLICT (name, ver)
        DO NOTHING
      RETURNING id)
      SELECT id INTO os_id
      FROM e
      UNION
      SELECT id
      FROM os
      WHERE name = os_name
          AND ver = os_ver;
ELSE
    os_id = 0;
END IF;
IF device_vendor != '' THEN
    WITH e AS (
INSERT INTO device (vendor, model)
        VALUES (device_vendor, device_model)
      ON CONFLICT (vendor, model)
        DO NOTHING
      RETURNING id)
      SELECT id INTO device_id
      FROM e
      UNION
      SELECT id
      FROM device
      WHERE vendor = device_vendor
          AND model = device_model;
ELSE
    device_id = 0;
END IF;
now = ceil(date_part('epoch'::text, now()));
INSERT INTO client_ip (client_id, ip, ctime)
    VALUES (client_id, ip, now)
  ON CONFLICT
    DO NOTHING;
INSERT INTO client_meta (client_id, os_id, browser_id, device_id, ctime)
    VALUES (client_id, os_id, browser_id, device_id, now);
END;
$$;
CREATE OR REPLACE FUNCTION public.drop_func(_name text, OUT functions_dropped integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  _sql text;
BEGIN
  SELECT count(*)::int, 'drop function ' || string_agg(oid::regprocedure::text, ';
drop function ')
  FROM pg_catalog.pg_proc
  WHERE proname = _name
    AND pg_function_is_visible(oid) -- restrict to current search_path
    INTO functions_dropped, _sql;
IF functions_dropped > 0 THEN
    -- only if function(s) found
    EXECUTE _sql;
END IF;
END
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.browser (
    id public.u32 NOT NULL,
    name character varying(255) NOT NULL,
    ver public.u32 NOT NULL
);
CREATE SEQUENCE public.browser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.browser_id_seq OWNED BY public.browser.id;
CREATE TABLE public.client_ip (
    id public.u64 NOT NULL,
    client_id public.u64 NOT NULL,
    ip bytea NOT NULL,
    ctime public.u64 DEFAULT ceil(date_part('epoch'::text, now())) NOT NULL
);
CREATE SEQUENCE public.client_ip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.client_ip_id_seq OWNED BY public.client_ip.id;
CREATE TABLE public.client_meta (
    id public.u64 NOT NULL,
    device_id public.u32 NOT NULL,
    browser_id public.u32 NOT NULL,
    os_id public.u32 NOT NULL,
    client_id public.u64 NOT NULL,
    ctime public.u64 DEFAULT ceil(date_part('epoch'::text, now())) NOT NULL
);
CREATE SEQUENCE public.client_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.client_meta_id_seq OWNED BY public.client_meta.id;
CREATE SEQUENCE public.device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.device (
    id public.u32 DEFAULT nextval('public.device_id_seq'::regclass) NOT NULL,
    vendor character varying(255) NOT NULL,
    model character varying(255) NOT NULL
);
CREATE TABLE public.os (
    id public.u64 NOT NULL,
    name character varying(255) NOT NULL,
    ver public.u32 NOT NULL
);
CREATE SEQUENCE public.os_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.os_id_seq OWNED BY public.os.id;
ALTER TABLE ONLY public.browser ALTER COLUMN id SET DEFAULT nextval('public.browser_id_seq'::regclass);
ALTER TABLE ONLY public.client_ip ALTER COLUMN id SET DEFAULT nextval('public.client_ip_id_seq'::regclass);
ALTER TABLE ONLY public.client_meta ALTER COLUMN id SET DEFAULT nextval('public.client_meta_id_seq'::regclass);
ALTER TABLE ONLY public.os ALTER COLUMN id SET DEFAULT nextval('public.os_id_seq'::regclass);
ALTER TABLE ONLY public.browser
    ADD CONSTRAINT "browser.name.ver" UNIQUE (name, ver);
ALTER TABLE ONLY public.browser
    ADD CONSTRAINT browser_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.client_ip
    ADD CONSTRAINT "client_ip.ctime" UNIQUE (ip, ctime);
ALTER TABLE ONLY public.client_ip
    ADD CONSTRAINT client_ip_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.client_meta
    ADD CONSTRAINT client_meta_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.device
    ADD CONSTRAINT "device.vendor.model" UNIQUE (vendor, model);
ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_model_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.os
    ADD CONSTRAINT "os.name.ver" UNIQUE (name, ver);
ALTER TABLE ONLY public.os
    ADD CONSTRAINT os_pkey PRIMARY KEY (id);