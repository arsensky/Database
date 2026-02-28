---- FOR DETAILED EXPLANATION SEE cheat_sheet.md
-- 1. Subqueries example:
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)  -- This scalar subquery returns a single value
    FROM employees
);

-- 2. Common Table Expressions (CTEs) example:
WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;

-- 3. Recursive Queries example:
WITH RECURSIVE org_chart AS (
    -- Anchor: Find the top-level manager (e.g., who has no manager)
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive: Find everyone who reports to the people already in the chart
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;

-- 4. Set Operations example:
-- Get all unique products from both warehouses
SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;

-- Find products that are out of stock in both warehouses
SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;

-- 5. Window Functions & Partitioning example:
SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

-- 6. Pivot and Unpivot Operations example:
SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;
-- 7. Unpivoting with UNION ALL example:
Unpivoting with UNION ALL:
SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;

-- 8. Complex Filtering and Sorting
-- Filtering example:
SELECT
    employee_id,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_salary_senior
FROM employees;

-- Sorting example:
SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;