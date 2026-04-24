-- Name: Daniel Narewski
-- Date: 4/24/26
-- Lab Number: 8

-- 1. DROP EXISTING TABLES
DROP TABLE IF EXISTS lab8_enrollment_audit;
DROP TABLE IF EXISTS lab8_enrollments;
DROP TABLE IF EXISTS lab8_courses;
DROP TABLE IF EXISTS lab8_students;

-- 2. CREATE TABLES
CREATE TABLE lab8_students (
  student_id INT PRIMARY KEY,
  student_name TEXT NOT NULL
);

CREATE TABLE lab8_courses (
  course_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  capacity INT NOT NULL CHECK (capacity > 0),
  enrolled_count INT NOT NULL DEFAULT 0 CHECK (enrolled_count >= 0 AND enrolled_count <= capacity)
);

CREATE TABLE lab8_enrollments (
  student_id INT NOT NULL REFERENCES lab8_students(student_id),
  course_id TEXT NOT NULL REFERENCES lab8_courses(course_id),
  enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, course_id)
);

CREATE TABLE lab8_enrollment_audit (
  audit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  action_type TEXT NOT NULL,
  student_id INT NOT NULL,
  course_id TEXT NOT NULL,
  action_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. INSERT SAMPLE DATA
-- 4 students
INSERT INTO lab8_students (student_id, student_name) VALUES 
(1, 'Alice Smith'),
(2, 'Bob Jones'),
(3, 'Charlie Brown'),
(4, 'Diana Prince');

-- 3 courses (CS103 has a capacity of 1 so we can easily test the "course full" error)
INSERT INTO lab8_courses (course_id, title, capacity) VALUES 
('CS101', 'Intro to Programming', 30),
('CS102', 'Database Systems', 20),
('CS103', 'Advanced AI Seminar', 1);
