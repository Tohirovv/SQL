CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

---1---
;WITH Hierarchy AS (
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        h.Depth + 1
    FROM Employees e
    INNER JOIN Hierarchy h ON e.ManagerID = h.EmployeeID
)

SELECT * FROM Hierarchy
ORDER BY Depth, EmployeeID;

---2---
declare  @n int = 10;

with factorials as(
select 
1 as Num,
1 as Factorial
union all 
Select Num + 1,
   Factorial * (Num + 1)
   from factorials
   Where Num + 1 <=@n
)
select * from factorials;

---3---
DECLARE @M INT = 10;
WITH Fibonacci(n, Fibonacci_Number, Prev_Number) AS (
    SELECT 1, 1, 0
    UNION ALL 
    SELECT n + 1, Fibonacci_Number + Prev_Number, Fibonacci_Number
    FROM Fibonacci
    WHERE n < @M
)
SELECT n, Fibonacci_Number
FROM Fibonacci





