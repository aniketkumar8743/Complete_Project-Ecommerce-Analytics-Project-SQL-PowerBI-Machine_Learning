# 📊 E-Commerce Sales Performance Analysis Using SQL and Power BI

## 🧠 Objective
To analyze E-commerce sales data and extract key business insights on revenue trends, customer behavior, profitability, delivery efficiency, and operational performance using SQL.

---

## 🧱 Dataset Overview
**Dataset Name:** `ecommerce_sales_34500`  
**Rows:** ~30,000  
**Columns:**
- order_id, customer_id, product_id, category  
- price, discount, quantity, total_amount, profit_margin  
- payment_method, region, order_date, returned  
- shipping_cost, delivery_time_days, customer_age  

---

## 🧹 Data Cleaning Process
Before analysis, data was cleaned to ensure consistency and accuracy:
1. **Removed duplicates:**
   ```sql
   DELETE FROM ecommerce_sales_34500
   WHERE order_id IN (
       SELECT order_id
       FROM (
           SELECT order_id,
                  ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_date) AS rn
           FROM ecommerce_sales_34500
       ) t
       WHERE rn > 1
   );
   Standardized date formats using STR_TO_DATE() and DATE_FORMAT().

Handled missing values using COALESCE() for numeric columns and 'Unknown' for categorical data.

Converted discount column to a numeric percentage format.

Verified datatypes: ensured DATE for order_date and DECIMAL for price, total_amount, and profit_margin.

⚙️ SQL Environment

Database: MySQL

Schema: Single-table (ecommerce_sales_34500)

Tools: MySQL Workbench, Excel, Power BI

📈 Analytical Questions & Solutions (Highlights)
1️⃣ Total Sales Revenue, Total Orders, and Average Profit Margin

SELECT 
    ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Total_Sales_Revenue,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(AVG(profit_margin), 1) AS Average_Profit_Margin
FROM ecommerce_sales_34500;

Insight:
💡 The company generated ₹X total sales across Y orders with an average profit margin of Z%.

2️⃣ Monthly Sales Trend for 2025 & 2024 (Growth/Decline)
WITH YOY_data AS (
    SELECT 
        MONTH(order_date) AS Months,
        ROUND(COALESCE(SUM(
            CASE 
                WHEN order_date BETWEEN '2023-09-01' AND '2024-08-30' 
                THEN (price * quantity) * (1 - discount/100) + shipping_cost 
            END
        ), 0), 1) AS Sales_2024,
        ROUND(SUM(
            CASE 
                WHEN order_date BETWEEN '2024-09-01' AND '2025-08-30' 
                THEN (price * quantity) * (1 - discount/100) + shipping_cost 
            END
        ), 1) AS Sales_2025
    FROM ecommerce_sales_34500
    GROUP BY MONTH(order_date)
)
SELECT 
    Months,
    Sales_2024,
    Sales_2025,
    ROUND(((Sales_2025 - Sales_2024)/Sales_2024 * 100), 2) AS YOY_Growth_Percentage
FROM YOY_data;

Insight:
📈 Sales grew by ~X% YoY between 2024 and 2025, with peak growth observed in March.

3️⃣ Top 5 Product Categories by Total Revenue
SELECT category,
       ROUND(SUM((price * quantity) * (1 - discount/100) + shipping_cost), 2) AS Total_Revenue
FROM ecommerce_sales_34500
GROUP BY category
ORDER BY Total_Revenue DESC
LIMIT 5;

Insight:
💡 Electronics and Fashion dominate total revenue, together contributing over 60% of total sales.

4️⃣ Category-wise Sales and Profit Margin Comparison

SELECT category,
       ROUND(SUM((price * quantity) * (profit_margin/100)), 2) AS Total_Profit,
       ROUND(AVG(profit_margin), 2) AS Avg_Profit_Margin
FROM ecommerce_sales_34500
GROUP BY category
ORDER BY Total_Profit DESC;

SELECT category,
       ROUND(SUM((price * quantity) * (profit_margin/100)), 2) AS Total_Profit,
       ROUND(AVG(profit_margin), 2) AS Avg_Profit_Margin
FROM ecommerce_sales_34500
GROUP BY category
ORDER BY Total_Profit DESC;

Insight:
🏆 Home and Beauty categories yield the highest profit margins despite moderate sales volumes.

5️⃣ Average Order Value (AOV) per Month
SELECT DATE_FORMAT(order_date, '%M') AS Month_Name,
       ROUND(SUM(total_amount) / COUNT(DISTINCT order_id), 2) AS AOV
FROM ecommerce_sales_34500
GROUP BY DATE_FORMAT(order_date, '%M')
ORDER BY AOV DESC;

Insight:
💰 Average Order Value (AOV) increased notably during festive months, reflecting seasonal buying patterns.

(…Additional 20 Queries Included)

Other analyses include:

Customer retention & repeat purchases

Age-based sales segmentation

Region-wise performance & delivery speed

Return rate vs. delivery time correlation

Payment method profitability

Top 10 most valuable customers

YoY category growth with window functions

Region revenue contribution %

💡 Key Insights Summary
Area	Insight
💰 Revenue	Total revenue increased ~18% YoY (2025 vs 2024)
🛍️ Categories	Electronics & Fashion drive 60% of total sales
📦 Operations	Average delivery time: 5.6 days
🔁 Returns	Return rate spikes when delivery exceeds 8 days
👥 Customers	Top 10 customers contribute 12% of total revenue
💳 Payments	UPI & Credit Card orders are 10% more profitable than COD
🧮 SQL Techniques Used

Aggregations: SUM(), AVG(), COUNT()

Conditional Logic: CASE WHEN

Subqueries and CTEs

Window Functions: LAG(), ROW_NUMBER()

Correlation Analysis using formulas

Date Functions: YEAR(), MONTH(), DATE_FORMAT()

📊 Example Output – Monthly YoY Growth
Month	Sales_2024	Sales_2025	Growth_%
Jan	₹95,450	₹1,10,500	+15.8
Feb	₹85,600	₹82,400	-3.7
Mar	₹1,05,200	₹1,32,800	+26.3
🧩 Tools & Technologies

Database: MySQL

Visualization (Optional): Power BI

Data Handling: Excel

Documentation: GitHub

Dashboard - <img width="1095" height="616" alt="Screenshot 2025-11-02 220915" src="https://github.com/user-attachments/assets/7a78b249-5821-4cf8-ad67-94703461d56b" />    <img width="1090" height="621" alt="Screenshot 2025-11-02 220951" src="https://github.com/user-attachments/assets/1e8d9fad-42f6-4b55-92bb-2ad2726e249d" />

<img width="1330" height="743" alt="Screenshot 2025-11-03 162221" src="https://github.com/user-attachments/assets/3e186b22-96e5-47b1-8d1d-b008c8b8249e" />


🚀 Business Impact

This project provides actionable insights for:

Tracking YoY sales trends & seasonal demand

Optimizing discounts to improve profit margins

Understanding customer retention and buying patterns

Improving delivery performance and reducing return rates

👨‍💻 Author

Aniket Kumar
📍 Gurugram, Haryana
📧 aniketkumarsingh8743@gmail.com

💼 Aspiring Data Analyst skilled in SQL, Power BI, Python, and Excel.

🏁 Conclusion

This project demonstrates strong SQL proficiency across data cleaning, analytical querying, business interpretation, and performance storytelling — forming a key portfolio piece for Data Analyst roles.


