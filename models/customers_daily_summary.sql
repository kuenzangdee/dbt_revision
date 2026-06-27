select
    customer_id
    ,order_date
    ,{{ dbt_utils.generate_surrogate_key(['customer_id', 'order_date']) }} as primary_key
    ,count(*) as count
from {{ ref('stg_jaffle_shop__orders') }}
group by 1,2