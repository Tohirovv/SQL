use lessons;
go

drop table if exists test_identity;
Create table test_identity(
id int Identity(1,1),
name Varchar(50)
);
INSERT INTO test_identity (name)
VALUES ('A'), ('B'), ('C'), ('D'), ('E');
select * from test_identity
--First case--
DELETE FROM test_identity;
INSERT INTO test_identity (name) VALUES ('F');
SELECT * FROM test_identity;
-- Identity will continue from 6

--Second case--
TRUNCATE TABLE test_identity;
Insert into test_identity(name) Values ('G');
SELECT * FROM test_identity;
-- Identity will restart from 1

--Third case--
DROP TABLE test_identity;
Select *from test_identity;
-- The table no longer exists

---2---
drop table if exists  data_types_demo;
CREATE TABLE data_types_demo(
    id INT,
    name NVARCHAR(100),
    birthdate DATE,
    salary DECIMAL(10,2),
    active BIT,
    photo VARBINARY(MAX),
    created_at DATETIME
	);
INSERT INTO data_types_demo (id, name, birthdate, salary, active, photo, created_at)
VALUES (1, 'Alice', '1990-01-01', 4500.50, 1, NULL, GETDATE());

SELECT * FROM data_types_demo;
---3---
drop table  if exists photos;
CREATE TABLE photos (
    id INT IDENTITY(1,1),
    image_data VARBINARY(MAX)
);
INSERT INTO photos (image_data)
SELECT * FROM OPENROWSET(BULK N'C:\Users\HP\Downloads\m.jpg', SINGLE_BLOB) AS ImageSource;
Select * from photos;
---4---
Drop table if exists student;
CREATE TABLE student(
    id INT IDENTITY(1,1),
    name VARCHAR(50),
    classes INT,
    tuition_per_class DECIMAL(10,2),
    total_tuition AS (classes * tuition_per_class)
);

INSERT INTO student (name, classes, tuition_per_class)
VALUES ('John', 3, 500.00), ('Alice', 4, 600.00), ('Bob', 2, 450.00);

SELECT * FROM student;

--5--
Drop Table if exists worker;
CREATE TABLE worker (
    id INT,
    name VARCHAR(100)
);

BULK INSERT worker
FROM 'C:\Users\HP\Downloads\workers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM worker;


