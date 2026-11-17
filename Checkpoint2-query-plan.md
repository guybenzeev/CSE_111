# Checkpoint 2: Planned SQL Statements

34 statements in three sections: 10 simple, 11 intermediate, 13 complex.

> **Run order matters.** Statements 7 → 13, 20 → 34 and 30 → 31 depend on
> earlier statements. Re-seed (`python Database/seed_db.py`) before each full run.

---

## Section 1: Simple Statements (1–10)

*Single table: filtering, sorting, pattern matching, plain aggregates, one-row changes.*

| # | Statement | Description |
|---|-----------|-------------|
| 1 | High-value products | Products priced at $100 or more, most expensive first. |
| 2 | Customers in one city | Customers whose address matches `'%Merced%'` (`LIKE`). |
| 3 | Safety catalog | Products whose SKU starts with `'SAF-'` (`LIKE`). |
| 4 | Order statuses in use | `SELECT DISTINCT status FROM Orders`. |
| 5 | Price statistics | `COUNT`, `MIN`, `MAX` and `ROUND(AVG())` of `unit_price` across all products. |
| 6 | Upcoming deliveries | Deliveries with status `SCHEDULED`, ordered by `delivery_date`. |
| 7 | `INSERT` a category | A new "Packaging & Shipping" category (id 7) with no products yet. Statement 13 uses it. |
| 8 | `INSERT` a customer | A new test customer (id 13). |
| 9 | `UPDATE` a product price | E.g. a coffee price increase. Old order lines keep their old `unit_price`, which shows why the price is stored on each line. |
| 10 | `DELETE` the test customer | Remove customer 13. It has no orders, so the "can't delete a customer with orders" rule doesn't block it. |

---

## Section 2: Intermediate Statements (11–21)

*Joins, `LEFT JOIN`, `GROUP BY` / `HAVING`, subqueries, table aliases, conditional updates.*

| # | Statement | Description |
|---|-----------|-------------|
| 11 | Product catalog with category names | Product joined to Category. |
| 12 | Order overview | Order id, date and status with the customer name and warehouse name (three-table join). |
| 13 | Categories with product counts | `LEFT JOIN` Category to Product, so the empty "Packaging & Shipping" category from #7 shows up with 0. |
| 14 | Order totals | `SUM(quantity * unit_price)` and number of lines for each order. |
| 15 | Suppliers with a broad catalog | Join SupplierProduct, `GROUP BY` supplier, `HAVING COUNT(*) > 4`. Returns 2 suppliers. |
| 16 | Inventory value per warehouse | `SUM(quantity_on_hand * unit_price)` from ProductStock joined to Product, grouped by warehouse. |
| 17 | Products Hayward doesn't carry | `LEFT JOIN` to ProductStock with `warehouse_id = 2` in the `ON` clause, then keep rows where the join found nothing (`IS NULL`). Returns 8 products. |
| 18 | Top customers | Revenue per customer from `DELIVERED` orders only, `HAVING` revenue > $1,000. |
| 19 | Supplier margins | For each supplier and product, the product price minus the supplier's cost, using table aliases. |
| 20 | Conditional `UPDATE` | Set orders to `DELIVERED` where status is `SHIPPED` and `order_date < '2026-11-08'`. Changes 1 row. |
| 21 | `UPDATE` using a subquery | Raise `reorder_level` for products where `product_id IN (SELECT ... WHERE category is 'Safety & PPE')`. |

---

## Section 3: Complex Statements (22–34)

*`EXISTS` / `NOT EXISTS`, set operations, `WITH` (CTEs), window functions, views, triggers, `CASE`.*

| # | Statement | Description |
|---|-----------|-------------|
| 22 | `EXISTS` | Customers who have at least one `PENDING` order. |
| 23 | `NOT EXISTS` | Warehouses with no upcoming deliveries. Returns only Ontario. |
| 24 | `EXCEPT` | Products stocked in Merced but not in Ontario. |
| 25 | `INTERSECT` | Products stocked in both Hayward and Ontario. |
| 26 | `UNION` | One contact list combining supplier contacts and customers, with a label column saying which is which. |
| 27 | CTE (`WITH`) | Find the cheapest supplier for each product, then join that to the low-stock rows so each one shows who to reorder from. |
| 28 | `DENSE_RANK()` | Rank products by revenue within each category (`PARTITION BY category_id`). |
| 29 | `ROW_NUMBER()` | Each customer's most recent order (`PARTITION BY customer_id ORDER BY order_date DESC`, keep row 1). |
| 30 | `CREATE VIEW` | A low-stock view of warehouse, product, quantity and reorder level where quantity is below the reorder level. |
| 31 | Query the view | Select from the view in #30, lowest stock first. |
| 32 | `CREATE TRIGGER` | When a Delivery's status changes to `RECEIVED`, add each of its items' quantities to ProductStock (one trigger that updates several rows). |
| 33 | Fire the trigger | `UPDATE Delivery SET status = 'RECEIVED' WHERE delivery_id = 13`, so the trigger from #32 actually runs. |
| 34 | `CASE` pivot | For each warehouse, count orders as `PENDING`, `SHIPPED`, `DELIVERED` and `CANCELLED` columns using `COUNT(CASE WHEN ... END)`. |
