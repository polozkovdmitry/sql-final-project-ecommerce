--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10 (Homebrew)
-- Dumped by pg_dump version 14.10 (Homebrew)

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
-- Name: created_shipped_delivered_validity(); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.created_shipped_delivered_validity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.created_msk_dttm > NEW.shipped_msk_dttm THEN
            RAISE EXCEPTION 'created_msk_dttm > shipped_msk_dttm is invalid';
        END IF;
        IF NEW.shipped_msk_dttm > NEW.delivered_msk_dttm THEN
            RAISE EXCEPTION 'shipped_msk_dttm > delivered_msk_dttm is invalid';
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.created_shipped_delivered_validity() OWNER TO ddpp;

--
-- Name: federal_name_meaningful(); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.federal_name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.federal_name) = ''
            THEN
            RAISE EXCEPTION 'regions.federal_name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;


ALTER FUNCTION public.federal_name_meaningful() OWNER TO ddpp;

--
-- Name: name_meaningful(); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.name) = ''
            THEN
            RAISE EXCEPTION 'warehouse.name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;


ALTER FUNCTION public.name_meaningful() OWNER TO ddpp;

--
-- Name: normalize_russian_phone(character varying); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.normalize_russian_phone(phone_number character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    normalized_phone varchar;
BEGIN
    -- убираем не цифры
    normalized_phone := regexp_replace(phone_number, '[^0-9]', '', 'g');

    -- если нужной длины, обработать +8...
    IF length(normalized_phone) = 16 THEN
        normalized_phone := '+7' || RIGHT(
            normalized_phone, 3
        );
    END IF;
    -- если длины на 1 меньше нужной, обработать 8...
    IF length(normalized_phone) = 16 THEN
        normalized_phone := '+7' || RIGHT(
            normalized_phone, 2
        );
    END IF;

    -- если без 7 или 8 в начале, добавить 7
    IF length(normalized_phone) = 10 THEN
        normalized_phone := '7' || normalized_phone;
    END IF;

    -- добавить скобки и дефисы
    normalized_phone := '+' || substring(
        normalized_phone from 1 for 1
    ) || '(' || substring(
        normalized_phone from 2 for 3
    ) || ')' || substring(
        normalized_phone from 5 for 3
    ) || '-' || substring(
        normalized_phone from 8 for 2
    ) || '-' || substring(
        normalized_phone from 10 for 2
    );

    RETURN normalized_phone;
END;
$$;


ALTER FUNCTION public.normalize_russian_phone(phone_number character varying) OWNER TO ddpp;

--
-- Name: prepare_text(text); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.prepare_text(input_text text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN trim(LOWER(regexp_replace(input_text, '[,.!?]+', '', 'g')));
END;
$$;


ALTER FUNCTION public.prepare_text(input_text text) OWNER TO ddpp;

--
-- Name: promo_id_submission(); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.promo_id_submission() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NEW.active_flag = True and (
            NEW.start_msk_dttm is null 
            or NEW.end_msk_dttm is null
        )
            THEN
            RAISE EXCEPTION 'active promos must have non-null start_msk_dttm and end_msk_dttm';
        END IF;
        IF NEW.active_flag = False and (
            NEW.start_msk_dttm is not null 
            or NEW.end_msk_dttm is not null
        )
            THEN
            RAISE EXCEPTION 'initially inactive promos must have null start_msk_dttm and end_msk_dttm';
        END IF;
 RETURN NEW;
    END;
$$;


ALTER FUNCTION public.promo_id_submission() OWNER TO ddpp;

--
-- Name: rus_name_meaningful(); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.rus_name_meaningful() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF prepare_text(NEW.rus_name) = ''
            THEN
            RAISE EXCEPTION 'sku.rus_name cannot be an empty string';
        END IF;
 RETURN NEW;
    END;
$$;


ALTER FUNCTION public.rus_name_meaningful() OWNER TO ddpp;

--
-- Name: split_text_to_array(text, text); Type: FUNCTION; Schema: public; Owner: ddpp
--

CREATE FUNCTION public.split_text_to_array(input_text text, delimiter text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT unnest(string_to_array(input_text, delimiter));
END;
$$;


ALTER FUNCTION public.split_text_to_array(input_text text, delimiter text) OWNER TO ddpp;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    hash_login character(8),
    hash_password character(8),
    contact_info jsonb,
    first_delivered_order_msk_dttm timestamp without time zone,
    last_delivered_order_msk_dttm timestamp without time zone,
    multiorders_num integer,
    CONSTRAINT customers_check CHECK ((first_delivered_order_msk_dttm <= last_delivered_order_msk_dttm)),
    CONSTRAINT customers_check1 CHECK ((first_delivered_order_msk_dttm <= last_delivered_order_msk_dttm)),
    CONSTRAINT customers_multiorders_num_check CHECK ((multiorders_num >= 0))
);


ALTER TABLE public.customers OWNER TO ddpp;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_id_seq OWNER TO ddpp;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customers.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.orders (
    item_id integer NOT NULL,
    items_num integer NOT NULL,
    multiorder_id integer NOT NULL,
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    sku integer NOT NULL,
    status text NOT NULL,
    created_msk_dttm timestamp without time zone NOT NULL,
    shipped_msk_dttm timestamp without time zone,
    delivered_msk_dttm timestamp without time zone,
    partner_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    promo_id integer,
    price double precision,
    CONSTRAINT orders_items_num_check CHECK (((items_num)::double precision >= (0)::double precision)),
    CONSTRAINT orders_price_check CHECK (((price > (0)::double precision) OR (price IS NULL)))
);


ALTER TABLE public.orders OWNER TO ddpp;

--
-- Name: item_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_id_seq OWNER TO ddpp;

--
-- Name: item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.item_id_seq OWNED BY public.orders.item_id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    contact_info jsonb,
    joined_msk_dttm timestamp without time zone NOT NULL,
    schema text NOT NULL,
    active_flag boolean NOT NULL
);


ALTER TABLE public.partners OWNER TO ddpp;

--
-- Name: partner_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.partner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partner_id_seq OWNER TO ddpp;

--
-- Name: partner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.partner_id_seq OWNED BY public.partners.id;


--
-- Name: promo; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.promo (
    id integer NOT NULL,
    percent_discount integer,
    fixed_discount integer,
    region_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    start_msk_dttm timestamp without time zone,
    end_msk_dttm timestamp without time zone,
    active_flag boolean NOT NULL,
    CONSTRAINT promo_fixed_discount_check CHECK (((fixed_discount > 0) OR (fixed_discount IS NULL))),
    CONSTRAINT promo_percent_discount_check CHECK ((((percent_discount > 0) AND (percent_discount < 100)) OR (percent_discount IS NULL)))
);


ALTER TABLE public.promo OWNER TO ddpp;

--
-- Name: promo_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.promo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promo_id_seq OWNER TO ddpp;

--
-- Name: promo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.promo_id_seq OWNED BY public.promo.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    federal_name text NOT NULL
);


