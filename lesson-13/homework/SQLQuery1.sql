declare @Year int = 2025;
declare @Month int = 5;

declare @startdate date = Datefromparts(@Year,@Month,1);
declare @enddate date = EOMONTH(@StartDate);
WITH Dates AS (
    SELECT @StartDate AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM Dates
    WHERE CalendarDate < @EndDate
),
DateWithWeek AS (
    SELECT
        CalendarDate,
        DATENAME(WEEKDAY, CalendarDate) AS WeekDayName,
        DATEPART(WEEK, CalendarDate) - DATEPART(WEEK, @StartDate) + 1 AS WeekNumber,
        DATEPART(WEEKDAY, CalendarDate) AS WeekDayNumber
    FROM Dates
)
SELECT
    WeekNumber,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 1 THEN DAY(CalendarDate) END) AS Sunday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 2 THEN DAY(CalendarDate) END) AS Monday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 3 THEN DAY(CalendarDate) END) AS Tuesday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 4 THEN DAY(CalendarDate) END) AS Wednesday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 5 THEN DAY(CalendarDate) END) AS Thursday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 6 THEN DAY(CalendarDate) END) AS Friday,
    MAX(CASE WHEN DATEPART(WEEKDAY, CalendarDate) = 7 THEN DAY(CalendarDate) END) AS Saturday
FROM DateWithWeek
GROUP BY WeekNumber
ORDER BY WeekNumber
OPTION (MAXRECURSION 1000);