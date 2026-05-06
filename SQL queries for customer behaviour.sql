select * from customer limit 10

--male vs female generated revenue

select gender, SUM(purchase_amount) as revenue
from customer
group by gender

--used discount but still spent more than average purchase
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount>= (select avg(purchase_amount) from customer)

--top five products with highest avg review rating
select item_purchased , avg(review_rating) as "average product rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--purchase amounts = standard vs express shipping
select shipping_type,
ROUND(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--subscribers vs non subscribers
select subscription_status,
count(customer_id)as total_customers,
round(avg(purchase_amount),2)as avg_spend,
round(sum(purchase_amount),2)as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend
desc;

--top 5 products with highest percent of discount applied

select item_purchased,
round(100*sum(case when discount_applied = 'Yes'then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--segment customers into new, returing and loyal
with customer_type as (
select customer_id , previous_purchases,
case 
when previous_purchases = 1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as customer_segment
from customer
)

select customer_segment, count(*) as "number of customer"
from customer_type
group by customer_segment

--top 3 most purchased products within each category
with item_counts as (
select category,
item_purchased,
count(customer_id)as total_orders,
row_number() over(partition by category order by count (customer_id)desc)as item_rank
from customer
group by category, item_purchased

)
select item_rank , category, item_purchased , total_orders
from item_counts
where item_rank <=3;

--customers with more than 5 purchases are more likely to subscribe ?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status

--revenue contribution of each age group
select age_group,
sum(purchase_amount)as total_revenue
from customer
group by age_group
order by total_revenue desc;


