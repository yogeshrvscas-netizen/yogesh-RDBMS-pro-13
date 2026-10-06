-- Lab Program 13
-- Normalize the Student table up to Third Normal Form (3NF).
--
-- Write your solution below.
--
-- Functional Dependencies:
-- StudentID -> StudentName, CourseName
-- CourseName -> FacultyName
-- FacultyName -> DepartmentName
--
-- Requirements:
-- 1. Create normalized tables.
-- 2. Define primary keys.
-- 3. Define foreign keys.
-- 4. Insert sample data.
--
-- Do not modify test.sh or .github/workflows/autograding.yml.

USE CollegeDB;

-- Write your 3NF solution here.
-- 1NF: Original Student Table
CREATE TABLE Student_1NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    CourseName VARCHAR(50),
    FacultyName VARCHAR(50),
    DepartmentName VARCHAR(50)
);

-- Insert sample values
INSERT INTO Student_1NF VALUES
(101, 'Arun', 'BCA', 'Dr. Kumar', 'Computer Science'),
(102, 'Divya', 'BCA', 'Dr. Kumar', 'Computer Science'),
(103, 'Karthik', 'BSc Maths', 'Dr. Ravi', 'Mathematics'),
(104, 'Nisha', 'BCA', 'Dr. Kumar', 'Computer Science');

-- 2NF: Separate Course and Student information
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    FacultyName VARCHAR(50),
    DepartmentName VARCHAR(50)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Insert Course values
INSERT INTO Course VALUES
(1, 'BCA', 'Dr. Kumar', 'Computer Science'),
(2, 'BSc Maths', 'Dr. Ravi', 'Mathematics');

-- Insert Student values
INSERT INTO Student VALUES
(101, 'Arun', 1),
(102, 'Divya', 1),
(103, 'Karthik', 2),
(104, 'Nisha', 1);

-- 3NF: Remove transitive dependency
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Course_3NF (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    FacultyID INT,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

CREATE TABLE Student_3NF (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Course_3NF(CourseID)
);

-- Department data
INSERT INTO Department VALUES
(10, 'Computer Science'),
(20, 'Mathematics');

-- Faculty data
INSERT INTO Faculty VALUES
(1, 'Dr. Kumar', 10),
(2, 'Dr. Ravi', 20);

-- Course data
INSERT INTO Course_3NF VALUES
(101, 'BCA', 1),
(102, 'BSc Maths', 2);

-- Student data
INSERT INTO Student_3NF VALUES
(1001, 'Arun', 101),
(1002, 'Divya', 101),
(1003, 'Karthik', 102),
(1004, 'Nisha', 101);

-- Display the normalized data
SELECT 
    s.StudentID,
    s.StudentName,
    c.CourseName,
    f.FacultyName,
    d.DepartmentName
FROM Student_3NF s
JOIN Course_3NF c ON s.CourseID = c.CourseID
JOIN Faculty f ON c.FacultyID = f.FacultyID
JOIN Department d ON f.DepartmentID = d.DepartmentID;
