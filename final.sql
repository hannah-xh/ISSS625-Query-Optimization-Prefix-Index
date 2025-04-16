-- Change Database
USE employee;
-- BEFORE OPTIMISATION

-- METRIC: EXPLAIN
EXPLAIN
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- METRIC: EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- METRIC: PERFORMANCE SCHEMA
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%' ) E ON E.emp_no=S.emp_no
GROUP BY dept_no;

SELECT DIGEST_TEXT, COUNT_STAR, AVG_TIMER_WAIT, SUM_ROWS_SENT,
       SUM_ROWS_EXAMINED, SUM_CREATED_TMP_TABLES, SUM_SELECT_FULL_JOIN,
       SUM_SELECT_FULL_RANGE_JOIN, SUM_SELECT_RANGE, SUM_SELECT_RANGE_CHECK,
       SUM_SELECT_SCAN, SUM_NO_INDEX_USED, SUM_NO_GOOD_INDEX_USED, SUM_CPU_TIME,
       MAX_CONTROLLED_MEMORY, MAX_TOTAL_MEMORY, COUNT_SECONDARY
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT LIKE 'SELECT%'
ORDER BY LAST_SEEN DESC
LIMIT 5;

-- OPTIMISATION: CREATE INDEX
CREATE INDEX idx_first_name_prefix ON employee(first_name(10));
-- CLEAR HISTORY
TRUNCATE TABLE performance_schema.events_statements_summary_by_digest;

-- METRIC: EXPLAIN 
EXPLAIN
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%' ) E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- METRIC: EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%' ) E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- METRIC: PERFORMANCE SCHEMA
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%' ) E ON E.emp_no=S.emp_no
GROUP BY dept_no;

SELECT DIGEST_TEXT, COUNT_STAR, AVG_TIMER_WAIT, SUM_ROWS_SENT,
       SUM_ROWS_EXAMINED, SUM_CREATED_TMP_TABLES, SUM_SELECT_FULL_JOIN,
       SUM_SELECT_FULL_RANGE_JOIN, SUM_SELECT_RANGE, SUM_SELECT_RANGE_CHECK,
       SUM_SELECT_SCAN, SUM_NO_INDEX_USED, SUM_NO_GOOD_INDEX_USED, SUM_CPU_TIME,
       MAX_CONTROLLED_MEMORY, MAX_TOTAL_MEMORY, COUNT_SECONDARY
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT LIKE 'SELECT%'
ORDER BY LAST_SEEN DESC
LIMIT 5;

-- METRIC: BUFFER POOL HIT RATIO
DROP INDEX idx_first_name_prefix ON employee;
-- BUFFER POOL HIT RATIO BEFORE ANY QUERY
SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');

-- NON-OPTIMISED QUERY
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- BUFFER POOL HIT RATIO AFTER NON-OPTIMISED QUERY
SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');

-- OPTIMISATION: CREATE INDEX
CREATE INDEX idx_first_name_prefix ON employee(first_name(10));
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

-- BUFFER POOL HIT RATIO AFTER OPTIMISED QUERY
SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');
