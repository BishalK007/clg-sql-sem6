-- Clear Screen
cl scr
SET PAGESIZE 50;

SET LINESIZE 200;

DROP TABLE customer;

DROP TABLE cust1;

DROP TABLE cust_one;

DROP TABLE cust2;

DROP TABLE cust3;

DROP TABLE cust4;

-- 1. Create and insert given data in table customer. 
CREATE TABLE
    customer (
        cust_id NUMBER (3) PRIMARY KEY,
        cust_fname VARCHAR(20) NOT NULL,
        cust_lname VARCHAR(20) NOT NULL,
        territory VARCHAR(20),
        cred_lmt NUMBER (10, 2),
        mngr_id NUMBER (1),
        marital_status VARCHAR(10),
        sex CHAR(1),
        income NUMBER (15, 2)
    );

@customer-data.sql
-- @<Path-to-data->.sql
-- or copy and add the data manually
-- 2. Alter table and  Add column stay_from_year 
PROMPT 2. Alter table and  Add column stay_from_year 
ALTER TABLE customer ADD stay_from_year NUMBER (4);

-- 3. Set value of stay_from_year as 2001 for Italy/America and 2003 otherwise 
PROMPT 3. Set value of stay_from_year as 2001 for Italy/America and 2003 otherwise 
UPDATE customer
SET
    stay_from_year = CASE
        WHEN territory IN ('Italy', 'America') THEN 2001
        ELSE 2003
    END;

-- 4. Display credit limit attribute for America
PROMPT 4. Display credit limit attribute for America
SELECT
    cred_lmt
FROM
    customer
WHERE
    territory = 'America';

-- 5. Delete the record corresponding to Meg  Sen 
PROMPT 5. Delete the record corresponding to Meg  Sen 
DELETE FROM customer
WHERE
    cust_fname = 'Meg'
    AND cust_lname = 'Sen';

-- 6. Show all attributes for Italy
PROMPT 6. Show all attributes for Italy
SELECT
    *
FROM
    customer
WHERE
    territory = 'Italy';

-- 7. If territory is India and status is Single set value of credit to 7000
PROMPT 7. If territory is India and status is Single set value of credit to 7000
UPDATE customer
SET
    cred_lmt = 7000
WHERE
    territory = 'India'
    AND marital_status = 'Single';

-- 8. Rename cust_fname to first_name
PROMPT 8. Rename cust_fname to first_name
ALTER TABLE customer
RENAME COLUMN cust_fname TO first_name;

-- 9. Rename cust_lname to last_name
PROMPT 9. Rename cust_lname to last_name
ALTER TABLE customer
RENAME COLUMN cust_lname TO last_name;

-- 10. Create table cust1 from the old table customer(copy structure as well as data using CTAS statement).  
PROMPT 10. Create table cust1 from the old table customer(copy structure as well as data using CTAS statement).  
CREATE TABLE
    cust1 AS
SELECT
    *
FROM
    customer;

-- 11. Create tables cust2 without values of cust1 using CTAS statement. 
PROMPT 11. Create tables cust2 without values of cust1 using CTAS statement. 
CREATE TABLE
    cust2 AS
SELECT
    *
FROM
    customer
WHERE
    1 = 0;

-- 12. Create tables cust3 with attributes cust_id,cust_fname,cust_lname,income from old customer table only 5 rows.(using CTAS statement). 
PROMPT 12. Create tables cust3 with attributes cust_id,cust_fname,cust_lname,income from old customer table only 5 rows.(using CTAS statement). 
CREATE TABLE
    cust3 AS
SELECT
    cust_id,
    first_name,
    last_name,
    income
FROM
    customer
WHERE
    ROWNUM <= 5;

-- 13. Create tables cust4 with attributes name customer_id,firstname,lastname, income from old customer table(using CTAS statement). 
PROMPT 13. Create tables cust4 with attributes name customer_id,firstname,lastname, income from old customer table(using CTAS statement). 
CREATE TABLE
    cust4 AS
SELECT
    cust_id AS customer_id,
    first_name AS firstname,
    last_name AS lastname,
    income
FROM
    customer
WHERE
    1 = 0;

-- 14. Drop column income from cust1. 
PROMPT 14. Drop column income from cust1. 
ALTER TABLE cust1
DROP COLUMN income;

