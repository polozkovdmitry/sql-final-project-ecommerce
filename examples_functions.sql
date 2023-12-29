-- -- 1. -- --
select sku, prepare_text(rus_name) from sku limit 10;

-- -- 2. -- --
-- распределение пользователей по кодам городов.
with customers_with_phones as (
    select 
        id,
        cast(contact_info['phone'] as varchar) as phone_number
    from   
        public.customers 
    where 
        contact_info is not null
)
SELECT 
    SUBSTRING(normalize_russian_phone(phone_number) FROM 4 FOR 3) AS city_code,
    COUNT(*) AS customers_count
FROM 
    customers_with_phones
GROUP BY 
    SUBSTRING(normalize_russian_phone(phone_number) FROM 4 FOR 3)
ORDER BY 
    city_code;

-- -- 3. -- --
-- используем для текстового анализа
with raw as (
    SELECT 
        split_text_to_array(b.rus_name, ' ') AS word
    FROM 
        public.orders as a 
        left join sku as b 
            on a.sku = b.sku
)
select 
    word, 
    count(*)
from 
    raw 
group by 
    word;
