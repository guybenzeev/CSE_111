-- Sample data for the StockFlow warehouse logistics database.
-- Run AFTER create_schema.sql, e.g.:
--   python Database/seed_db.py
-- or
--   sqlite3 Database/stockflow.sqlite3 < Database/seed_data.sql
--
-- Re-runnable: existing rows are cleared first (children before parents).
-- "Today" in this dataset is 2026-11-16: older orders are DELIVERED, recent ones
-- SHIPPED/PENDING; past deliveries are RECEIVED, upcoming ones SCHEDULED.

PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DELETE FROM DeliveryItem;
DELETE FROM SupplierProduct;
DELETE FROM OrderLineItem;
DELETE FROM ProductStock;
DELETE FROM Delivery;
DELETE FROM Orders;
DELETE FROM Customer;
DELETE FROM Warehouse;
DELETE FROM Supplier;
DELETE FROM Product;
DELETE FROM Category;

-- ---------------------------------------------------------------------------
-- Category (6)
-- ---------------------------------------------------------------------------
INSERT INTO Category (category_id, name, description) VALUES
(1, 'Electronics',            'Computer peripherals, monitors, and docking hardware'),
(2, 'Office Supplies',        'Paper, writing instruments, and desk essentials'),
(3, 'Furniture',              'Desks, seating, and storage furniture'),
(4, 'Kitchen & Breakroom',    'Coffee, beverages, and breakroom consumables'),
(5, 'Cleaning & Janitorial',  'Cleaning chemicals, paper goods, and waste supplies'),
(6, 'Safety & PPE',           'Personal protective equipment and first aid');

-- ---------------------------------------------------------------------------
-- Product (24) -- BelongsTo: Product -> Category
-- ---------------------------------------------------------------------------
INSERT INTO Product (product_id, sku, name, description, unit_price, category_id) VALUES
(1,  'ELEC-1001', 'Wireless Optical Mouse',            '2.4 GHz wireless mouse with USB receiver',          24.99, 1),
(2,  'ELEC-1002', 'USB-C Docking Station',             'Dual 4K display dock with 100W pass-through',      129.99, 1),
(3,  'ELEC-1003', '27-inch LED Monitor',               '27" 1440p IPS monitor, HDMI/DisplayPort',          219.99, 1),
(4,  'ELEC-1004', 'Mechanical Keyboard',               'Full-size keyboard with tactile switches',          89.99, 1),
(5,  'OFF-2001',  'Copy Paper, Letter, 10-Ream Case',  '8.5x11 in, 20 lb, 5,000 sheets per case',           54.99, 2),
(6,  'OFF-2002',  'Ballpoint Pens, Blue, 12-Pack',     'Medium point, retractable',                          6.49, 2),
(7,  'OFF-2003',  'Sticky Notes 3x3, 12-Pack',         'Assorted colors, 100 sheets per pad',               11.99, 2),
(8,  'OFF-2004',  'Heavy-Duty Stapler',                'Staples up to 100 sheets',                          19.99, 2),
(9,  'FURN-3001', 'Ergonomic Office Chair',            'Mesh back, adjustable lumbar and armrests',        249.00, 3),
(10, 'FURN-3002', 'Height-Adjustable Standing Desk',   '60x30 in electric dual-motor desk',                449.00, 3),
(11, 'FURN-3003', '4-Drawer Filing Cabinet',           'Letter-size vertical steel cabinet with lock',     189.00, 3),
(12, 'FURN-3004', 'Bookshelf, 5-Shelf',                '72 in laminate bookshelf, espresso finish',         89.00, 3),
(13, 'KIT-4001',  'Ground Coffee, 2 lb Bag',           'Medium roast, 100% arabica',                        17.99, 4),
(14, 'KIT-4002',  'Paper Hot Cups, 12 oz, 500-Count',  'Insulated paper cups',                              39.99, 4),
(15, 'KIT-4003',  'Bottled Water, 24-Pack',            '16.9 oz purified water bottles',                     5.99, 4),
(16, 'KIT-4004',  'Single-Serve Coffee Maker',         'Pod-style brewer, 3 cup sizes',                     79.99, 4),
(17, 'CLN-5001',  'Disinfecting Wipes, 3-Pack',        '75 wipes per canister',                             12.49, 5),
(18, 'CLN-5002',  'Trash Bags, 33 gal, 100-Count',     'Heavy-duty black drawstring bags',                  27.99, 5),
(19, 'CLN-5003',  'Paper Towels, 12 Rolls',            '2-ply, 120 sheets per roll',                        23.99, 5),
(20, 'CLN-5004',  'Hand Soap Refill, 1 gal',           'Antibacterial liquid hand soap',                    14.99, 5),
(21, 'SAF-6001',  'Nitrile Gloves, Box of 100',        'Powder-free, size large',                           13.99, 6),
(22, 'SAF-6002',  'Safety Glasses, Clear',             'ANSI Z87.1 rated, anti-fog',                         4.99, 6),
(23, 'SAF-6003',  'Hi-Vis Safety Vest',                'ANSI Class 2, reflective, one size',                 9.99, 6),
(24, 'SAF-6004',  'First Aid Kit, 100-Piece',          'OSHA-compliant workplace kit',                      34.99, 6);

