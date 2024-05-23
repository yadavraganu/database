/* Find the date which is 2 weeks after this week's sunday */
SELECT DATEADD(WEEK,2,DATEADD(DAY,8-DATEPART(WEEKDAY,GETDATE()),GETDATE()));

/* Write sql query to print below pattern
*
**
***
****
*****
******
*******
********
*********
**********
***********
*/
WITH CTE AS (
SELECT 1 AS NUM
UNION ALL
SELECT NUM + 1 AS NUM FROM CTE WHERE  NUM < 11)
SELECT REPLICATE('*', NUM) FROM CTE;