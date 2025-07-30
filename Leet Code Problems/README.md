# Window Functions Syntax
```sql
-- Mysql
WINDOW_FUNCTION ( [argument_expression] ) OVER (
    [PARTITION BY expression [, ...n]]
    [ORDER BY expression [ASC | DESC] [, ...n]]
    [ROWS | RANGE {UNBOUNDED PRECEDING | CURRENT ROW | N PRECEDING | N FOLLOWING | BETWEEN frame_start AND frame_end}]
)
````

## 180\. Consecutive Numbers

```sql
--RESTRICTED TO 3 CONSECUTIVE NUMS
SELECT DISTINCT
    L1.NUM AS CONSECUTIVENUMS
FROM
    LOGS L1
JOIN
    LOGS L2 ON L1.ID = L2.ID - 1 AND L1.NUM = L2.NUM
JOIN
    LOGS L3 ON L1.ID = L3.ID - 2 AND L1.NUM = L3.NUM;
--------
SELECT DISTINCT
    NUM AS CONSECUTIVENUMS
FROM (
    SELECT
        ID,
        NUM,
        -- GET THE NUMBER FROM THE PREVIOUS ROW
        LAG(NUM, 1) OVER (ORDER BY ID) AS PREV_NUM_1,
        -- GET THE NUMBER FROM TWO ROWS PRIOR
        LAG(NUM, 2) OVER (ORDER BY ID) AS PREV_NUM_2
    FROM
        LOGS
) AS SUBQUERY
WHERE
    NUM = PREV_NUM_1 AND NUM = PREV_NUM_2;
----------
SELECT DISTINCT
    NUM AS CONSECUTIVENUMS
FROM (
    SELECT
        NUM,
        -- CALCULATE THE DIFFERENCE TO IDENTIFY CONSECUTIVE GROUPS
        ID - ROW_NUMBER() OVER (PARTITION BY NUM ORDER BY ID) AS GROUP_KEY
    FROM
        LOGS
) AS T
GROUP BY
    NUM,
    GROUP_KEY
HAVING
    COUNT(*) >= 3;
```

## 184\. Department Highest Salary

```sql
SELECT
  DEPARTMENT,
  EMPLOYEE,
  SALARY
FROM
  (
    SELECT
      D.NAME AS DEPARTMENT,
      E.NAME AS EMPLOYEE,
      SALARY,
      RANK() OVER(
        PARTITION BY D.NAME
        ORDER BY
          SALARY DESC
      ) AS RANK_DPT
    FROM
      EMPLOYEE E
      LEFT OUTER JOIN DEPARTMENT D ON E.DEPARTMENTID = D.ID
  ) DATA
WHERE
  DATA.RANK_DPT = 1
```

## 185\. Department Top Three Salaries

```sql
SELECT
  DEPARTMENT,
  EMPLOYEE,
  SALARY
FROM
  (
    SELECT
      D.NAME AS DEPARTMENT,
      E.NAME AS EMPLOYEE,
      SALARY,
      DENSE_RANK() OVER(
        PARTITION BY D.NAME
        ORDER BY
          SALARY DESC
      ) AS RANK_DPT
    FROM
      EMPLOYEE E
      LEFT OUTER JOIN DEPARTMENT D ON E.DEPARTMENTID = D.ID
  ) DATA
WHERE
  DATA.RANK_DPT < 4 ORDER BY 1,3 DESC
```

## 196\. Delete Duplicate Emails

## 197\. Rising Temperature

## 262\. Trips and Users

## 511\. Game Play Analysis I

## 534\. Game Play Analysis II

## 550\. Game Play Analysis III

## 569\. Median Employee Salary

## 570\. Managers with at Least 5 Direct Reports

## 574\. Winning Candidate

## 577\. Employee Bonus

## 579\. Find Cumulative Salary of an Employee

## 584\. Find Customer Referee

## 585\. Investments in 2016

## 586\. Customer Placing the Largest Number of Orders

## 595\. Big Countries

## 602\. Friend Requests II: Who Has the Most Friends

```sql
SELECT
  ID,
  COUNT(*) AS NUM
FROM
  (
    SELECT
      REQUESTER_ID AS ID
    FROM
      REQUESTACCEPTED
    UNION ALL
    SELECT
      ACCEPTER_ID AS ID
    FROM
      REQUESTACCEPTED
  ) AS D
GROUP BY
  ID
ORDER BY
  NUM DESC
