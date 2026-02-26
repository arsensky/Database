-- INSERT is used to add new rows into a table.
--- example:
CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

-- inserting a student
INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');

-- inserting multiple records at once
INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Ainura', 'Toktomamatova', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');

-- UPDATE statement modifies existing records.
-- It must usually be combined with a WHERE clause to avoid changing all rows.
--- example:
UPDATE Students
SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek' AND last_name = 'Sharshenov';

-- DELETE statement removes rows from a table.
-- * IMPORTANT: Omitting WHERE will delete all rows in the table.
--- example:
DELETE FROM Students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova';

DELETE FROM Students
WHERE birth_date < '2002-01-01';

-- Bulk operations are used when working with large sets of data.
-- The COPY command allows fast bulk insertion from CSV or text files.
--- example:
COPY Students(first_name, last_name, birth_date)
FROM '/path/to/students.csv'
DELIMITER ','
CSV HEADER;

-- Bulk Update
UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov');

-- Bulk Delete
DELETE FROM Students
WHERE student_id IN (2, 3, 5);