-- ---------------------------------------------------------------------------
-- Supplier (6)
-- ---------------------------------------------------------------------------
INSERT INTO Supplier (supplier_id, name, contact_name, phone, email) VALUES
(1, 'TechSource Distribution',        'Priya Raman',     '(408) 555-0142', 'sales@techsource.example'),
(2, 'Pacific Paper & Office Co.',     'Mark Ellison',    '(510) 555-0187', 'orders@pacificpaper.example'),
(3, 'Summit Office Furniture',        'Dana Whitfield',  '(916) 555-0123', 'dana.w@summitfurniture.example'),
(4, 'Golden State Breakroom Supply',  'Luis Ortega',     '(559) 555-0168', 'lortega@gsbreakroom.example'),
(5, 'CleanPro Janitorial',            'Angela Brooks',   '(209) 555-0191', 'abrooks@cleanpro.example'),
(6, 'Guardian Safety Products',       'Tom Nakamura',    '(714) 555-0135', 'tnakamura@guardiansafety.example');

-- ---------------------------------------------------------------------------
-- Warehouse (3)
-- ---------------------------------------------------------------------------
INSERT INTO Warehouse (warehouse_id, name, address, city, state, manager_name) VALUES
(1, 'Central Valley Distribution Center', '1450 Industrial Way',   'Merced',  'CA', 'Rachel Kim'),
(2, 'Bay Area Fulfillment Center',        '7800 Clawiter Rd',      'Hayward', 'CA', 'Marcus Lee'),
(3, 'SoCal Regional Warehouse',           '2200 E Commerce Ct',    'Ontario', 'CA', 'Sofia Hernandez');

-- ---------------------------------------------------------------------------
-- Customer (12)
-- ---------------------------------------------------------------------------
INSERT INTO Customer (customer_id, name, email, phone, address) VALUES
(1,  'Merced Family Dental',          'frontdesk@mercedfamilydental.example', '(209) 555-0110', '655 W 18th St, Merced, CA 95340'),
(2,  'Valley Tech Solutions LLC',     'purchasing@valleytech.example',        '(559) 555-0144', '1820 E Shaw Ave, Fresno, CA 93710'),
(3,  'Atwater Unified School District','facilities@atwaterusd.example',       '(209) 555-0156', '1401 Broadway Ave, Atwater, CA 95301'),
(4,  'Riverbank Auto Repair',         'service@riverbankauto.example',        '(209) 555-0172', '3120 Patterson Rd, Modesto, CA 95350'),
(5,  'Bayview Coworking',             'ops@bayviewcowork.example',            '(510) 555-0118', '410 Broadway, Oakland, CA 94607'),
(6,  'Pinecrest Accounting Group',    'admin@pinecrestcpa.example',           '(408) 555-0129', '95 S Market St, San Jose, CA 95113'),
(7,  'Mission Street Cafe',           'owner@missionstcafe.example',          '(415) 555-0163', '2290 Mission St, San Francisco, CA 94110'),
(8,  'Fremont Pediatrics',            'office@fremontpeds.example',           '(510) 555-0195', '39500 Stevenson Pl, Fremont, CA 94539'),
(9,  'Inland Empire Logistics',       'procurement@ielogistics.example',      '(951) 555-0137', '6700 Arlington Ave, Riverside, CA 92503'),
(10, 'Sunset Yoga Studio',            'hello@sunsetyoga.example',             '(626) 555-0181', '88 N Lake Ave, Pasadena, CA 91101'),
(11, 'Harbor Construction Inc.',      'safety@harborconstruction.example',    '(562) 555-0149', '1200 W Anaheim St, Long Beach, CA 90813'),
(12, 'Jordan Patel',                  'jordan.patel@mail.example',            '(209) 555-0107', '2715 Rogers Ave, Merced, CA 95348');

