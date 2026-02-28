---- FOR DETAILED EXPLANATION SEE cheat_sheet.md
--- Example - Violating 1NF:
-- BAD: Multiple phone numbers in one column
CREATE TABLE students_bad (
    student_id    INT PRIMARY KEY,
    name          VARCHAR(100),
    phone_numbers TEXT -- "123-456-7890, 098-765-4321"
);

--- Example - Following 1NF:
-- GOOD: Atomic values
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name       VARCHAR(100)
);

CREATE TABLE student_phones (
    student_id   INT,
    phone_number VARCHAR(15),
    phone_type   VARCHAR(20), -- 'mobile', 'home', etc.
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
);

--- Example - Violating 2NF:
-- BAD: course_name depends only on course_id, not on the full primary key
CREATE TABLE enrollments_bad (
    student_id  INT,
    course_id   INT,
    course_name VARCHAR(100), -- Partial dependency!
    grade       CHAR(2),
    PRIMARY KEY (student_id, course_id)
);

--- Example - Following 2NF:
-- GOOD: Separate tables
CREATE TABLE courses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits     INT
);

CREATE TABLE enrollments (
    student_id INT,
    course_id  INT,
    grade      CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

--- Example - Violating 3NF:
-- BAD: department_name depends on department_id, which depends on student_id
CREATE TABLE students_bad (
    student_id      INT PRIMARY KEY,
    name            VARCHAR(100),
    department_id   INT,
    department_name VARCHAR(100) -- Transitive dependency!
);

--- Example - Following 3NF:
-- GOOD: Separate department information
CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100),
    department_head VARCHAR(100)
);

CREATE TABLE students (
    student_id    INT PRIMARY KEY,
    name          VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

--- Example: Designing a Library Management System
-- Logical Design (Requirements Analysis and Conceptual Design are provided on cheat_sheet.md)
CREATE TABLE authors (
    author_id  SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    Last_name  VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE books (
    book_id          SERIAL PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    isbn             VARCHAR(13) UNIQUE,
    publication_year INTEGER,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors (
    book_id   INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE members (
    member_id       SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)         NOT NULL,
    last_name       VARCHAR(50)         NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans (
    loan_id     SERIAL PRIMARY KEY,
    member_id   INTEGER NOT NULL,
    book_id     INTEGER NOT NULL,
    loan_date   DATE           DEFAULT CURRENT_DATE,
    due_date    DATE    NOT NULL,
    return_date DATE,
    late_fee    DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);