
CREATE TABLE #EmployeeTransfers (
    EmployeeID INT,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT 
    EmployeeID,
    Name,
    CASE 
        WHEN Department = 'HR' THEN 'IT'
        WHEN Department = 'IT' THEN 'Sales'
        WHEN Department = 'Sales' THEN 'HR'
        ELSE Department
    END AS Department,
    Salary
FROM Employees;


UPDATE E
SET E.Department = 
    CASE 
        WHEN E.Department = 'HR' THEN 'IT'
        WHEN E.Department = 'IT' THEN 'Sales'
        WHEN E.Department = 'Sales' THEN 'HR'
        ELSE E.Department
    END
FROM Employees E;

SELECT * FROM #EmployeeTransfers;

SELECT * FROM Employees;
---2---
declare @MissingOrders table(
OrderID int,
CustomerName varchar(50),
[Product] varchar(50),
Quantity int);

insert into @MissingOrders
select 
    O1.OrderID, 
    O1.CustomerName, 
    O1.Product, 
    O1.Quantity
FROM Orders_DB1 O1
left join Orders_DB2 O2
on o1.OrderId= O2.OrderId
where O2.OrderId is NULL;

select * from @MissingOrders
go
--3--
drop view if exists vw_MonthlyWorkSummary;
CREATE VIEW vw_MonthlyWorkSummary AS
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    SUM(HoursWorked) AS TotalHoursWorked,
    NULL AS TotalHoursDepartment,
    NULL AS AvgHoursDepartment,
    'EmployeeSummary' AS SummaryType
FROM WorkLog
GROUP BY EmployeeID, EmployeeName, Department
UNION ALL
SELECT 
    NULL AS EmployeeID,
    NULL AS EmployeeName,
    Department,
    NULL AS TotalHoursWorked,
    SUM(HoursWorked) AS TotalHoursDepartment,
    NULL AS AvgHoursDepartment,
    'DepartmentTotal' AS SummaryType
FROM WorkLog
GROUP BY Department
UNION ALL
SELECT 
    NULL AS EmployeeID,
    NULL AS EmployeeName,
    Department,
    NULL AS TotalHoursWorked,
    NULL AS TotalHoursDepartment,
    AVG(HoursWorked * 1.0) AS AvgHoursDepartment,
    'DepartmentAverage' AS SummaryType
FROM WorkLog
GROUP BY Department;




