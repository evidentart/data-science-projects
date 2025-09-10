-- ================================================
-- Supermarket Relational DB (Oracle SQL)
-- ================================================

-- ========================
-- 1. DROP TABLES SAFELY
-- ========================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Sale_Info CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Order_Detail CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Employee CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SupplierProduct CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Customer CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Product CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Department CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Supplier CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Address CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ========================
-- 2. CREATE TABLES
-- ========================

CREATE TABLE Address (
    address_id INT PRIMARY KEY,
    street_name VARCHAR2(200),
    state_name VARCHAR2(20),
    state_area_code VARCHAR2(20)
);

CREATE TABLE Supplier (
    sup_id INT PRIMARY KEY,
    address_id INT,
    sup_name VARCHAR2(50),
    sup_number VARCHAR2(20),
    sup_fax VARCHAR2(20),
    product_type VARCHAR2(50),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Department (
    dep_id INT PRIMARY KEY,
    dep_name VARCHAR2(50),
    dep_description VARCHAR2(250)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    dep_id INT,
    sup_id INT,
    product_name VARCHAR2(50),
    unit_list_price NUMBER(10,2),
    unit_in_stock NUMBER,
    FOREIGN KEY (dep_id) REFERENCES Department(dep_id),
    FOREIGN KEY (sup_id) REFERENCES Supplier(sup_id)
);

CREATE TABLE SupplierProduct (
    sup_id INT,
    product_id INT,
    quantity_received NUMBER,
    sup_prod_name VARCHAR2(50),
    sup_transactionDate DATE,
    PRIMARY KEY (sup_id, product_id),
    FOREIGN KEY (sup_id) REFERENCES Supplier(sup_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    address_id INT,
    dep_id INT,
    emp_fname VARCHAR2(50),
    emp_last VARCHAR2(50),
    emp_email VARCHAR2(200),
    emp_dob DATE,
    emp_hireDate DATE,
    FOREIGN KEY (dep_id) REFERENCES Department(dep_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    address_id INT,
    cust_fname VARCHAR2(50),
    cust_last VARCHAR2(50),
    cust_dob DATE,
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

CREATE TABLE Order_Detail (
    order_id INT PRIMARY KEY,
    cust_id INT,
    emp_id INT,
    product_id INT,
    total_amount NUMBER(10,2),
    order_date DATE,
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Sale_Info (
    order_id INT,
    product_id INT,
    quantity_sold NUMBER,
    transaction_date DATE,
    FOREIGN KEY (order_id) REFERENCES Order_Detail(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- ========================
-- 3. INSERT SAMPLE DATA
-- ========================

-- ADDRESS
INSERT INTO Address VALUES(201, '13 Westfall', 'Maryland', '204');                          
INSERT INTO Address VALUES(202, '20 Clinton Rd', 'New York', '302');
INSERT INTO Address VALUES(203, '24 Monroe St', 'Florida', '412');
INSERT INTO Address VALUES(204, '17 Cedar Run', 'Georgia', '319');
INSERT INTO Address VALUES(205, '1522 Madison Ave', 'Maryland', '219');
INSERT INTO Address VALUES(206, '9 Hills Run', 'Maryland', '443');
INSERT INTO Address VALUES(207, '19 Adams Ave', 'Maryland', '240');
INSERT INTO Address VALUES(208, '9 Queen St', 'Maryland', '240');
INSERT INTO Address VALUES(209, '376 Honey Creek St', 'Maryland', '240');
INSERT INTO Address VALUES(210, '8665 Adams Ave', 'Kentucky', '277');
INSERT INTO Address VALUES(211, '86 Illinois Ave', 'Illinois', '309');
INSERT INTO Address VALUES(212, '73 Cactus Ave', 'Maryland', '410');
INSERT INTO Address VALUES(213, '116 Jolene St', 'Maryland', '443');
INSERT INTO Address VALUES(214, '37 Cookie Blvd', 'California', '310');                        
INSERT INTO Address VALUES(215, '9999 Madison Square Circle', 'Maryland', '763');

-- CUSTOMER
INSERT INTO Customer VALUES(101, 201, 'Johnny', 'Depp', DATE '2005-03-15');
INSERT INTO Customer VALUES(102, 204, 'Lilli', 'Rivera', DATE '2021-09-22'); 
INSERT INTO Customer VALUES(103, 203, 'Liam', 'Harrington', DATE '2000-03-10');       
INSERT INTO Customer VALUES(104, 214, 'Shaq', 'Oneal', DATE '1977-10-13');
INSERT INTO Customer VALUES(105, 209, 'Amara', 'London', DATE '2002-08-17');

-- SUPPLIER
INSERT INTO Supplier VALUES(401, 201, 'Giant Food', '555-242-1222', '242-444-5422', 'Snack');
INSERT INTO Supplier VALUES(402, 210, 'Safe Way', '277-244-9900', '277-418-5555', 'Sodas');     
INSERT INTO Supplier VALUES(403, 211, 'Bare Foot', '309-972-1112', '309-884-5422', 'Wine');     
INSERT INTO Supplier VALUES(404, 212, 'Amazon Fresh', '410-778-2310', '410-496-6999', 'Produce');     
INSERT INTO Supplier VALUES(405, 213, 'Restaurant Depot', '443-892-2111', '443-404-6262', 'Meats'); 

-- DEPARTMENT
INSERT INTO Department VALUES(601, 'Snacks and Soft Drinks', 'cookies, baked goods, jerky, dehydrated fruit, popcorn, granola, crackers, fruit juice, colas, water, iced teas, etc.');    
INSERT INTO Department VALUES(602, 'Vegetables and Fruits',  'leafy greens, cruciferous, marrow, root(potato etc), edible plant stem, allium, apples, citrus, stone fruit, tropical, exotic, berries, melons, etc.'); 
INSERT INTO Department VALUES(603, 'Beer and Wine', 'ale, lager, lambic, red wine, white wine, rosé wine, sparkling wine, etc.'); 
INSERT INTO Department VALUES(604, 'Meat and Fish', 'red meat, pork, beef, lamb, and goat, poultry, turkey, chicken, sea food, fish, lobster, crab, and mollusks');
INSERT INTO Department VALUES(605, 'Frozen Products', 'frozen meals, ice cream, frozen pizzas, frozen rolls and wraps, etc.'); 

-- EMPLOYEE
INSERT INTO Employee VALUES(301, 201, 601, 'Henry', 'Brown', 'hbrown@gmail.com', DATE '1970-06-09', DATE '2020-01-01');
INSERT INTO Employee VALUES(302, 205, 601, 'Kaitlyn', 'Wong', 'kwong@msn.com', DATE '1985-01-10', DATE '2018-09-13');
INSERT INTO Employee VALUES(303, 206, 602, 'Jennifer', 'Carter', 'jcarter@yahoo.com', DATE '1982-07-05', DATE '2019-10-01');    
INSERT INTO Employee VALUES(304, 207, 602, 'Amber', 'Rose', 'arose@gmail.com', DATE '1994-03-16', DATE '2003-06-05');
INSERT INTO Employee VALUES(305, 208, 605, 'Justin', 'Timberlake', 'jtimberlake@gmail.com', DATE '1989-03-16', DATE '2022-01-17');

-- PRODUCT
INSERT INTO Product VALUES(501, 601, 401, 'Doritos', 5.99, 2500);    
INSERT INTO Product VALUES(502, 602, 404, 'Granny Smith', 0.99, 1000);    
INSERT INTO Product VALUES(503, 603, 403, 'Volcanic Merlot', 75.95, 500);    
INSERT INTO Product VALUES(504, 604, 405, 'Blue Crab', 30.99, 370);  
INSERT INTO Product VALUES(505, 605, 405, 'Chicken Tenders', 15.99, 2000); 

-- ORDER DETAILS
INSERT INTO Order_Detail VALUES(10, 101, 301, 501, 15.11, DATE '2001-01-01');    
INSERT INTO Order_Detail VALUES(11, 102, 302, 502, 15.15, DATE '2001-01-01');
INSERT INTO Order_Detail VALUES(12, 103, 303, 503, 80.00, DATE '2001-02-03');
INSERT INTO Order_Detail VALUES(13, 104, 304, 504, 65.59, DATE '2001-02-10');
INSERT INTO Order_Detail VALUES(14, 105, 305, 505, 47.97, DATE '2001-03-15');
INSERT INTO Order_Detail VALUES(15, 105, 305, 505, 47.97, DATE '2001-06-10');
INSERT INTO Order_Detail VALUES(16, 101, 301, 502, 15.15, DATE '2002-08-24');  
INSERT INTO Order_Detail VALUES(17, 101, 303, 505, 15.99, DATE '2022-09-06');

-- SALE INFO
INSERT INTO Sale_Info VALUES(10, 501, 500, DATE '2023-06-01');   
INSERT INTO Sale_Info VALUES(11, 502, 500, DATE '2023-06-01');  
INSERT INTO Sale_Info VALUES(12, 503, 350, DATE '2023-06-13');
INSERT INTO Sale_Info VALUES(13, 504, 500, DATE '2023-06-14');
INSERT INTO Sale_Info VALUES(14, 505, 610, DATE '2023-06-20');
INSERT INTO Sale_Info VALUES(15, 501, 610, DATE '2023-06-20');

-- SUPPLIER PRODUCT
INSERT INTO SupplierProduct VALUES(401, 501, 1500, 'Chips', DATE '2020-02-21');  
INSERT INTO SupplierProduct VALUES(402, 502, 5500, 'Green Apple', DATE '2020-02-21');  
INSERT INTO SupplierProduct VALUES(403, 503, 5000, 'Red Wine', DATE '2020-03-18');
INSERT INTO SupplierProduct VALUES(405, 504, 3400, 'Blue Crab', DATE '2020-04-01');

-- ========================
-- Script Ready for Use
-- ========================
COMMIT;


-- Check all tables in your schema
SELECT table_name 
FROM user_tables 
ORDER BY table_name;

-- Count rows in each table to verify data
SELECT 'Address' AS table_name, COUNT(*) AS row_count FROM Address
UNION ALL
SELECT 'Supplier', COUNT(*) FROM Supplier
UNION ALL
SELECT 'Department', COUNT(*) FROM Department
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'SupplierProduct', COUNT(*) FROM SupplierProduct
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL
SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL
SELECT 'Order_Detail', COUNT(*) FROM Order_Detail
UNION ALL
SELECT 'Sale_Info', COUNT(*) FROM Sale_Info;

-- Sample data check (first 5 rows per table)
SELECT * FROM Address WHERE ROWNUM <= 5;
SELECT * FROM Supplier WHERE ROWNUM <= 5;
SELECT * FROM Department WHERE ROWNUM <= 5;
SELECT * FROM Product WHERE ROWNUM <= 5;
SELECT * FROM SupplierProduct WHERE ROWNUM <= 5;
SELECT * FROM Employee WHERE ROWNUM <= 5;
SELECT * FROM Customer WHERE ROWNUM <= 5;
SELECT * FROM Order_Detail WHERE ROWNUM <= 5;
SELECT * FROM Sale_Info WHERE ROWNUM <= 5;

