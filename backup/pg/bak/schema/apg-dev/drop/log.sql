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
DROP TRIGGER IF EXISTS seen_click_fav_sum ON log.seen_click_fav;
ALTER TABLE IF EXISTS ONLY log.seen_click_fav DROP CONSTRAINT IF EXISTS seen_click_fav_pkey;
DROP TABLE IF EXISTS log.seen_click_fav_sum;
DROP TABLE IF EXISTS log.seen_click_fav;
DROP FUNCTION IF EXISTS log.seen_click_fav_sum();
DROP SCHEMA IF EXISTS log;
CREATE SCHEMA log;
SET search_path TO log;
CREATE OR REPLACE FUNCTION log.seen_click_fav_sum() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE log.seen_click_fav_sum
    SET seen = seen + NEW.seen,
        click = click + NEW.click,
        fav = fav + NEW.fav;
  ELSIF TG_OP = 'UPDATE' THEN
    UPDATE log.seen_click_fav_sum
    SET seen = seen - OLD.seen + NEW.seen,
        click = click - OLD.click + NEW.click,
        fav = fav - OLD.fav + NEW.fav;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE log.seen_click_fav_sum
    SET seen = seen - OLD.seen,
        click = click - OLD.click,
        fav = fav - OLD.fav;
  END IF;
  RETURN NEW;
END;
$$;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE log.seen_click_fav (
    cid public.u8 NOT NULL,
    rid public.u64 NOT NULL,
    seen public.u64 DEFAULT 0 NOT NULL,
    click public.u64 DEFAULT 0 NOT NULL,
    fav public.u64 DEFAULT 0 NOT NULL
);
CREATE TABLE log.seen_click_fav_sum (
    seen public.u64 DEFAULT 0 NOT NULL,
    click public.u64 DEFAULT 0 NOT NULL,
    fav public.u64 DEFAULT 0 NOT NULL
);
ALTER TABLE ONLY log.seen_click_fav
    ADD CONSTRAINT seen_click_fav_pkey PRIMARY KEY (cid, rid);
CREATE TRIGGER seen_click_fav_sum AFTER INSERT OR DELETE OR UPDATE ON log.seen_click_fav FOR EACH ROW EXECUTE FUNCTION log.seen_click_fav_sum();