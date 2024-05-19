cl scr
SET PAGESIZE 50;

SET LINESIZE 200;

DROP TABLE cust_100;
DROP TABLE dept;


CREATE TABLE dept(
    dept_id NUMBER(3) PRIMARY KEY,
    dept_name VARCHAR2(15)
);
CREATE TABLE cust_100(
    emp_id NUMBER(3) PRIMARY KEY,
    first_name VARCHAR2(10),
    last_name VARCHAR2(10),
    email VARCHAR2(30),
    ph_no VARCHAR2(15),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER(8,2),
    mgr_id NUMBER(3),
    dept_id NUMBER(3),
    CONSTRAINT all_upper_email CHECK(email = UPPER(email)),
    CONSTRAINT date_gt_01_jan_1980 CHECK(hire_date > TO_DATE('01-JAN-1980', 'DD-Mon-YYYY')),
    CONSTRAINT job_id_begin_FI_AD_IT CHECK (
        job_id LIKE 'FI%' OR
        job_id LIKE 'AD%' OR
        job_id LIKE 'IT%'
    ),
    CONSTRAINT salary_bw_4k_25k CHECK(salary >= 4000 AND salary <= 25000),
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id)
);

PROMPT "Insert DATA"
@data.sql

-- 2. Drop column mrg_id
PROMPT "2. Drop column mrg_id"
ALTER TABLE cust_100
DROP COLUMN mgr_id;

DESCRIBE cust_100;

-- 3. Add column mgr_id and make it self referenced such that first 4 id’s correspond to first emp_id, next 4 correspond to fifth emp_id and the last 2 correspond to the ninth emp_id
PROMPT "3. Add column mgr_id and make it self referenced such that first 4 id’s correspond to first emp_id, next 4 correspond to fifth emp_id and the last 2 correspond to the ninth emp_id"
ALTER TABLE cust_100
ADD mgr_id NUMBER(3);

ALTER TABLE cust_100
ADD CONSTRAINT fk_mgr_id_emp_id
FOREIGN KEY (mgr_id)
REFERENCES cust_100(emp_id);

UPDATE cust_100
SET mgr_id = CASE
    WHEN ROWNUM <= 4 THEN 1
    WHEN ROWNUM <= 8 THEN 5
    ELSE 9
    END;
SELECT * FROM cust_100;


-- SELECT TABLE_NAME, CONSTRAINT_NAME, R_CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION FROM USER_CONSTRAINTS
-- WHERE TABLE_NAME IN('DEPT', 'CUST_100');
