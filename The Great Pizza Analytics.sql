-- 1. Create the pizza_types table
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    ingredients TEXT
);

-- 2. Create the pizzas table (FK to pizza_types)
CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(10),
    price DECIMAL(5,2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

-- 3. Create the orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME
);

-- 4. Create the order_details table (FK to orders and pizzas)
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

-- =====================================================================
-- QUESTIONS FOR ANALYSIS (MySQL Version)
-- =====================================================================

-- ============================
-- Phase 1: Foundation & Inspection
-- ============================

-- 1. Install IDC_Pizza.dump as IDC_Pizza server (import into MySQL)
-- 2. List all unique pizza categories (using DISTINCT).
SELECT DISTINCT category AS pizza_category FROM pizza_types;

-- 3. Display pizza_type_id, name, and ingredients,
--    replacing NULL ingredients with 'Missing Data'.
--    Show only the first 5 rows (LIMIT 5).
SELECT pizza_type_id,
       name,
       COALESCE(ingredients, 'Missing Data') AS ingredients
FROM pizza_types
LIMIT 5;

-- 4. Check for pizzas missing a price (price IS NULL).
SELECT *
FROM pizzas
WHERE price IS NULL;

-- ============================
-- Phase 2: Filtering & Exploration
-- ============================

-- 1. Show all orders placed on '2015-01-01' (SELECT + WHERE).
SELECT *
FROM orders
WHERE date = '2015-01-01';

-- 2. List pizzas ordered by price in descending order.
SELECT *
FROM pizzas
ORDER BY price DESC;

-- 3. Find pizzas sold in sizes 'L' or 'XL'.
SELECT *
FROM pizzas
WHERE size IN ('L', 'XL');

-- 4. Find pizzas priced between $15.00 and $17.00 (BETWEEN).
SELECT *
FROM pizzas
WHERE price BETWEEN 15.00 AND 17.00
ORDER BY price;

-- 5. Pizzas that contain the word 'Chicken' in their name (LIKE).
SELECT *
FROM pizza_types
WHERE upper(name) LIKE '%CHICKEN%';

-- 6. Orders on '2015-02-15' OR orders placed after 20:00 (8 PM).
SELECT *
FROM orders
WHERE (date = '2015-02-15' OR time > '20:00:00');

-- ============================
-- Phase 3: Sales Performance
-- ============================

-- 1. Total quantity of pizzas sold (SUM on quantity).
SELECT SUM(quantity) AS total_pizzas_sold 
FROM order_details;

-- 2. Average pizza price (AVG).
SELECT ROUND(AVG(price), 2) AS avg_price_pizza 
FROM pizzas;

-- 3. Total order value per order (JOIN order_details + pizzas,
--    SUM(price * quantity), GROUP BY order_id).
SELECT o.order_id,
       SUM(p.price * o.quantity) AS order_value
FROM order_details o
LEFT JOIN pizzas p ON o.pizza_id = p.pizza_id
GROUP BY o.order_id
ORDER BY order_value DESC, o.order_id;

-- 4. Total quantity sold per pizza category (JOIN + GROUP BY category).
SELECT pt.category AS pizza_category,
       SUM(quantity) AS total_orders
FROM order_details o 
LEFT JOIN pizzas p ON o.pizza_id = p.pizza_id
LEFT JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.category;

-- 5. Categories with more than 5,000 pizzas sold (HAVING).
SELECT pt.category AS pizza_category,
       SUM(quantity) AS total_orders
FROM order_details o 
LEFT JOIN pizzas p ON o.pizza_id = p.pizza_id
LEFT JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.category
HAVING SUM(quantity) > 5000;

-- 6. Pizzas that were never ordered (LEFT JOIN to order_details).
SELECT p.pizza_id,
       p.size,
       pt.name AS pizza_name,
       pt.category
FROM pizzas p
LEFT JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM order_details o 
    WHERE o.pizza_id = p.pizza_id
);

-- 7. Price differences between different sizes of the same pizza
--    (SELF JOIN on pizzas table).
SELECT pt.name AS pizza_name,
       pt.category,
       p1.size AS size_1,
       p2.size AS size_2,
       ROUND(p1.price - p2.price, 2) AS price_difference
FROM pizzas p1
JOIN pizzas p2
    ON p1.pizza_type_id = p2.pizza_type_id
   AND p1.size < p2.size          -- prevents duplicates
JOIN pizza_types pt
    ON p1.pizza_type_id = pt.pizza_type_id
ORDER BY pt.name;