LIMIT 1;
```

## 603\. Consecutive Available Seats

## 607\. Sales Person

## 608\. Tree Node

## 610\. Triangle Judgment

## 619\. Biggest Single Number

## 620\. Not Boring Movies

## 626\. Exchange Seats

```sql
SELECT
    CASE
        WHEN MOD(ID, 2) <> 0 AND ID = (SELECT MAX(ID) FROM SEAT) THEN ID -- ODD ID AND IT'S THE LAST ID
        WHEN MOD(ID, 2) <> 0 THEN ID + 1 -- ODD ID, SWAP WITH THE NEXT ID
        ELSE ID - 1 -- EVEN ID, SWAP WITH THE PREVIOUS ID
    END AS ID,
    STUDENT
FROM
    SEAT
ORDER BY
    ID ASC;
---------------------------
SELECT
    ID,
    CASE
        WHEN MOD(ID, 2) = 1 AND LEAD(STUDENT, 1, STUDENT) OVER (ORDER BY ID) IS NOT NULL THEN LEAD(STUDENT, 1, STUDENT) OVER (ORDER BY ID)
        WHEN MOD(ID, 2) = 0 THEN LAG(STUDENT) OVER (ORDER BY ID)
        ELSE STUDENT -- THIS CASE IS TECHNICALLY COVERED BY LEAD'S DEFAULT OR THE FIRST WHEN, BUT GOOD FOR CLARITY.
    END AS STUDENT
FROM
    SEAT
ORDER BY
    ID ASC;
```

## 627\. Swap Salary

```sql
UPDATE SALARY SET SEX = CASE WHEN UPPER(SEX) = 'M' THEN 'F' ELSE 'M' END
```

## 1045\. Customers Who Bought All Products

```sql
SELECT CUSTOMER_ID FROM CUSTOMER GROUP BY CUSTOMER_ID HAVING COUNT(DISTINCT PRODUCT_KEY) = (SELECT COUNT(*) FROM PRODUCT)
```

## 1050\. Actors and Directors Who Cooperated At Least Three Times

```sql
SELECT ACTOR_ID,DIRECTOR_ID FROM ACTORDIRECTOR GROUP BY ACTOR_ID,DIRECTOR_ID HAVING COUNT(*)>=3
```

## 1068\. Product Sales Analysis I

```sql
SELECT PRODUCT_NAME,YEAR,PRICE FROM SALES S LEFT JOIN PRODUCT P ON S.PRODUCT_ID=P.PRODUCT_ID
```

## 1069\. Product Sales Analysis II

```sql
SELECT PRODUCT_ID, SUM(QUANTITY) AS TOTAL_QUANTITY FROM SALES GROUP BY 1
```

## 1070\. Product Sales Analysis III

```sql
SELECT
  PRODUCT_ID,
  FIRST_YEAR,
  QUANTITY,
  PRICE
FROM
  (
    SELECT
      PRODUCT_ID,
      YEAR AS FIRST_YEAR,
      QUANTITY,
      PRICE,
      MIN(YEAR) OVER (PARTITION BY PRODUCT_ID) AS MIN_YEAR
    FROM
      SALES
  ) A
WHERE
  MIN_YEAR = FIRST_YEAR
```

## 1075\. Project Employees I

```sql
SELECT PROJECT_ID,ROUND(AVG(EXPERIENCE_YEARS),2) AS AVERAGE_YEARS  FROM PROJECT P JOIN EMPLOYEE E ON P.EMPLOYEE_ID=E.EMPLOYEE_ID GROUP BY PROJECT_ID
```

## 1076\. Project Employees II

```sql
SELECT PROJECT_ID
FROM PROJECT
GROUP BY PROJECT_ID
HAVING COUNT(EMPLOYEE_ID) = (
    SELECT COUNT(EMPLOYEE_ID)
    FROM PROJECT
    GROUP BY PROJECT_ID
    ORDER BY COUNT(EMPLOYEE_ID) DESC
    LIMIT 1
);
```

## 1077\. Project Employees III

```sql
WITH EMPLOYEEPROJECTEXPERIENCE AS (
    SELECT
        P.PROJECT_ID,
        P.EMPLOYEE_ID,
        E.EXPERIENCE_YEARS,
        DENSE_RANK() OVER (PARTITION BY P.PROJECT_ID ORDER BY E.EXPERIENCE_YEARS DESC) AS EXPERIENCE_RANK
    FROM
        PROJECT P
    JOIN
        EMPLOYEE E ON P.EMPLOYEE_ID = E.EMPLOYEE_ID
)
SELECT
    PROJECT_ID,
    EMPLOYEE_ID
FROM
    EMPLOYEEPROJECTEXPERIENCE
WHERE
    EXPERIENCE_RANK = 1;
