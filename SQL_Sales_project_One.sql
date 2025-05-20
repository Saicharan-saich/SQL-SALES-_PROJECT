
USE [Project 1]
--Data Cleaning--
SELECT *
FROM Sales
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY

update sales
set cogs = COALESCE(cogs,0)

alter table sales
alter column total_sale money
sp_help sales

delete from sales
where cogs IS NULL or total_sale IS NULL

SELECT *
FROM Sales
ORDER BY transactions_id ASC
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY

sp_help sales

--Sales Analysis_Project_One
--what are total sales?
select count(*) as total_sales
from sales
--How many unique customers we have?
select count(distinct customer_id) as total_customers
from sales
--How many categories we have?
select distinct category as categories from sales
--Data analysis 
--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from Sales
where sale_date = '2022-11-05'
--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 1
-- in the month of Nov-2022
select * from Sales
where category = 'Clothing' and quantiy>=4 and MONTH(sale_date) = 11


--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales from Sales
group by category
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as avg_age from Sales
where category = 'Beauty'
--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from Sales
where total_sale > 1000
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender, count(transactions_id) as txn_count from Sales
group by category,gender
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with CTE_AVGSALES as
(select year(sale_date) as years,month(sale_date) as months,  avg(total_sale) as avg_sale
from Sales
group by year(sale_date),month(sale_date))
select * from CTE_AVGSALES
where avg_sale in  (
select max(avg_sale) from CTE_AVGSALES
group by years)

USE [Project 1]

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as total_Sales
from Sales
group by customer_id
order by total_Sales Desc
offset 0 rows
fetch first 5 rows only
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select distinct customer_id,count(category) as count from Sales
where transactions_id is NOT NULL and category in('Beauty','Clothing','Electronics')
group by customer_id

SELECT
  customer_id
FROM Sales
WHERE
  category IN ('Beauty', 'Clothing', 'Electronics')
GROUP BY
  customer_id
HAVING
  COUNT(DISTINCT category) = 3
--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select (case
		when datepart(HOUR,sale_time)<=12 then 'Morning'
		when datepart(HOUR,sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
		end) as shift_,count(total_sale) as number_orders
		from Sales
		group by (case
		when datepart(HOUR,sale_time)<=12 then 'Morning'
		when datepart(HOUR,sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
		end)

--End of Sales Project-- 