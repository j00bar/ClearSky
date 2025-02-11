--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.6

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: clearskyprod_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO clearskyprod_user;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.api (
    key character(32) NOT NULL,
    date_added timestamp without time zone,
    valid boolean,
    owner text,
    owner_id text,
    environment text,
    first_name text,
    last_name text,
    invalid_date timestamp without time zone,
    access_type text
);


ALTER TABLE public.api OWNER TO clearskyprod_user;

--
-- Name: api_access; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.api_access (
    server boolean,
    ui boolean,
    uipush boolean,
    internalserver boolean,
    key text NOT NULL
);


ALTER TABLE public.api_access OWNER TO clearskyprod_user;

--
-- Name: blocklists; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.blocklists (
    user_did text,
    blocked_did text,
    block_date timestamp with time zone,
    cid text,
    uri text NOT NULL,
    touched timestamp with time zone,
    touched_actor text
);


ALTER TABLE public.blocklists OWNER TO clearskyprod_user;

--
-- Name: blocklists_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.blocklists_transaction (
    serial_id bigint NOT NULL,
    user_did text,
    blocked_did text,
    block_date timestamp with time zone,
    cid text,
    uri text NOT NULL,
    touched timestamp with time zone,
    touched_actor text,
    delete boolean
);


ALTER TABLE public.blocklists_transaction OWNER TO clearskyprod_user;

--
-- Name: blocklists_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.blocklists_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blocklists_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: blocklists_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.blocklists_transaction_serial_id_seq OWNED BY public.blocklists_transaction.serial_id;


--
-- Name: count_delete_queue; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.count_delete_queue (
    uri text NOT NULL,
    touched timestamp with time zone,
    touched_actor text
);


ALTER TABLE public.count_delete_queue OWNER TO clearskyprod_user;

--
-- Name: did_web_history; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.did_web_history (
    did text,
    handle text,
    pds text,
    "timestamp" timestamp with time zone,
    status boolean
);


ALTER TABLE public.did_web_history OWNER TO clearskyprod_user;

--
-- Name: labelers; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.labelers (
    did text NOT NULL,
    endpoint text,
    name text,
    created_date timestamp with time zone,
    description text,
    status boolean,
    active boolean
);


ALTER TABLE public.labelers OWNER TO clearskyprod_user;

--
-- Name: last_did_created_date; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.last_did_created_date (
    last_created timestamp with time zone NOT NULL
);


ALTER TABLE public.last_did_created_date OWNER TO clearskyprod_user;

--
-- Name: mutelists; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.mutelists (
    url text,
    uri text NOT NULL,
    did text,
    cid text NOT NULL,
    name text,
    created_date timestamp with time zone,
    description text,
    touched timestamp with time zone,
    touched_actor text
);


ALTER TABLE public.mutelists OWNER TO clearskyprod_user;

--
-- Name: mutelists_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.mutelists_transaction (
    url text,
    uri text NOT NULL,
    did text,
    cid text,
    name text,
    created_date timestamp with time zone,
    description text,
    touched timestamp with time zone,
    touched_actor text,
    serial_id bigint NOT NULL,
    update boolean,
    delete boolean
);


ALTER TABLE public.mutelists_transaction OWNER TO clearskyprod_user;

--
-- Name: mutelists_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.mutelists_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mutelists_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: mutelists_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.mutelists_transaction_serial_id_seq OWNED BY public.mutelists_transaction.serial_id;


--
-- Name: mutelists_user_count; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.mutelists_user_count (
    list_uri text NOT NULL,
    user_count integer,
    touched timestamp with time zone,
    touched_actor text
);


ALTER TABLE public.mutelists_user_count OWNER TO clearskyprod_user;

--
-- Name: mutelists_users; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.mutelists_users (
    list_uri text,
    cid text NOT NULL,
    subject_did text,
    date_added timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    listitem_uri text NOT NULL,
    owner_did text
);


ALTER TABLE public.mutelists_users OWNER TO clearskyprod_user;

--
-- Name: mutelists_users_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.mutelists_users_transaction (
    list_uri text,
    cid text,
    subject_did text,
    date_added timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    serial_id bigint NOT NULL,
    listitem_uri text NOT NULL,
    owner_did text,
    delete boolean
);


ALTER TABLE public.mutelists_users_transaction OWNER TO clearskyprod_user;

--
-- Name: mutelists_users_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.mutelists_users_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mutelists_users_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: mutelists_users_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.mutelists_users_transaction_serial_id_seq OWNED BY public.mutelists_users_transaction.serial_id;


