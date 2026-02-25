# Cheat sheet from Labs
The cheat sheet was created by me based on the lab materials to help me remember important information, commands, and other key details.

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

## SQL Syntax Basics (lab 4)
SQL (*Structured Query Language*) is the standard language for interacting with relational databases.
<br>It is case-insensitive for keywords but follows conventions: 
- Keywords like **SELECT**, **FROM**, and **WHERE** are written in uppercase.
- Table names, column names usually written in snake_case.

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
- **CHECK**: Ensures all values in a column satisfy a specific condition (e.g., CHECK (grade >= 0 AND grade <= 100)).
- **FOREIGN KEY**: Enforces a link to the primary key in another table.

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