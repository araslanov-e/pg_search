--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: articles_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION articles_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        begin
          new.tsv :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.body,'')), 'B');
          return new;
        end
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    title character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tsv tsvector
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: articles_tsv_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX articles_tsv_idx ON articles USING gin (tsv);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: tsvector_articles_upsert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvector_articles_upsert_trigger BEFORE INSERT OR UPDATE ON articles FOR EACH ROW EXECUTE PROCEDURE articles_trigger();


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20110426100122');

INSERT INTO schema_migrations (version) VALUES ('20110426102403');