```

## 1082\. Sales Analysis I

```sql
SELECT SELLER_ID
FROM SALES
GROUP BY SELLER_ID
HAVING SUM(PRICE) = (
    SELECT SUM(PRICE)
    FROM SALES
    GROUP BY SELLER_ID
    ORDER BY SUM(PRICE) DESC
    LIMIT 1
);
------------------------
WITH SELLERTOTALSALES AS (
    SELECT
        SELLER_ID,
        SUM(PRICE) AS TOTAL_SALES
    FROM
        SALES
    GROUP BY
        SELLER_ID
),
RANKEDSELLERS AS (
    SELECT
        SELLER_ID,
        TOTAL_SALES,
        DENSE_RANK() OVER (ORDER BY TOTAL_SALES DESC) AS SALES_RANK
    FROM
        SELLERTOTALSALES
)
SELECT
    SELLER_ID
FROM
    RANKEDSELLERS
WHERE
    SALES_RANK = 1;
```

## 1083\. Sales Analysis II

```sql
-- NOT PREFFERED DUE PERFORMANCE OF NOT IN OPERATOR
SELECT DISTINCT S.BUYER_ID
FROM SALES S
JOIN PRODUCT P ON S.PRODUCT_ID = P.PRODUCT_ID
WHERE P.PRODUCT_NAME = 'S8'
AND S.BUYER_ID NOT IN (
    SELECT S2.BUYER_ID
    FROM SALES S2
    JOIN PRODUCT P2 ON S2.PRODUCT_ID = P2.PRODUCT_ID
    WHERE P2.PRODUCT_NAME = 'iPhone'
);
-----------------------------
--  PREFERRED FOR PERFORMANCE REASONS, ESPECIALLY WITH LARGE DATASETS
SELECT DISTINCT S_S8.BUYER_ID
FROM SALES S_S8
JOIN PRODUCT P_S8 ON S_S8.PRODUCT_ID = P_S8.PRODUCT_ID
LEFT JOIN (
    SELECT S_IPHONE.BUYER_ID
    FROM SALES S_IPHONE
    JOIN PRODUCT P_IPHONE ON S_IPHONE.PRODUCT_ID = P_IPHONE.PRODUCT_ID
    WHERE P_IPHONE.PRODUCT_NAME = 'iPhone'
) AS IPHONE_BUYERS ON S_S8.BUYER_ID = IPHONE_BUYERS.BUYER_ID
WHERE P_S8.PRODUCT_NAME = 'S8' AND IPHONE_BUYERS.BUYER_ID IS NULL;
-----------------------------
-- IT'S NOT THE NATURAL OR RECOMMENDED WAY TO SOLVE
SELECT
    S.BUYER_ID
FROM
    SALES S
JOIN
    PRODUCT P ON S.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
    S.BUYER_ID
HAVING
    -- BUYER BOUGHT S8 (SUM OF PRODUCT_ID FOR S8 SALES > 0)
    SUM(CASE WHEN P.PRODUCT_NAME = 'S8' THEN 1 ELSE 0 END) > 0
    AND
    -- BUYER DID NOT BUY IPHONE (SUM OF PRODUCT_ID FOR IPHONE SALES = 0)
    SUM(CASE WHEN P.PRODUCT_NAME = 'iPhone' THEN 1 ELSE 0 END) = 0;
```

## 1084\. Sales Analysis III

## 1098\. Unpopular Books

## 1107\. New Users Daily Count

## 1112\. Highest Grade For Each Student

```sql
SELECT
    STUDENT_ID,
    COURSE_ID,
    GRADE
FROM
    (SELECT
        STUDENT_ID,
        COURSE_ID,
        GRADE,
        ROW_NUMBER() OVER(PARTITION BY STUDENT_ID ORDER BY GRADE DESC, COURSE_ID ASC) AS RN
    FROM
        ENROLLMENTS) AS RANKED_GRADES
WHERE
    RN = 1;
