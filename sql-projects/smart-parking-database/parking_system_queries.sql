------------------------------------------------------------
-- FEATURE 1: Create or Update Customer
------------------------------------------------------------

SET SERVEROUTPUT ON;

CREATE SEQUENCE CustomerID_seq START WITH 5;

CREATE OR REPLACE PROCEDURE create_or_update_customer(
    p_name IN VARCHAR2,
    p_phone_number IN VARCHAR2,
    p_address IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zipcode IN VARCHAR2,
    p_email IN VARCHAR2,
    p_credit_card_number IN VARCHAR2
) AS
    v_customer_id NUMBER;
BEGIN
    -- Attempt to find a customer with the same phone number
    SELECT COUNT(*) INTO v_customer_id FROM customer WHERE c_phoneNum = p_phone_number;

    IF v_customer_id = 0 THEN
        -- Create new customer
        INSERT INTO customer(custid, c_name, c_phoneNum, c_address, c_state, c_zip, c_email, c_paymentNum)
        VALUES (CustomerID_seq.NEXTVAL, p_name, p_phone_number, p_address, p_state, p_zipcode, p_email, p_credit_card_number);

        DBMS_OUTPUT.PUT_LINE('No Account Associated with this Number, Account has been Created with Customer ID of ' || CustomerID_seq.CURRVAL);

    ELSE
        -- Update existing customer
        UPDATE customer SET 
            c_name = p_name,
            c_address = p_address,
            c_state = p_state,
            c_zip = p_zipcode,
            c_email = p_email,
            c_paymentNum = p_credit_card_number
        WHERE c_phoneNum = p_phone_number;

        DBMS_OUTPUT.PUT_LINE('Customer already exists. Information updated.');
    END IF;
END;
/
------------------------------------------------------------
-- Validation Feature 1
------------------------------------------------------------

-- 1. Insert new customer
EXEC create_or_update_customer('Alice', '927-654-8510', '807 Foxwell Rd', 'Maryland', '21061', 'alice@example.com', '9876543210654321');

-- 2. Update existing customer
EXEC create_or_update_customer('Bob', '912-552-2499', '123 Main St', 'California', '90210', 'alice@example.com', '9876543210123456');

-- Check customer table
SELECT * FROM customer;

------------------------------------------------------------
-- FEATURE 2: Add Vehicle
------------------------------------------------------------

CREATE OR REPLACE FUNCTION add_vehicle(
    f_plate_num IN VARCHAR2, 
    f_plate_state IN VARCHAR2, 
    f_cust_id IN INT, 
    f_vehicle_make IN VARCHAR2, 
    f_vehicle_model IN VARCHAR2, 
    f_vehicle_year IN INT, 
    f_vehicle_color IN VARCHAR2
) RETURN INT
IS
    f_vehicle_id INT;
    f_plate_count INT;
    f_cust_count INT;
BEGIN
    -- Generate new vehicle ID
    SELECT COALESCE(MAX(vid),0)+1 INTO f_vehicle_id FROM vehicle;

    -- Check if vehicle already exists
    SELECT COUNT(*) INTO f_plate_count FROM vehicle WHERE v_platenum = f_plate_num AND v_state = f_plate_state;

    -- Check if customer exists
    SELECT COUNT(*) INTO f_cust_count FROM customer WHERE custid = f_cust_id;

    IF f_plate_count = 0 THEN
        IF f_cust_count > 0 THEN
            INSERT INTO vehicle (vid, custid, v_platenum, v_state, v_maker, v_model, v_year, v_color)
            VALUES (f_vehicle_id, f_cust_id, f_plate_num, f_plate_state, f_vehicle_make, f_vehicle_model, f_vehicle_year, f_vehicle_color);
            RETURN f_vehicle_id;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid Customer ID!');
            RETURN -1;
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Vehicle Already Exists!');
        RETURN -1;
    END IF;
END;
/
------------------------------------------------------------
-- Validation Feature 2
------------------------------------------------------------

-- 1. Valid Vehicle
DECLARE
    test_result INT;
