# Introduction to Relational Databases — Summary

**Database** is an organized collection of structured data.
<br>**DBMS** (*database management system*) – software to manage databases (CRUD operations).
<br>Examples: PostgreSQL, MySQL, Oracle, MS SQL.

**Relational Database** stores data in tables that can be related to each other.
- **Table** – data organized in rows and columns.
- **Row** – single record.
- **Column** – field/attribute.
- **Primary Key** – unique identifier for each row.
- **Foreign Key** – links to primary key in another table.

**SQL** (*Structured Query Language*) is used to interact with relational databases. 
Databases without SQL support are called NoSQL.

#### Important Terms
- **Schema** – database structure.
- **Query** – request for data.
- **Index** – improves search speed.
- **Normalization** – reduces data redundancy.

#### Relationship Types:
- One-to-One
- One-to-Many
- Many-to-Many

### NoSQL Overview
Flexible databases with non-rigid schema.

#### Types:
- Document (MongoDB)
- Key-Value (Redis)
- Columnar (Cassandra)
- Graph (Neo4j)

### SQL vs NoSQL

#### SQL:
- Rigid schema
- Vertical scaling
- ACID
- Strong consistency

#### NoSQL:
- Flexible schema
- Horizontal scaling
- BASE
- Eventual consistency

### ACID Properties
- **Atomicity** – all or nothing
- **Consistency** – valid state before and after transaction
- **Isolation** – transactions do not interfere
- **Durability** – data is saved permanently

### PostgreSQL
- Open-source DBMS
- Full ACID support
- JSON support
- Extensible
- Scalable

### Comparison:
- PostgreSQL – powerful and free
- MySQL – popular for web apps
- SQLite – lightweight
- Oracle – powerful but commercial