```

## 1126\. Active Business

## 1127\. User Purchase Platform

## 1132\. Reported Posts

## 1132\. Reported Posts II

## 1141\. User Activity for the Past 30 Days I

## 1142\. User Activity for the Past 30 Days II

## 1148\. Article Views I

## 1149\. Article Views II

## 1158\. Market Analysis I

## 1159\. Market Analysis II

```sql
```

## 1164\. Product Price at a Given Date

```sql
```

## 1173\. Immediate Food Delivery I

```sql
```

## 1174\. Immediate Food Delivery II

```sql
```

## 1179\. Reformat Department Table

```sql
```

## 1193\. Monthly Transactions I

```sql
```

## 1194\. Tournament Winners

```sql
```

## 1204\. Last Person to Fit in the Bus

```sql
```

## 1205\. Monthly Transactions II

```sql
```

## 1211\. Queries Quality and Percentage

```sql
```

## 1212\. Team Scores in Football Tournament

```sql
```

## 1225\. Report Contiguous Dates

```sql
```

## 1246\. Number of Comments per Post

```sql
```

## 1251\. Average Selling Price

```sql
```

## 1280\. Students and Examinations

```sql
```

## 1294\. Weather Type In Each Country

```sql
```

## 1308\. Find the Start and End Number of Continuous Ranges

```sql
```

## 1321\. Restaurant Growth

## 1326\. Server Utilization Time

```sql
WITH SERVERSESSIONS AS (
    SELECT
        SERVER_ID,
        STATUS_TIME AS START_TIME,
        LEAD(STATUS_TIME) OVER (PARTITION BY SERVER_ID ORDER BY STATUS_TIME) AS NEXT_STATUS_TIME,
        SESSION_STATUS
    FROM
        SERVERS
)
SELECT
    FLOOR(SUM(CAST(DATEDIFF(SECOND, START_TIME, NEXT_STATUS_TIME) AS BIGINT)) / (CAST(24 AS BIGINT) * 60 * 60)) AS TOTAL_UPTIME_DAYS
FROM
    SERVERSESSIONS
WHERE
    SESSION_STATUS = 'START' AND NEXT_STATUS_TIME IS NOT NULL;
```

## 1341\. Game Play Analysis V

## 1393\. Capital Gain/Loss

## 1398\. Customers Who Bought Products A and B But Not C

## 1407\. Top Travellers

## 1412\. Find the Quiet Students in All Exams

```sql
WITH T AS (
    SELECT
        STUDENT_ID,
        RANK() OVER (
            PARTITION BY EXAM_ID
            ORDER BY SCORE
        ) AS RK1, -- Rank for lowest scores (1 means lowest)
        RANK() OVER (
            PARTITION BY EXAM_ID
            ORDER BY SCORE DESC
        ) AS RK2  -- Rank for highest scores (1 means highest)
    FROM EXAM
)
SELECT S.STUDENT_ID, S.STUDENT_NAME
FROM
    T
    JOIN STUDENT S USING (STUDENT_ID) -- Use an alias for clarity in SELECT
GROUP BY S.STUDENT_ID, S.STUDENT_NAME -- Group by both for robust SQL standard compliance
HAVING SUM(CASE WHEN RK1 = 1 THEN 1 ELSE 0 END) = 0 -- Equivalent to SUM(RK1 = 1) if boolean is converted to int
   AND SUM(CASE WHEN RK2 = 1 THEN 1 ELSE 0 END) = 0
ORDER BY S.STUDENT_ID;
```

## 1421\. NPV Queries

## 1440\. Product Sales Analysis IV

## 1445\. Apples & Oranges

## 1454\. Active Users

```sql
WITH DISTINCTLOGINS AS (
    SELECT
        DISTINCT ID,
        LOGIN_DATE
    FROM
        LOGINS
),
RANKEDLOGINS AS (
    SELECT
        ID,
        LOGIN_DATE,
        -- ASSIGN A SEQUENTIAL RANK TO EACH LOGIN DATE FOR A GIVEN USER
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY LOGIN_DATE) AS RN
    FROM
        DISTINCTLOGINS
),
CONSECUTIVEGROUPS AS (
    SELECT
        ID,
        LOGIN_DATE,
        -- CALCULATE A 'GROUP_ID' WHICH WILL BE CONSTANT FOR CONSECUTIVE DAYS
        DATE_SUB(LOGIN_DATE, INTERVAL RN DAY) AS GROUP_ID_DATE
    FROM
        RANKEDLOGINS
),
ACTIVEUSERIDS AS (
    SELECT
        ID
    FROM
        CONSECUTIVEGROUPS
    GROUP BY
        ID,
        GROUP_ID_DATE
    HAVING
        COUNT(*) >= 5 -- CHECK FOR 5 OR MORE CONSECUTIVE DAYS
)
SELECT
    A.ID,
    A.NAME
FROM
    ACCOUNTS AS A
JOIN
    ACTIVEUSERIDS AS AU
ON
    A.ID = AU.ID
ORDER BY
    A.ID;
```

## 1468\. Calculate Salaries

```sql
SELECT
    s.company_id,
    s.employee_id,
    s.employee_name,
    ROUND(
        CASE
            WHEN c.max_salary < 1000 THEN s.salary
            WHEN c.max_salary BETWEEN 1000 AND 10000 THEN s.salary * (1 - 0.24)
            ELSE s.salary * (1 - 0.49)
        END
    ) AS salary
FROM
    Salaries s
