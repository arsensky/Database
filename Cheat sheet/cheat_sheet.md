# Cheat sheet from Labs
The cheat sheet was created by me based on the lab materials to help me
remember important information, commands, and other key details.

---
## Connecting to PostgreSQL via psql (lab 3)
`psql -h <host> -p <port> -U <username> -d <database>`

- `-h` — server address (default localhost)
- `-p` — port (default 5432)
- `-U` — PostgreSQL username
- `-d` — database name

Example: `psql -U postgres -d mydb -h localhost -p 5432`

## Meta-commands in psql (lab 3)
- `\l` - list all databases
- `\c <dbname>` - connect to a database
- `\dt` - list all tables in the current database
- `\d <table>` - description of the table structure (columns, types, keys)
- `\q` - exit psql
- `\h` - help on SQL commands (for example: \h SELECT)
- `\?` - list of all meta commands

---
## SQL Syntax Basics (lab 4)
SQL (*Structured Query Language*) is the standard language for interacting with relational databases.
<br>It is case-insensitive for keywords but follows conventions: 
- Keywords like **SELECT**, **FROM**, and **WHERE** are written in uppercase.
- Table names, column names usually written in snake_case.

---
## Tables (lab 6)
The structure of a table is defined by its columns.
<br>Each column has:
- A name (e.g., student_id, email).
- A data type (e.g., SERIAL, VARCHAR, INTEGER, DATE) that defines what kind of data it can store.
- Optional constraints (e.g., PRIMARY KEY, NOT NULL, UNIQUE) that enforce rules on the data.

### Common Data Types:
- **SERIAL**: Auto-incrementing integer (perfect for surrogate primary keys).
- **INTEGER, BIGINT**: Whole numbers.
- **VARCHAR(n)**: Variable-length character string with a maximum length of n.
- **TEXT**: Variable-length character string without a set limit.
- **BOOLEAN**: True or false values.
- **DATE, TIMESTAMP**: Date and time values.

### Common Constraints:
- **PRIMARY KEY**: Uniquely identifies each row in a table (implies UNIQUE and NOT NULL).
- **NOT NULL**: Ensures a column cannot have a NULL value.
- **UNIQUE**: Ensures all values in a column are different.
- **CHECK**: Ensures all values in a column satisfy a specific condition
(e.g., CHECK (grade >= 0 AND grade <= 100)).
- **FOREIGN KEY**: Enforces a link to the primary key in another table.

---
## Primary Keys (lab 7)
**Primary Key** – a column (or columns) that uniquely identifies each row in a table.

### Rules
- **Unique** – no duplicates  
- **Not NULL** – cannot be empty  
- **Immutable** – should not change  
- **One per table**

### Why Important?
- Ensures unique row identification  
- Maintains referential integrity (used by foreign keys)  
- Improves performance (automatic index)  
- Required for replication and synchronization  

---
## Database Design Basics (lab 9)
Note: Examples are provided in `lab9.sql`
### Entity-Relationship Modeling
Visually represent DB structure before implementation.
- **Entity** → table (e.g. Student, Course)
- **Attribute** → column (e.g. Name, Email); can be simple, composite, derived, or key
- **Relationship** → how entities connect (1:M, M:M)

### Normalization
Reduces redundancy and improves data integrity.
- **1NF** — atomic values, no repeating groups, unique rows
- **2NF** — 1NF + no partial dependencies on composite PK
- **3NF** — 2NF + no transitive dependencies between non-key attributes

### Design Process
1. **Requirements Analysis** — what data, who uses it
2. **Conceptual Design** — high-level ER diagram
3. **Logical Design** — tables, keys, normalization, data types
4. **Physical Design** — indexes, partitioning, backup

### Finding Entities & Attributes
- Entities → look for **nouns** in requirements
- Attributes → ask *"what do we need to store about this entity?"*

### Example: Designing a Library Management System
Note: Logical Design is provided on `lab9.sql`
#### Requirements Analysis
- Track books, authors, members, and borrowing history
- Members can borrow multiple books
- Books can have multiple authors
- Track due dates and late fees

#### Conceptual Design
**Entities**: Book, Author, Member, Loan<br>
**Relationships**:
- Author WRITES Book (Many-to-Many)
- Member BORROWS Book through Loan (One-to-Many)