-- ---------------------------------------------------------------------------
-- Orders (21) -- Places: Customer -> Order, FulfilledBy: Order -> Warehouse
-- Customers are served by their nearest warehouse.
-- ---------------------------------------------------------------------------
INSERT INTO Orders (order_id, customer_id, warehouse_id, order_date, status, shipping_address) VALUES
(1,  1,  1, '2026-08-04 09:15:00', 'DELIVERED', '655 W 18th St, Merced, CA 95340'),
(2,  5,  2, '2026-08-11 14:02:00', 'DELIVERED', '410 Broadway, Oakland, CA 94607'),
(3,  9,  3, '2026-08-19 10:30:00', 'DELIVERED', '6700 Arlington Ave, Riverside, CA 92503'),
(4,  3,  1, '2026-08-26 08:45:00', 'DELIVERED', '1401 Broadway Ave, Atwater, CA 95301'),
(5,  7,  2, '2026-09-02 07:50:00', 'DELIVERED', '2290 Mission St, San Francisco, CA 94110'),
(6,  2,  1, '2026-09-09 11:20:00', 'DELIVERED', '1820 E Shaw Ave, Fresno, CA 93710'),
(7,  11, 3, '2026-09-15 13:05:00', 'DELIVERED', '1200 W Anaheim St, Long Beach, CA 90813'),
(8,  6,  2, '2026-09-22 16:40:00', 'CANCELLED', '95 S Market St, San Jose, CA 95113'),
(9,  4,  1, '2026-09-29 09:00:00', 'DELIVERED', '3120 Patterson Rd, Modesto, CA 95350'),
(10, 10, 3, '2026-10-06 12:10:00', 'DELIVERED', '88 N Lake Ave, Pasadena, CA 91101'),
(11, 8,  2, '2026-10-13 10:25:00', 'DELIVERED', '39500 Stevenson Pl, Fremont, CA 94539'),
(12, 12, 1, '2026-10-17 19:45:00', 'DELIVERED', '2715 Rogers Ave, Merced, CA 95348'),
(13, 1,  1, '2026-10-23 09:30:00', 'DELIVERED', '655 W 18th St, Merced, CA 95340'),
(14, 9,  3, '2026-10-28 15:15:00', 'DELIVERED', '6700 Arlington Ave, Riverside, CA 92503'),
(15, 5,  2, '2026-11-03 11:00:00', 'DELIVERED', '410 Broadway, Oakland, CA 94607'),
(16, 3,  1, '2026-11-06 08:10:00', 'SHIPPED',   '1401 Broadway Ave, Atwater, CA 95301'),
(17, 6,  2, '2026-11-09 14:30:00', 'SHIPPED',   '95 S Market St, San Jose, CA 95113'),
(18, 11, 3, '2026-11-11 07:55:00', 'CANCELLED', '1200 W Anaheim St, Long Beach, CA 90813'),
(19, 2,  1, '2026-11-13 10:05:00', 'PENDING',   '1820 E Shaw Ave, Fresno, CA 93710'),
(20, 10, 3, '2026-11-14 17:20:00', 'PENDING',   '88 N Lake Ave, Pasadena, CA 91101'),
(21, 7,  2, '2026-11-15 08:35:00', 'PENDING',   '2290 Mission St, San Francisco, CA 94110');

