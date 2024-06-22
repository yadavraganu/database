/*
-- Find the user with total visit entry,max visited floor by a user along with the distinct resources used
CREATE TABLE ENTRIES (
NAME VARCHAR(20),
ADDRESS VARCHAR(20),
EMAIL VARCHAR(20),
FLOOR INT,
RESOURCES VARCHAR(10));

INSERT INTO ENTRIES
VALUES ('A','BANGALORE','A@GMAIL.COM',1,'CPU'),('A','BANGALORE','A1@GMAIL.COM',1,'CPU'),('A','BANGALORE','A2@GMAIL.COM',2,'DESKTOP')
,('B','BANGALORE','B@GMAIL.COM',2,'DESKTOP'),('B','BANGALORE','B1@GMAIL.COM',2,'DESKTOP'),('B','BANGALORE','B2@GMAIL.COM',1,'MONITOR')
*/
WITH PER_FLOOR_VISIT AS (SELECT *, RANK() OVER (PARTITION BY NAME ORDER BY VISITS DESC) AS RNK
                         FROM(SELECT *
                              FROM(SELECT NAME, FLOOR, COUNT(*) AS VISITS FROM ENTRIES GROUP BY NAME, FLOOR)A )B ),

	 TOTAL_VISIT AS (SELECT NAME, COUNT(*) AS TOTAL_VISITS FROM ENTRIES GROUP BY NAME),

	 TOTAL_RESOURCES AS (SELECT NAME, STRING_AGG(RESOURCES, ',') AS RESOURCES_USED
                                                                                                                                                                                                                           FROM(SELECT DISTINCT NAME, RESOURCES FROM ENTRIES)A
                                                                                                                                                                                                                           GROUP BY NAME)
SELECT FV.NAME, FLOOR AS MOST_VISITED_FLOOR, TOTAL_VISITS, RESOURCES_USED
FROM PER_FLOOR_VISIT FV
     LEFT OUTER JOIN TOTAL_VISIT TV ON FV.NAME=TV.NAME
     LEFT OUTER JOIN TOTAL_RESOURCES TR ON FV.NAME=TR.NAME
WHERE RNK=1;