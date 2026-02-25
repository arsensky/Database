-- creating a table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

-- dropping a table
CREATE TABLE unnecessary_table ();
DROP TABLE unnecessary_table;

-- dropping a table if it exists
DROP TABLE IF EXISTS non_existing_table;

-- altering table structure
--- adding a column
ALTER TABLE students
ADD COLUMN date_of_birth DATE;

--- dropping a column
ALTER TABLE students
DROP COLUMN faculty;

--- changing a column's datatype
ALTER TABLE students
ALTER COLUMN first_name TYPE TEXT;

--- adding a constraint
ALTER TABLE students
ADD CONSTRAINT unique_student_email UNIQUE (email);

--- renaming a column / a table
ALTER TABLE students
RENAME COLUMN email TO email_address;

ALTER TABLE students
RENAME TO university_students;

-- temporary tables
CREATE TEMP TABLE temporary_table (
    temporary_column1 SERIAL PRIMARY KEY
)