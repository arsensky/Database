---- Types of joins:
--- 1. INNER JOIN returns only the rows that have matching values in both tables.
--- This is the most restrictive type of join. Example:
-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- INNER JOIN Query:
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

--- 2. LEFT JOIN (LEFT OUTER JOIN) returns all rows from the left table and matching rows from the right table.
--- If no match is found, NULL values are returned for the right table columns. Example:
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- This query returns all customers, including those who haven't placed any orders (their order columns will show NULL).

--- 3. RIGHT JOIN (RIGHT OUTER JOIN) returns all rows from the right table and matching rows from the left table.
--- If no match is found, NULL values are returned for the left table columns. Example:
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- This query returns all orders, even if the customer information is missing (customer columns would show NULL).

--- 4. FULL OUTER JOIN returns all rows when there's a match in either table.
--- It combines the results of both LEFT and RIGHT joins. Example:
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
-- This query returns all customers and all orders, with NULL values where there's no match.

--- 5. CROSS JOIN returns the Cartesian product of both tables,
--- meaning every row from the first table is combined with every row from the second table. Example:
SELECT c.name, p.product_name
FROM customers c
CROSS JOIN products p;
-- Warning: Use CROSS JOIN carefully as it can produce very large result sets!

---- Advanced Join Techniques
--- Multiple Table Joins
-- You can join more than two tables in a single query:
SELECT c.name, o.order_date, oi.quantity, p.product_name, p.price
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

--- Self Joins
-- A table can be joined with itself to compare rows within the same table:
-- Find employees and their managers
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

--- Join with Conditions
-- You can add additional conditions to your JOIN clauses:
SELECT c.name, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
AND o.total_amount > 100;

---- Working with Different Relationship Types
--- One-to-One Relationships
-- For one-to-one relationships, INNER JOIN or LEFT JOIN are typically used:
-- Joining user profiles (one-to-one)
SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;

--- One-to-Many Relationships
-- For one-to-many relationships, be aware that the "one" side may be repeated:
-- Authors and their books (one-to-many)
SELECT a.author_name, b.title, b.publication_year
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

--- Many-to-Many Relationships
-- For many-to-many relationships, you'll need to join through the junction table:
-- Students and their enrolled courses (many-to-many)
SELECT s.student_name, c.course_name, e.enrollment_date, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

---- Performance Considerations
--- Use Indexes are used to ensure foreign key columns and join columns have indexes:
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

/* Choose the Right Join Type
- Use INNER JOIN when you only need matching records
- Use LEFT JOIN when you need all records from the left table
- Avoid CROSS JOIN unless you specifically need a Cartesian product */

--- Table Aliases are used to make queries more readable and potentially faster:
SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

---- Common Pitfalls and How to Avoid Them
/* 1. Cartesian Products
Problem: Forgetting the JOIN condition creates a Cartesian product.
Solution: Always specify proper JOIN conditions. */
-- Wrong (Cartesian product)
SELECT c.name, o.order_date
FROM customers c, orders o;

-- Correct
SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

/* 2. Null Value Confusion
Problem: Not understanding how NULLs work in outer joins.
Solution: Use IS NULL or IS NOT NULL appropriately. */
-- Find customers without orders
SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

/* 3. Many-to-Many Join Errors
Problem: Forgetting to include the junction table.
Solution: Always join through the junction table for many-to-many relationships. */