-- ========================================
-- 1) List all suppliers with their supplied product quantities
-- Ordered by quantity received (highest first)
-- ========================================
SELECT s.sup_id, s.sup_name, s.product_type, sp.quantity_received
FROM Supplier s
INNER JOIN SupplierProduct sp ON s.sup_id = sp.sup_id
ORDER BY sp.quantity_received DESC;

-- ========================================
-- 2) Count total orders per customer
-- Ordered by most orders
-- ========================================
SELECT cust_id, COUNT(*) AS total_orders
FROM Order_Detail
GROUP BY cust_id
ORDER BY total_orders DESC;

-- ========================================
-- 3) Increase quantity received for a supplier (example of UPDATE)
-- ========================================
UPDATE SupplierProduct
SET quantity_received = quantity_received + 2500, sup_transactionDate = DATE '2020-06-01'
WHERE sup_id = 401;

-- ========================================
-- 4) Find all employees in the same department as 'Henry'
-- ========================================
SELECT e2.emp_fname, e2.emp_last
FROM Employee e1
JOIN Employee e2 ON e1.dep_id = e2.dep_id
WHERE e1.emp_fname = 'Henry';

-- ========================================
-- 5) Employees hired before a specific date
-- ========================================
SELECT *
FROM Employee
WHERE emp_hireDate <= DATE '2019-01-01';

-- ========================================
-- 6) List all suppliers with their address details
-- ========================================
SELECT s.sup_id, s.sup_name, a.street_name, a.state_name
FROM Supplier s
LEFT JOIN Address a ON s.address_id = a.address_id
ORDER BY s.sup_id;

-- ========================================
-- 7) Count customers by last name
-- ========================================
SELECT cust_last, COUNT(cust_id) AS customer_count
FROM Customer
GROUP BY cust_last;

-- ========================================
-- 8) Average product price per department
-- ========================================
SELECT dep_id, AVG(unit_list_price) AS avg_price
FROM Product
GROUP BY dep_id
ORDER BY avg_price DESC;

-- ========================================
-- 9) Show all customer orders
-- ========================================
SELECT c.cust_fname, c.cust_last, o.order_id, o.total_amount, o.order_date
FROM Customer c
JOIN Order_Detail o ON c.cust_id = o.cust_id;

-- ========================================
-- 10) Quantity sold of a specific product on a given date
-- ========================================
SELECT p.product_name, s.quantity_sold
FROM Product p
JOIN Sale_Info s ON p.product_id = s.product_id
WHERE p.product_name = 'Doritos'
AND s.transaction_date = DATE '2023-06-01';

-- ========================================
-- 11) Update an address
-- ========================================
UPDATE Address
SET street_name = '404 Forest Mill Rd'
WHERE address_id = 206;

-- ========================================
-- 12) Total sales per product (additional analytical query)
-- ========================================
SELECT p.product_name, SUM(s.quantity_sold) AS total_sold
FROM Product p
JOIN Sale_Info s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- ========================================
-- 13) Total revenue per department (additional valuable query)
-- ========================================
SELECT d.dep_name, SUM(od.total_amount) AS total_revenue
FROM Department d
JOIN Product p ON d.dep_id = p.dep_id
JOIN Order_Detail od ON p.product_id = od.product_id
GROUP BY d.dep_name
ORDER BY total_revenue DESC;

-- ========================================
-- 14) Customer with highest total spending (additional valuable query)
-- ========================================
SELECT c.cust_fname, c.cust_last, SUM(od.total_amount) AS total_spent
FROM Customer c
JOIN Order_Detail od ON c.cust_id = od.cust_id
GROUP BY c.cust_fname, c.cust_last
ORDER BY total_spent DESC
FETCH FIRST 1 ROWS ONLY;

-- ========================================
-- 15) List employees and the number of orders they processed
-- ========================================
SELECT e.emp_fname, e.emp_last, COUNT(o.order_id) AS orders_handled
FROM Employee e
LEFT JOIN Order_Detail o ON e.emp_id = o.emp_id
GROUP BY e.emp_fname, e.emp_last
ORDER BY orders_handled DESC;