ALTER TABLE public.regions OWNER TO ddpp;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO ddpp;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.region_id_seq OWNED BY public.regions.id;


--
-- Name: schemas; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.schemas (
    name text NOT NULL,
    fix_fee double precision,
    var_fee double precision,
    CONSTRAINT schemas_fix_fee_check CHECK (((fix_fee > (0)::double precision) OR (fix_fee IS NULL))),
    CONSTRAINT schemas_var_fee_check CHECK (((var_fee > (0)::double precision) OR (var_fee IS NULL)))
);


ALTER TABLE public.schemas OWNER TO ddpp;

--
-- Name: sku; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.sku (
    sku integer NOT NULL,
    rus_name text NOT NULL,
    warehouse_id_list integer[] NOT NULL,
    category_lvl_1 text NOT NULL,
    category_lvl_2 text NOT NULL,
    category_lvl_3 text NOT NULL
);


ALTER TABLE public.sku OWNER TO ddpp;

--
-- Name: sku_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.sku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sku_seq OWNER TO ddpp;

--
-- Name: sku_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.sku_seq OWNED BY public.sku.sku;


--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: ddpp
--

CREATE TABLE public.warehouses (
    id integer NOT NULL,
    name text,
    region_id integer NOT NULL
);


ALTER TABLE public.warehouses OWNER TO ddpp;

--
-- Name: warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: ddpp
--

CREATE SEQUENCE public.warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_id_seq OWNER TO ddpp;

--
-- Name: warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ddpp
--

ALTER SEQUENCE public.warehouse_id_seq OWNED BY public.warehouses.id;


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: orders item_id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.orders ALTER COLUMN item_id SET DEFAULT nextval('public.item_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partner_id_seq'::regclass);


--
-- Name: promo id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.promo ALTER COLUMN id SET DEFAULT nextval('public.promo_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.region_id_seq'::regclass);