--
-- Name: pds; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.pds (
    pds text NOT NULL,
    status boolean,
    last_status_code integer
);


ALTER TABLE public.pds OWNER TO clearskyprod_user;

--
-- Name: resolution_queue; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.resolution_queue (
    did text,
    serial_id bigint NOT NULL,
    "timestamp" timestamp without time zone,
    touched_actor text,
    touched timestamp without time zone
);


ALTER TABLE public.resolution_queue OWNER TO clearskyprod_user;

--
-- Name: resolution_queue_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.resolution_queue_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resolution_queue_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: resolution_queue_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.resolution_queue_serial_id_seq OWNED BY public.resolution_queue.serial_id;


--
-- Name: starter_packs; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.starter_packs (
    name text,
    uri text NOT NULL,
    description text,
    list_uri text,
    url text,
    did text,
    created_date timestamp with time zone
);


ALTER TABLE public.starter_packs OWNER TO clearskyprod_user;

--
-- Name: starter_packs_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.starter_packs_transaction (
    name text,
    uri text,
    list_uri text,
    description text,
    url text,
    did text,
    created_date timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    record_type text,
    update boolean,
    delete boolean,
    serial_id bigint NOT NULL
);


ALTER TABLE public.starter_packs_transaction OWNER TO clearskyprod_user;

--
-- Name: starter_packs_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.starter_packs_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.starter_packs_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: starter_packs_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.starter_packs_transaction_serial_id_seq OWNED BY public.starter_packs_transaction.serial_id;


--
-- Name: subscribe_blocklists; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.subscribe_blocklists (
    did text,
    uri text NOT NULL,
    list_uri text,
    cid text,
    date_added timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    record_type text
);


ALTER TABLE public.subscribe_blocklists OWNER TO clearskyprod_user;

--
-- Name: subscribe_blocklists_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.subscribe_blocklists_transaction (
    serial_id bigint NOT NULL,
    did text,
    uri text,
    list_uri text,
    cid text,
    date_added timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    record_type text,
    delete boolean
);


ALTER TABLE public.subscribe_blocklists_transaction OWNER TO clearskyprod_user;

--
-- Name: subscribe_blocklists_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.subscribe_blocklists_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscribe_blocklists_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: subscribe_blocklists_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.subscribe_blocklists_transaction_serial_id_seq OWNED BY public.subscribe_blocklists_transaction.serial_id;


--
-- Name: subscribe_blocklists_user_count; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.subscribe_blocklists_user_count (
    list_uri text NOT NULL,
    user_count integer,
    touched timestamp with time zone,
    touched_actor text
);


ALTER TABLE public.subscribe_blocklists_user_count OWNER TO clearskyprod_user;

--
-- Name: subscriptionstate; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.subscriptionstate (
    service character varying(255) NOT NULL,
    cursor bigint,
    touched timestamp with time zone,
    "timestamp" timestamp with time zone,
    response text
);


ALTER TABLE public.subscriptionstate OWNER TO clearskyprod_user;

--
-- Name: top_block; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.top_block (
    did text,
    count integer,
    list_type text
);


ALTER TABLE public.top_block OWNER TO clearskyprod_user;

--
-- Name: top_twentyfour_hour_block; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.top_twentyfour_hour_block (
    did text,
    count integer,
    list_type text
);


ALTER TABLE public.top_twentyfour_hour_block OWNER TO clearskyprod_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.users (
    did text NOT NULL,
    handle text,
    status boolean,
    pds text,
    created_date timestamp with time zone,
    valid boolean,
    reason text
);


ALTER TABLE public.users OWNER TO clearskyprod_user;

--
-- Name: users_transaction; Type: TABLE; Schema: public; Owner: clearskyprod_user
--

CREATE TABLE public.users_transaction (
    serial_id bigint NOT NULL,
    did text,
    handle text,
    "timestamp" timestamp with time zone,
    touched timestamp with time zone,
    touched_actor text,
    status boolean,
    reason text,
    event_type text
);


ALTER TABLE public.users_transaction OWNER TO clearskyprod_user;

--
-- Name: users_transaction_serial_id_seq; Type: SEQUENCE; Schema: public; Owner: clearskyprod_user
--

CREATE SEQUENCE public.users_transaction_serial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_transaction_serial_id_seq OWNER TO clearskyprod_user;

--
-- Name: users_transaction_serial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clearskyprod_user
--

ALTER SEQUENCE public.users_transaction_serial_id_seq OWNED BY public.users_transaction.serial_id;


--
-- Name: blocklists_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.blocklists_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.blocklists_transaction_serial_id_seq'::regclass);


