-- create data
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

-- insert data
INSERT INTO students (name, age) VALUES ('Alice', 21), ('Bob', 23);

-- select data
SELECT * FROM students;

-- delete table
DROP TABLE students;