-- 15. Rename table cust1 to cust_one 
PROMPT 15. Rename table cust1 to cust_one 
RENAME cust1 TO cust_one;

-- 16. Insert values into cust2 table from customer table 
PROMPT 16. Insert values into cust2 table from customer table 
INSERT INTO
    cust2
SELECT
    *
FROM
    customer;

-- 17. Insert values into cust3 table with attributes cust_ id, f_name, l_name,Income from customer table where income > 50000 
PROMPT 17. Insert values into cust3 table with attributes cust_ id, f_name, l_name,Income from customer table where income > 50000 
INSERT INTO
    cust3 (cust_id, first_name, last_name, income)
SELECT
    cust_id,
    first_name,
    last_name,
    income
FROM
    customer
WHERE
    income > 50000;

-- 18. alter the table cust4 change cust id to varchar(6) and income to number(16, 2) 
PROMPT 18. alter the table cust4 change cust id to varchar(6) and income to number(16, 2) 
ALTER TABLE cust4 MODIFY (
    customer_id VARCHAR(6) NOT NULL,
    income NUMBER (16, 2)
);

-- 19. Add new attribute mngr_name to cust4 and insert 5 records 
PROMPT 19. Add new attribute mngr_name to cust4 and insert 5 records 
ALTER TABLE cust4 ADD mngr_name VARCHAR(15);

@cust4-data.sql
-- @<Path-to-data->.sql
-- or copy and add the data manually

-- 20. Add attribute territory to cust4 
PROMPT 20. Add attribute territory to cust4 
ALTER TABLE cust4 ADD territory VARCHAR(15);

-- 21. Drop table cust3 and then bring it back. 
PROMPT 21. Drop table cust3 and then bring it back. 
-- DROP TABLE cust3;
-- FLASHBACK TABLE cust3 TO BEFORE DROP; 

-- 22. Increase the size of the column cust_id by 5. 
PROMPT 22. Increase the size of the column cust_id by 5. 
ALTER TABLE customer MODIFY cust_id NUMBER (8) NOT NULL; -- Requires pl/sql to do dynamically.


-- 23. Suppose the customer with id no 1 has changed her last name & now it is just same as the customer with id no 2. 
PROMPT 23. Suppose the customer with id no 1 has changed her last name & now it is just same as the customer with id no 2. 
-- 24. Update  customer set lname=(select lname from customer where cid=1) where cid=2.  
UPDATE customer SET last_name = (SELECT last_name FROM customer where cust_id=1) WHERE cust_id=2;

-- 25. Display the records where territory=America & crd_lmt=25000. 
PROMPT 25. Display the records where territory=America & crd_lmt=25000. 
SELECT * FROM customer WHERE territory='America' AND cred_lmt=25000;

-- 26. Display the records of all Indian customers whose income>20000.
PROMPT 26. Display the records of all Indian customers whose income>20000.
SELECT * FROM customer WHERE income > 20000 AND territory = 'India';

-- 27. Display the name of the customer having crd_lmt between 2000 and 7000. 
PROMPT 27. Display the name of the customer having crd_lmt between 2000 and 7000. 
SELECT first_name || ' ' || last_name AS name FROM customer WHERE cred_lmt > 2000 AND cred_lmt < 7000;

-- 28. Display the records of the customers having income 20000,24000,300,4500 using only one query. 
PROMPT 28. Display the records of the customers having income 20000,24000,300,4500 using only one query. 
SELECT first_name || ' ' || last_name AS name FROM customer WHERE income IN(20000, 24000, 300, 4500);

-- 29. Display the records in ascending order of first name
PROMPT 29. Display the records in ascending order of first name
SELECT * FROM CUSTOMER ORDER BY first_name ASC;

-- 30. Display the records in descending order of income. 
PROMPT 30. Display the records in descending order of income. 
SELECT * FROM CUSTOMER ORDER BY income DESC;

-- 31. Insert a duplicate record and display all the records. 
PROMPT 31. Insert a duplicate record and display all the records. 
-- write urself

-- 32. Suppose your friend wants to select a name from the names of the customers. Show the different names of the student
PROMPT 32. Suppose your friend wants to select a name from the names of the customers. Show the different names of the student
SELECT DISTINCT first_name FROM customer;


commit;