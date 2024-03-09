# Olist Store Analysis Project | MySQL

-- KPI 1 : Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
select * from payments;
select * from orders;

select case when weekday(order_purchase_timestamp) in (5,6) then 'Weekend'
else 'Weekday' end as Day_end, concat(round(sum(payment_value)/(select sum(payment_value) from payments)*100,2), '%') as Payment_values
from orders as O
join payments as P on O.order_id=P.order_id
group by Day_end;

-- KPI 2 : Number of Orders with review score 5 and payment type as credit card.
select * from reviews;
select * from payments;

select count(P.order_id) as Total_Orders
from payments P
inner join reviews R on P.order_id=R.order_id
where R.review_score = 5
and P.payment_type = 'credit_card';

-- KPI 3 : Average number of days taken for order_delivered_customer_date for pet_shop
select * from products;
select * from orders;
select * from order_items;

select P.product_category_name,
round(avg(datediff(O.order_delivered_customer_date,O.order_purchase_timestamp))) as Avg_delivery_days
from orders O join
order_items OI on O.order_id=OI.order_id 
join products P
on OI.product_id=P.product_id
where P.product_category_name = 'Pet_shop'
group by P.product_category_name;

-- KPI 4 : Average price and payment values from customers of sao paulo city
select * from order_items;
select * from customers;
select * from payments;
select * from orders;

select A.Avg_price, B.Avg_payment
from (
select round(avg(I.price)) as Avg_price
from order_items I join orders O on I.order_id=O.order_id
join customers C on O.customer_id=C.customer_id
where C.customer_city = 'Sao Paulo'
) as A
cross join (
select round(avg(P.payment_value)) as Avg_payment
from payments P join orders O 
on P.order_id=O.order_id
join customers C on C.customer_id=O.customer_id
where C.customer_city = 'Sao Paulo') as B;

-- KPI 5 : Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select * from reviews;
select * from orders;

select R.review_score,
round(avg(datediff(O.order_delivered_customer_date,order_purchase_timestamp)),0) as 'Avg shipping days'
from orders as O
join reviews as R on R.order_id=O.order_id
group by R.review_score
order by R.review_score;
