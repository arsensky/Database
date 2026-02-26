-- SELECT statement is the starting point for every query.
-- It's used to specify which columns you want to retrieve from a table.
--- examples:
-- Select all columns from the employees table:
SELECT * FROM employees;

-- Select specific columns (name and department):
SELECT name, department FROM employees;

-- Perform calculations on the fly. This query calculates a 10% bonus for each employee:
SELECT name, salary, salary * 0.10 AS potential_bonus
FROM employees;

-- WHERE clause is used to filter records and return only those that meet a specified condition.
-- It comes after the FROM clause.
--- examples:
-- Find all employees in the 'Sales' department:
SELECT name, salary
FROM employees
WHERE department = 'Sales';

-- Find employees with a salary greater than 75,000 in the 'Engineering' department:
SELECT name
FROM employees
WHERE salary > 75000 AND department = 'Engineering';

-- Find products with a price between 20 and 50 dollars:
SELECT product_name, price
FROM products
WHERE price BETWEEN 20 AND 50;

-- LIKE and ILIKE operators are used in a WHERE clause to search for a specified pattern in a column.
--- examples:
-- Find customers whose name starts with 'Bra' (e.g., Brad, Brandon):
SELECT customer_name
FROM customers
WHERE customer_name LIKE 'Bra%';

-- Find products whose name ends with 'berry' (e.g., Strawberry, Blueberry):
SELECT product_name
FROM products
WHERE product_name LIKE '%berry';

-- Find email addresses from Gmail (case-insensitive):
SELECT email
FROM users
WHERE email ILIKE '%@gmail.com';

-- Regular expressions (look cheat_sheet1 for more info)
--- examples:
-- Find names that start with 'A' or 'B':
SELECT name
FROM employees
WHERE name ~ '^[AB]';

-- Find email addresses that are valid (a simple check):
SELECT email
FROM users
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

-- IN operator is used to check if a value matches any value in a list or subquery.
-- Best for static lists or small subqueries.
SELECT name, department
FROM employees
WHERE department_id IN (3, 5, 7);
-- Or with a subquery
SELECT name
FROM employees
WHERE id IN (SELECT employee_id FROM sales WHERE amount > 1000);

/* EXISTS operator is used to test for the existence of any rows in a subquery.
   It returns true if the subquery returns one or more rows.
   Often more efficient than IN for large datasets because it stops processing as soon as it finds one match. */
SELECT name
FROM employees e
WHERE EXISTS (
  SELECT 1
  FROM sales s
  WHERE s.employee_id = e.id AND s.amount > 1000
);

-- CASE statement is the SQL equivalent of IF-THEN-ELSE logic.
-- It's used to create conditional output inside your queries.
--- example:
SELECT name, salary,
  CASE
    WHEN salary > 100000 THEN 'Senior'
    WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
    ELSE 'Junior'
  END AS employee_level
FROM employees;

/* Common Table Expressions (CTEs, also called "WITH clauses") allow you to define a temporary named result set
   that you can reference within your main SELECT, INSERT, UPDATE, or DELETE statement.
   They are fantastic for breaking down complex queries into simple, logical parts. */
--- example:
WITH department_averages AS (
  SELECT
    department,
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)

SELECT
  e.name,
  e.salary,
  e.department,
  da.avg_salary
FROM employees e
JOIN department_averages da ON e.department = da.department
WHERE e.salary > da.avg_salary;