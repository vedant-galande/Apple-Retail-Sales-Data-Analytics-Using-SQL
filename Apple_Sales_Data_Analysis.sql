-- Apple Sales Project - 1M rows sales dataset
SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM warranty;

-- Improving the Query Performance:

--1st INDEXING:

SELECT DISTINCT(store_id) FROM sales;

--There are '64' distinct values in rhe store_id and this column will be in used for JOINS, GROUP BY, and WHERE.
-- So lets apply INDEX on this.

-- Execution Time BEFORE Indexing = 118.5 ms
-- Planning Time BEFORE Indexing = 0.053 ms
EXPLAIN ANALYSE 
SELECT * 
FROM sales
WHERE product_id ='P-44';

CREATE INDEX sales_product_id 
ON sales(product_id);

EXPLAIN ANALYSE 
SELECT * 
FROM sales
WHERE product_id ='P-44';

-- Execution Time After INDEX = 3.66 ms
-- Planning Time After INDEX = 1.50 ms

--2nd INDEXING:
SELECT DISTINCT(store_id) 
FROM sales;

--There are '70' distinct values in rhe store_id and this column will be in used for JOINS, GROUP BY, and WHERE.
-- So lets apply INDEX on this.

EXPLAIN ANALYSE 
SELECT * 
FROM sales
WHERE store_id ='ST-31';

-- Execution Time BEFORE Indexing = 72.93 ms
-- Planning Time BEFORE Indexing = 0.063 ms

CREATE INDEX sales_store_id 
ON sales(store_id);


EXPLAIN ANALYSE 
SELECT * 
FROM sales
WHERE store_id ='ST-31';

-- Execution Time AFTER Indexing = 2.15 ms
-- Planning Time AFTER Indexing = 2.26 ms

--3rd INDEXING:

EXPLAIN ANALYSE
SELECT * 
FROM sales
WHERE sale_date = '2023-12-01';

-- Execution Time BEFORE Indexing = 120.79 ms
-- Planning Time BEFORE Indexing = 0.93 ms

CREATE INDEX sales_sale_year 
ON sales(sale_date);

EXPLAIN ANALYSE
SELECT * 
FROM sales
WHERE sale_date = '2023-12-01';

-- Execution Time AFTER Indexing = 0.87 ms
-- Planning Time AFTER Indexing = 1.44 ms

--Business Problems
--1) Find the number of stores in each country?
SELECT * 
FROM stores;

SELECT COUNT(store_id) AS total_stores, country 
FROM stores
GROUP BY 2
ORDER BY total_stores DESC;

--2) What is the total number of units sold by each store?

SELECT 
	sales.store_id,
	stores.store_name, 
	SUM(quantity) AS total_sales 
FROM sales
JOIN stores
	ON stores.store_id=sales.store_id
GROUP BY 
	sales.store_id,stores.store_name
ORDER BY total_sales DESC;

--3)How many sales occurred in December 2023?
SELECT * FROM sales;

1) Approach:

SELECT 
	SUM(quantity) 
FROM sales
WHERE EXTRACT(YEAR FROM sale_date) = '2023' 
	AND EXTRACT(MONTH FROM sale_date) = '12';

2) Approach:

SELECT 
	SUM(quantity)
FROM sales
WHERE sale_date BETWEEN '2023-12-01' AND '2023-12-31';

3) Approach:

SELECT 
	SUM(quantity)
FROM sales
WHERE TO_CHAR(sale_date, 'YYYY-MM') = '2023-12';

4) Approach:

SELECT 
	SUM(quantity)
FROM sales
WHERE sale_date >= '2023-12-01' 
	AND sale_date < '2024-01-01';

--4) How many stores have never had a warranty claim filed against any of their products?
SELECT * FROM warranty;

SELECT * FROM stores;

SELECT * FROM sales;

SELECT 
	COUNT(store_id) 
FROM stores 
WHERE store_id NOT IN(
	SELECT DISTINCT store_id 
	FROM sales s
	RIGHT JOIN warranty w 
	ON s.sale_id=w.sale_id
	);  