---
## Querying Data (lab 12)
### WHERE clause 
Common Operators:
- **Comparison**: =, <> or != (not equal), >, <, >=, <=
- **Logical**: `AND`, `OR`, `NOT`
- **Range**: `BETWEEN` (inclusive range)
- **Null Check**: `IS NULL`, `IS NOT NULL`

### Pattern matching (LIKE, ILIKE)
The LIKE and ILIKE operators are used in a WHERE clause to search for a specified pattern in a column.
- `%` represents zero, one, or multiple characters.
- `_` represents a single character.
- `ILIKE` is a PostgreSQL-specific operator that is case-insensitive.

### Regular expressions
For more complex pattern matching than LIKE can handle,
PostgreSQL offers powerful Regular Expression operators. The most common is ~.
- `~`: Case-sensitive regular expression match
- `~*`: Case-insensitive regular expression match
- `!~`: Does not match (case-sensitive)
- `!~*`: Does not match (case-insensitive)

---
## Advanced Querying (lab 15)
Note: Examples are provided in `lab15.sql`
### Subqueries
A subquery (or inner query) is a query nested inside another SQL statement.

**Concept:** Think of it as asking a question to answer a bigger question.
The result of the inner query is used by the outer query.

**Types:**
- **Scalar Subquery**: Returns a single value (one row, one column).
Used with operators like =, >, <.
- **Row Subquery**: Returns a single row with multiple columns.
- **Table** Subquery: Returns a full result set (multiple rows and columns).
Often used with `IN`, `EXISTS`, or `FROM`.

### Common Table Expressions (CTEs)
**CTEs**, defined using the `WITH` clause,
allow you to name a subquery and reference it later in your main query.
They make your queries much more readable and modular.

**Concept:** It's like defining a temporary view for the duration of your query.

Use CTEs to break down complex problems into logical, manageable steps.
This is often the cleanest solution.

### Recursive Queries
A special form of CTE that allows you to query hierarchical or tree-structured data.
A recursive CTE has two parts: a *non-recursive term* (the anchor) and a *recursive term*.

**Concept:** It repeatedly executes the recursive term, using the results from the previous iteration, until it returns no more rows.

### Set Operations
Set operations combine the results of two or more `SELECT` queries.
- `UNION`: Combines results and removes duplicates.
- `UNION ALL`: Combines results and keeps all duplicates (faster than UNION).
- `INTERSECT`: Returns only the rows that are present in both result sets.
- `EXCEPT` (or `MINUS` in some SQL dialects): Returns the rows from the first query that are not present in the second query.

### Window Functions & Partitioning
Window functions perform a calculation across a set of table rows that are somehow related to the current row.
Unlike `GROUP BY`, they do not cause rows to become grouped into a single output row.

**Key Clauses:**
- `OVER()`: Defines the "window" of rows to perform the calculation on.
- `PARTITION BY`: Divides the result set into partitions (like groups) to perform the calculation within.
Similar to GROUP BY but doesn't reduce rows.
- `ORDER BY`: Defines the order of rows within the window.

