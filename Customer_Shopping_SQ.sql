SHOW DATABASES;

select * from customers limit 20;

-- Q1 What is the total revenue genearted by male vs female?
select gender, sum(purchase_amount) as Total_revenue
from customers
group by gender;

-- Q2 which customers used a discount  but still spent more than the average puchase amount?
select customer_id, purchase_amount
from customers
where discount_applied='Yes' and purchase_amount>= (select avg(purchase_amount) from customers);

-- Q3 Which are the top 5 products with the higest average review rating?
select item_purchased, round(avg(review_rating),2) as highest_avg_rating from customers
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4 Compare the average purchase Amounts between Standard and Express Shipping?
select shipping_type,avg(purchase_amount) as avg_amount 
from customers
where shipping_type in ('Standard','Express')
group by shipping_type
;

-- Q5 Do Subscried customers spend more? Compare Average spend total and total revenue b/w subscriber and non-sub?
select count(customer_id) as Total_count,subscription_status, sum(purchase_amount) as total_revenue, avg(purchase_amount) as avg_spend
from customers
group by subscription_status;

-- Q6 Which 5 products have the higest perecntage of purchase with discount applied?
select item_purchased, round(sum(discount_applied= 'yes')/count(*)* 100,2) as discount_rate
from customers
group by item_purchased
order by discount_rate desc
limit 5;

-- Q7 Segment customers into New, Returning and Loyal based on their total number of previuos purchases
-- and show the count of each segment?
with customer_type as (
select customer_id, previous_purchases,
case
    When previous_purchases= 1 then "New"
    when previous_purchases between 2 and 10 then "Returning"
    else "Loyal"
    end as customer_segment
from customers
)
select customer_segment, count(*) as "number of customers"
from customer_type
group by customer_segment
;

-- Q8 What are the top 3 most purchased products within each category?
with item_counts as(
select category, item_purchased, count(customer_id)as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customers
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;

-- Q9 Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status, count(customer_id) as repeat_buyers
from customers
where previous_purchases>5
group by subscription_status;

-- Q10 what is the revenue contibution of each age group?
select age_group, sum(purchase_amount) as revenue
from customers
group by age_group
order by revenue desc;

