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
DROP INDEX IF EXISTS fav.fav_user_user_id_ctime_idx;
ALTER TABLE IF EXISTS ONLY fav."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS ONLY fav."user" DROP CONSTRAINT IF EXISTS user_id_cid_rid_ctime;
DROP TABLE IF EXISTS fav."user";
DROP SEQUENCE IF EXISTS fav.user_id_seq;
DROP FUNCTION IF EXISTS fav.ym_count_by_user_id(_user_id integer);
DROP SCHEMA IF EXISTS fav;
CREATE SCHEMA fav;
SET search_path TO fav;
CREATE OR REPLACE FUNCTION fav.ym_count_by_user_id(_user_id integer) RETURNS TABLE(ym integer, n integer)
    LANGUAGE plpgsql
    AS $$
BEGIN 
  RETURN QUERY 
    SELECT 
      TO_CHAR(to_timestamp(cast(ctime/1000 as bigint)) AT TIME ZONE 'UTC','YYYYMM')::INTEGER AS ym, 
      COUNT(1)::INTEGER as n
    FROM 
      fav.user 
    WHERE 
      user_id=_user_id 
    GROUP BY 
      ym; 
END; 
$$;
CREATE SEQUENCE fav.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE fav."user" (
    id public.u64 DEFAULT nextval('fav.user_id_seq'::regclass) NOT NULL,
    uid public.u64 NOT NULL,
    cid public.u16 NOT NULL,
    rid public.u64 NOT NULL,
    ts public.u64 NOT NULL,
    aid public.i8 NOT NULL
);
ALTER TABLE ONLY fav."user"
    ADD CONSTRAINT user_id_cid_rid_ctime UNIQUE (uid, cid, rid, ts);
ALTER TABLE ONLY fav."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
CREATE INDEX IF NOT EXISTS fav_user_user_id_ctime_idx ON fav."user" USING btree (uid, ts);