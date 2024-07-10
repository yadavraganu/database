/*
CREATE TABLE CUSTOMER_ORDERS
(
    ORDER_ID INTEGER,
    CUSTOMER_ID INTEGER,
    ORDER_DATE DATE,
    ORDER_AMOUNT INTEGER
);
INSERT INTO CUSTOMER_ORDERS
VALUES
(1, 100, CAST('2022-01-01' AS DATE), 2000),
(2, 200, CAST('2022-01-01' AS DATE), 2500),
(3, 300, CAST('2022-01-01' AS DATE), 2100),
(4, 100, CAST('2022-01-02' AS DATE), 2000),
(5, 400, CAST('2022-01-02' AS DATE), 2200),
(6, 500, CAST('2022-01-02' AS DATE), 2700),
(7, 100, CAST('2022-01-03' AS DATE), 3000),
(8, 400, CAST('2022-01-03' AS DATE), 1000),
(9, 600, CAST('2022-01-03' AS DATE), 3000);
*/
-- Find the number of customer which are new on each order data & which are exisiting Approach 1
SELECT ORDER_DATE,
       SUM(PREV_MARKER) AS NEW_CUSTOMER,
       COUNT(*) - SUM(PREV_MARKER) AS OLD_CUSTOMER
  FROM (   SELECT ORDER_DATE,
                  (CASE
                        WHEN EXISTS (   SELECT 1
                                          FROM CUSTOMER_ORDERS A
                                         WHERE ORDER_DATE  < B.ORDER_DATE
                                           AND CUSTOMER_ID = B.CUSTOMER_ID) THEN 0
                        ELSE 1 END) AS PREV_MARKER
             FROM CUSTOMER_ORDERS B) DATA
 GROUP BY ORDER_DATE;

-- Find the number of customer which are new on each order data & which are exisiting Approach 2

WITH FIRST_VISIT
  AS (SELECT CUSTOMER_ID,
             MIN(ORDER_DATE) AS FIRST_VISIT_DATE
        FROM CUSTOMER_ORDERS
       GROUP BY CUSTOMER_ID)
SELECT ORDER_DATE,
       SUM(CASE
                WHEN ORDER_DATE = FIRST_VISIT_DATE THEN 1
                ELSE 0 END) AS NEW_CUSTOMER,
       SUM(CASE
                WHEN ORDER_DATE <> FIRST_VISIT_DATE THEN 1
                ELSE 0 END) AS OLD_CUSTOMER
  FROM CUSTOMER_ORDERS A
  LEFT OUTER JOIN FIRST_VISIT F
    ON A.CUSTOMER_ID = F.CUSTOMER_ID
 GROUP BY ORDER_DATE