JOIN (
    SELECT
        company_id,
        MAX(salary) AS max_salary
    FROM
        Salarie
    GROUP BY
        company_id
) c ON s.company_id = c.company_id;
```

## 1479\. Friendly Movies Streamed Last Month

## 1484\. Group Sold Products By The Date

## 1501\. Countries You Can Safely Invest In

## 1511\. Customer Order Frequency

## 1517\. Find Users With Valid E-Mails

## 1527\. Patients With a Condition

## 1532\. The Most Recent Three Orders

## 1543\. Fix Product Name Format

```sql
SELECT
    LOWER(TRIM(PRODUCT_NAME)) AS PRODUCT_NAME, -- FIX PRODUCT NAME FORMAT
    DATE_FORMAT(SALE_DATE, '%Y-%M') AS SALE_DATE, -- FORMAT DATE TO YYYY-MM
    COUNT(SALE_ID) AS TOTAL -- COUNT SALES FOR EACH PRODUCT/MONTH GROUP
FROM
    SALES
GROUP BY
    LOWER(TRIM(PRODUCT_NAME)), -- GROUP BY THE FIXED PRODUCT NAME
    DATE_FORMAT(SALE_DATE, '%Y-%M') -- GROUP BY THE FORMATTED SALE DATE
ORDER BY
    PRODUCT_NAME ASC, -- ORDER BY FIXED PRODUCT NAME
    SALE_DATE ASC;     -- THEN BY FORMATTED SALE DATE
```

## 1555\. Bank Account Summary

## 1565\. Unique Orders and Customers Per Month

## 1571\. Warehouse Manager

## 1581\. Customer Who Visited but Did Not Make Any Transactions

## 1587\. Bank Account Summary II

## 1596\. The Most Frequently Ordered Products for Each Customer

```sql
SELECT
    CUSTOMER_ID,
    PRODUCT_ID,
    PRODUCT_NAME
FROM (
    SELECT
        O.CUSTOMER_ID,
        O.PRODUCT_ID,
        P.PRODUCT_NAME,
        DENSE_RANK() OVER (PARTITION BY O.CUSTOMER_ID ORDER BY COUNT(O.PRODUCT_ID) DESC) AS RNK
    FROM
        ORDERS O
    JOIN
        PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
    GROUP BY
        O.CUSTOMER_ID, O.PRODUCT_ID, P.PRODUCT_NAME -- INCLUDE PRODUCT_NAME IN GROUP BY FOR CONSISTENCY OR JUST SELECT IT FROM THE OUTER QUERY
) AS RANKEDORDERS
WHERE
    RNK = 1;
```

## 1607\. Sellers With No Sales

## 1613\. Find the Missing IDs

```sql
WITH RECURSIVE NUMBERSEQUENCE AS (
    -- ANCHOR MEMBER: START THE SEQUENCE FROM 1
    SELECT 1 AS ID
    UNION ALL
    -- RECURSIVE MEMBER: GENERATE SUBSEQUENT NUMBERS UP TO THE MAXIMUM CUSTOMER_ID
    SELECT ID + 1
    FROM NUMBERSEQUENCE
    WHERE ID < (SELECT MAX(CUSTOMER_ID) FROM CUSTOMERS)
)
SELECT ID AS IDS
FROM NUMBERSEQUENCE
WHERE ID NOT IN (SELECT CUSTOMER_ID FROM CUSTOMERS)
ORDER BY IDS ASC;
```

## 1623\. All Valid Triplets That Can Represent a Country

```sql
SELECT
    S1.STUDENT_ID AS STUDENT_ID1,
    S2.STUDENT_ID AS STUDENT_ID2,
    S3.STUDENT_ID AS STUDENT_ID3
FROM
    SCHOOLA S1
JOIN
    SCHOOLB S2 ON S1.STUDENT_NAME != S2.STUDENT_NAME AND S1.STUDENT_ID != S2.STUDENT_ID
JOIN
    SCHOOLC S3 ON S2.STUDENT_NAME != S3.STUDENT_NAME AND S1.STUDENT_NAME != S3.STUDENT_NAME AND S1.STUDENT_ID != S3.STUDENT_ID AND S2.STUDENT_ID != S3.STUDENT_ID
ORDER BY
    STUDENT_ID1, STUDENT_ID2, STUDENT_ID3;
```

## 1633\. Percentage of Users Attended a Contest

```sql
SELECT
    R.CONTEST_ID,
    ROUND(COUNT(DISTINCT R.USER_ID) * 100.0 / (SELECT COUNT(USER_ID) FROM USERS), 2) AS PERCENTAGE
FROM
    REGISTER R
GROUP BY
    R.CONTEST_ID
ORDER BY
    PERCENTAGE DESC,
    R.CONTEST_ID ASC;
