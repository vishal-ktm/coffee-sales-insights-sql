CREATE SCHEMA coffee_shop_db;
use coffee_shop_db;

SELECT * FROM coffee_shop_sales;

SET SQL_SAFE_UPDATES = 0;

DESCRIBE coffee_shop_sales;

-- CONVERT DATE (transaction_date) COLUMN TO PROPER DATE FORMAT
UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

-- ALTER DATE (transaction_date) COLUMN TO DATE DATA TYPE
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

-- CONVERT TIME (transaction_time)  COLUMN TO PROPER DATE FORMAT
UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

-- ALTER TIME transaction_time COLUMN TO DATE DATA TYPE
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

-- DATA TYPES OF DIFFERENT COLUMNS
DESCRIBE coffee_shop_sales;
SELECT * FROM coffee_shop_sales;

-- CHANGE COLUMN NAME ï»¿transaction_id to transaction_id
ALTER TABLE coffee_shop_sales
CHANGE COLUMN `ï»¿transaction_id` transaction_id INT; 

-- KPI's (Key Performance Indicator) Requirements in sales :
-- total sales in coffee shop
SELECT ROUND(SUM(unit_price * transaction_qty)) as total_sales
FROM coffee_shop_sales;

-- total sales in the month of may 
SELECT ROUND(SUM(unit_price * transaction_qty)) as total_sales
FROM coffee_shop_sales WHERE month(transaction_date)=5;

-- total sales in the all month  
 SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (1,2,3,4,5,6) 
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- calculating avg sale in the year of 2023
SELECT AVG(transaction_qty * unit_price) AS avg_sale_2023
FROM coffee_shop_sales
WHERE YEAR(transaction_date) = 2023;

-- sale of hot chocalte different sote locations
SELECT transaction_id,store_location,product_type 
FROM coffee_shop_sales 
where product_type = "Hot chocolate";

-- KPI's (Key Performance Indicator) Requirements in orders:
-- total orders in may month
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5;

-- total orders in the all month
SELECT 
    MONTH(transaction_date) AS month,
     COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (1,2,3,4,5,6)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- total orders in bakery 
SELECT COUNT(*) AS total_orders_bakery
FROM coffee_shop_sales
WHERE product_category = 'Bakery';

-- KPI's (Key Performance Indicator) Requirements in Quantity:
-- total quantity sold 
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales ;

-- total quatity sold in each month 
SELECT 
    MONTH(transaction_date) AS month,
 SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (1,2,3,4,5,6) 
GROUP BY MONTH(transaction_date);

-- SALES TREND OVER PERIOD
-- report the total sale,quantity sold and orders on the of 18th jan 2023 
SELECT SUM(unit_price * transaction_qty) AS total_sales,
       SUM(transaction_qty) AS total_quantity_sold,
       COUNT(transaction_id) AS total_orders
FROM coffee_shop_sales
WHERE transaction_date = '2023-01-18';

-- overall avg sales 
SELECT AVG(total_sales) AS average_sales
FROM (SELECT SUM(unit_price * transaction_qty) AS total_sales
	FROM coffee_shop_sales ) AS overall_avg_sales;
    
-- setting a case for sales in feb month
SELECT day_of_month,
CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
        END AS sales_status,
        total_sales
FROM (SELECT DAY(transaction_date) AS day_of_month,
			SUM(unit_price * transaction_qty) AS total_sales,
			AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 2 
    GROUP BY DAY(transaction_date)) AS sales_data
ORDER BY day_of_month;

-- total sales on the month if april and may by day wise 
SELECT DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) in (4,5)
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date);

-- sales by product  catagory wise
SELECT product_category,ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) in (1,2,3,4,5,6) 
GROUP BY product_category;

-- sales by store location wise
SELECT store_location,SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
GROUP BY store_location;

-- max sale in march at  each locatiom
SELECT store_location,max(unit_price * transaction_qty) as max_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) =3
GROUP BY store_location;

-- max sale in jan by each products
SELECT product_category,max(unit_price * transaction_qty)as Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) =1
GROUP BY product_category;

































