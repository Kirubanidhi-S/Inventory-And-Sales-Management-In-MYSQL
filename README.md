📌 1️⃣ Project Overview
Project Title:

Inventory & Sales Management System (SQL-Based)

Objective:

To design and implement a relational database system that tracks:

Products

Inventory levels

Customers

Sales transactions

Revenue performance

Business Problem:

Manual inventory tracking leads to:

Stock shortages

Overstocking

Revenue leakage

Poor sales insights

This system enables:

Real-time stock monitoring

Sales performance analysis

Profitability tracking

Business decision support

📌 2️⃣ Project Steps
Step 1: Requirement Analysis

Identify entities (Products, Customers, Orders, Suppliers)

Define relationships

Define KPIs (Revenue, Profit, Top Products, Low Stock)

Step 2: Database Design

Create ER Diagram

Define Primary Keys & Foreign Keys

Normalize tables (up to 3NF)

Step 3: Database Implementation

Create tables

Insert sample data

Define constraints

Step 4: Data Cleaning

Remove duplicates

Handle NULL values

Standardize formats

Step 5: Data Analysis

Write analytical queries

Generate reports

Step 6: Performance Optimization

Add indexes

Optimize joins

Avoid unnecessary subqueries

📌 3️⃣ Database Setup
Create Database
CREATE DATABASE inventory_sales;
USE inventory_sales;
Create Tables
1️⃣ Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    stock_quantity INT
);
2️⃣ Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    phone VARCHAR(15)
);
3️⃣ Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
4️⃣ Order Details Table
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
📌 4️⃣ Data Cleaning & Procedures & Queries
🔹 Data Cleaning
Remove Duplicate Products
DELETE p1 FROM products p1
JOIN products p2
ON p1.product_name = p2.product_name
AND p1.product_id > p2.product_id;
Handle NULL Values
UPDATE customers
SET phone = 'Not Available'
WHERE phone IS NULL;
🔹 Stored Procedure Example
Procedure to Reduce Stock After Sale
DELIMITER //

CREATE PROCEDURE update_stock (
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;
END //

DELIMITER ;
🔹 Analytical Queries
1️⃣ Total Revenue
SELECT SUM(total_amount) AS total_revenue
FROM order_details;
2️⃣ Top 5 Selling Products
SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;
3️⃣ Low Stock Products
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 10;
4️⃣ Monthly Sales
SELECT MONTH(order_date) AS month,
       SUM(total_amount) AS monthly_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY MONTH(order_date);
📌 5️⃣ Performance Optimization
🔹 1. Add Indexes
CREATE INDEX idx_product_id ON order_details(product_id);
CREATE INDEX idx_order_id ON order_details(order_id);
CREATE INDEX idx_customer_id ON orders(customer_id);
🔹 2. Use Proper Data Types

INT for IDs

DECIMAL for money

DATE for dates

🔹 3. Avoid SELECT *

Instead use:

SELECT product_name, stock_quantity FROM products;
🔹 4. Optimize Joins

Ensure foreign keys are indexed

Avoid unnecessary nested queries

📌 6️⃣ Output & Insights
📊 Key Outputs

Total Revenue Generated

Top-Selling Products

Low-Stock Alerts

Monthly Sales Trends

Customer Purchase Patterns

📈 Business Insights

Identify best-performing product categories

Detect slow-moving inventory

Forecast restocking requirements

Improve pricing strategy

Identify high-value customers
