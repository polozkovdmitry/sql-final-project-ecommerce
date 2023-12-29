-- требуется посчитать распределение по количеству единиц товаров
-- в одному мультизаказе (посылке)
with step_1 as (
    select 
        multiorder_id, 
        sum(items_num) as total_items
    from 
        public.orders
    group by 
        multiorder_id
),
bar_raw as (
    select
        total_items, 
        count(*) as frequency
    from 
        step_1
    group by 
        total_items
)
select 
    total_items,
    frequency
from 
    bar_raw
order by 
    total_items asc

    