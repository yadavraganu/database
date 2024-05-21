/*
Find the caller id's whose first & last call was to same person for a day
*/
CREATE TABLE PHONE_LOG
  (
     CALLER_ID    INT,
     RECIPIENT_ID INT,
     DATE_CALLED  DATETIME
  );

INSERT INTO PHONE_LOG (CALLER_ID,RECIPIENT_ID,DATE_CALLED)
VALUES (1,2,CONVERT(DATETIME, '2019-01-01 09:00:00.000', 103)),
       (1,3,CONVERT(DATETIME, '2019-01-01 17:00:00.000', 103)),
           (1,
             4,
             CONVERT(DATETIME, '2019-01-01 23:00:00.000', 103)),
            (2,
             5,
             CONVERT(DATETIME, '2019-07-05 09:00:00.000', 103)),
            (2,
             3,
             CONVERT(DATETIME, '2019-07-05 17:00:00.000', 103)),
            (2,
             3,
             CONVERT(DATETIME, '2019-07-05 17:20:00.000', 103)),
            (2,
             5,
             CONVERT(DATETIME, '2019-07-05 23:00:00.000', 103)),
            (2,
             3,
             CONVERT(DATETIME, '2019-08-01 09:00:00.000', 103)),
            (2,
             3,
             CONVERT(DATETIME, '2019-08-01 17:00:00.000', 103)),
            (2,
             5,
             CONVERT(DATETIME, '2019-08-01 19:30:00.000', 103)),
            (2,
             4,
             CONVERT(DATETIME, '2019-08-02 09:00:00.000', 103)),
            (2,
             5,
             CONVERT(DATETIME, '2019-08-02 10:00:00.000', 103)),
            (2,
             5,
             CONVERT(DATETIME, '2019-08-02 10:45:00.000', 103)),
            (2,
             4,
             CONVERT(DATETIME, '2019-08-02 11:00:00.000', 103));

SELECT DISTINCT CALLER_ID,
                RECIPIENT_ID,
                DATE_CALLED
FROM   (SELECT CALLER_ID,
               RECIPIENT_ID,
               FIRST_VALUE(RECIPIENT_ID)
                 OVER (
                   PARTITION BY CALLER_ID, DATE_CALLED
                   ORDER BY DATE_CALLED_TS ASC ROWS BETWEEN UNBOUNDED PRECEDING
                 AND
                 UNBOUNDED
                 FOLLOWING ) AS First_Call,
               LAST_VALUE(RECIPIENT_ID)
                 OVER (
                   PARTITION BY CALLER_ID, DATE_CALLED
                   ORDER BY DATE_CALLED_TS ASC ROWS BETWEEN UNBOUNDED PRECEDING
                 AND
                 UNBOUNDED
                 FOLLOWING)  AS Last_Call,
               DATE_CALLED
        FROM   (SELECT CALLER_ID,
                       RECIPIENT_ID,
                       DATE_CALLED                AS Date_Called_Ts,
                       CONVERT(DATE, DATE_CALLED) AS Date_Called
                FROM   PHONE_LOG) A) B
WHERE  FIRST_CALL = LAST_CALL 
