-- -- orders -- --
INSERT INTO public.orders (
    item_id,
    items_num,
    multiorder_id,
    order_id,
    customer_id,
    sku,
    status,
    created_msk_dttm,
    shipped_msk_dttm,
    delivered_msk_dttm,
    partner_id,
    warehouse_id,
    promo_id,
    price
) VALUES
    (1,  1, 1, 1, 1, 1, 'shipped',    '2023-12-29 16:01:23+03', '2023-12-30 16:34:25+03', NULL,                     1, 1, 2,    251.44),
    (2,  1, 1, 1, 1, 2, 'shipped',    '2023-12-29 16:01:23+03', '2023-12-30 16:34:25+03', NULL,                     1, 4, 1,    263.56),
    (3,  2, 1, 1, 1, 3, 'shipped',    '2023-12-29 16:01:23+03', '2023-12-30 16:34:25+03', NULL,                     1, 1, 2,    2126.48),
    (4,  2, 1, 2, 1, 4, 'shipped',    '2023-12-29 16:01:23+03', '2023-12-31 08:43:34+03', NULL,                     2, 2, 1,    1943.58),
    (5,  2, 2, 3, 2, 2, 'created',    '2023-12-29 12:04:26+03', NULL,                     NULL,                     1, 4, NULL, 1941.26),
    (6,  6, 3, 4, 3, 5, 'delivered',  '2023-12-23 17:56:34+03', '2023-12-25 14:34:23+03', '2023-12-26 23:51:33+03', 2, 1, 3,    17417.7),
    (7,  1, 4, 5, 3, 6, 'created',    '2023-12-24 11:03:26+03', NULL,                     NULL,                     3, 3, 3,    398.75),
    (8,  1, 4, 5, 3, 7, 'created',    '2023-12-24 11:03:26+04', NULL,                     NULL,                     4, 1, NULL, 169.36),
    (9,  9, 4, 5, 3, 1, 'created',    '2023-12-24 11:03:26+05', NULL,                     NULL,                     1, 1, NULL, 37263.06),
    (10, 4, 5, 6, 2, 2, 'cancelled',  '2023-12-29 06:08:26+03', '2023-12-30 09:11:23+03', NULL,                     1, 5, 1,    7881.16),
    (11, 1, 5, 7, 2, 3, 'cancelled',  '2023-12-29 06:08:26+04', NULL,                     NULL,                     1, 1, 2,    37.55),
    (12, 1, 5, 7, 2, 4, 'cancelled',  '2023-12-29 06:08:26+05', NULL,                     NULL,                     2, 2, 2,    295.72),
    (13, 1, 6, 8, 4, 6, 'shipped',    '2023-12-23 08:34:22+03', '2023-12-25 12:32:56+03', NULL,                     3, 3, 1,    498.15),
    (14, 4, 7, 9, 5, 8, 'delivered',  '2023-12-29 12:04:26+03', '2023-12-31 08:03:54+03', '2023-12-31 22:34:14+03', 5, 2, NULL, 6828.56),
    (15, 3, 8, 10, 5, 9, 'delivered', '2023-12-23 20:44:56+03', '2023-12-25 22:41:23+03', '2023-12-26 12:32:07+03', 6, 1, NULL, 4766.7);

SELECT pg_catalog.setval('public.item_id_seq', 1, false);


-- -- sku -- --
INSERT INTO public.sku (
    sku,
    rus_name,
    warehouse_id_list,
    category_lvl_1,
    category_lvl_2,
    category_lvl_3
) VALUES
    (1, 'Антисептик', ARRAY[1, 2], 'Аптека', 'Санитария', 'Жидкости'),
    (2, 'Расчёска', ARRAY[1], 'Аптека', 'Аптека для головы', 'Уход'),
    (3, 'Подарочкая карта 1', ARRAY[3], 'Подарки', 'Подарочные карты', 'Подарочные карты'),
    (4, 'Подарочная карта 2', ARRAY[3, 4], 'Подарки', 'Подарочные карты', 'Подарочные карты'),
    (5, 'Фото в рамке кроссовки рик овенс геобаскет 44.5 размер', ARRAY[1, 5], 'Дом', 'Декор', 'Фотографии'),
    (6, 'Букет цветов 1', ARRAY[4], 'Цветы', 'Цветы', 'Цветы'),
    (7, 'Подарочный набор 2', ARRAY[3, 5], 'Подарки', 'Подарочные карты', 'Подарочные карты'),
    (8, 'Букет цветов 2', ARRAY[1], 'Цветы', 'Цветы', 'Цветы'),
    (9, 'Картина в рамке футболка махариши М', ARRAY[1], 'Дом', 'Декор', 'Картины');

SELECT pg_catalog.setval('public.sku_seq', 1, false);


-- -- partners -- --
INSERT INTO public.partners (
    id,
    contact_info,
    joined_msk_dttm,
    schema,
    active_flag
) VALUES
    (
        1,
        '{"contact_person": "E M", "email": "wearehiting@mail.ru", "phone": "79167744463", "address": {"street": "kremlin", "city": "moscow"}}'::JSONB,
        '2023-08-29 16:01:23+03',
        'NO W D',
        TRUE
    ),
    (
        2,
        NULL,
        '2023-05-29 16:01:23+03',
        'O W D',
        TRUE
    ),
    (
        3,
        '{"contact_person": "T G", "email": "hacha@mail.ru", "address": {"street": "bolshoy konyshenyi", "city": "moscow"}}'::JSONB,
        '2023-04-29 16:01:23+03',
        'NO NW D',
        TRUE
    ),
    (
        4,
        NULL,
        '2023-02-23 16:01:23+03',
        'NO NW ND',
        TRUE
    ),
    (
        5,
        NULL,
        '2023-10-29 16:01:23+03',
        'NO NW D',
        TRUE
    ),
    (
        6,
        NULL,
        '2023-06-29 16:01:23+03',
        'NO W D',
        TRUE
    );