--5) What percentage of warranty claims are marked as "Warranty Void"? (Hard)!!

select * from warranty;

--1)Approach:

SELECT ROUND(
			COUNT(*)/ (SELECT COUNT(*) FROM warranty)::numeric * 100,2) 
FROM warranty 
WHERE repair_status='Warranty Void';


--2)Approach:

WITH void_count AS (
    SELECT COUNT(*) AS cnt 
	FROM warranty 
	WHERE repair_status = 'Warranty Void'
),
total_warr AS (
    SELECT COUNT(*) AS cnt 
	FROM warranty
)
SELECT 
	ROUND(void_count.cnt / total_warr.cnt::numeric *100,2) AS ratio
FROM void_count, total_warr;

-- 6) Which store had the highest total units sold in the last year?(Here the count or sum can be misleading 
--    if we dont know from which time fram we need values)

SELECT * FROM sales;

SELECT * FROM stores;

--1) Approach

SELECT 
	sales.store_id,
	stores.store_name, 
	SUM(sales.quantity) AS total_sales 
FROM sales
JOIN stores 
	ON stores.store_id=sales.store_id
WHERE EXTRACT(YEAR FROM sale_date) >= EXTRACT(YEAR FROM CURRENT_DATE)-1
GROUP BY 
	sales.store_id,
	stores.store_name
ORDER BY total_sales DESC
LIMIT 1;

--2) Approach
SELECT 
	store_id,
	SUM(quantity) AS total_sales 
FROM sales
WHERE sale_date >= CURRENT_DATE - interval '2 year' --here cant write a 1 year because no dates are available
GROUP BY store_id
ORDER BY total_sales DESC
LIMIT 1;

--7) Count the number of unique products sold in the last year.
SELECT * FROM sales;

-- unique produt sold last year are

SELECT DISTINCT 
	product_id AS total_sales 
FROM sales 
WHERE EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)-1;

--Count of those unique products
SELECT 
	COUNT(DISTINCT product_id) AS total_sales 
FROM sales 
WHERE EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)-1;

-- Total number of unique product sold last year

SELECT 
	product_id,
	COUNT(*) AS total_sales 
FROM sales 
WHERE EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)-1
GROUP BY product_id 
ORDER BY total_sales DESC;


--8)What is the average price of products in each category?

SELECT * FROM products;
SELECT * FROM category;


SELECT 
	category.category_name,
	products.category_id, 
	AVG(products.price) AS avg_price
FROM products
JOIN category 
	ON products.category_id=category.category_id 
GROUP BY 
	category.category_name,
	products.category_id
ORDER BY avg_price DESC;

--9)How many warranty claims were filed in 2020?

SELECT * FROM warranty;
--1) Approach 1
SELECT 
	COUNT(*) AS total_claims 
FROM warranty
WHERE to_char(claim_date,'YYYY')='2020';

--2) Approach 2

SELECT 
	COUNT(*) AS total_claim
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date)=2020;

--10) Identify each store and best selling day based on highest qty sold

SELECT * FROM sales;

SELECT 
	store_id, 
	sale_date, 
	total_qty,
	TO_CHAR(sale_date,'Day') AS Sales_Day
FROM (
    SELECT store_id,
           sale_date,
           SUM(quantity) AS total_qty,
           RANK() OVER (PARTITION BY store_id ORDER BY SUM(quantity) DESC) AS rnk
    FROM sales
    GROUP BY store_id, sale_date
) ranked
WHERE rnk = 1;

--11) Identify least selling product of each country for each year based on total unit sold


SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM products;

