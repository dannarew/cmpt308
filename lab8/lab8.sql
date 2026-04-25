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

-- Create roles
DROP ROLE IF EXISTS advisor_role;
DROP ROLE IF EXISTS registrar_role;
CREATE ROLE advisor_role;
CREATE ROLE registrar_role;

-- Grant SELECT to advisor_role
GRANT SELECT ON lab8_students, lab8_courses, lab8_enrollments TO advisor_role;

-- Grant SELECT, INSERT, UPDATE to registrar_role
GRANT SELECT ON lab8_students, lab8_courses, lab8_enrollments TO registrar_role;
GRANT INSERT ON lab8_enrollments TO registrar_role;
GRANT UPDATE ON lab8_courses TO registrar_role;

-- Revoke DELETE explicitly 
REVOKE DELETE ON lab8_enrollments FROM registrar_role;

-- Privilege-report query
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee IN ('advisor_role', 'registrar_role')
  AND table_name IN ('lab8_students', 'lab8_courses', 'lab8_enrollments')
ORDER BY grantee, table_name, privilege_type;

-- part B
CREATE OR REPLACE FUNCTION register_student(p_student_id INT, p_course_id TEXT)
RETURNS TEXT AS $$
DECLARE
    v_student_exists INT;
    v_course_exists INT;
    v_already_enrolled INT;
    v_capacity INT;
    v_enrolled INT;
BEGIN
    -- Check if student exists
    SELECT COUNT(*) INTO v_student_exists FROM lab8_students WHERE student_id = p_student_id;
    IF v_student_exists = 0 THEN 
        RETURN 'Error: Student does not exist.'; 
    END IF;

    -- Check if course exists
    SELECT COUNT(*) INTO v_course_exists FROM lab8_courses WHERE course_id = p_course_id;
    IF v_course_exists = 0 THEN 
        RETURN 'Error: Course does not exist.'; 
    END IF;

    -- Check if already enrolled
    SELECT COUNT(*) INTO v_already_enrolled FROM lab8_enrollments WHERE student_id = p_student_id AND course_id = p_course_id;
    IF v_already_enrolled > 0 THEN 
        RETURN 'Error: Student already enrolled in this course.'; 
    END IF;

    -- Check capacity
    SELECT capacity, enrolled_count INTO v_capacity, v_enrolled FROM lab8_courses WHERE course_id = p_course_id;
    IF v_enrolled >= v_capacity THEN 
        RETURN 'Error: Course is full.'; 
    END IF;

    -- If all checks pass, register student and update count
    INSERT INTO lab8_enrollments (student_id, course_id) VALUES (p_student_id, p_course_id);
    UPDATE lab8_courses SET enrolled_count = enrolled_count + 1 WHERE course_id = p_course_id;

    RETURN 'Success: Student registered successfully.';
END;
$$ LANGUAGE plpgsql;

-- Test Cases
SELECT register_student(1, 'CS103'); -- 1. Success
SELECT register_student(1, 'CS103'); -- 2. Duplicate Attempt
SELECT register_student(2, 'CS103'); -- 3. Course Full Attempt (since capacity is 1)

-- part C
-- Create trigger function
CREATE OR REPLACE FUNCTION log_enrollment_action()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO lab8_enrollment_audit (action_type, student_id, course_id)
    VALUES ('INSERT', NEW.student_id, NEW.course_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER after_enrollment_insert
AFTER INSERT ON lab8_enrollments
FOR EACH ROW
EXECUTE FUNCTION log_enrollment_action();

-- Test the trigger (Enroll student 3 in CS101)
SELECT register_student(3, 'CS101');

-- Query the audit table
SELECT * FROM lab8_enrollment_audit;

-- Part D
-- 1. Enrollment list
SELECT s.student_name, c.course_id, c.title, e.enrolled_at
FROM lab8_enrollments e
JOIN lab8_students s ON e.student_id = s.student_id
JOIN lab8_courses c ON e.course_id = c.course_id;

-- 2. Seats remaining
SELECT course_id, title, capacity, enrolled_count, (capacity - enrolled_count) AS seats_remaining
FROM lab8_courses;

-- 3. Audit log report
SELECT * FROM lab8_enrollment_audit ORDER BY action_time ASC;

-- 4. Privilege report
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee IN ('advisor_role', 'registrar_role')
  AND table_name IN ('lab8_students', 'lab8_courses', 'lab8_enrollments')
ORDER BY grantee, table_name, privilege_type;