SELECT pg_catalog.setval('public.partner_id_seq', 1, false);

-- -- promo -- --
INSERT INTO public.promo (
    id,
    percent_discount,
    fixed_discount,
    region_id,
    warehouse_id,
    start_msk_dttm,
    end_msk_dttm,
    active_flag
) values 
    (1, null, 100, 1, 1, null, null, False),
    (2, null, 500, 1, 1, null, null, False),
    (3, 35, null, 1, 1, '2023-12-24 10:03:26+03', '2025-01-01 00:00:12+03', True),
    (1, null, 100, 1, 2, null, null, False),
    (2, null, 500, 1, 2, null, null, False),
    (3, 35, null, 1, 2, null, null, False),
    (1, null, 100, 1, 3, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', True),
    (2, null, 500, 1, 3, '2023-12-29 06:04:00+03', '2024-01-01 00:00:12+03', True),
    (3, 35, null, 1, 3, null, null, False),
    (1, null, 100, 1, 4, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', True),
    (2, null, 500, 1, 4, null, null, False),
    (3, 35, null, 1, 4, null, null, False),
    (1, null, 100, 1, 5, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', True),
    (2, null, 500, 1, 5, null, null, True),
    (3, 35, null, 1, 5, '2023-12-24 10:03:26+03', '2025-01-01 00:00:12+03', True),
    (1, null, 100, 2, 1, null, null, False),
    (2, null, 500, 2, 1, null, null, False),
    (3, 35, null, 2, 1, '2023-12-24 10:03:26+03', '2025-01-01 00:00:12+03', True),
    (1, null, 100, 2, 2, null, null, False),
    (2, null, 500, 2, 2, null, null, False),
    (3, 35, null, 2, 2, null, null, False),
    (1, null, 100, 2, 3, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', True),
    (2, null, 500, 2, 3, null, null, False),
    (3, 35, null, 2, 3, null, null, False),
    (1, null, 100, 2, 4, '2023-12-27 04:08:26+03', '2024-01-01 00:00:12+03', True),
    (2, null, 500, 2, 4, null, null, False),
    (3, 35, null, 2, 4, null, null, False),
    (1, null, 100, 2, 5, null, null, False),
    (2, null, 500, 2, 5, '2023-12-29 06:04:00+03', '2024-01-01 00:00:12+03', True),
    (3, 35, null, 1, 5, null, null, False);

SELECT pg_catalog.setval('public.promo_id_seq', 1, false);


-- -- warehouses -- --
INSERT INTO public.warehouses (
    id,
    name,
    region_id
) values
    (1, 'Подвал на таганке', 1),
    (2, 'Гараж папы Димы', 1),
    (3, 'Бункер', 2),
    (4, 'Винный погреб', 2),
    (5, 'Раздевалка на покре', 1);

SELECT pg_catalog.setval('public.warehouse_id_seq', 1, false);

-- -- customers -- --
INSERT INTO public.customers (
    id,
    hash_login,
    hash_password,
    contact_info,
    first_delivered_order_msk_dttm,
    last_delivered_order_msk_dttm,
    multiorders_num
) values
    (1, '0f5b25cd', '11ddbaf3', '{"email": "dada@gmail.com", "phone": "+79852674523", "address": {"street": "tverskaya", "city": "moscow", "zip_code": "109147"}}'::JSONB, NULL, NULL, 1),
    (2, 'c3cc6e31', 'd9308f32', '{"email": "asas@mail.ru", "phone": "89851234567", "address": {"street": "delegatskaya", "city": "moscow", "zip_code": "127055"}}'::JSONB, NULL, NULL, 2),
    (3, '3b2285b3', 'a7c471cf', NULL, '2023-12-26 23:51:33+03', '2023-12-26 23:51:33+03', 2),
    (4, '4cfdc2e1', 'f25b8258', '{"email": "easy10@mail.ru", "phone": "79528124562", "address": {"street": "delegatskaya", "flat_no": "11", "city": "st. petersburg"}}'::JSONB, '2023-12-26 12:32:07+03', '2023-12-31 22:34:14+03', 1),
    (5, '829614df', 'a7c471cf', '{"email": "lol@mail.ru", "phone": "74957324621", "address": {"city": "moscow", "zip_code": "115478"}}'::JSONB, NULL, NULL, 2);

SELECT pg_catalog.setval('public.customer_id_seq', 1, false);


-- -- schemas -- --
INSERT INTO public.schemas (
    name,
    fix_fee,
    var_fee
) values
    ('O W D', NULL, 0.01),
    ('NO W D', 10.5, 0.02),
    ('NO NW D', 20, 0.025),
    ('NO NW ND', 30, 0.03);

-- SELECT pg_catalog.setval('public.schema_name_seq', 1, false);


-- -- regions -- --
INSERT INTO public.regions (
    id,
    federal_name
) values
    (1, 'Москва'),
    (2, 'Комсомольск-на-Амуре');

SELECT pg_catalog.setval('public.region_id_seq', 1, false);
