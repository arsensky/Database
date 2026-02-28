--- BEGIN - Start a new transaction
BEGIN;
-- or alternatively
BEGIN TRANSACTION;
-- or simply
START TRANSACTION;

--- COMMIT - Save all changes made in the transaction
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT; -- Both updates are saved permanently

--- ROLLBACK - Undo all changes made in the transaction
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
-- Something went wrong, undo everything
ROLLBACK; -- Both updates are undone

-- Transfer $500 from account 1 to account 2
BEGIN;
-- Check if account 1 has sufficient balance
SELECT balance FROM accounts WHERE account_id = 1;
-- If sufficient, perform the transfer
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
-- If everything is correct, commit
COMMIT;
-- If there was an error, we would ROLLBACK instead

--- ATOMICITY
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 2);
UPDATE inventory SET stock = stock - 2 WHERE product_id = 101;
-- If any of these fail, ALL are rolled back
COMMIT;

--- CONSISTENCY
-- This transaction maintains consistency by respecting foreign key constraints
BEGIN;
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
INSERT INTO orders (customer_id, total) VALUES (LASTVAL(), 100.00);
COMMIT;

--- READ UNCOMMITED
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM accounts; -- May see uncommitted changes
COMMIT;

--- READ COMMITED (DEFAULT)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 1000;
-- Another transaction might modify data here
SELECT * FROM accounts WHERE balance > 1000; -- May return different results
COMMIT;

--- REPEATABLE READ
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts WHERE balance > 1000;
-- Even if other transactions modify data, this query will return same results
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;

--- SERIALIZABLE
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts;
UPDATE accounts SET balance = balance * 1.05; -- 5% interest
COMMIT;

--- Setting session-level isolation:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

--- Creating and using savepoints:
BEGIN;
INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');
SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 500.00);
-- Something went wrong with the order, rollback to savepoint
ROLLBACK TO SAVEPOINT after_customer_insert;
-- Customer insert is still there, but order insert is undone
INSERT INTO orders (customer_id, total) VALUES (1, 300.00);
COMMIT; -- Only customer and the second order are committed

--- Multiple savepoints:
BEGIN;
INSERT INTO products (name, price) VALUES ('Laptop', 999.99);
SAVEPOINT sp1;
INSERT INTO products (name, price) VALUES ('Mouse', 25.99);
SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Invalid Product', -50.00);
-- This violates business rules
ROLLBACK TO SAVEPOINT sp2; -- Removes invalid product insert
-- Laptop and Mouse inserts are still active
INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);
COMMIT; -- Commits Laptop, Mouse, and Keyboard

-- Releasing savepoints:
BEGIN;
INSERT INTO logs (message) VALUES ('Starting process');
SAVEPOINT process_start;
-- Do some work
INSERT INTO logs (message) VALUES ('Process completed');
-- If everything is OK, release the savepoint
RELEASE SAVEPOINT process_start;
COMMIT;

--- Keep transactions short and focused
-- Good: Short, focused transaction
BEGIN;
UPDATE inventory SET stock = stock - 1 WHERE product_id = 101;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 1);
COMMIT;
-- Avoid: Long-running transactions that lock resources

--- Handle errors properly
BEGIN;
DO $$
DECLARE
    insufficient_funds EXCEPTION;
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;

    IF current_balance < 100 THEN
        RAISE insufficient_funds;
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

EXCEPTION
    WHEN insufficient_funds THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
        ROLLBACK;
END $$;

--- Use appropriate isolation levels
-- For financial operations, use higher isolation
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Critical financial operations here
COMMIT;
-- For reporting, READ COMMITTED is usually sufficient
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Generate reports here
COMMIT;

--- Use savepoints for complex operations
BEGIN;
-- Main operation
INSERT INTO orders (customer_id, total) VALUES (1, 1000.00);

SAVEPOINT before_items;

-- Add items (might fail for some items)
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_id_seq'), 101, 2);

-- If this fails, rollback to savepoint and continue
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_id_seq'), 102, 1);
COMMIT;

--- Monitor transaction locks and deadlocks
-- Check for blocking transactions
SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
WHERE NOT blocked_locks.granted;

--- Use explicit transactions for multiple operations
-- Good: Explicit transaction control
BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (currval('users_id_seq'), 'dark');
COMMIT;

-- Avoid: Relying on autocommit for related operations
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
-- If this fails, the audit log entry above is already committed
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');