BEGIN
    test_result := add_vehicle('SPEED','MD',1,'Chevrolet','Corvette',2022,'Red');
    DBMS_OUTPUT.PUT_LINE('Returned Vehicle ID: ' || test_result);
END;
/

-- 2. Vehicle Already Exists
DECLARE
    test_result INT;
BEGIN
    test_result := add_vehicle('2AC-6211','NY',3,'BMW','M5',2023,'Black');
    DBMS_OUTPUT.PUT_LINE('Returned Vehicle ID: ' || test_result);
END;
/

-- 3. Invalid Customer ID
DECLARE
    test_result INT;
BEGIN
    test_result := add_vehicle('NO C02','MD',20,'Tesla','Model 3',2020,'Blue');
    DBMS_OUTPUT.PUT_LINE('Returned Vehicle ID: ' || test_result);
END;
/

-- Check vehicle table
SELECT * FROM vehicle;

------------------------------------------------------------
-- FEATURE 3: Search Parking Zone
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE search_parking_zone(
    v_zipcode VARCHAR2, 
    v_startTime TIMESTAMP, 
    v_endTime TIMESTAMP
)
IS
    v_available INT;
BEGIN
    -- Count available zones
    SELECT COUNT(*) INTO v_available
    FROM zone
    WHERE z_zip = v_zipcode AND start_time <= v_startTime AND end_time >= v_endTime AND z_avblSlot > 0;

    IF v_available = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No available zone');
        RETURN;
    END IF;

    FOR results IN (
        SELECT * 
        FROM zone
        WHERE z_zip = v_zipcode AND start_time <= v_startTime AND end_time >= v_endTime AND z_avblSlot > 0
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Zone ID: ' || results.zid);
        DBMS_OUTPUT.PUT_LINE('Address: ' || results.z_address);
        DBMS_OUTPUT.PUT_LINE('Available spots: ' || results.z_avblSlot);
        DBMS_OUTPUT.PUT_LINE('Hourly rate: ' || results.z_hrRate);
        DBMS_OUTPUT.PUT_LINE('Max parking length: ' || results.z_maxParkingLength);
        DBMS_OUTPUT.PUT_LINE('Start day: ' || results.start_dayOfWeek || ' Start time: ' || TO_CHAR(results.start_time,'HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('End day: ' || results.endDayOfWeek || ' End time: ' || TO_CHAR(results.end_time,'HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    END LOOP;
END;
/
------------------------------------------------------------
-- Validation Feature 3
------------------------------------------------------------

-- 1. Valid slot
EXEC search_parking_zone('25336', TO_TIMESTAMP('2023-12-04 09:25:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-08 05:26:00','YYYY-MM-DD HH24:MI:SS'));

-- 2. Invalid time
EXEC search_parking_zone('25336', TO_TIMESTAMP('2023-12-04 06:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-08 07:00:00','YYYY-MM-DD HH24:MI:SS'));

-- 3. No available slots
EXEC search_parking_zone('42521', TO_TIMESTAMP('2023-12-13 10:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-06-14 05:15:22','YYYY-MM-DD HH24:MI:SS'));

-- Check zone table
SELECT * FROM zone;

------------------------------------------------------------
-- FEATURE 4: Get Parking Sessions
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_parking_sessions(
    p_custid IN customer.custid%TYPE,
    p_start_date IN TIMESTAMP,
    p_end_date IN TIMESTAMP
)
IS
    total_charge NUMBER := 0;
BEGIN
    -- Ensure customer exists
    SELECT 0 INTO total_charge FROM customer WHERE custid = p_custid;

    FOR session_info IN (
        SELECT seid, start_timeSession, end_timeSession, zid, vid, total_charge
        FROM parkingSession
        WHERE custid = p_custid
          AND start_timeSession BETWEEN p_start_date AND p_end_date
    )
    LOOP
        total_charge := total_charge + session_info.total_charge;
        DBMS_OUTPUT.PUT_LINE('Session ID: ' || session_info.seid ||
                            ', Start: ' || session_info.start_timeSession ||
                            ', End: ' || session_info.end_timeSession ||
                            ', Zone ID: ' || session_info.zid ||
                            ', Vehicle ID: ' || session_info.vid ||
                            ', Charge: ' || session_info.total_charge);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Charge for Customer ' || p_custid || ': $' || total_charge);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No such customer');
END;
/
------------------------------------------------------------
-- Validation Feature 4
------------------------------------------------------------

-- Existing customer
EXEC get_parking_sessions(1, TO_TIMESTAMP('2023-12-04 01:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-14 12:00:00','YYYY-MM-DD HH24:MI:SS'));

-- Non-existent customer
EXEC get_parking_sessions(8, TO_TIMESTAMP('2023-12-04 01:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-12-14 12:00:00','YYYY-MM-DD HH24:MI:SS'));

-- Check table
SELECT * FROM parkingSession;

------------------------------------------------------------
-- FEATURE 5: List Active Sessions at a Zone
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE list_active_sessions_at_zone(
    p_zone_id INT,
    p_current_time TIMESTAMP
)
IS
    l_exists NUMBER;
    l_active_sessions NUMBER := 0;
BEGIN
    -- Check if zone exists
    SELECT COUNT(*) INTO l_exists FROM zone WHERE zid = p_zone_id;
    IF l_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Incorrect zone ID');
        RETURN;
    END IF;

    -- Fetch active sessions
    FOR active_session IN (
        SELECT ps.vid, ps.custid, v.v_platenum, v.v_state, v.v_maker, v.v_model, v.v_color
        FROM parkingSession ps
        JOIN vehicle v ON ps.vid = v.vid
        WHERE ps.zid = p_zone_id
          AND p_current_time BETWEEN ps.start_timeSession AND ps.end_timeSession
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Vehicle ID: ' || active_session.vid);
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || active_session.custid);
        DBMS_OUTPUT.PUT_LINE('Plate: ' || active_session.v_platenum);
        DBMS_OUTPUT.PUT_LINE('State: ' || active_session.v_state);
        DBMS_OUTPUT.PUT_LINE('Maker: ' || active_session.v_maker);
        DBMS_OUTPUT.PUT_LINE('Model: ' || active_session.v_model);
        DBMS_OUTPUT.PUT_LINE('Color: ' || active_session.v_color);
        l_active_sessions := l_active_sessions + 1;
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;

    IF l_active_sessions = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No active session');
    END IF;
END;
/
------------------------------------------------------------
-- Validation Feature 5
------------------------------------------------------------

-- Normal case
EXEC list_active_sessions_at_zone(5, TO_TIMESTAMP('2023-12-04 09:00:00','YYYY-MM-DD HH24:MI:SS'));

-- Incorrect zone
EXEC list_active_sessions_at_zone(999, TO_TIMESTAMP('2023-12-04 09:00:00','YYYY-MM-DD HH24:MI:SS'));

-- No active sessions
EXEC list_active_sessions_at_zone(6, TO_TIMESTAMP('2023-12-04 09:00:00','YYYY-MM-DD HH24:MI:SS'));

------------------------------------------------------------
-- FEATURE 6: Start Parking Session
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE start_session(
    v_custID INT,
    v_vehicleID INT,
    v_zoneID INT,
    v_startTime TIMESTAMP,
    v_hoursToPark INT
)
IS
    v_availableSpots INT;
    v_effectiveStart TIMESTAMP;
    v_effectiveEnd TIMESTAMP;
    v_totalCharge DECIMAL(5,2) := 0.00;
BEGIN
    -- Validate customer, vehicle, zone
    SELECT COUNT(*) INTO v_availableSpots FROM customer WHERE custID = v_custID;
    IF v_availableSpots = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid customer ID.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_availableSpots FROM vehicle WHERE vid = v_vehicleID;
    IF v_availableSpots = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid vehicle ID.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_availableSpots FROM zone WHERE zid = v_zoneID AND z_avblSlot > 0;
    IF v_availableSpots = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No available spot in the zone.');
        RETURN;
    END IF;

    -- Effective period check
    SELECT start_time, end_time, z_hrRate INTO v_effectiveStart, v_effectiveEnd, v_totalCharge
    FROM zone
    WHERE zid = v_zoneID;

    IF v_startTime < v_effectiveStart OR v_startTime > v_effectiveEnd THEN
        DBMS_OUTPUT.PUT_LINE('Start time is outside effective period.');
        RETURN;
    END IF;

    IF NUMTODSINTERVAL(v_hoursToPark,'hour') > (v_effectiveEnd - v_startTime) THEN
        DBMS_OUTPUT.PUT_LINE('Parking length exceeds maximal length.');
        RETURN;
    END IF;

    -- Compute total charge
    v_totalCharge := v_hoursToPark * v_totalCharge;

    -- Insert session
    INSERT INTO parkingSession VALUES (
        (SELECT COALESCE(MAX(seid),0)+1 FROM parkingSession),
        v_custID,
        v_vehicleID,
        v_zoneID,
        v_startTime,
        v_startTime + NUMTODSINTERVAL(v_hoursToPark,'hour'),
        v_totalCharge
    );

    -- Insert message
    INSERT INTO message VALUES (
        (SELECT COALESCE(MAX(mid),0)+1 FROM message),
        v_custID,
        v_startTime,
        'New parking session started.'
    );

    -- Update zone spots
    UPDATE zone SET z_avblSlot = z_avblSlot - 1 WHERE zid = v_zoneID;

    -- Insert transaction
    INSERT INTO transaction VALUES (
        (SELECT COALESCE(MAX(payment_id),0)+1 FROM transaction),
        (SELECT MAX(seid) FROM parkingSession),
        v_startTime,
        v_totalCharge,
        v_hoursToPark
    );

    DBMS_OUTPUT.PUT_LINE('Parking session started. Total charge: $' || v_totalCharge);
END;
/
------------------------------------------------------------
-- Validation Feature 6
------------------------------------------------------------

-- Valid session
EXEC start_session(1,8,5, TO_TIMESTAMP('2023-12-04 10:00:00','YYYY-MM-DD HH24:MI:SS'),2);

-- No spot
EXEC start_session(4,11,5, TO_TIMESTAMP('2023-12-04 09:00:00','YYYY-MM-DD HH24:MI:SS'),5);

-- Start outside effective period
EXEC start_session(3,10,7, TO_TIMESTAMP('2023-12-04 06:00:00','YYYY-MM-DD HH24:MI:SS'),1);

-- Exceeds max length
EXEC start_session(2,9,6, TO_TIMESTAMP('2023-12-09 15:00:00','YYYY-MM-DD HH24:MI:SS'),100);

-- Check tables
SELECT * FROM parkingSession;
SELECT * FROM message;
SELECT * FROM zone;
SELECT * FROM transaction;

------------------------------------------------------------
-- FEATURE 7: Extend Parking Session
------------------------------------------------------------

CREATE SEQUENCE message_seq;
CREATE SEQUENCE payment_seq;

CREATE OR REPLACE PROCEDURE extend_session(
    v_session_id IN parkingSession.Seid%TYPE,
    v_current_time IN TIMESTAMP,
    v_hours_to_extend IN NUMBER
)
IS
    v_end_time TIMESTAMP;
    v_max_length NUMBER;
    v_hourly_rate NUMBER;
    v_customer_id NUMBER;
    v_new_end_time TIMESTAMP;
    v_message_id NUMBER;
    v_payment_id NUMBER;
BEGIN
    SELECT end_timeSession, custid, z_maxParkingLength, z_hrRate
    INTO v_end_time, v_customer_id, v_max_length, v_hourly_rate
    FROM parkingSession p
    JOIN zone z ON p.zid = z.zid
    WHERE p.Seid = v_session_id;

    IF v_hours_to_extend > v_max_length THEN
        DBMS_OUTPUT.PUT_LINE('Requested length exceeds max parking length.');
        RETURN;
    END IF;

    IF v_current_time >= v_end_time THEN
        DBMS_OUTPUT.PUT_LINE('Cannot extend after session expired.');
        RETURN;
    END IF;

    v_new_end_time := v_end_time + INTERVAL '1' HOUR * v_hours_to_extend;

    UPDATE parkingSession
    SET end_timeSession = v_new_end_time,
        total_charge = total_charge + (v_hourly_rate * v_hours_to_extend)
    WHERE seid = v_session_id;

    SELECT message_seq.NEXTVAL INTO v_message_id FROM dual;
    INSERT INTO message VALUES (v_message_id, v_customer_id, v_current_time, 'Session ' || v_session_id || ' extended.');

    SELECT payment_seq.NEXTVAL INTO v_payment_id FROM dual;
    INSERT INTO transaction VALUES (v_payment_id, v_session_id, v_current_time, v_hourly_rate * v_hours_to_extend, v_hours_to_extend);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Session extended successfully.');
END;
/
------------------------------------------------------------
-- Validation Feature 7
------------------------------------------------------------

-- Valid extension
DECLARE
    v_session_id NUMBER := 16;
    v_current_time TIMESTAMP := TO_TIMESTAMP('2023-12-04 09:45:00','YYYY-MM-DD HH24:MI:SS');
    v_hours_to_extend NUMBER := 1;
BEGIN
    extend_session(v_session_id, v_current_time, v_hours_to_extend);
END;
/

-- After expiry
DECLARE
    v_session_id NUMBER := 16;
    v_current_time TIMESTAMP := TO_TIMESTAMP('2023-12-04 12:45:00','YYYY-MM-DD HH24:MI:SS');
    v_hours_to_extend NUMBER := 5;
BEGIN
    extend_session(v_session_id, v_current_time, v_hours_to_extend);
END;
/

-- Exceeds max length
DECLARE
    v_session_id NUMBER := 18;
    v_current_time TIMESTAMP := TO_TIMESTAMP('2023-12-12 09:45:00','YYYY-MM-DD HH24:MI:SS');
    v_hours_to_extend NUMBER := 9;
BEGIN
    extend_session(v_session_id, v_current_time, v_hours_to_extend);
END;
/

-- Check table
SELECT * FROM parkingSession;
SELECT * FROM message;
SELECT * FROM transaction;

------------------------------------------------------------
-- FEATURE 8: Stop Parking Session
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE stop_session(
    v_sessionID INT,
    v_currentTime TIMESTAMP
)
IS
    v_endTime TIMESTAMP;
    v_custID INT;
BEGIN
    -- Retrieve session info
    SELECT end_timeSession, custid INTO v_endTime, v_custID
    FROM parkingSession
    WHERE seid = v_sessionID;

    IF v_currentTime > v_endTime THEN
        -- Session expired: insert warning message
        INSERT INTO message VALUES(
            (SELECT COALESCE(MAX(mid),0)+1 FROM message),
            v_custID,
            v_currentTime,
            'Session ' || v_sessionID || ' is expired. You may get a ticket.'
        );
        DBMS_OUTPUT.PUT_LINE('The session ' || v_sessionID || ' is expired. You may get a ticket.');
    ELSE
        -- Session ending normally
        UPDATE parkingSession
        SET end_timeSession = v_currentTime
        WHERE seid = v_sessionID;

        INSERT INTO message VALUES(
            (SELECT COALESCE(MAX(mid),0)+1 FROM message),
            v_custID,
            v_currentTime,
            'Session ' || v_sessionID || ' ended at ' || v_currentTime
        );

        DBMS_OUTPUT.PUT_LINE('The session ' || v_sessionID || ' ends at ' || v_currentTime);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid session ID');
END;
/
------------------------------------------------------------
-- Validation Feature 8
------------------------------------------------------------

-- Invalid session ID
EXEC stop_session(25, TO_TIMESTAMP('2023-12-04 10:00:00','YYYY-MM-DD HH24:MI:SS'));

-- Session expired
EXEC stop_session(16, TO_TIMESTAMP('2023-12-04 12:00:00','YYYY-MM-DD HH24:MI:SS'));

-- Session ends normally
EXEC stop_session(16, TO_TIMESTAMP('2023-12-04 09:30:00','YYYY-MM-DD HH24:MI:SS'));

-- Check tables
SELECT * FROM parkingSession;
SELECT * FROM message;

------------------------------------------------------------
-- FEATURE 9: Create Reminder for Sessions Expiring in 15 Minutes
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE create_reminder(
    v_currentTime TIMESTAMP
)
IS
BEGIN
    FOR session IN (
        SELECT seid, custid, end_timeSession
        FROM parkingSession
        WHERE end_timeSession BETWEEN v_currentTime AND v_currentTime + INTERVAL '15' MINUTE
    )
    LOOP
        INSERT INTO message VALUES(
            (SELECT COALESCE(MAX(mid),0)+1 FROM message),
            session.custid,
            v_currentTime,
            'Session ' || session.seid || ' will expire in 15 minutes.'
        );
        DBMS_OUTPUT.PUT_LINE('Reminder created for session ' || session.seid);
    END LOOP;
END;
/
------------------------------------------------------------
-- Validation Feature 9
------------------------------------------------------------

-- Session expiring in 15 minutes
EXEC create_reminder(TO_TIMESTAMP('2023-12-04 09:45:00','YYYY-MM-DD HH24:MI:SS'));

-- Session not expiring
EXEC create_reminder(TO_TIMESTAMP('2023-12-12 11:00:29','YYYY-MM-DD HH24:MI:SS'));

-- Check table
SELECT * FROM message;

------------------------------------------------------------
-- FEATURE 10: Statistics
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE statistics(
    date_start TIMESTAMP,
    date_end TIMESTAMP
)
IS
    v_customer_count INT;
    v_vehicle_count INT;
    v_zone_count INT;
    v_session_count INT;
    v_total_revenue NUMBER;
    v_avg_revenue NUMBER;
BEGIN
    -- Total customers
    SELECT COUNT(*) INTO v_customer_count FROM customer;
    DBMS_OUTPUT.PUT_LINE('Total customers: ' || v_customer_count);

    -- Total vehicles
    SELECT COUNT(*) INTO v_vehicle_count FROM vehicle;
    DBMS_OUTPUT.PUT_LINE('Total vehicles: ' || v_vehicle_count);

    -- Total zones
    SELECT COUNT(*) INTO v_zone_count FROM zone;
    DBMS_OUTPUT.PUT_LINE('Total zones: ' || v_zone_count);

    -- Sessions in period
    SELECT COUNT(*), COALESCE(SUM(total_charge),0), COALESCE(AVG(total_charge),0)
    INTO v_session_count, v_total_revenue, v_avg_revenue
    FROM parkingSession
    WHERE start_timeSession < date_end AND end_timeSession > date_start;

    DBMS_OUTPUT.PUT_LINE('Total sessions in period: ' || v_session_count);
    DBMS_OUTPUT.PUT_LINE('Total revenue in period: $' || v_total_revenue);
    DBMS_OUTPUT.PUT_LINE('Average revenue per session: $' || v_avg_revenue);

    -- Optional: detailed zone info
    FOR z IN (SELECT zid, z_capacity FROM zone) LOOP
        DECLARE
            v_zone_sess INT;
            v_zone_rev NUMBER;
        BEGIN
            SELECT COUNT(*), COALESCE(SUM(total_charge),0)
            INTO v_zone_sess, v_zone_rev
            FROM parkingSession
            WHERE zid = z.zid
              AND start_timeSession < date_end
              AND end_timeSession > date_start;

            DBMS_OUTPUT.PUT_LINE('Zone ' || z.zid || ': Sessions=' || v_zone_sess || ', Revenue=$' || v_zone_rev);
        END;
    END LOOP;
END;
/
------------------------------------------------------------
-- Validation Feature 10
------------------------------------------------------------

EXEC statistics(
    TO_TIMESTAMP('2023-12-03 10:00:00','YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2023-12-13 10:00:00','YYYY-MM-DD HH24:MI:SS')
);

