 /** 1️ Total Sales Revenue, Total Orders, and Average Profit Margin.
-- use e_commerce
select * from ecommerce_sales_34500
SELECT 
    round(sum((price*quantity)*(1-discount/100)+shipping_cost),2) AS Total_sales_revenue,
    COUNT(DISTINCT order_id) AS Total_orders,
    Round(AVG(profit_margin),1)AS Average_Profit_Margin
FROM
    ecommerce_sales_34500 
    
2. Monthly Sales Trend for 2025 & 2024 (find growth/decline).
with YOY_data as (select 
Month(order_date) as Months,
round(COALESCE(sum(case when order_date >= '2023-09-01' and order_date <= '2024-08-30' then (price * quantity) * (1-discount/100) + shipping_cost  END),0),1) as Sales_2024,
round(sum(case when order_date >= '2024-09-01' and order_date <= '2025-08-30' then (price * quantity) * (1-discount/100) + shipping_cost END),1) as Sales_2025
 from ecommerce_sales_34500 
 group by Month(order_date)
 order by Month(order_date))
 
 select Months, Sales_2024, Sales_2025,
 Round(((Sales_2025 - Sales_2024)/ Sales_2024 * 100),2) as YOY_Growth_Percentage
 from YOY_data

 
 3. Top 5 Product Categories by Total Revenue 
SELECT 
    category,
    ROUND(SUM((price * quantity) * (1 - discount / 100) + shipping_cost),
            2) AS Total_Revenue
FROM
    ecommerce_sales_34500
GROUP BY category
ORDER BY Total_Revenue DESC
LIMIT 5

4. Category-wise Sales and Profit Margin comparison. 
select category, Round(sum((price*quantity)*(profit_margin/100)),2) as Total_profit,
Round(Avg(profit_margin),2) as Average_Profit_Margin from ecommerce_sales_34500
group by category
order by Total_profit Desc

5. Average Order Value (AOV) per Month 
select date_format(order_date , '%M') as month_name,
round(sum(total_amount) /count(distinct order_id),2) as AOV
 from ecommerce_sales_34500
 group by date_format(order_date , '%M')
 order by AOV Desc

6. Total Customers who made purchases in 2024. 
select count(distinct customer_id) as Total_customer from ecommerce_sales_34500
where year(order_date) = 2024

7. Number of Repeat Customers (customers with >1 order)
with Ranked_order as ( select
customer_id,
count(distinct order_id) as number_of_order
from ecommerce_sales_34500
group by customer_id)
select count(distinct customer_id) as Repeat_customer from Ranked_order
where number_of_order > 1

8. Customer Segmentation: Average Sales by Age Group (18–25, 26–35, 36–45, etc.).
select 
case when customer_age >=18 and customer_age <=25 then '18-25' 
when customer_age >=26 and customer_age <=35 then '26-35'
when customer_age >=36 and customer_age <=45 then '36-45'
when customer_age >=46 and customer_age <=55 then '46-55'
when customer_age >=56 and customer_age <=65 then '56-65'
when customer_age > 65 then '66+' END as Age_group ,
round(avg(total_amount+shipping_cost),2) as avg_sales
from ecommerce_sales_34500
group by Age_group
order by avg_sales DESC

9. Identify the region with the highest customer retention (repeat buyers) 
with repeat_customer as (select region, customer_id,count(customer_id)
from ecommerce_sales_34500
group by region, customer_id
having count(customer_id) > 1) 

select region, COUNT(DISTINCT customer_id) as Repeat_buyer 
from repeat_customer
group by region
order by Repeat_buyer DESC

10. Customers who returned products more than 2 times.
select customer_id, count(order_id) as order_count
from ecommerce_sales_34500
where returned = 'Yes'
group by customer_id
having count(order_id) > 2

11. Category with Highest and Lowest Average Profit Margin.
with final_table as (select category,
Round(avg(profit_margin),2) as avg_Profit_margin
 from ecommerce_sales_34500
group by category)

select category , avg_profit_margin
from final_table
where avg_profit_margin = (select max(avg_Profit_margin) as Highest_Average_Profit_margin from final_table)
OR avg_profit_margin = (select min(avg_Profit_margin) as Lowest_Average_Profit_margin from final_table)

13. Top 5 Regions by Total Profit.
select region , ROUND(SUM((price * quantity) * (profit_margin / 100)), 2) as Total_profit
from ecommerce_sales_34500
group by region
order by Total_profit DESC
Limit 5

14. Average Shipping Cost vs. Profit Margin — does faster shipping affect profit? 
SELECT 
    ROUND(AVG(shipping_cost), 2) AS Avg_Shipping_Cost,
    ROUND(AVG(profit_margin), 2) AS Avg_Profit_Margin,
    ROUND(
        (
            (COUNT(*) * SUM(shipping_cost * profit_margin)) - 
            (SUM(shipping_cost) * SUM(profit_margin))
        ) /
        SQRT(
            (COUNT(*) * SUM(POWER(shipping_cost, 2)) - POWER(SUM(shipping_cost), 2)) *
            (COUNT(*) * SUM(POWER(profit_margin, 2)) - POWER(SUM(profit_margin), 2))
        ),
        3
    ) AS Shipping_Profit_Correlation
FROM ecommerce_sales_34500;

15. Payment Method Preference vs. Profit (e.g., are COD orders less profitable?).
select 
payment_method,
round(avg(profit_margin),2) as avg_profit_margin,
ROUND(SUM(total_amount - shipping_cost), 2) AS total_profit,
    COUNT(order_id) AS total_orders
 from ecommerce_sales_34500
 group by payment_method
 order by  avg_profit_margin DESC
 
 16. Average Delivery Time per Region. 
 select Region , Round(Avg(delivery_time_days),0) as Avg_Delivery_time from ecommerce_sales_34500
 group by Region
 order by Avg_Delivery_time Desc
 
 17. Find Regions or Categories where Delivery Time > 7 Days 
 select region, category,delivery_time_days, count(*) as delayed_orders from ecommerce_sales_34500
 where delivery_time_days > '7'
 group by region, category,delivery_time_days
 order by delayed_orders DESC
 
 18. Relationship between Delivery Time and Return Rate.
select delivery_time_days,
count(*) as total_order,
sum(case when returned = 'Yes' then 1 else 0 end) as returned_order,
round(sum(case when returned = 'Yes' then 1 else 0 end)*100/ count(*),2) as return_rate_percent
from ecommerce_sales_34500
group by delivery_time_days
order by delivery_time_days

19. Total Number of Returned Orders by Category. 
select 
category,
sum(case when returned = 'Yes' then 1 else 0 end) as Returned_orders
from ecommerce_sales_34500
group by category
order by Returned_orders Desc
 
20. Month with the Highest Return Percentage. 
select date_format(order_date,'%M') as Months,
sum(case when returned = 'Yes' then 1 else 0 End) as return_orders,
Round((sum(case when returned = 'Yes' then 1 else 0 End)*100/count(*)),2) as Percent_return_order
from ecommerce_sales_34500
group by date_format(order_date,'%M')
order by Percent_return_order DESC
limit 1

21. Rank categories by Year-over-Year (YoY) Sales Growth using a window function.
with sales_by_years as (
select category, Year(order_date) as Years, Round(sum((price*quantity)*(1-discount/100)+shipping_cost),2) as Total_sales
 from ecommerce_sales_34500
 group by category, Year(order_date) ),
 yoy_growth as (
 select category, years,total_sales,
 lag(total_sales) over (partition by category order by years ) as Prev_year_sales,
 Round(((total_sales) - lag(total_sales) over (partition by category order by years))/ lag(total_sales) over (partition by category order by years) *100,2) as Yoy_growth_percent
 from sales_by_years)
select category, years, total_sales, Yoy_growth_percent,
 row_number() over (order by Yoy_growth_percent DESC) as rank_by_growth
 from yoy_growth
 where Yoy_growth_percent is not null
 order by rank_by_growth

22. Compute the Percentage Contribution of each Region to Total Revenue.
select region, 
count(*) as order_number,
ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Region_Revenue,
ROUND(
        (SUM((price * quantity) * (1 - discount/100) + shipping_cost) * 100) /
        (SELECT SUM((price * quantity) * (1 - discount/100) + shipping_cost) FROM ecommerce_sales_34500),
    2) AS Percentage_Contribution
FROM ecommerce_sales_34500
GROUP BY region
ORDER BY Percentage_Contribution DESC;

23. Compare the Share of Payment Methods between Years.
select payment_method,YEAR(order_date) AS Years,ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Total_Revenue,
ROUND((SUM((price * quantity) * (1 - discount/100) + shipping_cost) * 100) /
        SUM(SUM((price * quantity) * (1 - discount/100) + shipping_cost)) OVER (PARTITION BY YEAR(order_date)),2) as Payment_Share_Percentage
 FROM ecommerce_sales_34500
 group by payment_method,YEAR(order_date)
 ORDER BY Years, Payment_Share_Percentage DESC
 
 24. Create a Moving Average of Monthly Sales. 
SELECT 
    DATE_FORMAT(order_date, '%m') AS Month,
    ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Monthly_Sales,
    ROUND(
        AVG(SUM((price * quantity) * (1 - discount/100) + shipping_cost)) 
        OVER (ORDER BY DATE_FORMAT(order_date, '%m') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    2) AS Moving_Avg_Sales
FROM ecommerce_sales_34500
GROUP BY DATE_FORMAT(order_date, '%m')
ORDER BY Month;

25. Find the Top 10 Most Valuable Customers (by Total Purchase Value). **/
select customer_id, ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Total_Purchase_Value 
from ecommerce_sales_34500
group by customer_id
order by Total_Purchase_Value Desc
Limit 10


 







 












 
 
 
 