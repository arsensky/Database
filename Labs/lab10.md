# Viewing Database and Table Structure
Understanding a database structure is important: tables, columns, data types, and relationships.

In PostgreSQL, you can use built-in `psql` commands to explore the structure, or external tools like ER diagrams for visualization.

## \dt and \d commands
`\dt` - shows all tables in current DB.
![dt_command.png](lab10_images/dt_command.png)

`\d` *table_name* - describe the exact table structure.
![img.png](lab10_images/d_command.png)

## ER diagrams
ER diagrams are graphical representation of database structure.

**How to view ER Digram via pgAdmin?**<br>
DB section → Schemas → Tables → Right click → ERD for database