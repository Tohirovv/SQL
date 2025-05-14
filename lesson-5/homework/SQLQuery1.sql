
use employee;
go

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');
select * from Employees

--- 1---
select *,
Dense_Rank()Over(order by salary) as rn
from employees
order by EmployeeID;
---2---
SELECT *
FROM Employees
WHERE Salary IN (
    SELECT Salary
    FROM Employees
    GROUP BY Salary
    HAVING COUNT(*) > 1
);
---3---
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
    FROM Employees
) ranked
WHERE DeptRank <= 2;
---4---
SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS DeptLowRank
    FROM Employees
) ranked
WHERE DeptLowRank = 1;
---5---
select * , sum(salary) over(partition by department order by hiredate) as Running_Total from Employees
---6---
SELECT Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryPerDept
FROM Employees;

-- 7. Department Average Salary Without GROUP BY
SELECT Name, Department, Salary,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryPerDept
FROM Employees;

-- 8. Salary Difference From Department Average
SELECT Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees;

-- 9. Moving Average Over 3 Rows (Previous, Current, Next)
SELECT Name, HireDate, Salary,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees;

-- 10. Sum of Salaries for Last 3 Hired Employees
SELECT SUM(Salary) AS SumLast3
FROM (
    SELECT Salary
    FROM Employees
    ORDER BY HireDate DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
) AS Last3;

-- 11. Running Average Salary by HireDate
SELECT Name, HireDate, Salary,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAvg
FROM Employees;

-- 12. Max Salary in a Sliding Window of 2 Before & 2 After
SELECT Name, HireDate, Salary,
       MAX(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS MaxSliding
FROM Employees;

-- 13. Percentage of Salary Contribution in Department
SELECT Name, Department, Salary,
       Cast(100.0 * Salary / SUM(Salary) OVER (PARTITION BY Department)as Decimal(10,2)) as Percentage_salary_cont
FROM Employees;