-------------------------------
WITH TOTAL_USER AS
  (SELECT COUNT(*) AS TOTAL_USER
   FROM USERS)
SELECT CONTEST_ID,
       ROUND(IFNULL(COUNT(DISTINCT R.USER_ID)*100/TU.TOTAL_USER, 0), 2) AS PERCENTAGE
FROM REGISTER R
JOIN TOTAL_USER TU
GROUP BY CONTEST_ID
ORDER BY 2 DESC,
         1 ASC
```

## 1640\. Table of Orders

## 1643\. Merge Overlapping Events In the Same Hall

## 1651\. Hopper Company Queries III

## 1657\. Get Highest Answer Rate Question

## 1661\. Average Time of Process per Machine

## 1667\. Fix Names in a Table

## 1677\. Product's Worth Over Invoices

## 1683\. Invalid Tweets

## 1693\. Daily Leads and Partners

## 1709\. Biggest Window Between Visits

## 1715\. Count Apples and Oranges

## 1729\. Find Followers Count

## 1731\. The Number of Employees Which Report to Each Employee

## 1741\. Find Total Time Spent By Each Employee

## 1767\. Find Unique Email Domains

## 1783\. Grand Slam Titles

## 1789\. Primary Department for Each Employee

## 1795\. Rearrange Products Table

## 1890\. The Latest Login in 2020

```sql
SELECT USER_ID,MAX(TIME_STAMP) AS LAST_STAMP FROM LOGINS WHERE YEAR(TIME_STAMP)=2020 GROUP BY USER_ID
```

## 1907\. Count Salary Categories

## 1934\. Confirmation Rate

## 1951\. All the Pairs With the Maximum Number of Common Followers

## 2026\. Low-Quality Problems

## 2051\. The Number of Seniors and Juniors to Join the Company

## 2066\. Account Balance

## 2072\. The Winner University

## 2082\. The Number of Rich Customers

## 2083\. Drop Type 1 Orders for Customers With Type 0 Orders

## 2112\. The Airport With the Most Traffic

## 2142\. The Number of Passengers In Each Bus I

## 2143\. The Number of Passengers In Each Bus II

## 2153\. The Number of Users That Are Eligible For Discount

## 2173\. Longest Winning Streak

```sql
WITH PLAYERALLMATCHESRN AS (
    SELECT
        PLAYER_ID,
        MATCH_DATE,
        RESULT,
        -- ROW NUMBER FOR ALL MATCHES FOR A PLAYER, ORDERED BY DATE
        ROW_NUMBER() OVER (PARTITION BY PLAYER_ID ORDER BY MATCH_DATE) AS RN_ALL
    FROM
        MATCHES
),
PLAYERWINMATCHESRN AS (
    SELECT
        PLAYER_ID,
        MATCH_DATE,
        RESULT,
        RN_ALL,
        -- ROW NUMBER FOR ONLY WINNING MATCHES FOR A PLAYER, ORDERED BY DATE
        -- THIS IS CRUCIAL FOR THE GROUPING KEY
        ROW_NUMBER() OVER (PARTITION BY PLAYER_ID ORDER BY MATCH_DATE) AS RN_WIN_ONLY
    FROM
        PLAYERALLMATCHESRN
    WHERE
        RESULT = 'WIN'
),
STREAKGROUPS AS (
    SELECT
        PLAYER_ID,
        MATCH_DATE,
        RESULT,
        -- THE DIFFERENCE CREATES THE GROUP IDENTIFIER FOR CONSECUTIVE WINS
        RN_ALL - RN_WIN_ONLY AS STREAK_GROUP
    FROM
        PLAYERWINMATCHESRN
),
WINNINGSTREAKLENGTHS AS (
    SELECT
        PLAYER_ID,
        STREAK_GROUP,
        COUNT(MATCH_DATE) AS CURRENT_STREAK_LENGTH
    FROM
        STREAKGROUPS
    GROUP BY
        PLAYER_ID,
        STREAK_GROUP
),
MAXWINNINGSTREAKS AS (
    SELECT
        PLAYER_ID,
        COALESCE(MAX(CURRENT_STREAK_LENGTH), 0) AS LONGEST_STREAK
    FROM
        WINNINGSTREAKLENGTHS
    GROUP BY
        PLAYER_ID
)
SELECT
    P.PLAYER_ID,
    COALESCE(MWS.LONGEST_STREAK, 0) AS LONGEST_STREAK
FROM
    (SELECT DISTINCT PLAYER_ID FROM MATCHES) P -- GET ALL DISTINCT PLAYERS
LEFT JOIN
    MAXWINNINGSTREAKS MWS ON P.PLAYER_ID = MWS.PLAYER_ID
ORDER BY
    P.PLAYER_ID;
