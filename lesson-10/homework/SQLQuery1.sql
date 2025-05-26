
;with All_days as(
select NUM  from Shipments
union all
select * from (Values (0),(0),(0),(0),(0),(0),(0)) as z(Num)
),
Ordered AS (
 SELECT Num, ROW_NUMBER() OVER(ORDER BY Num) AS rn
 FROM All_days
)
SELECT AVG(Num) AS Median
FROM Ordered
WHERE rn IN (20, 21);