--
-- Name: sku sku; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.sku ALTER COLUMN sku SET DEFAULT nextval('public.sku_seq'::regclass);


--
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouse_id_seq'::regclass);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.customers (id, hash_login, hash_password, contact_info, first_delivered_order_msk_dttm, last_delivered_order_msk_dttm, multiorders_num) FROM stdin;
1	0f5b25cd	11ddbaf3	{"email": "dada@gmail.com", "phone": "+79852674523", "address": {"city": "moscow", "street": "tverskaya", "zip_code": "109147"}}	\N	\N	1
2	c3cc6e31	d9308f32	{"email": "asas@mail.ru", "phone": "89851234567", "address": {"city": "moscow", "street": "delegatskaya", "zip_code": "127055"}}	\N	\N	2
3	3b2285b3	a7c471cf	\N	2023-12-26 23:51:33	2023-12-26 23:51:33	2
4	4cfdc2e1	f25b8258	{"email": "easy10@mail.ru", "phone": "79528124562", "address": {"city": "st. petersburg", "street": "delegatskaya", "flat_no": "11"}}	2023-12-26 12:32:07	2023-12-31 22:34:14	1
5	829614df	a7c471cf	{"email": "lol@mail.ru", "phone": "74957324621", "address": {"city": "moscow", "zip_code": "115478"}}	\N	\N	2
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.orders (item_id, items_num, multiorder_id, order_id, customer_id, sku, status, created_msk_dttm, shipped_msk_dttm, delivered_msk_dttm, partner_id, warehouse_id, promo_id, price) FROM stdin;
1	1	1	1	1	1	shipped	2023-12-29 16:01:23	2023-12-30 16:34:25	\N	1	1	2	251.44
2	1	1	1	1	2	shipped	2023-12-29 16:01:23	2023-12-30 16:34:25	\N	1	4	1	263.56
3	2	1	1	1	3	shipped	2023-12-29 16:01:23	2023-12-30 16:34:25	\N	1	1	2	2126.48
4	2	1	2	1	4	shipped	2023-12-29 16:01:23	2023-12-31 08:43:34	\N	2	2	1	1943.58
5	2	2	3	2	2	created	2023-12-29 12:04:26	\N	\N	1	4	\N	1941.26
6	6	3	4	3	5	delivered	2023-12-23 17:56:34	2023-12-25 14:34:23	2023-12-26 23:51:33	2	1	3	17417.7
7	1	4	5	3	6	created	2023-12-24 11:03:26	\N	\N	3	3	3	398.75
8	1	4	5	3	7	created	2023-12-24 11:03:26	\N	\N	4	1	\N	169.36
9	9	4	5	3	1	created	2023-12-24 11:03:26	\N	\N	1	1	\N	37263.06
10	4	5	6	2	2	cancelled	2023-12-29 06:08:26	2023-12-30 09:11:23	\N	1	5	1	7881.16
11	1	5	7	2	3	cancelled	2023-12-29 06:08:26	\N	\N	1	1	2	37.55
12	1	5	7	2	4	cancelled	2023-12-29 06:08:26	\N	\N	2	2	2	295.72
13	1	6	8	4	6	shipped	2023-12-23 08:34:22	2023-12-25 12:32:56	\N	3	3	1	498.15
14	4	7	9	5	8	delivered	2023-12-29 12:04:26	2023-12-31 08:03:54	2023-12-31 22:34:14	5	2	\N	6828.56
15	3	8	10	5	9	delivered	2023-12-23 20:44:56	2023-12-25 22:41:23	2023-12-26 12:32:07	6	1	\N	4766.7
\.


--
-- Data for Name: partners; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.partners (id, contact_info, joined_msk_dttm, schema, active_flag) FROM stdin;
1	{"email": "wearehiting@mail.ru", "phone": "79167744463", "address": {"city": "moscow", "street": "kremlin"}, "contact_person": "E M"}	2023-08-29 16:01:23	NO W D	t
2	\N	2023-05-29 16:01:23	O W D	t
3	{"email": "hacha@mail.ru", "address": {"city": "moscow", "street": "bolshoy konyshenyi"}, "contact_person": "T G"}	2023-04-29 16:01:23	NO NW D	t
4	\N	2023-02-23 16:01:23	NO NW ND	t
5	\N	2023-10-29 16:01:23	NO NW D	t
6	\N	2023-06-29 16:01:23	NO W D	t
\.