--
-- Name: mutelists_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.mutelists_transaction_serial_id_seq'::regclass);


--
-- Name: mutelists_users_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_users_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.mutelists_users_transaction_serial_id_seq'::regclass);


--
-- Name: resolution_queue serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.resolution_queue ALTER COLUMN serial_id SET DEFAULT nextval('public.resolution_queue_serial_id_seq'::regclass);


--
-- Name: starter_packs_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.starter_packs_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.starter_packs_transaction_serial_id_seq'::regclass);


--
-- Name: subscribe_blocklists_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.subscribe_blocklists_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.subscribe_blocklists_transaction_serial_id_seq'::regclass);


--
-- Name: users_transaction serial_id; Type: DEFAULT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.users_transaction ALTER COLUMN serial_id SET DEFAULT nextval('public.users_transaction_serial_id_seq'::regclass);


--
-- Name: api_access api_access_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.api_access
    ADD CONSTRAINT api_access_pkey PRIMARY KEY (key);


--
-- Name: api api_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.api
    ADD CONSTRAINT api_pkey PRIMARY KEY (key);


--
-- Name: blocklists blocklists_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.blocklists
    ADD CONSTRAINT blocklists_pkey PRIMARY KEY (uri);


--
-- Name: blocklists_transaction blocklists_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.blocklists_transaction
    ADD CONSTRAINT blocklists_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: count_delete_queue count_delete_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.count_delete_queue
    ADD CONSTRAINT count_delete_queue_pkey PRIMARY KEY (uri);


--
-- Name: labelers labelers_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.labelers
    ADD CONSTRAINT labelers_pkey PRIMARY KEY (did);


--
-- Name: last_did_created_date last_did_created_date_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.last_did_created_date
    ADD CONSTRAINT last_did_created_date_pkey PRIMARY KEY (last_created);


--
-- Name: mutelists mutelists_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists
    ADD CONSTRAINT mutelists_pkey PRIMARY KEY (uri);


--
-- Name: mutelists_transaction mutelists_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_transaction
    ADD CONSTRAINT mutelists_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: mutelists_user_count mutelists_user_count_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_user_count
    ADD CONSTRAINT mutelists_user_count_pkey PRIMARY KEY (list_uri);


--
-- Name: mutelists_users mutelists_users_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_users
    ADD CONSTRAINT mutelists_users_pkey PRIMARY KEY (listitem_uri);


--
-- Name: mutelists_users_transaction mutelists_users_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.mutelists_users_transaction
    ADD CONSTRAINT mutelists_users_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: pds pds_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.pds
    ADD CONSTRAINT pds_pkey PRIMARY KEY (pds);


--
-- Name: resolution_queue resolution_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.resolution_queue
    ADD CONSTRAINT resolution_queue_pkey PRIMARY KEY (serial_id);


--
-- Name: starter_packs starter_packs_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.starter_packs
    ADD CONSTRAINT starter_packs_pkey PRIMARY KEY (uri);


--
-- Name: starter_packs_transaction starter_packs_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.starter_packs_transaction
    ADD CONSTRAINT starter_packs_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: subscribe_blocklists_user_count subscibe_blocklists_user_count_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.subscribe_blocklists_user_count
    ADD CONSTRAINT subscibe_blocklists_user_count_pkey PRIMARY KEY (list_uri);


--
-- Name: subscribe_blocklists subscribe_blocklists_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.subscribe_blocklists
    ADD CONSTRAINT subscribe_blocklists_pkey PRIMARY KEY (uri);


--
-- Name: subscribe_blocklists_transaction subscribe_blocklists_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.subscribe_blocklists_transaction
    ADD CONSTRAINT subscribe_blocklists_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: subscriptionstate subscriptionstate_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.subscriptionstate
    ADD CONSTRAINT subscriptionstate_pkey PRIMARY KEY (service);


--
-- Name: did_web_history unique_combination; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.did_web_history
    ADD CONSTRAINT unique_combination UNIQUE (did, handle, pds, "timestamp", status);


--
-- Name: top_block unique_did_list_type; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.top_block
    ADD CONSTRAINT unique_did_list_type UNIQUE (did, list_type);


--
-- Name: top_twentyfour_hour_block unique_did_list_type_24; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.top_twentyfour_hour_block
    ADD CONSTRAINT unique_did_list_type_24 UNIQUE (did, list_type);


--
-- Name: resolution_queue unique_record; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.resolution_queue
    ADD CONSTRAINT unique_record UNIQUE (did, "timestamp");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (did);


--
-- Name: users_transaction users_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: clearskyprod_user
--

