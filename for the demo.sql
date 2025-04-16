USE employee;


DROP INDEX idx_first_name_prefix ON employee;
SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');

SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');

CREATE INDEX idx_first_name_prefix ON employee(first_name(10));

SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` FROM
Dept_emp D INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;

SELECT (SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_reads',
               VARIABLE_VALUE, 0)) / SUM(IF(VARIABLE_NAME = 'Innodb_buffer_pool_read_requests',
            VARIABLE_VALUE, 0))) * 100 AS Buffer_Hit_Ratio
FROM performance_schema.global_status
WHERE VARIABLE_NAME IN ('Innodb_buffer_pool_reads', 'Innodb_buffer_pool_read_requests');