-----------------------------------------------------------------------
WITH WINNINGMATCHESWITHRN AS (
    SELECT
        PLAYER_ID,
        MATCH_DATE,
        -- ASSIGN A ROW NUMBER ONLY TO WINNING MATCHES FOR EACH PLAYER
        ROW_NUMBER() OVER (PARTITION BY PLAYER_ID ORDER BY MATCH_DATE) AS RN
    FROM
        MATCHES
    WHERE
        RESULT = 'WIN'
),
STREAKGROUPS AS (
    SELECT
        PLAYER_ID,
        MATCH_DATE,
        RN,
        -- CALCULATE THE "GROUPING KEY": DATE MINUS THE ROW NUMBER (IN DAYS)
        -- THIS WORKS BECAUSE IF DATES ARE CONSECUTIVE, (DATE - RN) WILL BE CONSTANT.
        -- IF THERE'S A GAP (LOSS OR SKIPPED DAY), THE VALUE WILL CHANGE, FORMING A NEW GROUP.
        DATE_SUB(MATCH_DATE, INTERVAL RN DAY) AS STREAK_GROUP_KEY
        -- NOTE: FOR OTHER DATABASES, YOU MIGHT USE DIFFERENT DATE ARITHMETIC:
        -- POSTGRESQL: MATCH_DATE - RN * INTERVAL '1 DAY'
        -- SQL SERVER: DATEADD(DAY, -RN, MATCH_DATE)
        -- ORACLE: MATCH_DATE - RN
    FROM
        WINNINGMATCHESWITHRN
),
WINNINGSTREAKLENGTHS AS (
    SELECT
        PLAYER_ID,
        STREAK_GROUP_KEY,
        COUNT(MATCH_DATE) AS CURRENT_STREAK_LENGTH
    FROM
        STREAKGROUPS
    GROUP BY
        PLAYER_ID,
        STREAK_GROUP_KEY
),
MAXWINNINGSTREAKS AS (
    SELECT
        PLAYER_ID,
        -- GET THE MAXIMUM STREAK LENGTH FOR EACH PLAYER
        COALESCE(MAX(CURRENT_STREAK_LENGTH), 0) AS LONGEST_STREAK
    FROM
        WINNINGSTREAKLENGTHS
    GROUP BY
        PLAYER_ID
)
SELECT
    P.PLAYER_ID,
    COALESCE(MWS.LONGEST_STREAK, 0) AS LONGEST_STREAK
FROM
    (SELECT DISTINCT PLAYER_ID FROM MATCHES) P -- GET ALL DISTINCT PLAYERS
LEFT JOIN
    MAXWINNINGSTREAKS MWS ON P.PLAYER_ID = MWS.PLAYER_ID
ORDER BY
    P.PLAYER_ID;
```

## 2199\. Find All Unique Email Domains

## 2228\. Users With Two Purchases Within Seven Days

## 2238\. Number of Times a Driver Was a Passenger

## 2241\. The Users That Are Eligible for Discount

## 2252\. Dynamic Pivoting of a Table

## 2298\. Consecutive Transactions With Increasing Amounts

## 2308\. Arrange Table By Gender

## 2324\. Product Sales Analysis V

## 2339\. All the Matches of the League

```sql
SELECT
    T1.TEAM_NAME AS HOME_TEAM,
    T2.TEAM_NAME AS AWAY_TEAM
FROM
    TEAMS AS T1
JOIN
    TEAMS AS T2 ON T1.TEAM_NAME != T2.TEAM_NAME;
```

## 2346\. Compute the Rank as a Percentage

```sql
SELECT
    STUDENT_ID,
    DEPARTMENT_ID,
    ROUND(
        IFNULL(
            (RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY MARK DESC) - 1) * 100.0 / (COUNT(STUDENT_ID) OVER (PARTITION BY DEPARTMENT_ID) - 1),
            0
        ),
        2
    ) AS PERCENTAGE
FROM
    STUDENTS;
```

## 2356\. Number of Unique Subjects Taught By Each Teacher

## 2480\. Find All Valid Triples that Can Represent a Country

## 2504\. Find Candidates for Data Scientist Position

## 2513\. Find the Start and End Number of Continuous Ranges

## 2516\. Customers With Strictly Increasing Purchases

## 2542\. Calculate Parking Fees and Duration

## 2566\. Find the Subtasks That Did Not Execute

## 2571\. Smallest Prime Number

## 2595\. Consecutive Available Seats

## 2646\. Product Price at a Given Date

## 2668\. Find Latest Salaries

## 2688\. Find Active Users

```sql
SELECT DISTINCT USER_ID
FROM (
    SELECT
        USER_ID,
        CREATED_AT,
        LAG(CREATED_AT, 1) OVER (PARTITION BY USER_ID ORDER BY CREATED_AT) AS PREV_CREATED_AT
    FROM
        USERS
) AS SUBQUERY
WHERE
    DATEDIFF(CREATED_AT, PREV_CREATED_AT) <= 7;