ALTER TABLE ONLY public.users_transaction
    ADD CONSTRAINT users_transaction_pkey PRIMARY KEY (serial_id);


--
-- Name: blocklist_blocked_did; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX blocklist_blocked_did ON public.blocklists USING btree (blocked_did);


--
-- Name: idx_block_date; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_block_date ON public.blocklists USING btree (block_date);


--
-- Name: idx_blocklists_covering; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_blocklists_covering ON public.blocklists USING btree (user_did, blocked_did, block_date);


--
-- Name: idx_mutelists_users_did; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_mutelists_users_did ON public.mutelists_users USING btree (subject_did);


--
-- Name: idx_mutelists_users_list; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_mutelists_users_list ON public.mutelists_users USING btree (list_uri);


--
-- Name: idx_users_handle_fulltext; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_users_handle_fulltext ON public.users USING gin (handle public.gin_trgm_ops);


--
-- Name: idx_users_status; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_users_status ON public.users USING btree (status);


--
-- Name: idx_users_status_false; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_users_status_false ON public.users USING btree (status) WHERE (status = false);


--
-- Name: idx_users_status_true; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX idx_users_status_true ON public.users USING btree (status) WHERE (status = true);


--
-- Name: mutelists_did_idx; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX mutelists_did_idx ON public.mutelists USING btree (did);


--
-- Name: mutelists_users_owner_did_idx; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX mutelists_users_owner_did_idx ON public.mutelists_users USING btree (owner_did);


--
-- Name: subscribe_blocklists_did_idx; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX subscribe_blocklists_did_idx ON public.subscribe_blocklists USING btree (did);


--
-- Name: subscribe_blocklists_list_uri_idx; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX subscribe_blocklists_list_uri_idx ON public.subscribe_blocklists USING btree (list_uri);


--
-- Name: users_created_date_idx; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX users_created_date_idx ON public.users USING btree (created_date);


--
-- Name: users_did_idx1; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX users_did_idx1 ON public.users USING gist (did public.gist_trgm_ops);


--
-- Name: users_pds_index; Type: INDEX; Schema: public; Owner: clearskyprod_user
--

CREATE INDEX users_pds_index ON public.users USING btree (pds);


--
-- Name: FUNCTION gtrgm_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_in(cstring) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_out(public.gtrgm); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_out(public.gtrgm) TO clearskyprod_user;


--
-- Name: TYPE gtrgm; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.gtrgm TO clearskyprod_user;


--
-- Name: FUNCTION gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_extract_query_trgm(text, internal, smallint, internal, internal, internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gin_extract_value_trgm(text, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_extract_value_trgm(text, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_trgm_consistent(internal, smallint, text, integer, internal, internal, internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gin_trgm_triconsistent(internal, smallint, text, integer, internal, internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_compress(internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_consistent(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_consistent(internal, text, smallint, oid, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_decompress(internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_distance(internal, text, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_distance(internal, text, smallint, oid, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_options(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_options(internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_penalty(internal, internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_picksplit(internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_same(public.gtrgm, public.gtrgm, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_same(public.gtrgm, public.gtrgm, internal) TO clearskyprod_user;


--
-- Name: FUNCTION gtrgm_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gtrgm_union(internal, internal) TO clearskyprod_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO clearskyprod_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO clearskyprod_user;


--
-- Name: FUNCTION set_limit(real); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_limit(real) TO clearskyprod_user;


--
-- Name: FUNCTION show_limit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_limit() TO clearskyprod_user;


--
-- Name: FUNCTION show_trgm(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_trgm(text) TO clearskyprod_user;


--
-- Name: FUNCTION similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION similarity_dist(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity_dist(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.similarity_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION strict_word_similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION strict_word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_commutator_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION strict_word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_commutator_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION strict_word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_dist_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION strict_word_similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.strict_word_similarity_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION word_similarity(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION word_similarity_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_commutator_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION word_similarity_dist_commutator_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_dist_commutator_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION word_similarity_dist_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_dist_op(text, text) TO clearskyprod_user;


--
-- Name: FUNCTION word_similarity_op(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.word_similarity_op(text, text) TO clearskyprod_user;


--
-- Name: TABLE pg_stat_database; Type: ACL; Schema: pg_catalog; Owner: postgres
--

GRANT SELECT ON TABLE pg_catalog.pg_stat_database TO datadog;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO clearskyprod_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO clearskyprod_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO clearskyprod_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO clearskyprod_user;


--
-- PostgreSQL database dump complete
--

