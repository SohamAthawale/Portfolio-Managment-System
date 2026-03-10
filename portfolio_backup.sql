--
-- PostgreSQL database dump
--

\restrict 0oVS1mahNqC7rbTAbvyQhcfnL2MkeLhmFJdbPhsSubEM3UQeKArJiUlHYUCw4QX

-- Dumped from database version 17.7 (Homebrew)
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: assign_service_request_id(); Type: FUNCTION; Schema: public; Owner: sohamathawale
--

CREATE FUNCTION public.assign_service_request_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    next_no INTEGER;
BEGIN
    SELECT COALESCE(MAX(request_id), 0) + 1
    INTO next_no
    FROM service_requests
    WHERE user_id = NEW.user_id;

    NEW.request_id = next_no;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.assign_service_request_id() OWNER TO sohamathawale;

--
-- Name: create_family_for_user(); Type: FUNCTION; Schema: public; Owner: sohamathawale
--

CREATE FUNCTION public.create_family_for_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_family_id BIGINT;
BEGIN
    -- Create a new family record and assign its ID to the new user
    INSERT INTO families (family_name, created_at)
    VALUES (NEW.email || '''s Family', NOW())
    RETURNING family_id INTO new_family_id;

    NEW.family_id := new_family_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.create_family_for_user() OWNER TO sohamathawale;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: families; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.families (
    family_id bigint NOT NULL,
    family_name character varying(255),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.families OWNER TO sohamathawale;

--
-- Name: families_family_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.families ALTER COLUMN family_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.families_family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: family_members; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.family_members (
    family_id bigint,
    name character varying(255),
    email character varying(255),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    member_id integer NOT NULL
);


ALTER TABLE public.family_members OWNER TO sohamathawale;

--
-- Name: family_members_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

CREATE SEQUENCE public.family_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.family_members_id_seq OWNER TO sohamathawale;

--
-- Name: family_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sohamathawale
--

ALTER SEQUENCE public.family_members_id_seq OWNED BY public.family_members.id;


--
-- Name: historic_returns; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.historic_returns (
    isin character varying(20) NOT NULL,
    return_1y numeric(8,4),
    return_3y numeric(8,4),
    return_5y numeric(8,4),
    return_10y numeric(8,4),
    currency character varying(10),
    as_of_date date,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.historic_returns OWNER TO sohamathawale;

--
-- Name: login_otps; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.login_otps (
    id integer NOT NULL,
    user_id integer,
    otp_code text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.login_otps OWNER TO sohamathawale;

--
-- Name: login_otps_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

CREATE SEQUENCE public.login_otps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_otps_id_seq OWNER TO sohamathawale;

--
-- Name: login_otps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sohamathawale
--

ALTER SEQUENCE public.login_otps_id_seq OWNED BY public.login_otps.id;


--
-- Name: pending_registrations; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.pending_registrations (
    id integer NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.pending_registrations OWNER TO sohamathawale;

--
-- Name: pending_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

CREATE SEQUENCE public.pending_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pending_registrations_id_seq OWNER TO sohamathawale;

--
-- Name: pending_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sohamathawale
--

ALTER SEQUENCE public.pending_registrations_id_seq OWNED BY public.pending_registrations.id;


--
-- Name: portfolio_duplicates; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.portfolio_duplicates (
    id integer NOT NULL,
    portfolio_id integer NOT NULL,
    user_id integer NOT NULL,
    member_id integer,
    isin_no text,
    fund_name text,
    units numeric,
    nav numeric,
    valuation numeric,
    file_type text,
    source_file text,
    created_at timestamp without time zone DEFAULT now(),
    resolved boolean DEFAULT false,
    resolved_at timestamp without time zone,
    linked_portfolio_entry_id bigint,
    invested_amount numeric,
    type text,
    category text,
    sub_category text
);


ALTER TABLE public.portfolio_duplicates OWNER TO sohamathawale;

--
-- Name: portfolio_duplicates_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

CREATE SEQUENCE public.portfolio_duplicates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.portfolio_duplicates_id_seq OWNER TO sohamathawale;

--
-- Name: portfolio_duplicates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sohamathawale
--

ALTER SEQUENCE public.portfolio_duplicates_id_seq OWNED BY public.portfolio_duplicates.id;


--
-- Name: portfolios; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.portfolios (
    id bigint NOT NULL,
    portfolio_id bigint,
    user_id bigint,
    member_id bigint,
    valuation numeric(20,2),
    fund_name character varying(255),
    booking_date date,
    isin_no character varying(100),
    transaction_no character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    type character varying(100),
    units numeric,
    invested_amount numeric,
    nav numeric,
    category character varying(100),
    sub_category character varying(100)
);


ALTER TABLE public.portfolios OWNER TO sohamathawale;

--
-- Name: portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.portfolios ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.roles (
    role_id bigint NOT NULL,
    role_name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO sohamathawale;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.roles ALTER COLUMN role_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: service_requests; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.service_requests (
    id bigint NOT NULL,
    request_id integer NOT NULL,
    user_id bigint NOT NULL,
    request_type character varying(150) NOT NULL,
    description text,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    member_id integer,
    admin_description text
);


ALTER TABLE public.service_requests OWNER TO sohamathawale;

--
-- Name: service_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.service_requests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.service_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.user_roles (
    user_role_id bigint NOT NULL,
    user_id bigint,
    role_id bigint,
    scope character varying(255)
);


ALTER TABLE public.user_roles OWNER TO sohamathawale;

--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.user_roles ALTER COLUMN user_role_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_roles_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: sohamathawale
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    family_id bigint,
    email character varying(255),
    phone character varying(50),
    password_hash character varying(255),
    otp character varying(50),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO sohamathawale;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: sohamathawale
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: family_members id; Type: DEFAULT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.family_members ALTER COLUMN id SET DEFAULT nextval('public.family_members_id_seq'::regclass);


--
-- Name: login_otps id; Type: DEFAULT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.login_otps ALTER COLUMN id SET DEFAULT nextval('public.login_otps_id_seq'::regclass);


--
-- Name: pending_registrations id; Type: DEFAULT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.pending_registrations ALTER COLUMN id SET DEFAULT nextval('public.pending_registrations_id_seq'::regclass);


--
-- Name: portfolio_duplicates id; Type: DEFAULT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.portfolio_duplicates ALTER COLUMN id SET DEFAULT nextval('public.portfolio_duplicates_id_seq'::regclass);


--
-- Data for Name: families; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.families (family_id, family_name, created_at) FROM stdin;
1	sohamathawale2003@gmail.com's Family	2026-02-09 15:18:08.457843
2	asoham60@gmail.com's Family	2026-02-09 15:18:36.252672
\.


--
-- Data for Name: family_members; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.family_members (family_id, name, email, phone, created_at, id, member_id) FROM stdin;
\.


--
-- Data for Name: historic_returns; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.historic_returns (isin, return_1y, return_3y, return_5y, return_10y, currency, as_of_date, updated_at) FROM stdin;
INF966L01DF3	-1.4773	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:51:46.482978
INF789F01513	1.0597	11.4467	9.9339	12.3856	CU$$$$$INR	\N	2026-01-29 14:26:46.716297
INF192K01BZ0	5.5069	17.1702	15.8557	13.0251	CU$$$$$INR	\N	2026-01-29 14:26:48.55167
INF179KC1BQ9	2.5066	18.2230	\N	\N	CU$$$$$INR	\N	2026-01-29 14:30:31.3611
INF846K01CH7	2.4863	11.3125	7.8956	11.9735	CU$$$$$INR	\N	2026-01-29 14:30:38.329316
INF200K01222	5.4895	13.9557	14.2716	12.8980	CU$$$$$INR	\N	2026-01-29 14:30:52.461958
INF277KA1CR8	-1.8730	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 14:31:04.750973
INF109KC19S9	10.8108	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 14:31:09.350035
INF179KC1HF9	-5.4400	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 14:31:14.074338
INF084M01AT0	12.5845	15.5493	10.0056	11.3416	CU$$$$$INR	\N	2026-01-29 14:31:18.416646
INF966L01341	-1.9744	15.1736	18.7586	15.8313	CU$$$$$INR	\N	2026-01-29 14:31:22.873876
INF247L01AC1	2.5912	18.5516	16.8337	\N	CU$$$$$INR	\N	2026-01-30 12:37:41.341786
INF179K01WQ2	3.1823	26.1238	28.2920	12.4132	CU$$$$$INR	\N	2026-01-30 12:37:43.987939
INF200K01RY0	13.0633	15.0718	14.3300	13.2404	CU$$$$$INR	\N	2026-01-30 12:37:46.53335
INF200K01QX4	10.4942	15.6106	15.5893	13.9311	CU$$$$$INR	\N	2026-01-30 12:37:49.295751
INF247L01502	-4.8216	22.7034	16.0321	14.1204	CU$$$$$INR	\N	2026-01-30 12:37:52.021929
INF200K01RJ1	16.6223	19.3352	17.8214	16.2507	CU$$$$$INR	\N	2026-01-29 13:51:48.323024
INF200K01RS2	-0.0826	22.3135	24.5499	16.7043	CU$$$$$INR	\N	2026-01-29 13:51:49.912874
INF200KA1Y73	10.9343	15.5606	\N	\N	CU$$$$$INR	\N	2026-01-29 13:51:52.316346
INF846K01859	1.0001	19.3874	17.7163	16.2704	CU$$$$$INR	\N	2026-01-29 14:30:45.399054
INF846K01J46	5.2467	20.9705	19.1345	\N	CU$$$$$INR	\N	2026-01-29 13:51:54.157487
INF179K01VK7	12.0495	22.6673	25.7039	15.7670	CU$$$$$INR	\N	2026-01-29 13:51:56.618504
INF194K01X46	-5.7621	26.4619	28.2785	17.1651	CU$$$$$INR	\N	2026-01-29 13:51:58.461186
INF846K01X30	25.6948	22.1703	15.2962	\N	CU$$$$$INR	\N	2026-01-29 14:31:00.752758
INF200K01UY4	12.4262	29.7905	30.6996	15.0419	CU$$$$$INR	\N	2026-01-29 13:52:00.919494
INF204K01F20	6.1569	21.8410	20.1418	14.1968	CU$$$$$INR	\N	2026-01-29 13:52:03.37406
INF200K01VS4	1.5449	18.1308	18.3224	17.2470	CU$$$$$INR	\N	2026-01-29 14:31:06.900869
INF769K01JJ2	10.4402	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:05.52637
INF200K01RA0	7.0202	21.4400	25.1711	17.5619	CU$$$$$INR	\N	2026-01-29 13:52:07.403593
INF740KA1LG1	-4.5516	23.0254	16.8478	\N	CU$$$$$INR	\N	2026-01-29 13:52:08.96582
INF200KA14W3	7.0392	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:10.772614
INF200KA1515	21.6614	20.8352	18.1203	18.6843	CU$$$$$INR	\N	2026-01-29 13:52:12.006363
INF846K01131	4.3866	14.3427	10.3845	12.2585	CU$$$$$INR	\N	2026-01-29 14:31:11.810813
INF200K01RK9	-5.3138	15.5856	19.4778	16.2255	CU$$$$$INR	\N	2026-01-29 13:52:14.741723
INF966L01CJ7	-4.6747	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:16.014166
INF846K01164	6.2746	12.3862	10.0692	12.5116	CU$$$$$INR	\N	2026-01-29 14:31:16.115423
INF200KB1126	5.8986	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:18.12221
INF109K012K1	14.3607	22.1483	24.0185	16.7453	CU$$$$$INR	\N	2026-01-29 13:52:20.577321
INF179KC1II1	8.1699	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 14:31:20.382472
INF966L01BX0	26.5048	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:23.034304
INF200K01SC4	8.0568	15.2163	14.5844	13.6530	CU$$$$$INR	\N	2026-01-29 13:52:25.029334
INF179K01XZ1	6.6025	12.8153	14.7594	13.2088	CU$$$$$INR	\N	2026-01-29 14:31:25.32691
INF194KB1AL4	0.1220	31.3335	27.4174	\N	CU$$$$$INR	\N	2026-01-29 13:52:26.748376
INF966L01721	-2.5573	18.0840	28.4597	19.8235	CU$$$$$INR	\N	2026-01-29 13:52:28.419669
INF200KA18E2	3.8343	17.6997	\N	\N	CU$$$$$INR	\N	2026-01-30 12:37:42.584109
INF174K01LS2	10.4173	17.5919	16.8830	15.4531	CU$$$$$INR	\N	2026-01-29 13:52:30.135873
INF769K01FA9	10.0141	21.8417	23.6672	\N	CU$$$$$INR	\N	2026-01-29 13:52:32.252214
INF200KA1Y81	10.9340	15.5592	\N	\N	CU$$$$$INR	\N	2026-01-30 12:37:45.278919
INF200K01T51	-4.0849	15.0222	19.9179	18.4238	CU$$$$$INR	\N	2026-01-29 13:52:34.709368
INF200KB1183	22.1433	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:36.573757
INF200KA1507	21.6615	20.8363	18.1218	18.6783	CU$$$$$INR	\N	2026-01-29 13:52:38.701482
INF200K01SZ5	7.5131	7.5905	6.2848	7.0063	CU$$$$$INR	\N	2026-01-30 12:37:47.795347
INF966L01689	-1.3613	21.7228	30.9116	20.0503	CU$$$$$INR	\N	2026-01-29 13:52:41.163136
INF200KB1324	-1.0835	\N	\N	\N	CU$$$$$INR	\N	2026-01-29 13:52:43.621453
INF200K01TP4	1.2031	18.5704	21.6314	15.4498	CU$$$$$INR	\N	2026-01-30 12:37:50.611
INF200K01T69	-4.0849	15.0230	19.9185	18.4241	CU$$$$$INR	\N	2026-01-29 13:52:46.078424
INF200KA1W00	2.5642	18.4761	\N	\N	CU$$$$$INR	\N	2026-01-30 12:37:53.193283
\.


--
-- Data for Name: login_otps; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.login_otps (id, user_id, otp_code, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: pending_registrations; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.pending_registrations (id, email, phone, password_hash, created_at) FROM stdin;
\.


--
-- Data for Name: portfolio_duplicates; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.portfolio_duplicates (id, portfolio_id, user_id, member_id, isin_no, fund_name, units, nav, valuation, file_type, source_file, created_at, resolved, resolved_at, linked_portfolio_entry_id, invested_amount, type, category, sub_category) FROM stdin;
1	6	2	\N	INF194KB1AL4	D340 - Bandhan Small Cap Fund- Direct Plan-Growth	94.445	45.308	4279.11	ecas_cdsl	portfolio_6_2_portfolio_2_ECAS_soham.pdf	2026-02-05 16:38:51.134914	f	\N	\N	4490.41	mutual fund	Equity	Small Cap
3	6	2	\N	INF789F01513	EQGP - UTI Flexi Cap Fund - Regular Plan	139.344	311.0724	43346.07	ecas_cdsl	portfolio_6_2_portfolio_2_ECAS_soham.pdf	2026-02-05 16:38:51.134914	f	\N	\N	33282.0	mutual fund	Equity	Flexi Cap
4	6	2	\N	INE758T01015	ETERNAL LIMITED # EQUITY SHARES	5.0	232.5	1162.5	ecas_cdsl	portfolio_6_2_portfolio_2_ECAS_soham.pdf	2026-02-05 16:38:51.134914	f	\N	\N	0.0	equity	Shares	Shares
2	6	2	\N	INF192K01BZ0	EFDG - JM Large Cap Fund - (Direct) - Growth Option	89.943	166.06	14935.93	ecas_cdsl	portfolio_6_2_portfolio_2_ECAS_soham.pdf	2026-02-05 16:38:51.134914	t	2026-02-05 16:38:58.60088	154	15000.0	mutual fund	Equity	Large Cap
\.


--
-- Data for Name: portfolios; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.portfolios (id, portfolio_id, user_id, member_id, valuation, fund_name, booking_date, isin_no, transaction_no, created_at, type, units, invested_amount, nav, category, sub_category) FROM stdin;
1	1	2	\N	6531.31	D340 - Bandhan Small Cap Fund- Direct Plan-Growth	\N	INF194KB1AL4	\N	2026-02-09 15:19:24.652578	mutual fund	124.2	6046.91	52.587	Equity	Small Cap
2	1	2	\N	13101.83	EFDG - JM Large Cap Fund - (Direct) - Growth Option	\N	INF192K01BZ0	\N	2026-02-09 15:19:24.652578	mutual fund	72.387	12072.13	180.997	Equity	Large Cap
3	1	2	\N	45819.09	EQGP - UTI Flexi Cap Fund - Regular Plan	\N	INF789F01513	\N	2026-02-09 15:19:24.652578	mutual fund	139.344	33283.0	328.82	Equity	Flexi Cap
4	1	2	\N	1588.75	ETERNAL LIMITED # EQUITY SHARES	\N	INE758T01015	\N	2026-02-09 15:19:24.652578	equity	5.0	0.0	317.75	Shares	Shares
5	2	2	\N	7386.54	D340 - Bandhan Small Cap Fund- Direct Plan-Growth	\N	INF194KB1AL4	\N	2026-02-09 15:19:38.104095	mutual fund	143.225	7046.91	51.573	Equity	Small Cap
6	2	2	\N	13317.37	EFDG - JM Large Cap Fund - (Direct) - Growth Option	\N	INF192K01BZ0	\N	2026-02-09 15:19:38.104095	mutual fund	72.387	12072.13	183.9746	Equity	Large Cap
7	2	2	\N	45693.71	EQGP - UTI Flexi Cap Fund - Regular Plan	\N	INF789F01513	\N	2026-02-09 15:19:38.104095	mutual fund	139.344	33283.0	327.9202	Equity	Flexi Cap
8	2	2	\N	1500.75	ETERNAL LIMITED # EQUITY SHARES	\N	INE758T01015	\N	2026-02-09 15:19:38.104095	equity	5.0	0.0	300.15	Shares	Shares
9	3	2	\N	7794.56	D340 - Bandhan Small Cap Fund- Direct Plan-Growth	\N	INF194KB1AL4	\N	2026-02-09 15:19:56.418086	mutual fund	153.192	7546.91	50.881	Equity	Small Cap
10	3	2	\N	13309.17	EFDG - JM Large Cap Fund - (Direct) - Growth Option	\N	INF192K01BZ0	\N	2026-02-09 15:19:56.418086	mutual fund	72.387	12072.13	183.8613	Equity	Large Cap
11	3	2	\N	44838.47	EQGP - UTI Flexi Cap Fund - Regular Plan	\N	INF789F01513	\N	2026-02-09 15:19:56.418086	mutual fund	139.344	33283.0	321.7826	Equity	Flexi Cap
12	3	2	\N	1389.75	ETERNAL LIMITED # EQUITY SHARES	\N	INE758T01015	\N	2026-02-09 15:19:56.418086	equity	5.0	0.0	277.95	Shares	Shares
13	4	2	\N	7971.62	D340 - Bandhan Small Cap Fund- Direct Plan-Growth	\N	INF194KB1AL4	\N	2026-02-09 15:20:22.841747	mutual fund	163.169	8046.91	48.855	Equity	Small Cap
14	4	2	\N	12822.61	EFDG - JM Large Cap Fund - (Direct) - Growth Option	\N	INF192K01BZ0	\N	2026-02-09 15:20:22.841747	mutual fund	72.387	12072.13	177.1397	Equity	Large Cap
15	4	2	\N	42596.88	EQGP - UTI Flexi Cap Fund - Regular Plan	\N	INF789F01513	\N	2026-02-09 15:20:22.841747	mutual fund	139.344	33283.0	305.6958	Equity	Flexi Cap
16	4	2	\N	1368.50	ETERNAL LIMITED # EQUITY SHARES	\N	INE758T01015	\N	2026-02-09 15:20:22.841747	equity	5.0	0.0	273.7	Shares	Shares
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.roles (role_id, role_name, description) FROM stdin;
1	admin	Full administrative privileges
2	user	Standard user with limited access
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.service_requests (id, request_id, user_id, request_type, description, status, created_at, updated_at, member_id, admin_description) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.user_roles (user_role_id, user_id, role_id, scope) FROM stdin;
1	1	1	global
2	2	2	default
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sohamathawale
--

COPY public.users (user_id, family_id, email, phone, password_hash, otp, created_at) FROM stdin;
1	1	sohamathawale2003@gmail.com	9999999999	scrypt:32768:8:1$habPRxxJmyyy8T56$ec93b749c70e5358fb89b76a830bd2276e229cc524c669754b50de6035901c29ca2fac99218e1003ad755d6c30979e8b1893ce6c4749ae04bf4f52833faae208	\N	2026-02-09 15:18:08.457843
2	2	asoham60@gmail.com	7506061821	scrypt:32768:8:1$JrIyfrjqngPjGMsB$0941ed58e44c0011c77a629b8235c483f746b0039635a2a9083f7af0eb378a46ae25f5d255c5f2e79a264e0a380547a6f0a8cb8125a098d61b271685a1cca883	\N	2026-02-09 15:18:36.252672
\.


--
-- Name: families_family_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.families_family_id_seq', 2, true);


--
-- Name: family_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.family_members_id_seq', 1, false);


--
-- Name: login_otps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.login_otps_id_seq', 3, true);


--
-- Name: pending_registrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.pending_registrations_id_seq', 2, true);


--
-- Name: portfolio_duplicates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.portfolio_duplicates_id_seq', 4, true);


--
-- Name: portfolios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.portfolios_id_seq', 16, true);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 2, true);


--
-- Name: service_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.service_requests_id_seq', 1, false);


--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.user_roles_user_role_id_seq', 2, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sohamathawale
--

SELECT pg_catalog.setval('public.users_user_id_seq', 2, true);


--
-- Name: families families_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.families
    ADD CONSTRAINT families_pkey PRIMARY KEY (family_id);


--
-- Name: family_members family_members_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT family_members_pkey PRIMARY KEY (id);


--
-- Name: historic_returns historic_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.historic_returns
    ADD CONSTRAINT historic_returns_pkey PRIMARY KEY (isin);


--
-- Name: login_otps login_otps_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.login_otps
    ADD CONSTRAINT login_otps_pkey PRIMARY KEY (id);


--
-- Name: pending_registrations pending_registrations_email_key; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.pending_registrations
    ADD CONSTRAINT pending_registrations_email_key UNIQUE (email);


--
-- Name: pending_registrations pending_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.pending_registrations
    ADD CONSTRAINT pending_registrations_pkey PRIMARY KEY (id);


--
-- Name: portfolio_duplicates portfolio_duplicates_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.portfolio_duplicates
    ADD CONSTRAINT portfolio_duplicates_pkey PRIMARY KEY (id);


--
-- Name: portfolios portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: family_members unique_family_member; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT unique_family_member UNIQUE (family_id, member_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_family_members_email; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_family_members_email ON public.family_members USING btree (email);


--
-- Name: idx_portfolios_isin; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_portfolios_isin ON public.portfolios USING btree (isin_no);


--
-- Name: idx_portfolios_member; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_portfolios_member ON public.portfolios USING btree (member_id);


--
-- Name: idx_portfolios_portfolio_id; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_portfolios_portfolio_id ON public.portfolios USING btree (portfolio_id);


--
-- Name: idx_portfolios_user; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_portfolios_user ON public.portfolios USING btree (user_id);


--
-- Name: idx_service_requests_user_request; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_service_requests_user_request ON public.service_requests USING btree (user_id, request_id);


--
-- Name: idx_user_roles_role; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_user_roles_role ON public.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_user_roles_user ON public.user_roles USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone);


--
-- Name: uniq_duplicate_link; Type: INDEX; Schema: public; Owner: sohamathawale
--

CREATE UNIQUE INDEX uniq_duplicate_link ON public.portfolio_duplicates USING btree (linked_portfolio_entry_id) WHERE (linked_portfolio_entry_id IS NOT NULL);


--
-- Name: users auto_create_family; Type: TRIGGER; Schema: public; Owner: sohamathawale
--

CREATE TRIGGER auto_create_family BEFORE INSERT ON public.users FOR EACH ROW WHEN ((new.family_id IS NULL)) EXECUTE FUNCTION public.create_family_for_user();


--
-- Name: service_requests trg_assign_service_request_id; Type: TRIGGER; Schema: public; Owner: sohamathawale
--

CREATE TRIGGER trg_assign_service_request_id BEFORE INSERT ON public.service_requests FOR EACH ROW EXECUTE FUNCTION public.assign_service_request_id();


--
-- Name: family_members family_members_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT family_members_family_id_fkey FOREIGN KEY (family_id) REFERENCES public.families(family_id) ON DELETE CASCADE;


--
-- Name: service_requests fk_sr_user; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: login_otps login_otps_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.login_otps
    ADD CONSTRAINT login_otps_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: portfolios portfolios_member_fk; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_member_fk FOREIGN KEY (member_id) REFERENCES public.family_members(id) ON DELETE SET NULL;


--
-- Name: portfolios portfolios_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: service_requests service_requests_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.family_members(id) ON DELETE SET NULL;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users users_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sohamathawale
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_family_id_fkey FOREIGN KEY (family_id) REFERENCES public.families(family_id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 0oVS1mahNqC7rbTAbvyQhcfnL2MkeLhmFJdbPhsSubEM3UQeKArJiUlHYUCw4QX

