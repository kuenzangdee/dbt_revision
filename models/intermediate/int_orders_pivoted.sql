with payments as 
(
    select *  from {{ ref('stg_stripe__payment') }}
    where payment_status='success'
    
),
pivoted as
(
    select order_id,
        {% set payment_methods=['bank_transfer','coupon','credit_card','gift_card'] %}
            {% for payment_method in payment_methods %}
                sum(case when payment_method={{payment_method}} then payment_amount    else 0 end) as {{payment_method}}_amount
                {%- if not loop.last -%} ,{%- endif -%}
            {% endfor %}


        --sum(case when payment_method='bank_transfer' then payment_amount    else 0 end) as bank_transfer_amount,
        --#sum(case when payment_method='coupon' then payment_amount    else 0 end) as coupon_amount,
        --#sum(case when payment_method='credit_card' then payment_amount    else 0 end) as credit_card_amount,
        --#sum(case when payment_method='gift_card' then payment_amount    else 0 end) as gift_card_amount
     from payments
     group by 1
)

select * from pivoted
