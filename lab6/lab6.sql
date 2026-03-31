-- Name: Daniel Narewski
-- Date: 3/31/26
-- Note: I reused my existing database tables (Students, Courses, Enrollments) from previous labs.

-- Part A: Baseline Plans

-- Filter query 1
EXPLAIN
SELECT *
FROM Enrollments
WHERE term = '2026SP' AND course_id = 'CMPT308';

-- Filter query 2
EXPLAIN
SELECT *
FROM Enrollments
WHERE term = '2026SP' AND student_id = 1001;

-- Join query
EXPLAIN
SELECT s.name, c.title, e.term
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id
WHERE e.term = '2026SP';

-- Part B: Create Indexes

-- 1. Composite index for Filter Query 1 and the Join query
CREATE INDEX idx_enrollments_term_course 
ON Enrollments (term, course_id);

-- 2. Composite index for Filter Query 2
CREATE INDEX idx_enrollments_term_student 
ON Enrollments (term, student_id);

-- 3. Single-column index to further assist the Join query
CREATE INDEX idx_students_student_id 
ON Students (student_id);

-- Part C: Re-run EXPLAIN after indexing

-- Filter query 1
EXPLAIN SELECT * FROM Enrollments WHERE term = '2026SP' AND course_id = 'CMPT308';

-- Filter query 2
EXPLAIN SELECT * FROM Enrollments WHERE term = '2026SP' AND student_id = 1001;

-- Join query
EXPLAIN SELECT s.name, c.title, e.term FROM Students s JOIN Enrollments e ON s.student_id = e.student_id JOIN Courses c ON c.course_id = e.course_id WHERE e.term = '2026SP';

-- Part E: When indexes may not help
EXPLAIN
SELECT *
FROM Students
WHERE major = 'CS';