-- ---------------------------------------------------------------------------
-- Delivery (16) -- Sends: Supplier -> Delivery, ReceivedAt: Delivery -> Warehouse
-- ---------------------------------------------------------------------------
INSERT INTO Delivery (delivery_id, supplier_id, warehouse_id, delivery_date, status) VALUES
(1,  1, 1, '2026-08-01', 'RECEIVED'),
(2,  3, 2, '2026-08-05', 'RECEIVED'),
(3,  6, 3, '2026-08-12', 'RECEIVED'),
(4,  2, 1, '2026-08-20', 'RECEIVED'),
(5,  4, 2, '2026-08-28', 'RECEIVED'),
(6,  5, 1, '2026-09-04', 'RECEIVED'),
(7,  3, 3, '2026-09-18', 'RECEIVED'),
(8,  5, 3, '2026-10-02', 'RECEIVED'),
(9,  6, 2, '2026-10-09', 'RECEIVED'),
(10, 1, 2, '2026-10-21', 'RECEIVED'),
(11, 4, 3, '2026-11-04', 'RECEIVED'),
(12, 2, 2, '2026-11-12', 'RECEIVED'),
(13, 3, 1, '2026-11-18', 'SCHEDULED'),
(14, 6, 1, '2026-11-20', 'SCHEDULED'),
(15, 4, 1, '2026-11-24', 'SCHEDULED'),
(16, 5, 2, '2026-12-01', 'SCHEDULED');

-- ---------------------------------------------------------------------------
-- ProductStock (56) -- Stocks: Warehouse <-> Product (M:N)
-- Merced stocks the full catalog; Hayward and Ontario stock subsets.
-- A few rows sit below reorder_level so low-stock queries return results.
-- ---------------------------------------------------------------------------
INSERT INTO ProductStock (warehouse_id, product_id, quantity_on_hand, reorder_level) VALUES
-- Warehouse 1: Merced (all 24 products)
(1, 1,  64, 20), (1, 2,  18, 8),  (1, 3,  27, 10), (1, 4,  41, 15),
(1, 5,  85, 30), (1, 6, 170, 50), (1, 7, 128, 40), (1, 8,  32, 10),
(1, 9,   9, 6),  (1, 10,  3, 5),  (1, 11,  6, 4),  (1, 12, 10, 4),
(1, 13, 37, 20), (1, 14, 22, 10), (1, 15, 60, 25), (1, 16,  7, 3),
(1, 17, 48, 25), (1, 18, 33, 15), (1, 19, 41, 20), (1, 20, 24, 10),
(1, 21, 61, 30), (1, 22, 18, 50), (1, 23, 25, 30), (1, 24, 12, 5),
-- Warehouse 2: Hayward (16 products)
(2, 1,  29, 15), (2, 2,  12, 6),  (2, 3,  14, 8),  (2, 4,  20, 10),
(2, 5,  55, 25), (2, 6,  90, 40), (2, 7,  78, 30), (2, 8,  15, 8),
(2, 9,  16, 6),  (2, 10,  2, 5),  (2, 13, 22, 20), (2, 14, 38, 10),
(2, 16,  0, 3),  (2, 17, 31, 20), (2, 21, 86, 30), (2, 24, 17, 5),
-- Warehouse 3: Ontario (16 products)
(3, 5,  40, 20), (3, 6,  75, 30), (3, 7,  50, 25), (3, 9,  19, 6),
(3, 11, 12, 4),  (3, 12, 10, 4),  (3, 13, 51, 20), (3, 14, 28, 10),
(3, 15, 104, 30),(3, 17, 34, 20), (3, 18, 27, 15), (3, 19, 26, 15),
(3, 21, 22, 30), (3, 22, 135, 50),(3, 23, 85, 30), (3, 24,  4, 10);

