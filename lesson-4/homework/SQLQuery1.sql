go
use lessons;
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);
 select * from TestMultipleZero
 where Not (A=0 and B=0 and C=0 and D=0);

---2---
CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

SELECT 
    Year1,
    Max1,
    Max2,
    Max3,
    GREATEST(Max1, Max2, Max3) AS MaxValue
FROM TestMax; 
	
	--3--

	CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

select Empid, EmpName, Birthdate from EmpBirth
where Month(Birthdate)=5 AND
      DAY(BirthDate) >= 7 AND DAY(BirthDate) <= 15;

---4---
create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');
---First---
SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 0 ELSE 1 END,
    letter;
---Second---
SELECT letter
FROM letters
ORDER BY 
    CASE WHEN letter = 'b' THEN 1 ELSE 0 END,
    letter;
---Third---
WITH Ordered AS (
    SELECT letter
    FROM letters
    WHERE letter <> 'b'
),
WithRowNums AS (
    SELECT letter, ROW_NUMBER() OVER (ORDER BY letter) AS rn
    FROM Ordered
),
Final AS (
    SELECT letter, rn FROM WithRowNums
    UNION ALL
    SELECT 'b', 3 
)
SELECT letter
FROM Final
ORDER BY rn;
