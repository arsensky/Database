-- table from lab3
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

INSERT INTO students (name, age) VALUES ('Alice', 21), ('Bob', 23);

-- SELECT, FROM and WHERE keywords using
SELECT name FROM students WHERE age = '21'; -- Output: Alice

SELECT * FROM students; -- retrieves all rows and columns

-- sorting with ORDER BY
SELECT name, age FROM students ORDER BY;

-- limiting results with LIMIT
SELECT name, age FROM students LIMIT 1;

/* This
   is
   a multiline comment. */