**Common Functions:**
`ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `SUM()`, `AVG()`, `LAG()`, `LEAD()`

### Pivot and Unpivot Operations
PostgreSQL doesn't have a native PIVOT/UNPIVOT operator like some other databases.
Instead, we use the crosstab() function from the tablefunc module or conditional aggregation.

**Pivoting with Conditional Aggregation (Most Common):**<br>
**Concept:** Turning unique row values into columns.

**Unpivoting with `UNION ALL`:**<br>
**Concept:** Turning columns into rows.

### Complex Filtering and Sorting
Go beyond basic `WHERE` and `ORDER BY`.

**Filtering:**<br>
**`FILTER` Clause:** A cleaner way to apply aggregates to subsets of data,
often used with window functions.

**Sorting:**<br>
**Custom Sorting with `CASE`:** Force a specific, non-alphabetical order.

### Query Optimization Techniques
Writing a correct query is one thing; writing an *efficient* one is another.
- **`EXPLAIN` and `EXPLAIN ANALYZE`:**
  - Your most important tools.
  Prepend `EXPLAIN` or `EXPLAIN ANALYZE` to any query to see the execution plan the database will use.
  - `EXPLAIN` shows the plan.
  - `EXPLAIN ANALYZE` executes the query *and* shows actual runtime metrics.
- **Use Indexes:** Indexes on columns used in `WHERE`, `JOIN`, and `ORDER BY` clauses can dramatically speed up queries.
- **Avoid `SELECT *`:** Only select the columns you need. 
This reduces the amount of data transferred and processed.
- **Be cautious with `DISTINCT` and `UNION`:** They require extra processing to remove duplicates.
Use `UNION ALL` if you know duplicates are impossible or acceptable.
- **Use `LIMIT` for Testing:** When building a complex query, use `LIMIT 10` to get quick feedback instead of processing the entire table.

---
## Transactions and ACID Properties (lab 16)
A **transaction** is a group of SQL operations treated as one unit of work.
Either all operations succeed (**commit**) or none of them do (**rollback**).
This ensures data consistency and integrity.

Example: In a bank transfer, money is deducted from one account and added to another.
Both actions must succeed, or neither happens.

### ACID Properties
**ACID** guarantees reliable database transactions.

#### Atomicity – All succeed or all fail
* All operations in a transaction succeed or none do
* If one fails, the whole transaction is rolled back
* “All-or-nothing” principle

#### Consistency – Database stays valid
* Database moves from one valid state to another
* All rules, constraints, and triggers are satisfied
* Data integrity is always maintained

#### Isolation – Transactions don’t affect each other
* Concurrent transactions don’t interfere with each other
* Each transaction behaves as if it runs alone
* Controlled by isolation levels

#### Durability – Saved changes remain permanent
* Once committed, changes are permanent
* Data survives crashes or power loss
* Stored in non-volatile memory

### Isolation Levels
#### READ UNCOMMITTED
* Lowest level
* Allows **dirty reads** (reading uncommitted data)
* Rarely used

#### READ COMMITTED (default)
* Most common level
* Prevents dirty reads
* Allows **non-repeatable reads** and **phantom reads**

#### REPEATABLE READ
* Prevents dirty and non-repeatable reads
* Same `SELECT` gives same results in one transaction
* May allow phantom reads

#### SERIALIZABLE
* Highest level
* Prevents dirty, non-repeatable, and phantom reads
* Transactions behave as if executed one by one

### Savepoints
**Savepoints** create intermediate checkpoints inside a transaction.
You can roll back to a savepoint without canceling the entire transaction.

---
## Data Import/Export and Backup (Lab 17)
### COPY Command
`COPY` is the fastest way to transfer large data between tables and files.

#### Directions:
- `COPY TO` – Export table to file  
- `COPY FROM` – Import file to table  

#### Features:
- Supports CSV  
- Export query results  
- Custom delimiter, NULL, encoding  
- Import specific columns  
- Used in ETL and migration  

### CSV Import/Export
CSV is the most common data exchange format.

#### Export:
- With headers  
- Custom delimiter/quote  
- Force quote columns  

#### Import:
- Basic import (table must exist)  
- Skip errors (`ON_ERROR IGNORE`)  
- Set encoding (UTF8)  
- Handle NULL and special characters  

### pg_dump & pg_restore
#### pg_dump:
- Full database backup  
- Compressed format (`-Fc`)  
- Schema-only (`-s`) / Data-only (`-a`)  
- Backup specific tables  

#### pg_restore:
- Restore full or partial backup  
- Parallel restore (`-j`)  
- View backup contents  

### Full Backups
Include data, schema, settings.  

Tools: `pg_dump`, `pg_dumpall`  

Best practice:
- Automate backups  
- Keep limited history  
- Test restore regularly  

### Incremental Backups
Backup only changes using:
- WAL  
- `pg_basebackup`  
- Continuous archiving  

Benefits: less storage, faster process  

### Point-in-Time Recovery (PITR)
Restore database to a specific moment.

Requires:
- Base backup  
- WAL archive  

Targets:
- Time  
- Transaction ID  
- Restore point  

### Migration Strategies
1. Dump & Restore  
2. Logical Replication  
3. Physical Replication  
4. ETL Pipeline  

### Best Practices
- Check source data  
- Test on small dataset  
- Monitor process  
- Validate results  
- Partition large tables  