-- ---------------------------------------------------------------------------
-- OrderLineItem (59) -- Contains: Order <-> Product (M:N)
-- unit_price is the price at time of sale (matches the current list price).
-- ---------------------------------------------------------------------------
INSERT INTO OrderLineItem (order_id, product_id, quantity, unit_price) VALUES
(1,  17, 6,  12.49), (1,  21, 10, 13.99), (1,  24, 1,  34.99),
(2,  9,  4, 249.00), (2,  10, 4, 449.00), (2,  3,  4, 219.99),
(3,  23, 25,  9.99), (3,  22, 25,  4.99), (3,  21, 8,  13.99),
(4,  5,  20, 54.99), (4,  6,  30,  6.49), (4,  7,  15, 11.99), (4,  8,  10, 19.99),
(5,  13, 12, 17.99), (5,  14, 6,  39.99), (5,  17, 4,  12.49),
(6,  1,  5,  24.99), (6,  2,  5, 129.99), (6,  3,  5, 219.99), (6,  4,  5,  89.99),
(7,  22, 40,  4.99), (7,  23, 40,  9.99), (7,  24, 6,  34.99),
(8,  10, 2, 449.00),
(9,  18, 4,  27.99), (9,  19, 6,  23.99), (9,  20, 3,  14.99), (9,  21, 5,  13.99),
(10, 15, 10,  5.99), (10, 17, 6,  12.49), (10, 19, 4,  23.99),
(11, 17, 8,  12.49), (11, 21, 12, 13.99), (11, 24, 2,  34.99),
(12, 1,  1,  24.99), (12, 4,  1,  89.99),
(13, 5,  4,  54.99), (13, 6,  6,   6.49), (13, 13, 3,  17.99),
(14, 9,  6, 249.00), (14, 11, 3, 189.00), (14, 12, 2,  89.00),
(15, 13, 10, 17.99), (15, 14, 4,  39.99), (15, 16, 2,  79.99),
(16, 9,  12, 249.00),(16, 11, 4, 189.00),
(17, 2,  3, 129.99), (17, 3,  6, 219.99), (17, 7,  10, 11.99),
(18, 18, 10, 27.99),
(19, 1,  10, 24.99), (19, 4,  10, 89.99),
(20, 13, 4,  17.99), (20, 14, 2,  39.99), (20, 15, 6,   5.99),
(21, 13, 15, 17.99), (21, 17, 4,  12.49), (21, 21, 2,  13.99);

-- ---------------------------------------------------------------------------
-- SupplierProduct (27) -- Supplies: Supplier <-> Product (M:N)
-- Wholesale cost is roughly 50-65% of list price. Some products have two
-- suppliers (mouse, paper cups, nitrile gloves).
-- ---------------------------------------------------------------------------
INSERT INTO SupplierProduct (supplier_id, product_id, unit_cost, lead_time_days) VALUES
(1, 1,  13.50, 5),  (1, 2,  78.00, 7),  (1, 3, 142.00, 10), (1, 4,  52.00, 7),
(2, 1,  14.25, 4),  (2, 5,  33.00, 3),  (2, 6,   3.20, 3),  (2, 7,   6.40, 3),
(2, 8,  10.75, 5),  (2, 14, 23.50, 5),
(3, 9, 148.00, 14), (3, 10, 285.00, 21),(3, 11, 112.00, 14),(3, 12, 51.00, 10),
(4, 13,  9.80, 4),  (4, 14, 22.00, 4),  (4, 15,  3.10, 2),  (4, 16, 48.00, 7),
(5, 17,  6.90, 3),  (5, 18, 15.50, 3),  (5, 19, 13.25, 3),  (5, 20,  7.80, 5),
(5, 21,  8.10, 5),
(6, 21,  7.60, 6),  (6, 22,  2.10, 6),  (6, 23,  4.75, 6),  (6, 24, 19.50, 8);

-- ---------------------------------------------------------------------------
-- DeliveryItem (48) -- Delivery <-> Product (M:N)
-- Every item is a product its delivery's supplier actually supplies.
-- ---------------------------------------------------------------------------
INSERT INTO DeliveryItem (delivery_id, product_id, quantity) VALUES
(1,  1,  50), (1,  2,  20), (1,  3,  30), (1,  4,  40),
(2,  9,  20), (2,  10, 15),
(3,  22, 200),(3,  23, 150),(3,  24, 30),
(4,  5,  100),(4,  6,  200),(4,  7,  150),(4,  8,  40),
(5,  13, 80), (5,  14, 40), (5,  16, 10),
(6,  17, 60), (6,  18, 40), (6,  19, 50), (6,  20, 30), (6,  21, 80),
(7,  9,  25), (7,  11, 15), (7,  12, 12),
(8,  17, 40), (8,  18, 30), (8,  19, 30),
(9,  21, 100),(9,  24, 20),
(10, 1,  30), (10, 2,  15), (10, 3,  20),
(11, 13, 60), (11, 14, 30), (11, 15, 120),
(12, 5,  60), (12, 7,  80), (12, 14, 25),
(13, 9,  30), (13, 10, 10), (13, 11, 10),
(14, 21, 120),(14, 22, 100),(14, 23, 60),
(15, 13, 50), (15, 16, 8),
(16, 17, 50), (16, 21, 60);

COMMIT;
