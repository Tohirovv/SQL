USE lessons;
GO

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(50),
    DeptID INT,
    Salary INT
);

-- Insert employee records
INSERT INTO Employees (EmployeeID, FullName, DeptID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Create Departments table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- Insert department records
INSERT INTO Departments (DeptID, DeptName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectTitle VARCHAR(50),
    AssignedTo INT
);

-- Insert project records
INSERT INTO Projects (ProjectID, ProjectTitle, AssignedTo) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

-- 1: Inner Join Employees and Departments
SELECT 
    emp.FullName AS Employee, 
    dept.DeptName AS Department
FROM Employees emp
JOIN Departments dept ON emp.DeptID = dept.DeptID;

-- 2: Left Join to show all Employees
SELECT 
    emp.FullName AS Employee, 
    dept.DeptName AS Department
FROM Employees emp
LEFT JOIN Departments dept ON emp.DeptID = dept.DeptID;

-- 3: Right Join to show all Departments
SELECT 
    emp.FullName AS Employee, 
    dept.DeptName AS Department
FROM Employees emp
RIGHT JOIN Departments dept ON emp.DeptID = dept.DeptID;

-- 4: Full Outer Join
SELECT 
    emp.FullName AS Employee, 
    dept.DeptName AS Department
FROM Employees emp
FULL OUTER JOIN Departments dept ON emp.DeptID = dept.DeptID;

-- 5: Aggregate salary by department
SELECT 
    dept.DeptName AS Department,
    SUM(emp.Salary) AS Total_Department_Salary
FROM Employees emp
JOIN Departments dept ON emp.DeptID = dept.DeptID
GROUP BY dept.DeptName;

-- 6: Cartesian product of Departments and Projects
SELECT 
    d.DeptName, 
    p.ProjectTitle
FROM Departments d
CROSS JOIN Projects p;

-- 7: Combine all info
SELECT 
    emp.EmployeeID, 
    emp.FullName AS Employee,
    dept.DeptName AS Department,
    proj.ProjectTitle AS Project
FROM Employees emp
LEFT JOIN Departments dept ON emp.DeptID = dept.DeptID
LEFT JOIN Projects proj ON proj.AssignedTo = emp.EmployeeID;
