-- SQL Retail Sales Analysis - P1
-- Create TABLE
drop table if exists retail_sales;
create table retail_sales
	(
    transactions_id int primary key,
	sale_date	date,
    sale_time	time,
	customer_id	int,
	gender	varchar(15),
	age	int,
	category	varchar(20),
	quantiy	int,
	price_per_unit	float,
	cogs	float,
	total_sale	float
	);
select*from retail_sales
limit 20

select
	count(*)
from retail_sales

select*from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or 
cogs is null
or
total_sale is null;

delete from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or 
cogs is null
or
total_sale is null;

-- data exploration

-- How many sales we have
select count(*) as total_sale from retail_sales

-- How many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales

--How many unique categories we have?
select distinct category from retail_sales


-- Data Analysis & Business key Problems & Answers

-- Q.1 Write SQL query to retrieve all columns for sales made on '-2022-11-05

select *
from retail_sales
where sale_date = '2022-11-05';

--Q.2 Write a SQL query to retrieve all tyransactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select *
from retail_sales
where category = 'Clothing'
	and
	to_char(sale_date, 'yyyy-mm') = '2022-11'
and 
quantiy >= 4

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1

--Q.4 Write SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
round(avg(age),2) as AVG_AGE
from
retail_sales
where category = 'Beauty'

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select*from retail_sales
where total_sale >= 1000

--Q.6 Write a SQL query  to find the total number of transactions(transaction_id) made by each gender in each category.

select 
	category,
	gender,
count(*) as total_transactions
from retail_sales
group by
	category,
	gender

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select
	year,
	month,
	avg_sale
	from
	(
	select
	extract (year from sale_date) as year,
	extract (month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg (total_sale) desc) as Rank
from retail_sales
group by 1,2
	) as T1
where rank = 1

--Q.8 Write a SQL query to find the top 5 customer based on the highest total sales

select 
	customer_id,
	sum(total_sale) as Total_sales
From retail_sales
group by 1
order by 2 desc
limit 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
	count(distinct customer_id) as Cnt_Unique_cs
from retail_sales
group by category

--Q.10 Write a SQL query to find the number of Repeated customers who purchased items from each category.

	select 
	customer_id,
	count(customer_id)
from retail_sales
group by customer_id
having count(customer_id)>1
order by count(customer_id) desc
limit 5

--Q.11 Write a SQL query to create each shift and number of orders
with hourly_sale
	as
	(
select *,
case 
when extract (hour from sale_time)<12 then 'Morning'
when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
	end as shift
from retail_sales
	)
select
	shift,
count (*) as total_orders
from hourly_sale
group by shift

--End of Project