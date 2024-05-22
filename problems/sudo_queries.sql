/* Find the date which is 2 weeks after this week's sunday */
SELECT DATEADD(WEEK,2,DATEADD(DAY,8-DATEPART(WEEKDAY,GETDATE()),GETDATE()));