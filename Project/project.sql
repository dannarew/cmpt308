-- ==============================================================================
-- CAMPUS TUTORING CENTER SCHEDULING SYSTEM
-- Phase 1: Schema, Constraints, Data, and Indexes
-- ==============================================================================

-- 0. CLEANUP (Allows the script to be run multiple times safely)
DROP TABLE IF EXISTS Session CASCADE;
DROP TABLE IF EXISTS Tutor_Course CASCADE;
DROP TABLE IF EXISTS Course CASCADE;
DROP TABLE IF EXISTS Tutor CASCADE;
DROP TABLE IF EXISTS Student CASCADE;

-- ==============================================================================
-- 1. TABLE CREATION & CONSTRAINTS
-- ==============================================================================

CREATE TABLE Student (
    StudentID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Major VARCHAR(100)
);

CREATE TABLE Tutor (
    TutorID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    HireDate DATE NOT NULL
);

CREATE TABLE Course (
    CourseCode VARCHAR(20) PRIMARY KEY,
    CourseName VARCHAR(150) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

CREATE TABLE Tutor_Course (
    TutorID INTEGER REFERENCES Tutor(TutorID) ON DELETE CASCADE,
    CourseCode VARCHAR(20) REFERENCES Course(CourseCode) ON DELETE CASCADE,
    PRIMARY KEY (TutorID, CourseCode)
);

CREATE TABLE Session (
    SessionID SERIAL PRIMARY KEY,
    SessionDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status VARCHAR(20) NOT NULL,
    StudentID INTEGER REFERENCES Student(StudentID) ON DELETE CASCADE,
    TutorID INTEGER REFERENCES Tutor(TutorID) ON DELETE CASCADE,
    CourseCode VARCHAR(20) REFERENCES Course(CourseCode) ON DELETE CASCADE,
    -- Implementing the CHECK constraint to ensure data integrity for the Status
    CONSTRAINT chk_status CHECK (Status IN ('Scheduled', 'Completed', 'Canceled'))
);

-- ==============================================================================
-- 2. SAMPLE DATA INSERTS
-- ==============================================================================

-- Insert 5 Students
INSERT INTO Student (Name, Email, Major) VALUES
('Elena.Rostova', 'elena.rostova@marist.edu', 'Computer Science'),
('Marcus.Chen', 'marcus.chen@marist.edu', 'Business'),
('Sarah.Jenkins', 'sarah.jenkins@marist.edu', 'Mathematics'),
('David.Smith', 'david.smith@marist.edu', 'Computer Science'),
('Aisha.Patel', 'aisha.patel@marist.edu', 'Business');

-- Insert 3 Tutors
INSERT INTO Tutor (Name, Email, HireDate) VALUES
('Dr. Alan.Turing', 'alan.turing@marist.edu', '2025-08-15'),
('Grace.Hopper', 'grace.hopper@marist.edu', '2025-09-01'),
('Ada.Lovelace', 'ada.lovelace@marist.edu', '2026-01-10');

-- Insert 10 Courses
INSERT INTO Course (CourseCode, CourseName, Department) VALUES
('CMPT308N', 'Database Management', 'Computer Science'),
('CMPT220', 'Software Development I', 'Computer Science'),
('CMPT430', 'Theory of Programming Languages', 'Computer Science'),
('BUS100', 'Introduction to Business', 'Business'),
('BUS301', 'Human Resource Management', 'Business'),
('BUS320', 'Financial Management', 'Business'),
('MATH241', 'Calculus I', 'Mathematics'),
('MATH242', 'Calculus II', 'Mathematics'),
('ENG120', 'Writing for College', 'English'),
('ECON103', 'Microeconomics', 'Economics');

-- Insert Tutor Competencies (M:N Relationship)
INSERT INTO Tutor_Course (TutorID, CourseCode) VALUES
(1, 'CMPT308N'), (1, 'CMPT220'), (1, 'MATH241'), -- Alan Turing
(2, 'CMPT430'), (2, 'CMPT220'), (2, 'BUS301'),  -- Grace Hopper
(3, 'MATH241'), (3, 'MATH242'), (3, 'ECON103');   -- Ada Lovelace

-- Insert 15 Sessions (Mix of Scheduled, Completed, and Canceled)
INSERT INTO Session (SessionDate, StartTime, EndTime, Status, StudentID, TutorID, CourseCode) VALUES
-- Past Completed Sessions
('2026-04-01', '10:00:00', '11:00:00', 'Completed', 1, 1, 'CMPT308N'),
('2026-04-02', '13:00:00', '14:00:00', 'Completed', 2, 2, 'BUS301'),
('2026-04-03', '15:00:00', '16:00:00', 'Completed', 3, 3, 'MATH241'),
('2026-04-04', '09:00:00', '10:00:00', 'Completed', 4, 1, 'CMPT220'),
('2026-04-05', '11:00:00', '12:00:00', 'Completed', 5, 3, 'ECON103'),

-- Canceled Sessions
('2026-04-06', '14:00:00', '15:00:00', 'Canceled', 1, 2, 'CMPT430'),
('2026-04-07', '16:00:00', '17:00:00', 'Canceled', 2, 1, 'MATH241'),

-- Future Scheduled Sessions (Assuming current date is mid-to-late Spring 2026)
('2026-05-10', '10:00:00', '11:00:00', 'Scheduled', 3, 3, 'MATH242'),
('2026-05-10', '11:30:00', '12:30:00', 'Scheduled', 4, 2, 'CMPT220'),
('2026-05-11', '13:00:00', '14:00:00', 'Scheduled', 5, 3, 'ECON103'),
('2026-05-11', '15:00:00', '16:00:00', 'Scheduled', 1, 1, 'CMPT308N'),
('2026-05-12', '09:00:00', '10:30:00', 'Scheduled', 2, 2, 'BUS301'),
('2026-05-13', '14:00:00', '15:00:00', 'Scheduled', 3, 1, 'MATH241'),
('2026-05-14', '16:00:00', '17:00:00', 'Scheduled', 4, 2, 'CMPT430'),
('2026-05-15', '10:00:00', '11:00:00', 'Scheduled', 5, 3, 'MATH242');

-- ==============================================================================
-- 3. INDEXES
-- ==============================================================================

-- Creating an index on SessionDate to speed up daily schedule queries 
-- since users will frequently search for appointments on specific days.
CREATE INDEX idx_session_date ON Session(SessionDate);

-- Basic Filter/Order Query
SELECT 
    SessionDate, 
    StartTime, 
    EndTime, 
    CourseCode, 
    Status
FROM Session
WHERE SessionDate = '2026-05-10' 
  AND Status = 'Scheduled'
ORDER BY StartTime ASC;

-- Join Query 1 3 Tables
SELECT 
    s.SessionDate, 
    s.StartTime, 
    st.Name AS StudentName, 
    c.CourseName, 
    s.Status 
FROM Session s
JOIN Student st ON s.StudentID = st.StudentID
JOIN Course c ON s.CourseCode = c.CourseCode
ORDER BY s.SessionDate, s.StartTime
LIMIT 5; 

-- Join Query 2 M:N Resolution
SELECT 
    t.Name AS TutorName, 
    c.CourseCode, 
    c.CourseName 
FROM Tutor t
JOIN Tutor_Course tc ON t.TutorID = tc.TutorID
JOIN Course c ON tc.CourseCode = c.CourseCode
ORDER BY t.Name, c.CourseCode;

-- Aggregation with GROUP BY
SELECT 
    t.Name AS TutorName, 
    COUNT(s.SessionID) AS TotalSessions 
FROM Tutor t
LEFT JOIN Session s ON t.TutorID = s.TutorID
GROUP BY t.TutorID, t.Name
ORDER BY TotalSessions DESC, t.Name ASC;

-- Subquery
SELECT 
    Name AS StudentName, 
    Email, 
    Major 
FROM Student 
WHERE StudentID IN (
    SELECT StudentID 
    FROM Session 
    WHERE CourseCode = 'MATH241'
);

-- Additional Useful Query
SELECT 
    c.CourseCode, 
    c.CourseName, 
    COUNT(s.SessionID) AS DemandCount 
FROM Course c
JOIN Session s ON c.CourseCode = s.CourseCode
GROUP BY c.CourseCode, c.CourseName
ORDER BY DemandCount DESC, c.CourseCode ASC;

-- BONUS in cly.py
