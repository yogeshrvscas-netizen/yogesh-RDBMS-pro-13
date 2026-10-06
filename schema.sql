DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;

USE CollegeDB;

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    CourseName VARCHAR(50),
    FacultyName VARCHAR(50),
    DepartmentName VARCHAR(50)
);

INSERT INTO Student VALUES
(101, 'Arun', 'BCA', 'Dr. Kumar', 'Computer Science'),
(102, 'Bala', 'BCA', 'Dr. Kumar', 'Computer Science'),
(103, 'Divya', 'BSc CS', 'Dr. Priya', 'Computer Science'),
(104, 'Meena', 'BCom', 'Dr. Ravi', 'Commerce');
