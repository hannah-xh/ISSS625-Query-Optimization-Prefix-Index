# MySQL Query Optimization: Prefix Indexing Implementation

## About Me

I'm Zhang Xiaohan (xh.zhang.2024@mitb.smu.edu.sg), and I actively contributed to all aspects of this query optimization project. As one of the five team members in "The Optimization Bots" group, I was involved in the implementation, analysis, and presentation of the prefix indexing technique demonstrated in this repository.

## Project Overview

This repository demonstrates my implementation of prefix indexing as a query optimization technique in MySQL. The project focuses on improving query performance when filtering string columns, particularly with the `LIKE` operator for pattern matching.

## Technical Implementation

### Prefix Indexing Technique

MySQL allows the creation of secondary indexes for string columns using only the first N characters (prefixes) of the values stored in the column:

```sql
CREATE INDEX idx_first_name_prefix ON employee(first_name(10));
```

This technique:
- Improves performance for queries with `LIKE 'prefix%'`
- Reduces storage space compared to full-column indexes
- Is particularly efficient for lengthy columns like TEXT or VARCHAR

### Dataset Used

The project uses the Employee Sample Database obtained from DataStudySquad on GitHub [https://github.com/DataStudySquad/employee-sample-database-mysql]. The dataset is licensed under the MIT License.

We recreated the Employee database by running the dump files provided in the GitHub repository in the following order: load_department as 'department', load_dep_emp as 'dept_emp', load_dept_manager as 'dept_manager', load_employee as 'employee', load_salary1 and load_salary2 and load_salary3 together as 'salary' and load_title as 'title'.

The dataset contains fabricated information on 300,024 employees and their salaries.

### Query Optimization Implementation

The test query aggregates average salary and employee count by department for employees whose first names start with 'ma':

```sql
SELECT dept_no, AVG(amount) as `Average Salary`, count(*) as `No. of employees` 
FROM Dept_emp D 
INNER JOIN Salary S ON D.emp_no=S.emp_no AND S.to_date='9999-1-1' AND D.to_date='9999-1-1'
INNER JOIN (SELECT * FROM employee WHERE first_name LIKE 'ma%') E ON E.emp_no=S.emp_no
GROUP BY dept_no;
```

## Performance Analysis

### Metrics Used for Evaluation

I measured query performance using multiple metrics:
1. `EXPLAIN` and `EXPLAIN ANALYZE` output
2. Performance schema metrics
3. Buffer pool hit ratio
4. Statistical significance testing

### Performance Improvements

Implementation of the prefix index yielded:

| Metric | Improvement |
|--------|-------------|
| Execution Time | Reduced from 1.278s to 592ms (54% reduction) |
| Total Cost | 37.4% reduction |
| Scan Type | Changed from table scan to range scan |
| Rows Examined | Significantly reduced |
| Average Timer Wait | Decreased |
| Buffer Hit Ratio | 20% improvement |

The t-test results (p-value < 0.05) confirmed that the performance improvement was statistically significant.

## Technical Benefits

1. **Storage Efficiency**: Indexing only part of string columns reduces index size
2. **Creation Speed**: Faster to create than full-column indexes
3. **Query Performance**: Optimizes queries filtering on leading characters
4. **Memory Usage**: Efficient use of buffer pool resources

## Technical Limitations

1. **Limited Use Cases**: Only effective for queries filtering on leading characters
2. **Ordering Limitations**: Cannot be used for ordering or grouping operations
3. **Size Restrictions**: Limited to values less than 1000 bytes
4. **Pattern Matching Limits**: Only helps with patterns at the beginning of strings

## Repository Contents

- SQL implementation scripts:
  - `final.sql`: Complete script with all metrics and tests
  - `for the demo.sql`: Simplified demonstration script
- `Query Optimization Presentation.pdf`: Technical documentation

## Skills Demonstrated

- SQL query optimization techniques
- Performance analysis using MySQL's EXPLAIN and performance_schema
- Index strategy implementation
- Statistical validation of optimization results
- Database performance troubleshooting

## Contributors

This project was completed by "The Optimization Bots" group:
- Moo Jia Rong: jiarong.moo.2024@mitb.smu.edu.sg
- Ruiyi Di: ruiyi.di.2024@mitb.smu.edu.sg
- Stefanie Felicia: s.felicia.2024@mitb.smu.edu.sg
- Zhang Xiao han: xh.zhang.2024@mitb.smu.edu.sg (I participated in all aspects of this project)
- Sathvika Subramanian: sathvika.s.2024@mitb.smu.edu.sg

## Course Information

ISSS625 Query Processing and Optimisation
