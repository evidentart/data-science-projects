-- ================================================
-- Parking Management DB (Oracle SQL)
-- ================================================

-- ========================
-- 1. DROP TABLES SAFELY
-- ========================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE transaction CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE parkingSession CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE message CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE vehicle CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE zone CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customer CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ========================
-- 2. CREATE TABLES
-- ========================

CREATE TABLE customer (
    custid INT PRIMARY KEY,
    c_name VARCHAR2(20),
    c_address VARCHAR2(100),
    c_zip VARCHAR2(5),
    c_state VARCHAR2(20),
    c_email VARCHAR2(30),
    c_phoneNum VARCHAR2(20),
    c_paymentNum NUMBER(16) NOT NULL
);

CREATE TABLE zone (
    zid INT PRIMARY KEY,
    z_address VARCHAR2(40),
    z_zipcode VARCHAR2(5),
    z_capacity INT,
    z_avblSlot INT,
    z_hrRate NUMBER(5,2),
    z_maxParkingLength NUMBER(5,2),
    start_dayOfWeek INT,   -- 1=Sunday, 7=Saturday
    start_time TIMESTAMP,
    endDayOfWeek INT,
    end_time TIMESTAMP(2)
);

CREATE TABLE vehicle (
    vid INT PRIMARY KEY,
    custid INT,
    v_platenum VARCHAR2(20),
    v_state VARCHAR2(30),
    v_maker VARCHAR2(30),
    v_model VARCHAR2(20),
    v_year INT,
    v_color VARCHAR2(20),
    FOREIGN KEY (custid) REFERENCES customer(custid)
);

CREATE TABLE message (
    mid INT PRIMARY KEY,
    customer_id INT,
    message_time TIMESTAMP,
    message_body VARCHAR2(100),
    FOREIGN KEY (customer_id) REFERENCES customer(custid)
);

CREATE TABLE parkingSession (
    seid INT PRIMARY KEY,
    custid INT,
    vid INT,
    zid INT,
    start_timeSession TIMESTAMP(1),
    end_timeSession TIMESTAMP(1),
    total_charge NUMBER(5,2),
    FOREIGN KEY (custid) REFERENCES customer(custid),
    FOREIGN KEY (vid) REFERENCES vehicle(vid),
    FOREIGN KEY (zid) REFERENCES zone(zid)
);

CREATE TABLE transaction (
    payment_id INT PRIMARY KEY,
    seid INT,
    payment_time TIMESTAMP,
    payment_amount NUMBER(5,2),
    hrs_payCover NUMBER(5,2),
    FOREIGN KEY (seid) REFERENCES parkingSession(seid)
);

-- ========================
-- 3. CREATE SEQUENCES
-- ========================

CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE zone_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE vehicle_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE message_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE parkingSession_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE transaction_seq START WITH 1 INCREMENT BY 1;

-- ========================
-- 4. INSERT SAMPLE DATA
-- ========================

-- CUSTOMERS
INSERT INTO customer VALUES (1, 'Bob', '4420 Hamilton Ave', '21212', 'Maryland', 'bob21@gmail.com', '912-552-2499', 125152195821750);
INSERT INTO customer VALUES (2, 'Vinny', '320 Medfield Pl', '14521', 'Virginia', 'vinY@msn.com', '520-534-0021', 564247795285771);
INSERT INTO customer VALUES (3, 'Jack', '50 Clover Ave', '21112', 'Maryland', 'jack99@yahoo.com', '410-629-9912', 821152829961750);
INSERT INTO customer VALUES (4, 'Fiona', 'Suite 880 2651 Smith Drive', '24992', 'New York', 'f21@outlook.com', '510-521-6800', 631177009961750);

