-- parent table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Method 1: Inline constraint during table creation
--- child table with foreign key
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id)
);

-- Method 2: Table-level constraint during creation
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Method 3: Adding constraint to existing table
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Method 4: Named constraint during table creation
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dept_id INTEGER,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

---- ON DELETE OPTIONS
--- CASCADE - Automatically delete child records when parent is deleted
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id) ON DELETE CASCADE
);

-- when department is deleted, all employees inside this department are also deleted
DELETE FROM departments WHERE dept_id = 1;

--- SET NULL - Set foreign key to NULL when parent is deleted
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id) ON DELETE SET NULL
);

-- when department is deleted, all employees' dept_id becomes NULL
DELETE FROM departments WHERE dept_id = 1;

--- SET DEFAULT - Set foreign key to its default value when parent is deleted
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id) ON DELETE SET DEFAULT
);

--- RESTRICT (default) - Prevent deletion of parent if child records exist
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id) ON DELETE RESTRICT
);

-- this will fail if employees exist in the department
DELETE FROM departments WHERE dept_id = 1;

---- ON UPDATE OPTIONS
--- CASCADE - Update foreign key values when parent key changes
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id) ON UPDATE CASCADE
);

-- when department id changes, employee records are automatically updated
UPDATE departments SET dept_id = 100 WHERE dept_id = 1;

---- Combined CASCADE options
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments (dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ONE-TO-ONE RELATIONSHIPS
--- parent table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- child table with one-to-one relationship
CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL, -- UNIQUE ensures one-to-one
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    profile_picture_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

--- alternative approach - sharing the same primary key
CREATE TABLE user_profiles (
    user_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    profile_picture_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

--- example usage
-- insert user
INSERT INTO users (username, email) VALUES
    ('johndoe', 'john@example.com');

-- insert corresponding profile (one-to-one)
INSERT INTO user_profiles (user_id, first_name, last_name, bio) VALUES
    (1, 'John', 'Doe', 'SFW Developer passionate about DB');

-- this will fail due to UNIQUE constraint
INSERT INTO user_profiles (user_id, first_name, last_name) VALUES
    (1, 'Jane', 'Smith'); -- error: duplicate key violates unique constraint

-- ONE-TO-MANY RELATIONSHIPS
--- example 1; parent table (one side)
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    budget DECIMAL(10,2)
);

--- child table (many side)
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT CURRENT_DATE,
    dept_id INTEGER N0T NULL, -- foreign key
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT
);

--- example usage
-- insert departments
INSERT INTO departments (dept_name, manager_name, budget) VALUES
    ('Engineering', 'Alice Johnson', 500000.00),
    ('Marketing', 'Bob Wilson', 200000.00);

-- insert multiple employees for one department
INSERT INTO employees (first_name, last_name, position, salary, dept_id) VALUES
    ('John', 'Smith', 'Software Engineer', 75000.00, 1),
    ('Jane', 'Doe', 'Senior Developer', 85000.00, 1),
    ('Mike', 'Brown', 'DevOps Engineer', 80000.00, 1),
    ('Sarah', 'Davis', 'Marketing Specialist', 55000.00, 2);

-- query to see the relationship
SELECT d.dept_name, e.first_name, e.last_name, e.position
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
ORDER BY d.dept_name, e.last_name;

-- MANY-TO-MANY RELATIONSHIPS
--- example 1; First parent table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    email VARCHAR (100) UNIQUE,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

-- Second parent table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR (10) UNIQUE NOT NULL,
    course_name VARCHAR (100) NOT NULL,
    credits INTEGER NOT NULL,
    instructor VARCHAR (100)
);
-- Junction table for many-to-many relationship
CREATE TABLE student_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade CHAR (2), -- Additional attributes specific to the relationship

    -- Foreign key constraints
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses (course_id) ON DELETE CASCADE,

    -- Prevent duplicate enrollments
    UNIQUE (student_id, course_id)
);

--- example usage
-- insert sample data
INSERT INTO students (first_name, last_name, email) VALUES
    ('Alice', 'Johnson', 'alice@university.edu'),
    ('Bob','Smith', 'bob@university.edu'),
    ('Carol', 'Wilson', 'carol@university.edu');

INSERT INTO courses (course_code, course_name, credits, instructor) VALUES
    ('CS101', 'Introduction to Programming', 3, 'Dr. Brown'),
    ('CS201', 'Data Structures', 4, 'Dr. Davis'),
    ('MATH101', 'Calculus I', 4, 'Dr. Wilson');

-- Enroll students in multiple courses
INSERT INTO students_enrollments (student_id, course_id, grade) VALUES
    (1, 1, 'A'),    -- Alice in CS101
    (1, 2, 'B+'),   -- Alice in CS201
    (2, 1, 'A-'),   -- Bob in CS101
    (2, 3, 'B'),    -- Bob in MATH101
    (3, 2, 'A'),    -- Carol in CS201
    (3, 3, 'A-');   -- Carol in MATH101

-- Complex query showing many-to-many relationships
SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    se.grade,
    se.enrollment_date
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id
ORDER BY s.last_name, c.course_code;

-- Find all students in a specific course
SELECT s.first_name, s.last_name, se.grade
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id
WHERE c.course_code = 'CS101':

-- Find all courses for a specific student
SELECT c.course_code, c.course_name, c.credits, se.grade
FROM courses c
JOIN student_enrollments se ON c.course_id = se.course_id
JOIN students s ON se.student_id = s.student_id
WHERE s-email = 'alice@university.edu';