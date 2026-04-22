 

CREATE TABLE STUDENTS (
    ID INT,
    NAME VARCHAR(50),
    MARKS INT
);

 

INSERT INTO STUDENTS VALUES (1, 'Asha', 85);
INSERT INTO STUDENTS VALUES (2, 'Rahul', 78);
INSERT INTO STUDENTS VALUES (3, 'Kiran', 92);
INSERT INTO STUDENTS VALUES (4, 'Meena', 67);
INSERT INTO STUDENTS VALUES (5, 'Arjun', 88);

-- ======================
-- CHECK DATA
-- ======================

SELECT * FROM STUDENTS;

-- ======================
-- QUERIES
-- ======================

-- 1. Students with marks > 80
SELECT * FROM STUDENTS WHERE MARKS > 80;

-- 2. Average marks
SELECT AVG(MARKS) AS AVERAGE_MARKS FROM STUDENTS;

-- 3. Highest marks
SELECT MAX(MARKS) AS HIGHEST_MARKS FROM STUDENTS;

-- 4. Lowest marks
SELECT MIN(MARKS) AS LOWEST_MARKS FROM STUDENTS;

-- 5. Count of students
SELECT COUNT(*) AS TOTAL_STUDENTS FROM STUDENTS;

-- 6. Sort by marks descending

SELECT * FROM STUDENTS ORDER BY MARKS DESc;
 