# Adding/Subtracting to a date
__Syntax__: DATEADD(interval, number, date)  
__interval options__ : 
- year, yyyy, yy = Year 
- quarter, qq, q = Quarter 
- month, mm, m = month 
- dayofyear, dy, y = Day of the year 
- day, dd, d = Day 
- week, ww, wk = Week 
- weekday, dw, w = Weekday 
- hour, hh = hour 
- minute, mi, n = Minute 
- second, ss, s = Second 
- millisecond, ms = Millisecond
```commandline
SELECT GETDATE() AS DATE,
DATEADD(MONTH,1,GETDATE()) AS DATE_PLUS_ONE_MONTH,
DATEADD(MONTH,-1,GETDATE()) AS DATE_MINUS_ONE_MONTH,
DATEADD(DAY,1,GETDATE()) AS DATE_PLUS_ONE_DAY,
DATEADD(DAY,-1,GETDATE()) AS DATE_MINUS_ONE_DAY,
DATEADD(YEAR,1,GETDATE()) AS DATE_PLUS_ONE_YEAR,
DATEADD(YEAR,-1,GETDATE()) AS DATE_MINUS_ONE_YEAR;
```
__Syntax__: DATEDIFF(interval, number, date)  
```commandline
WITH TEMP_DATA AS ( SELECT '2024-01-01' AS START_DATE,'2024-02-14' AS END_DATE )
SELECT DATEDIFF(DAY,START_DATE,END_DATE) AS DATE_DIFF_DAYS,
DATEDIFF(WEEK,START_DATE,END_DATE) AS DATE_DIFF_WEEKS,
DATEDIFF(MONTH,START_DATE,END_DATE) AS DATE_DIFF_MONTH,
DATEDIFF(YEAR,START_DATE,END_DATE) AS DATE_DIFF_YEAR,
DATEDIFF(HOUR,START_DATE,END_DATE) AS DATE_DIFF_HOUR,
DATEDIFF(MINUTE,START_DATE,END_DATE) AS DATE_DIFF_MINUTE
FROM TEMP_DATA;
```