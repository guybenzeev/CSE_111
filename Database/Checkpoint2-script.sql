-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: StockFlow: Multi-Warehouse Inventory & Order Management System
-- Team Members: Guy Ben Zeev, Vishwa Reddy
-- File: Checkpoint2-script.sql
-- ============================================================================

-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- No modifications made to the Checkpoint 1 schema.

-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: [Member 1]: XX%, [Member 2]: XX%
-- Statement 02: [Member 1]: XX%, [Member 2]: XX%
-- Statement 03: [Member 1]: XX%, [Member 2]: XX%
-- Statement 04: [Member 1]: XX%, [Member 2]: XX%
-- Statement 05: [Member 1]: XX%, [Member 2]: XX%
-- Statement 06: [Member 1]: XX%, [Member 2]: XX%
-- Statement 07: [Member 1]: XX%, [Member 2]: XX%
-- Statement 08: [Member 1]: XX%, [Member 2]: XX%
-- Statement 09: [Member 1]: XX%, [Member 2]: XX%
-- Statement 10: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: [Member 1]: XX%, [Member 2]: XX%
-- Statement 12: [Member 1]: XX%, [Member 2]: XX%
-- Statement 13: [Member 1]: XX%, [Member 2]: XX%
-- Statement 14: [Member 1]: XX%, [Member 2]: XX%
-- Statement 15: [Member 1]: XX%, [Member 2]: XX%
-- Statement 16: [Member 1]: XX%, [Member 2]: XX%
-- Statement 17: [Member 1]: XX%, [Member 2]: XX%
-- Statement 18: [Member 1]: XX%, [Member 2]: XX%
-- Statement 19: [Member 1]: XX%, [Member 2]: XX%
-- Statement 20: [Member 1]: XX%, [Member 2]: XX%
-- Statement 21: [Member 1]: XX%, [Member 2]: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: [Member 1]: XX%, [Member 2]: XX%
-- Statement 23: [Member 1]: XX%, [Member 2]: XX%
-- Statement 24: [Member 1]: XX%, [Member 2]: XX%
-- Statement 25: [Member 1]: XX%, [Member 2]: XX%
-- Statement 26: [Member 1]: XX%, [Member 2]: XX%
-- Statement 27: [Member 1]: XX%, [Member 2]: XX%
-- Statement 28: [Member 1]: XX%, [Member 2]: XX%
-- Statement 29: [Member 1]: XX%, [Member 2]: XX%
-- Statement 30: [Member 1]: XX%, [Member 2]: XX%
-- Statement 31: [Member 1]: XX%, [Member 2]: XX%
-- Statement 32: [Member 1]: XX%, [Member 2]: XX%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column


-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes,
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: High-Value Products
-- Explanation: Retrieves all products priced at $100 or more, sorted from
--              most expensive to least expensive.
-- ----------------------------------------------------------------------------
SELECT *
FROM Product
WHERE unit_price >= 100
ORDER BY unit_price DESC;

-- ----------------------------------------------------------------------------
-- Statement 02: Customers in Merced
-- Explanation: Retrieves customers whose address contains "Merced" using
--              the LIKE operator for pattern matching.
-- ----------------------------------------------------------------------------
SELECT *
FROM Customer
WHERE address LIKE '%Merced%';

-- ----------------------------------------------------------------------------
-- Statement 03: Safety Catalog
-- Explanation: Retrieves products whose SKU begins with "SAF-", identifying
--              products belonging to the safety catalog.
-- ----------------------------------------------------------------------------
SELECT *
FROM Product
WHERE sku LIKE 'SAF-%';

-- ----------------------------------------------------------------------------
-- Statement 04: Order Statuses in Use
-- Explanation: Retrieves the distinct order statuses currently present in
--              the Orders table without displaying duplicates.
-- ----------------------------------------------------------------------------
SELECT DISTINCT status
FROM Orders;

-- ----------------------------------------------------------------------------
-- Statement 05: Product Price Statistics
-- Explanation: Calculates the total number of products, minimum price,
--              maximum price, and average price rounded to two decimals.
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*) AS product_count,
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price,
    ROUND(AVG(unit_price), 2) AS average_price
FROM Product;

