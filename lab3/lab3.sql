-- PART C: Schema Setup
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE clubs (
    club_id INT PRIMARY KEY,
    club_name VARCHAR(100) NOT NULL,
    dept_id INT REFERENCES departments(dept_id),
    -- CHECK constraint: Club names must be at least 3 characters
    CONSTRAINT chk_club_name_length CHECK (char_length(club_name) >= 3)
);

CREATE TABLE memberships (
    student_id INT REFERENCES students(student_id),
    club_id INT REFERENCES clubs(club_id),
    join_date DATE NOT NULL,
    member_role VARCHAR(50), 
    PRIMARY KEY (student_id, club_id)
);

-- INSERT DATA (8 per entity, 15 for join table)
INSERT INTO departments VALUES (1, 'Arts'), (2, 'Science'), (3, 'Engineering');

INSERT INTO students VALUES 
(1, 'Alice', 'Smith', 'alice@edu.com'), (2, 'Bob', 'Jones', 'bob@edu.com'),
(3, 'Charlie', 'Brown', 'charlie@edu.com'), (4, 'Diana', 'Prince', 'diana@edu.com'),
(5, 'Edward', 'Norton', 'ed@edu.com'), (6, 'Fiona', 'Gallagher', 'fiona@edu.com'),
(7, 'George', 'Miller', 'george@edu.com'), (8, 'Hannah', 'Abbott', 'hannah@edu.com');

INSERT INTO clubs VALUES 
(10, 'Chess Club', 1), (20, 'Coding Club', 3), (30, 'Art Hive', 1),
(40, 'Bio Society', 2), (50, 'Robotics', 3), (60, 'Drama', 1),
(70, 'Mathletes', 2), (80, 'E-Sports', 3);

INSERT INTO memberships VALUES 
(1, 10, '2023-01-10', 'President'), (1, 20, '2023-01-15', NULL), -- NULL 1
(2, 10, '2023-02-01', 'Member'), (2, 30, '2023-02-05', 'Treasurer'),
(3, 20, '2023-01-20', 'Lead Developer'), (3, 50, '2023-03-01', NULL), -- NULL 2
(4, 40, '2023-01-12', 'Member'), (4, 70, '2023-04-10', 'Secretary'),
(5, 50, '2023-02-14', 'Member'), (5, 80, '2023-05-01', 'Captain'),
(6, 60, '2023-01-05', 'Director'), (6, 30, '2023-06-01', NULL), -- NULL 3
(7, 70, '2023-02-20', 'Member'), (7, 10, '2023-03-15', 'Member'),
(8, 80, '2023-04-01', 'Member');

-- PART D: QUERIES
-- 1. Two-table join
SELECT students.first_name, memberships.join_date 
FROM students 
JOIN memberships ON students.student_id = memberships.student_id;

-- 2. Three-table join (Student -> Membership -> Club)
SELECT s.first_name, c.club_name, m.member_role
FROM students s
JOIN memberships m ON s.student_id = m.student_id
JOIN clubs c ON m.club_id = c.club_id;

-- 3. Join + Filter (Only Science department clubs)
SELECT c.club_name, d.dept_name
FROM clubs c
JOIN departments d ON c.dept_id = d.dept_id
WHERE d.dept_name = 'Science';

-- 4. Join + Projection + Sort
SELECT s.last_name, m.join_date
FROM students s
JOIN memberships m ON s.student_id = m.student_id
ORDER BY m.join_date DESC;

-- 5. NULL query
SELECT s.first_name, m.club_id
FROM students s
JOIN memberships m ON s.student_id = m.student_id
WHERE m.member_role IS NULL;

-- PART E: Constraint Tests 
-- FK Violation: Student 999 does not exist
INSERT INTO memberships VALUES (999, 10, '2023-01-01', 'Ghost');

-- CHECK Violation: Club name "X" is too short (min 3)
INSERT INTO clubs VALUES (99, 'X', 1);