WITH cte AS (
	SELECT 
		EXTRACT(YEAR FROM s.sale_date) AS YEAR,
		SUM(s.quantity) AS total,
		s.product_id,
		p.product_name,
		st.country, 
		RANK() OVER (
			PARTITION BY EXTRACT(YEAR FROM s.sale_date), country 
			ORDER BY SUM(quantity) ASC
		) AS rnk 
	FROM sales s
	LEFT JOIN stores st 
		ON st.store_id=s.store_id
	LEFT JOIN products p 
		ON p.product_id=s.product_id
	GROUP BY 
		EXTRACT(YEAR FROM s.sale_date),
		st.country,
		s.product_id,
		p.product_name
	ORDER BY YEAR,country,total ASC
)
SELECT * 
FROM cte 
WHERE rnk='1';

--12) How many warranty claims were filed within 180 days of a product sale?
SELECT * FROM sales;
SELECT * FROM warranty;

--Correct Way
SELECT 
	COUNT(*) AS claims
FROM (
	SELECT 
		s.sale_date,
		w.claim_date,
		w.claim_date-s.sale_date AS days 
	FROM sales s
	JOIN warranty w 
		ON s.sale_id=w.sale_id
	WHERE claim_date-sale_date <= 180
	);

-- 13) How many warranty claims have been filed for products launched in the last two years?
-- REMEBER: This question is ambiguous. You have to ask stake holder about what he want
-- the interval approach (from today’s date going back exactly 2 years) or Calendar years (year-based)

SELECT * FROM products
SELECT * FROM warranty
SELECT * FROM sales

--1) interval approach (from today’s date going back exactly 2 years)
SELECT p.product_name, EXTRACT(YEAR FROM p.launch_date) AS YEAR, COUNT(w.claim_id) AS no_claim
FROM warranty AS w
JOIN sales AS s
ON s.sale_id=w.sale_id
JOIN products AS p
ON p.product_id=s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 1,2;

--2) Calendar years (year-based)

WITH cte AS (
	SELECT * 
	FROM (SELECT *,EXTRACT(YEAR FROM launch_date) AS YEAR FROM products) 
WHERE YEAR >= EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '2 year')))

SELECT 
	c.product_name,
	c.year,
	COUNT(*) AS total_claims 
FROM sales s 
	JOIN warranty w ON s.sale_id=w.sale_id
	JOIN cte c ON c.product_id=s.product_id
GROUP BY c.product_name,c.year;


--14) List the month in all years where sales exceeded 5000 units from usa.
SELECT * FROM sales;
SELECT * FROM stores;

WITH cte AS (
	SELECT 
		s.store_id,
		s.product_id,
		s.quantity,
		s.sale_date,
		st.country 
	FROM sales s
	LEFT JOIN stores st 
		ON s.store_id=st.store_id
)

SELECT * 
FROM (
	SELECT country,
		EXTRACT(MONTH FROM sale_date) AS MONTH,
		SUM(quantity) AS total_sales,
		EXTRACT(YEAR FROM sale_date) AS YEAR 
	FROM cte 
	GROUP BY 
		country,
		MONTH,
		YEAR
	) 
WHERE country='USA' AND total_sales >= '5000'
ORDER BY YEAR,total_sales DESC


--15) Which product category had the most warranty claims filed in 2022 and 2023?
SELECT * FROM products
SELECT * FROM sales
SELECT * FROM warranty
SELECT * FROM category

WITH cte AS 
	(
	SELECT 
		*,
		EXTRACT(YEAR FROM w.claim_date) AS YEAR 
	FROM warranty w 
	LEFT JOIN sales s 
	ON s.sale_id=w.sale_id
	LEFT JOIN products p 
	ON s.product_id=p.product_id
	),

cte_2 AS ( 
	SELECT 
		YEAR,
		category_id,
		COUNT(*) AS total_claims,
		RANK()OVER(PARTITION BY YEAR ORDER BY COUNT(*) DESC) AS rnk 
	FROM cte
		WHERE YEAR = 2022 OR YEAR = 2023
	GROUP BY YEAR,category_id
	ORDER BY YEAR,total_claims DESC
		)
SELECT 
	YEAR,
	total_claims,
	ct.category_id,
	ca.category_name 
FROM cte_2 ct 
LEFT JOIN category ca 
ON ct.category_id=ca.category_id
WHERE rnk=1