-- ----------------------------------------------------------------------------
-- Statement 06: Upcoming Deliveries
-- Explanation: Retrieves deliveries with a status of SCHEDULED, ordered
--              chronologically by their delivery date.
-- ----------------------------------------------------------------------------
SELECT *
FROM Delivery
WHERE status = 'SCHEDULED'
ORDER BY delivery_date ASC;

-- ----------------------------------------------------------------------------
-- Statement 07: Insert Packaging and Shipping Category
-- Explanation: Adds a new category with ID 7 named "Packaging & Shipping".
--              This category initially has no associated products.
-- ----------------------------------------------------------------------------
INSERT INTO Category (category_id, name, description)
VALUES (
    7,
    'Packaging & Shipping',
    'Products used for packaging and shipping'
);

-- ----------------------------------------------------------------------------
-- Statement 08: Insert Test Customer
-- Explanation: Adds a new test customer with ID 13 to the Customer table.
--              This customer is not associated with any orders.
-- ----------------------------------------------------------------------------
INSERT INTO Customer (customer_id, name, email, phone, address)
VALUES (
    13,
    'Test Customer',
    'testcustomer@example.com',
    '209-555-0113',
    '123 Test Street, Merced, CA'
);

-- ----------------------------------------------------------------------------
-- Statement 09: Update Coffee Product Price
-- Explanation: Increases the price of a coffee product by 10 percent.
--              Existing order lines retain their original unit_price.
-- ----------------------------------------------------------------------------
UPDATE Product
SET unit_price = ROUND(unit_price * 1.10, 2)
WHERE product_id = (
    SELECT product_id
    FROM Product
    WHERE name LIKE '%Coffee%'
    ORDER BY product_id
    LIMIT 1
);

-- ----------------------------------------------------------------------------
-- Statement 10: Delete Test Customer
-- Explanation: Removes the test customer with ID 13 from the database.
--              The deletion is allowed because the customer has no orders.
-- ----------------------------------------------------------------------------
DELETE FROM Customer
WHERE customer_id = 13;


-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Product Catalog with Category Names
-- Explanation: Joins Product with Category to display each product's
--              information alongside its corresponding category name.
-- ----------------------------------------------------------------------------
SELECT
    p.product_id,
    p.sku,
    p.name AS product_name,
    p.unit_price,
    c.name AS category_name
FROM Product AS p
INNER JOIN Category AS c
    ON p.category_id = c.category_id
ORDER BY c.name, p.name;

-- ----------------------------------------------------------------------------
-- Statement 12: Order Overview
-- Explanation: Joins Orders, Customer, and Warehouse to display each order's
--              ID, date, status, customer name, and warehouse name.
-- ----------------------------------------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.name AS customer_name,
    w.name AS warehouse_name
FROM Orders AS o
INNER JOIN Customer AS c
    ON o.customer_id = c.customer_id
INNER JOIN Warehouse AS w
    ON o.warehouse_id = w.warehouse_id
ORDER BY o.order_date DESC;

-- ----------------------------------------------------------------------------
-- Statement 13: Categories with Product Counts
-- Explanation: Uses a LEFT JOIN to count products in each category, including
--              categories with no products, such as Packaging & Shipping.
-- ----------------------------------------------------------------------------
SELECT
    c.category_id,
    c.name AS category_name,
    COUNT(p.product_id) AS product_count
FROM Category AS c
LEFT JOIN Product AS p
    ON c.category_id = p.category_id
GROUP BY c.category_id, c.name
ORDER BY c.category_id;

-- ----------------------------------------------------------------------------
-- Statement 14: Order Totals
-- Explanation: Calculates the total monetary value of each order by summing
--              quantity times unit_price and counts its distinct line items.
-- ----------------------------------------------------------------------------
SELECT
    o.order_id,
    ROUND(SUM(oli.quantity * oli.unit_price), 2) AS order_total,
    COUNT(oli.product_id) AS line_count
FROM Orders AS o
INNER JOIN OrderLineItem AS oli
    ON o.order_id = oli.order_id
GROUP BY o.order_id
ORDER BY o.order_id;