```

## 2690\. Users That Actively Request Confirmation Messages

## 2720\. Find the Team Size

## 2725\. Calculate Compressed Mean

## 2728\. Find the Kth Largest Sum of Subarray

## 2738\. Consecutive Available Seats II

## 2753\. The Number of Employees Which Report to Each Employee

## 2755\. The Number of Seniors and Juniors to Join the Company II

## 2760\. Find a Peak in a 2D Grid

## 2783\. Total Traveled Distance

## 2793\. Average Price of Each Product

## 2809\. Find the Maximum Sum of Node Values

## 2811\. Average Selling Price

## 2837\. Total Sales Amount By Year

## 2840\. Product Sales Analysis V

## 2841\. Maximum Number of Tasks You Can Assign

## 2854\. Rolling Average Steps

```sql
SELECT
    USER_ID,
    STEPS_DATE,
    ROUND(ROLLING_AVERAGE, 2) AS ROLLING_AVERAGE
FROM (
    SELECT
        USER_ID,
        STEPS_DATE,
        STEPS_COUNT,
        AVG(STEPS_COUNT) OVER (
            PARTITION BY USER_ID
            ORDER BY STEPS_DATE
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS ROLLING_AVERAGE,
        LAG(STEPS_DATE, 2) OVER (
            PARTITION BY USER_ID
            ORDER BY STEPS_DATE
        ) AS STEPS_DATE_TWO_DAYS_AGO
    FROM
        STEPS
) AS SUBQUERY
WHERE
    DATEDIFF(STEPS_DATE, STEPS_DATE_TWO_DAYS_AGO) = 2
ORDER BY
    USER_ID ASC,
    STEPS_DATE ASC;
```

## 2865\. Beautiful Towers I

## 2886\. Change Null Values in a Table to the Previous Value

## 2887\. Fill Missing Invoices

## 2892\. Latest Login in 2020

## 2923\. Find a Corresponding Node of a Binary Tree in a Clone of That Tree

## 2975\. Find Peak Calling Hours for Each City

## 3020\. Find the Maximum Number of Elements in an Array

## 3044\. The Number of Users That Are Eligible For Discount

## 3085\. Find the Kth Largest Sum of Node Values

## 3140\. Consecutive Available Seats II

```sql
WITH T AS (
    SELECT *,
           seat_id - RANK() OVER (ORDER BY seat_id) AS gid
    FROM Cinema
    WHERE free = 1
),
P AS (
    SELECT
        MIN(seat_id) AS first_seat_id,
        MAX(seat_id) AS last_seat_id,
        COUNT(*) AS consecutive_seats_len,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rk
    FROM T
    GROUP BY gid
)
SELECT
    first_seat_id,
    last_seat_id,
    consecutive_seats_len
FROM P
WHERE rk = 1
ORDER BY first_seat_id;
```

## 3150\. Find a Corresponding Node of a Binary Tree in a Clone of That Tree II

## 3192\. Find the Number of Subarrays with K Sum

## 3214\. Year on Year Growth Rate

```sql
WITH YEARLYSPENDS AS (
    SELECT
        YEAR(TRANSACTION_DATE) AS YEAR,
        PRODUCT_ID,
        SUM(SPEND) AS TOTAL_SPEND
    FROM
        USER_TRANSACTIONS
    GROUP BY
        YEAR(TRANSACTION_DATE),
        PRODUCT_ID
),
LAGGEDSPENDS AS (
    SELECT
        YEAR,
        PRODUCT_ID,
        TOTAL_SPEND AS CURR_YEAR_SPEND,
        LAG(TOTAL_SPEND, 1) OVER (PARTITION BY PRODUCT_ID ORDER BY YEAR) AS PREV_YEAR_SPEND
    FROM
        YEARLYSPENDS
)
SELECT
    YEAR,
    PRODUCT_ID,
    CURR_YEAR_SPEND,
    PREV_YEAR_SPEND,
    ROUND(
        CASE
            WHEN PREV_YEAR_SPEND IS NULL OR PREV_YEAR_SPEND = 0 THEN NULL
            ELSE (CURR_YEAR_SPEND - PREV_YEAR_SPEND) * 100.0 / PREV_YEAR_SPEND
        END,
        2
    ) AS YOY_RATE
FROM
    LAGGEDSPENDS
ORDER BY
    PRODUCT_ID,
    YEAR;
```
