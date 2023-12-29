-- transactions

-- Общая выручка Компании за декабрь 2023 в Комсомольске-на-Амуре
SELECT 
    SUM(a.price) AS total_item_price
FROM 
    public.orders AS a 
    LEFT JOIN public.warehouses AS b 
        ON a.warehouse_id = b.id
    LEFT JOIN public.regions as c 
        on b.region_id = c.id
WHERE 
    c.federal_name = 'Комсомольск-на-Амуре';


-- Динамика доли доставленных заказов среди всех оформленных на текущий момент
-- (слово динамика означает в дополнительной гранулярности DATE(created_msk_dttm)) 
with shares as (
    select    
        date(created_msk_dttm) as created_dt,
        sum(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) as delivered_count,
        sum(CASE WHEN status = 'created' THEN 1 ELSE 0 END) as created_count
    from 
        public.orders
    group by 
        date(created_msk_dttm)
)
select  
    created_dt, 
    CASE 
        WHEN created_count <> 0 THEN delivered_count::numeric / created_count 
        ELSE NULL 
    END AS share_delivered_among_created
from    
    shares;

-- Средняя цена одной штуки товара в Москве среди товаров купленных до полудня 
-- против цены после полудня.
WITH raw AS (
    SELECT 
        a.item_id, 
        a.price::numeric / a.items_num AS one_item_price,
        CASE 
            WHEN EXTRACT(HOUR FROM a.created_msk_dttm) < 12 THEN TRUE
            ELSE FALSE
        END AS before_noon_flag
    FROM public.orders as a 
    left join public.warehouses AS b 
        ON a.warehouse_id = b.id
    WHERE 
        b.region_id = 1
)
SELECT 
    before_noon_flag,
    AVG(one_item_price) AS avg_one_item_price
FROM 
    raw 
GROUP BY    
    before_noon_flag;


-- Самый длинный интервал между мультизаказами и пользователь, который его совершил
WITH orders_with_last AS (
    SELECT  
        customer_id,
        item_id, 
        created_msk_dttm, 
        LAG(created_msk_dttm) OVER (
            PARTITION BY customer_id ORDER BY created_msk_dttm ASC
        ) AS prev_created_msk_dttm
    FROM 
        public.orders 
), 
customers_max_interval AS (
    SELECT  
        customer_id, 
        max(created_msk_dttm - coalesce(prev_created_msk_dttm, created_msk_dttm)) as max_interval_days
    FROM 
        orders_with_last
    GROUP BY
        customer_id
),
t AS (
    SELECT 
        customer_id, 
        max_interval_days, 
        MAX(max_interval_days) OVER () AS maximum_interval_days
    FROM customers_max_interval
)
SELECT 
    customer_id, 
    max_interval_days
FROM 
    t
WHERE
    max_interval_days = maximum_interval_days;