-- ----------------------------------------------------------------------------
-- Statement 15: Suppliers with a Broad Catalog
-- Explanation: Joins Supplier with SupplierProduct and groups by supplier.
--              HAVING selects suppliers that provide more than four products.
-- ----------------------------------------------------------------------------
SELECT
    s.supplier_id,
    s.name AS supplier_name,
    COUNT(sp.product_id) AS product_count
FROM Supplier AS s
INNER JOIN SupplierProduct AS sp
    ON s.supplier_id = sp.supplier_id
GROUP BY s.supplier_id, s.name
HAVING COUNT(*) > 4
ORDER BY product_count DESC;

-- ----------------------------------------------------------------------------
-- Statement 16: Inventory Value per Warehouse
-- Explanation: Joins warehouse stock with product prices and calculates each
--              warehouse's total inventory value using quantity times price.
-- ----------------------------------------------------------------------------
SELECT
    w.warehouse_id,
    w.name AS warehouse_name,
    ROUND(SUM(ps.quantity_on_hand * p.unit_price), 2) AS inventory_value
FROM Warehouse AS w
INNER JOIN ProductStock AS ps
    ON w.warehouse_id = ps.warehouse_id
INNER JOIN Product AS p
    ON ps.product_id = p.product_id
GROUP BY w.warehouse_id, w.name
ORDER BY w.warehouse_id;

-- ----------------------------------------------------------------------------
-- Statement 17: Products Hayward Does Not Carry
-- Explanation: Uses a LEFT JOIN restricted to warehouse ID 2 (Hayward).
--              Products with no matching stock record are returned.
-- ----------------------------------------------------------------------------
SELECT
    p.product_id,
    p.sku,
    p.name AS product_name
FROM Product AS p
LEFT JOIN ProductStock AS ps
    ON p.product_id = ps.product_id
    AND ps.warehouse_id = 2
WHERE ps.product_id IS NULL
ORDER BY p.product_id;

-- ----------------------------------------------------------------------------
-- Statement 18: Top Customers by Delivered Revenue
-- Explanation: Calculates revenue from DELIVERED orders for each customer.
--              HAVING filters customers whose total revenue exceeds $1,000.
-- ----------------------------------------------------------------------------
SELECT
    c.customer_id,
    c.name AS customer_name,
    ROUND(SUM(oli.quantity * oli.unit_price), 2) AS total_revenue
FROM Customer AS c
INNER JOIN Orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN OrderLineItem AS oli
    ON o.order_id = oli.order_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, c.name
HAVING SUM(oli.quantity * oli.unit_price) > 1000
ORDER BY total_revenue DESC;

-- ----------------------------------------------------------------------------
-- Statement 19: Supplier Margins
-- Explanation: Joins Supplier, SupplierProduct, and Product to calculate
--              the difference between product selling price and supplier cost.
-- ----------------------------------------------------------------------------
SELECT
    s.supplier_id,
    s.name AS supplier_name,
    p.product_id,
    p.name AS product_name,
    p.unit_price AS selling_price,
    sp.unit_cost AS supplier_cost,
    ROUND(p.unit_price - sp.unit_cost, 2) AS margin
FROM Supplier AS s
INNER JOIN SupplierProduct AS sp
    ON s.supplier_id = sp.supplier_id
INNER JOIN Product AS p
    ON sp.product_id = p.product_id
ORDER BY s.name, p.name;

-- ----------------------------------------------------------------------------
-- Statement 20: Conditional Order Status Update
-- Explanation: Updates orders from SHIPPED to DELIVERED only when their
--              order date is earlier than November 8, 2026.
-- ----------------------------------------------------------------------------
UPDATE Orders
SET status = 'DELIVERED'
WHERE status = 'SHIPPED'
    AND order_date < '2026-11-08';

-- ----------------------------------------------------------------------------
-- Statement 21: Update Reorder Levels Using a Subquery
-- Explanation: Increases reorder levels by five for products belonging to
--              the Safety & PPE category, identified through a subquery.
-- ----------------------------------------------------------------------------
UPDATE ProductStock
SET reorder_level = reorder_level + 5
WHERE product_id IN (
    SELECT p.product_id
    FROM Product AS p
    INNER JOIN Category AS c
        ON p.category_id = c.category_id
    WHERE c.name = 'Safety & PPE'
);


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 22: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 22 Here];

-- [Continue Statements 23 through 32...]