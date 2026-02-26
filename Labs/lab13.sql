-- Common Aggregate Functions:
-- 1. COUNT() function returns the number of rows that match a specified condition.
--- example:
-- Count total number of employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- Count employees with non-NULL email addresses
SELECT COUNT(email) AS employees_with_email
FROM employees;

-- Count unique departments
SELECT COUNT(DISTINCT department) AS unique_departments
FROM employees;

-- 2. SUM() function calculates the total sum of numeric values.
--- example:
-- Calculate total salary expenditure
SELECT SUM(salary) AS total_salaries
FROM employees;
-- Calculate total sales by department
SELECT department, SUM(sales_amount) AS total_sales
FROM sales_data
GROUP BY department;

-- 3. AVG() function calculates the arithmetic mean of numeric values.
--- example:
-- Calculate average salary
SELECT AVG(salary) AS average_salary
FROM employees;
-- Calculate average age by department
SELECT department, AVG(age) AS avg_age
FROM employees
GROUP BY department;

-- 4. MAX() and MIN() find the maximum and minimum values respectively.
--- example:
-- Find highest and lowest salaries
SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;

-- Find the most recent hire date by department
SELECT department, MAX(hire_date) AS latest_hire
FROM employees
GROUP BY department;

-- 5. STRING_AGG() concatenates values from multiple rows into a single string with a specified delimiter.
--- examples:
-- List all employees in each department as a comma-separated string
SELECT department, STRING_AGG(first_name, ', ') AS employee_names
FROM employees
GROUP BY department;

-- Create a list of skills per employee (ordered alphabetically)
SELECT employee_id, STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills
GROUP BY employee_id;

-- 6. ARRAY_AGG() collects values from multiple rows into an array.
--- examples:
-- Create an array of all salaries in each department
SELECT department, ARRAY_AGG(salary) AS salary_array
FROM employees
GROUP BY department;

-- Create ordered array of employee names
SELECT department, ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees
GROUP BY department;


-- Statistical Aggregate Functions:
-- PostgreSQL provides several statistical functions:
-- Standard deviation and variance
SELECT
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

-- Correlation coefficient between two numeric columns
SELECT CORR(experience_years, salary) AS experience_salary_correlation
FROM employees;

-- GROUP BY clause is essential when using aggregate functions to group rows based on one or more columns.
-- Basic GROUP BY example:
-- Sales summary by product category
SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products
GROUP BY category;

-- Multiple Column Grouping example:
-- Sales analysis by year and quarter
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

-- GROUP BY with Expressions example:
-- Group by calculated values
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

-- HAVING clause filters groups created by GROUP BY, similar to how WHERE filters individual rows.
-- Key difference: WHERE filters before grouping, HAVING filters after grouping.
--- examples:
-- Find departments with more than 5 employees
SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- Find products with average rating above 4.0
SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING AVG(rating) > 4.0 AND COUNT(*) >= 10;

--- While aggregate functions collapse rows, window functions perform calculations across rows while preserving individual row details.
-- Aggregate function: Returns one row per department
SELECT department, AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department;

-- Window function: Returns all rows with department average
SELECT
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;

--- Handling NULL Values
-- Aggregate functions handle NULL values in specific ways:
-- COUNT(*) includes NULLs, COUNT(column) excludes NULLs
SELECT
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees;

-- SUM, AVG, MAX, MIN ignore NULL values
SELECT
    SUM(bonus) AS total_bonus,        -- NULLs ignored
    AVG(bonus) AS avg_bonus,          -- NULLs ignored
    COUNT(bonus) AS employees_with_bonus
FROM employees;


--- Common Patterns and Best Practices:
-- 1. Combining Multiple Aggregations
SELECT
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_std_dev
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

-- 2. Conditional Aggregation
-- Count employees by different criteria
SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;

-- 3. Percentage Calculations
-- Calculate percentage of total
SELECT
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT / (SELECT COUNT(*) FROM employees) * 100 AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;