# Apple Retail Sales Data Analytics Using SQL  

## 📑 Table of Contents
- [Abstract](#abstract)
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Database Schema](#database-schema)
- [Performance Optimization](#performance-optimization)
- [Business Problems Solved](#business-problems-solved)
- [Conclusion](#conclusion)

---

## Abstract  
A SQL-based project analyzing **1 million rows of Apple retail sales data**, optimized with indexing and advanced query techniques to uncover business insights, improve query performance, and support strategic decision-making.  

---

## Project Overview  
The dataset simulates a realistic Apple retail sales environment with details on **stores, products, categories, sales, and warranty claims**.  
This project focuses on:  
1. Designing a relational schema and creating normalized tables.  
2. Conducting **Exploratory Data Analysis (EDA)**.  
3. Applying **query optimization techniques**, including indexing.  
4. Solving complex business problems through SQL queries.  

---

## Key Features  
- **Database Schema**: Designed a relational model with five core tables – *stores, products, category, sales, warranty*.  
- **Performance Optimization**: Applied indexing on frequently queried columns (`product_id`, `store_id`, `sale_date`, `quantity`), reducing query execution time from **~118 ms to ~3 ms**.  
- **Business Analysis**: Addressed real-world scenarios such as sales trends, warranty claim patterns, and product performance evaluation.  
- **Advanced Querying**: Utilized window functions, subqueries, CTEs, and aggregate functions for in-depth analysis.  

---

## Database Schema  
The project uses five main tables:  

1. **stores** – Apple retail store details  
   - `store_id`, `store_name`, `city`, `country`  

2. **category** – Product categories  
   - `category_id`, `category_name`  

3. **products** – Product details  
   - `product_id`, `product_name`, `category_id`, `launch_date`, `price`  

4. **sales** – Sales transactions  
   - `sale_id`, `sale_date`, `store_id`, `product_id`, `quantity`  

5. **warranty** – Warranty claims  
   - `claim_id`, `claim_date`, `sale_id`, `repair_status`  

---

## Performance Optimization  

1. **`sales(product_id)`** – Product-based analysis  
   - Execution time reduced: **118.5 ms → 3.66 ms**  
   - Planning time: **0.053 ms → 1.50 ms**  

2. **`sales(store_id)`** – Store-level queries  
   - Execution time reduced: **72.93 ms → 2.15 ms**  
   - Planning time: **0.063 ms → 2.26 ms**  

3. **`sales(sale_date)`** – Date-based analysis  
   - Execution time reduced: **120.79 ms → 0.87 ms**  
   - Planning time: **0.93 ms → 1.44 ms**  

⚡ These optimizations achieved up to **139x faster execution**, making analysis on 1M+ rows highly efficient.  

---

## Business Problems Solved  

1. Find the number of stores in each country.  
2. Calculate the total number of units sold by each store.  
3. Determine sales recorded in December 2023.  
4. Identify stores with no warranty claims filed.  
5. Calculate the percentage of claims marked as *“Warranty Void”*.  
6. Find the store with the highest total units sold in the last year.  
7. Count the number of unique products sold in the last year.  
8. Calculate the average product price per category.  
9. Find the number of warranty claims filed in 2020.  
10. Identify each store’s best-selling day based on highest quantity sold.  
11. Identify the least-selling product of each country per year.  
12. Count warranty claims filed within 180 days of sale.  
13. Determine warranty claims for products launched in the last two years.  
14. List months where sales exceeded 5,000 units in the USA.  
15. Find the product category with the most claims in 2022 & 2023.  

---

## Conclusion  
This project demonstrates **SQL expertise** across schema design, optimization, and advanced querying. By analyzing over **1 million rows**, it highlights skills in performance tuning, business problem-solving, and delivering actionable insights that support **data-driven decision-making**.  

---
