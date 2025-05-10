go
use lessons;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);
Drop table if exists Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);
----1-----
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES 
    (1, 'Alice', 'Johnson', 'HR', 65000, '2019-03-15'),
    (2, 'Bob', 'Smith', 'IT', 90000, '2018-07-20'),
    (3, 'Charlie', 'Brown', 'Finance', 95000, '2017-01-10'),
    (4, 'David', 'Williams', 'HR', 60000, '2021-05-22'),
    (5, 'Emma', 'Jones', 'IT', 110000, '2016-12-02'),
    (6, 'Frank', 'Miller', 'Finance', 42000, '2022-06-30'),
    (7, 'Grace', 'Davis', 'Marketing', 75000, '2020-09-14'),
    (8, 'Henry', 'White', 'Marketing', 70000, '2020-10-10'),
    (9, 'Ivy', 'Taylor', 'IT', 95000, '2017-04-05'),
    (10, 'Jack', 'Anderson', 'Finance', 105000, '2015-11-12');
select top 10 * from Employees
order by salary DESC ;

SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;

WITH DepartmentAvg AS (
    SELECT 
        Department,
        AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY Department
),
EmployeeWithCategory AS (
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Department,
        e.Salary,
        CASE
            WHEN e.Salary > 80000 THEN 'High'
            WHEN e.Salary BETWEEN 50000 AND 80000 THEN 'Medium'
            ELSE 'Low'
        END AS SalaryCategory,
        d.AverageSalary
    FROM Employees e
    JOIN DepartmentAvg d ON e.Department = d.Department
)
SELECT *
FROM EmployeeWithCategory
ORDER BY AverageSalary DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;

---2---
INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES 
    (101, 'John Doe', '2023-01-15', 2600, 'Shipped'),
    (102, 'Mary Smith', '2023-02-10', 4700, 'Pending'),
    (103, 'James Brown', '2023-03-25', 6300, 'Delivered'),
    (104, 'Patricia Davis', '2023-05-05', 2000, 'Cancelled'),
    (105, 'Michael Wilson', '2023-06-14', 7600, 'Shipped'),
    (106, 'Elizabeth Garcia', '2023-07-20', 9100, 'Delivered'),
    (107, 'David Martinez', '2023-08-02', 1400, 'Pending'),
    (108, 'Susan Clark', '2023-09-12', 5800, 'Shipped'),
    (109, 'Robert Lewis', '2023-10-30', 4200, 'Cancelled'),
    (110, 'Emily Walker', '2023-12-05', 10200, 'Delivered');

SELECT 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
    END AS OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
    END
HAVING SUM(TotalAmount) > 5000
ORDER BY TotalRevenue DESC;
---3---
INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES 
    (1, 'Laptop', 'Electronics', 1300, 20),
    (2, 'Smartphone', 'Electronics', 850, 40),
    (3, 'Desk Chair', 'Furniture', 180, 10),
    (4, 'LED TV', 'Electronics', 1500, 12),
    (5, 'Coffee Table', 'Furniture', 300, 5),
    (6, 'Headphones', 'Accessories', 220, 30),
    (7, 'Monitor', 'Electronics', 400, 14),
    (8, 'Sofa', 'Furniture', 950, 3),
    (9, 'Backpack', 'Accessories', 85, 60),
    (10, 'Gaming Mouse', 'Accessories', 140, 25);

Select * from Products;

SELECT DISTINCT Category
FROM Products;

SELECT 
    Category,
    ProductName,
    Price
FROM Products p1
WHERE Price = (
    SELECT MAX(Price)
    FROM Products p2
    WHERE p2.Category = p1.Category
);

SELECT 
    Category,
    ProductName,
    Price,
    IIF(Stock = 0, 'Out of Stock', 
        IIF(Stock BETWEEN 1 AND 10, 'Low Stock', 'In Stock')) AS InventoryStatus
FROM Products
ORDER BY Price DESC
OFFSET 5 ROWS;