-- ZONES
INSERT INTO zone VALUES (5, 'Common Garage', '25336', 15, 5, 2.00, 3.00, 2, '04-DEC-23 07:00:00', 6, '08-DEC-23 07:00:00');
INSERT INTO zone VALUES (6, 'Admin Garage', '14205', 10, 2, 5.00, 2.00, 7, '09-DEC-23 12:00:00', 1, '10-DEC-23 09:00:00');
INSERT INTO zone VALUES (7, 'Stadium Lot', '42521', 25, 0, 4.00, 5.00, 2, '11-DEC-23 09:00:00', 6, '15-JUN-23 06:00:00');

-- VEHICLES
INSERT INTO vehicle VALUES (8, 1, '6FG-5213', 'MD', 'Honda', 'Accord', 2020, 'Gray');
INSERT INTO vehicle VALUES (9, 2, '2AC-6211', 'NY', 'BMW', 'M5', 2023, 'Black');
INSERT INTO vehicle VALUES (10, 3, '8PA-6233', 'MD', 'Toyota', 'Corolla', 2008, 'White');
INSERT INTO vehicle VALUES (11, 4, 'ABU-0501', 'NY', 'Audi', 'A2', 2022, 'Blue');

-- MESSAGES
INSERT INTO message VALUES (12, 1, '01-FEB-23 04:23:47.125', 'It was very difficult to find parking space');
INSERT INTO message VALUES (13, 2, '26-MAY-23 12:44:34.234', 'Very nice parking lot');
INSERT INTO message VALUES (14, 3, '15-JAN-23 10:21:15', 'When will the upper floor open? Thanks!');
INSERT INTO message VALUES (15, 4, '09-DEC-23 11:00:42', 'Very convenient!!!');

-- PARKING SESSIONS
INSERT INTO parkingSession VALUES (16, 1, 8, 5, '04-DEC-23 07:00:00', '04-DEC-23 10:00:00', 36.00);
INSERT INTO parkingSession VALUES (17, 2, 9, 6, '09-DEC-23 01:55:54', '09-DEC-23 05:01:00', 61.00);
INSERT INTO parkingSession VALUES (18, 3, 10, 7, '12-DEC-23 09:26:53', '12-DEC-23 11:25:29', 11.06);
INSERT INTO parkingSession VALUES (19, 4, 11, 7, '13-DEC-23 04:15:02', '13-DEC-23 06:55:25', 16.80);

-- TRANSACTIONS
INSERT INTO transaction VALUES (20, 16, '04-DEC-23 07:00:00', 36.00, 3.00);
INSERT INTO transaction VALUES (21, 17, '09-DEC-23 01:55:54', 61.00, 3.08);
INSERT INTO transaction VALUES (22, 18, '12-DEC-23 09:26:53', 11.06, 1.58);
INSERT INTO transaction VALUES (23, 19, '13-DEC-23 04:15:02', 16.80, 2.40);

-- ========================
-- 5. VERIFICATION QUERIES
-- ========================

-- List all tables
SELECT table_name 
FROM user_tables 
ORDER BY table_name;

-- Count rows in each table
SELECT 'Customer' AS table_name, COUNT(*) AS row_count FROM customer
UNION ALL
SELECT 'Zone', COUNT(*) FROM zone
UNION ALL
SELECT 'Vehicle', COUNT(*) FROM vehicle
UNION ALL
SELECT 'Message', COUNT(*) FROM message
UNION ALL
SELECT 'ParkingSession', COUNT(*) FROM parkingSession
UNION ALL
SELECT 'Transaction', COUNT(*) FROM transaction;

-- Sample data check (first 5 rows per table)
SELECT * FROM customer WHERE ROWNUM <= 5;
SELECT * FROM zone WHERE ROWNUM <= 5;
SELECT * FROM vehicle WHERE ROWNUM <= 5;
SELECT * FROM message WHERE ROWNUM <= 5;
SELECT * FROM parkingSession WHERE ROWNUM <= 5;
SELECT * FROM transaction WHERE ROWNUM <= 5;

-- ========================
-- Script Ready for Use
-- ========================
COMMIT;


