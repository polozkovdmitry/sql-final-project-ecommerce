-- \q
-- psql postgres
-- drop database test;
-- create database test;
-- \c test;

-- -- orders -- --
create table public.orders (
	item_id            integer   not null,
	items_num          integer   not null check (items_num >= (0)::double precision),
	multiorder_id      integer   not null,
	order_id           integer   not null,
	customer_id        integer   not null,
	sku                integer   not null,
	status             text      not null,
	created_msk_dttm   timestamp not null,
	shipped_msk_dttm   timestamp,
	delivered_msk_dttm timestamp,
	partner_id         integer   not null,
	warehouse_id       integer   not null,
	promo_id           integer,
	price              float     check (price > (0)::double precision or price is null),

    CONSTRAINT orders_pk PRIMARY KEY (item_id)
);

ALTER TABLE public.orders OWNER TO ddpp;

CREATE SEQUENCE public.item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.item_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.item_id_seq OWNED BY public.orders.item_id;

ALTER TABLE ONLY public.orders ALTER COLUMN item_id 
SET DEFAULT nextval('public.item_id_seq'::regclass);


-- -- sku -- --
CREATE TABLE public.sku (
    sku               INTEGER   NOT NULL,
    rus_name          TEXT      NOT NULL,
    warehouse_id_list INTEGER[] NOT NULL,
    category_lvl_1    TEXT      NOT NULL,
    category_lvl_2    TEXT      NOT NULL,
    category_lvl_3    TEXT      NOT NULL,

    CONSTRAINT sku_pk PRIMARY KEY (sku)
);

ALTER TABLE public.sku OWNER TO ddpp;

CREATE SEQUENCE public.sku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.sku_seq OWNER TO ddpp;

ALTER SEQUENCE public.sku_seq OWNED BY public.sku.sku;

ALTER TABLE ONLY public.sku ALTER COLUMN sku 
SET DEFAULT nextval('public.sku_seq'::regclass);


-- -- partners -- --
CREATE TABLE public.partners (
    id              INTEGER   NOT NULL,
    contact_info    JSONB,
    joined_msk_dttm TIMESTAMP NOT NULL,
    schema          text   NOT NULL,
    active_flag     BOOLEAN   NOT NULL,

    CONSTRAINT partners_pk PRIMARY KEY (id)
);

ALTER TABLE public.partners OWNER TO ddpp;

CREATE SEQUENCE public.partner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.partner_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.partner_id_seq OWNED BY public.partners.id;

ALTER TABLE ONLY public.partners ALTER COLUMN id 
SET DEFAULT nextval('public.partner_id_seq'::regclass);


-- -- promo -- --
CREATE TABLE public.promo (
    id               INTEGER    NOT NULL,
    percent_discount INTEGER    CHECK (
        (percent_discount > 0 AND percent_discount < 100) OR percent_discount IS NULL
    ),
    fixed_discount   INTEGER    CHECK (
        fixed_discount > 0 OR fixed_discount IS NULL
    ),
    region_id        INTEGER    NOT NULL,
    warehouse_id     INTEGER    NOT NULL,
    start_msk_dttm   TIMESTAMP,
    end_msk_dttm  TIMESTAMP,
    active_flag      BOOLEAN    NOT NULL,

    CONSTRAINT promo_pk PRIMARY KEY (id, warehouse_id, region_id)
);

ALTER TABLE public.promo OWNER TO ddpp;

CREATE SEQUENCE public.promo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.promo_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.promo_id_seq OWNED BY public.promo.id;

ALTER TABLE ONLY public.promo ALTER COLUMN id 
SET DEFAULT nextval('public.promo_id_seq'::regclass);


-- -- warehouses -- --
CREATE TABLE public.warehouses (
    id        INTEGER NOT NULL,
    name      TEXT,
    region_id INTEGER NOT NULL,

    CONSTRAINT warehouses_pk PRIMARY KEY (id)
);

ALTER TABLE public.warehouses OWNER TO ddpp;

CREATE SEQUENCE public.warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.warehouse_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.warehouse_id_seq OWNED BY public.warehouses.id;

ALTER TABLE ONLY public.warehouses ALTER COLUMN id 
SET DEFAULT nextval('public.warehouse_id_seq'::regclass);


-- -- customers -- --
CREATE TABLE public.customers (
    id                             INTEGER   NOT NULL,
    hash_login                     CHAR(8),
    hash_password                  CHAR(8),
    contact_info                   JSONB,
    first_delivered_order_msk_dttm TIMESTAMP CHECK (first_delivered_order_msk_dttm <= last_delivered_order_msk_dttm),
    last_delivered_order_msk_dttm  TIMESTAMP CHECK (first_delivered_order_msk_dttm <= last_delivered_order_msk_dttm),
    multiorders_num                INTEGER   CHECK (multiorders_num >= 0),

    CONSTRAINT customers_pk PRIMARY KEY (id)
);

ALTER TABLE public.customers OWNER TO ddpp;

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.customer_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customers.id;

ALTER TABLE ONLY public.customers ALTER COLUMN id 
SET DEFAULT nextval('public.customer_id_seq'::regclass);


-- -- schemas -- --
CREATE TABLE public.schemas (
    name     TEXT  NOT NULL,
    fix_fee  FLOAT CHECK (fix_fee > 0 OR fix_fee IS NULL),
    var_fee  FLOAT CHECK (var_fee > 0 OR var_fee IS NULL),

    CONSTRAINT schemas_pk PRIMARY KEY (name)
);

ALTER TABLE public.schemas OWNER TO ddpp;

-- CREATE SEQUENCE public.schema_name_seq
--     AS integer
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
    -- CACHE 1;

-- ALTER TABLE public.schema_name_seq OWNER TO ddpp;

-- ALTER SEQUENCE public.schema_name_seq OWNED BY public.schemas.name;

-- ALTER TABLE ONLY public.schemas ALTER COLUMN name 
-- SET DEFAULT nextval('public.schema_name_seq'::regclass);


-- -- regions -- --
CREATE TABLE public.regions (
    id           INTEGER NOT NULL,
    federal_name TEXT NOT NULL,

    CONSTRAINT regions_pk PRIMARY KEY (id)
);

ALTER TABLE public.regions OWNER TO ddpp;

CREATE SEQUENCE public.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE public.region_id_seq OWNER TO ddpp;

ALTER SEQUENCE public.region_id_seq OWNED BY public.regions.id;

ALTER TABLE ONLY public.regions ALTER COLUMN id 
SET DEFAULT nextval('public.region_id_seq'::regclass);