--
-- Data for Name: promo; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.promo (id, percent_discount, fixed_discount, region_id, warehouse_id, start_msk_dttm, end_msk_dttm, active_flag) FROM stdin;
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.regions (id, federal_name) FROM stdin;
1	Москва
2	Комсомольск-на-Амуре
\.


--
-- Data for Name: schemas; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.schemas (name, fix_fee, var_fee) FROM stdin;
O W D	\N	0.01
NO W D	10.5	0.02
NO NW D	20	0.025
NO NW ND	30	0.03
\.


--
-- Data for Name: sku; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.sku (sku, rus_name, warehouse_id_list, category_lvl_1, category_lvl_2, category_lvl_3) FROM stdin;
1	Антисептик	{1,2}	Аптека	Санитария	Жидкости
2	Расчёска	{1}	Аптека	Аптека для головы	Уход
3	Подарочкая карта 1	{3}	Подарки	Подарочные карты	Подарочные карты
4	Подарочная карта 2	{3,4}	Подарки	Подарочные карты	Подарочные карты
5	Фото в рамке кроссовки рик овенс геобаскет 44.5 размер	{1,5}	Дом	Декор	Фотографии
6	Букет цветов 1	{4}	Цветы	Цветы	Цветы
7	Подарочный набор 2	{3,5}	Подарки	Подарочные карты	Подарочные карты
8	Букет цветов 2	{1}	Цветы	Цветы	Цветы
9	Картина в рамке футболка махариши М	{1}	Дом	Декор	Картины
\.


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: ddpp
--

COPY public.warehouses (id, name, region_id) FROM stdin;
1	Подвал на таганке	1
2	Гараж папы Димы	1
3	Бункер	2
4	Винный погреб	2
5	Раздевалка на покре	1
\.


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.customer_id_seq', 1, false);


--
-- Name: item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.item_id_seq', 1, false);


--
-- Name: partner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.partner_id_seq', 1, false);


--
-- Name: promo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.promo_id_seq', 1, false);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.region_id_seq', 1, false);


--
-- Name: sku_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.sku_seq', 1, false);


--
-- Name: warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ddpp
--

SELECT pg_catalog.setval('public.warehouse_id_seq', 1, false);


--
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- Name: orders orders_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (item_id);


--
-- Name: partners partners_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT partners_pk PRIMARY KEY (id);


--
-- Name: promo promo_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.promo
    ADD CONSTRAINT promo_pk PRIMARY KEY (id, warehouse_id, region_id);


--
-- Name: regions regions_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pk PRIMARY KEY (id);


--
-- Name: schemas schemas_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.schemas
    ADD CONSTRAINT schemas_pk PRIMARY KEY (name);


--
-- Name: sku sku_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.sku
    ADD CONSTRAINT sku_pk PRIMARY KEY (sku);


--
-- Name: warehouses warehouses_pk; Type: CONSTRAINT; Schema: public; Owner: ddpp
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pk PRIMARY KEY (id);


--
-- Name: orders created_shipped_delivered_validity_check; Type: TRIGGER; Schema: public; Owner: ddpp
--

CREATE TRIGGER created_shipped_delivered_validity_check BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.created_shipped_delivered_validity();


--
-- Name: regions federal_name_meaningful_check; Type: TRIGGER; Schema: public; Owner: ddpp
--

CREATE TRIGGER federal_name_meaningful_check BEFORE INSERT OR UPDATE ON public.regions FOR EACH ROW EXECUTE FUNCTION public.federal_name_meaningful();


--
-- Name: warehouses name_meaningful_check; Type: TRIGGER; Schema: public; Owner: ddpp
--

CREATE TRIGGER name_meaningful_check BEFORE INSERT OR UPDATE ON public.warehouses FOR EACH ROW EXECUTE FUNCTION public.name_meaningful();


--
-- Name: promo promo_id_submission_check; Type: TRIGGER; Schema: public; Owner: ddpp
--

CREATE TRIGGER promo_id_submission_check BEFORE INSERT ON public.promo FOR EACH ROW EXECUTE FUNCTION public.promo_id_submission();


--
-- Name: sku rus_name_meaningful_check; Type: TRIGGER; Schema: public; Owner: ddpp
--

CREATE TRIGGER rus_name_meaningful_check BEFORE INSERT OR UPDATE ON public.sku FOR EACH ROW EXECUTE FUNCTION public.rus_name_meaningful();


--
-- PostgreSQL database dump complete
--

