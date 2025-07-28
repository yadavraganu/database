# Window Functions Syntax
```sql
-- Mysql
WINDOW_FUNCTION ( [argument_expression] ) OVER (
    [PARTITION BY expression [, ...n]]
    [ORDER BY expression [ASC | DESC] [, ...n]]
    [ROWS | RANGE {UNBOUNDED PRECEDING | CURRENT ROW | N PRECEDING | N FOLLOWING | BETWEEN frame_start AND frame_end}]
)
```
## 626. Exchange Seats
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
## 627. Swap Salary
```sql
UPDATE SALARY SET SEX = CASE WHEN UPPER(SEX) = 'M' THEN 'F' ELSE 'M' END 
```
## 1045. Customers Who Bought All Products
```sql
SELECT CUSTOMER_ID FROM CUSTOMER GROUP BY CUSTOMER_ID HAVING COUNT(DISTINCT PRODUCT_KEY) = (SELECT COUNT(*) FROM PRODUCT)
```
## 1050. Actors and Directors Who Cooperated At Least Three Times
```sql
SELECT ACTOR_ID,DIRECTOR_ID FROM ACTORDIRECTOR GROUP BY ACTOR_ID,DIRECTOR_ID HAVING COUNT(*)>=3
```
## 1068. Product Sales Analysis I
```sql
SELECT PRODUCT_NAME,YEAR,PRICE FROM SALES S LEFT JOIN PRODUCT P ON S.PRODUCT_ID=P.PRODUCT_ID
```
## 1069. Product Sales Analysis II
```sql
SELECT PRODUCT_ID, SUM(QUANTITY) AS TOTAL_QUANTITY FROM SALES GROUP BY 1
```
## 1070. Product Sales Analysis III
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
## 1075. Project Employees I
```sql
SELECT PROJECT_ID,ROUND(AVG(EXPERIENCE_YEARS),2) AS AVERAGE_YEARS  FROM PROJECT P JOIN EMPLOYEE E ON P.EMPLOYEE_ID=E.EMPLOYEE_ID GROUP BY PROJECT_ID
```
## 1076. Project Employees II
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
## 1077. Project Employees III
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
## 1082. Sales Analysis I
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
## 1083. Sales Analysis II
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
## Sales Analysis III
## Game Play Analysis V
## Unpopular Books
## New Users Daily Count
## 1112. Highest Grade For Each Student
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
## Reported Posts
## Active Business
## User Purchase Platform
## Reported Posts II
## User Activity for the Past 30 Days I
## User Activity for the Past 30 Days II
## Article Views I
## Article Views II
## Market Analysis I
## Market Analysis II
```sql
```
## Product Price at a Given Date
```sql
```
## Immediate Food Delivery I
```sql
```
## Immediate Food Delivery II
```sql
```
## Reformat Department Table
```sql
```
## Monthly Transactions I
```sql
```
## Tournament Winners
```sql
```
## Last Person to Fit in the Bus
```sql
```
## Monthly Transactions II
```sql
```
## Queries Quality and Percentage
```sql
```
## Team Scores in Football Tournament
```sql
```
## Report Contiguous Dates
```sql
```
## Number of Comments per Post
```sql
```
## Average Selling Price
```sql
```
## Page Recommendations
```sql
```
## All People Report to the Given Manager
```sql
```
## Students and Examinations
```sql
```
## Find the Start and End Number of Continuous Ranges
```sql
```
## Weather Type In Each Country
```sql
```
## 1326. Server Utilization Time
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
## 3140. Consecutive Available Seats II
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
 * Invalid Tweets II
 * Employee Task Duration and Concurrent Tasks
 * Calculate Parking Fees and Duration
 * Second Day Verification
 * Find Top Scoring Students
 * Find Top Scoring Students II
 * Find Cities in Each State
 * Bitwise User Permissions Analysis
## 3214. Year on Year Growth Rate
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
 * Odd and Even Transactions
 * Customer Purchasing Behavior Analysis
 * CEO Subordinate Hierarchy
 * Premier League Table Ranking
 * Premier League Table Ranking II
 * Find Overlapping Shifts
 * Find Overlapping Shifts II
 * Find Candidates for Data Scientist Position II
 * Calculate Product Final Price
 * Find Top Performing Driver
 * Premier League Table Ranking III
 * Find Cities in Each State II
 * Second Highest Salary II
 * Books with NULL Ratings
 * First Letter Capitalization
 * First Letter Capitalization II
 * Team Dominance By Pass Success
 * Longest Team Pass Streak
 * Find Circular Gift Exchange Chains
 * Find Products with Three Consecutive Digits
 * Find Students Who Improved
 * Find Valid Emails
 * Find Invalid IP Addresses
 * Find Products with Valid Serial Numbers
 * DNA Pattern Recognition
 * Analyze Organization Hierarchy
 * Analyze Subscription Conversion
 * Find Product Recommendation Pairs
 * Find Category Recommendation Pairs
 * Seasonal Sales Analysis
 * Find Books with No Available Copies
 * Find Consistently Improving Employees
 * Find COVID Recovery Patients
 * Combine Two Tables
 * Second Highest Salary
 * Nth Highest Salary
 * Rank Scores
## 180. Consecutive Numbers
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
 * Employees Earning More Than Their Managers
 * Duplicate Emails
 * Customers Who Never Order
## 184. Department Highest Salary
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
## 185. Department Top Three Salaries
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
 * Delete Duplicate Emails
 * Rising Temperature
 * Trips and Users
 * Game Play Analysis I
 * Game Play Analysis II
 * Game Play Analysis III
 * Game Play Analysis IV
 * Median Employee Salary
 * Managers with at Least 5 Direct Reports
 * Find Median Given Frequency of Numbers
 * Winning Candidate
 * Employee Bonus
 * Get Highest Answer Rate Question
 * Find Cumulative Salary of an Employee
 * Count Student Number in Departments
 * Find Customer Referee
 * Investments in 2016
 * Customer Placing the Largest Number of Orders
 * Big Countries
 * Classes With at Least 5 Students
 * Friend Requests I: Overall Acceptance Rate
 * Human Traffic of Stadium
## 602. Friend Requests II: Who Has the Most Friends
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
 * Consecutive Available Seats
 * Sales Person
 * Tree Node
 * Triangle Judgment
 * Shortest Distance in a Line
 * Shortest Distance in a Plane
 * Second Degree Follower
 * Average Salary: Departments VS Company
 * Students Report By Geography
 * Biggest Single Number
 * Not Boring Movies
 * Count Artist Occurrences On Spotify Ranking List
 * Immediate Food Delivery III
 * Bikes Last Time Used
## 1454. Active Users
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
 * Consecutive Transactions With Increasing Amounts
 * Popularity Percentage
 * Count Occurrences in Text
 * Customers With Maximum Number of Transactions on Consecutive Days
 * Flight Occupancy and Waitlist Analysis
 * Status of Flight Tickets
 * Election Results
 * Total Traveled Distance
 * Highest Salaries Difference
## 2854. Rolling Average Steps
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
 * Calculate Orders Within Each Interval
 * Market Analysis III
 * Symmetric Coordinates
 * Find Peak Calling Hours for Each City
 * Calculate Compressed Mean
 * Find Third Transaction
 * Find Expensive Cities
 * Manager of the Largest Department
 * Class Performance
 * Loan Types
 * Top Three Wineries
 * Friday Purchases I
 * Friday Purchases II
 * Viewers Turned Streamers
 * Pizza Toppings Cost Analysis
 * Find Candidates for Data Scientist Position
 * Maximize Items
 * Classifying Triangles by Lengths
 * Binary Tree Nodes
 * Top Percentile Fraud
 * Snaps Analysis
 * Employees Project Allocation
 * Friends With No Mutual Friends
 * Find All Unique Email Domains
 * User Activities within Time Bounds
 * Calculate Trapping Rain Water
 * Find Trending Hashtag
 * Find Bursty Behavior
 * Find Trending Hashtags II
 * Friday Purchase III
 * Find Longest Calls
 * Hopper Company Queries I
 * Hopper Company Queries II
 * Hopper Company Queries III
 * Average Time of Process per Machine
 * Fix Names in a Table
 * Product's Worth Over Invoices
 * Invalid Tweets
 * Daily Leads and Partners
 * Number of Calls Between Two Persons
 * Biggest Window Between Visits
 * Count Apples and Oranges
 * Find Followers Count
 * The Number of Employees Which Report to Each Employee
 * Find Total Time Spent By Each Employee
 * Leetflex Banned Accounts
 * Recyclable and Low Fat Products
 * Find the Subtasks That Did Not Execute
 * Product's Price for Each Store
 * Grand Slam Titles
 * Primary Department for Each Employee
 * Rearrange Products Table
 * Ad-Free Sessions
 * Find Interview Candidates
 * Find Customers with Positive Revenue this Year
 * Maximum Transaction Each Day
 * League Statistics
 * Suspicious Bank Accounts
 * Convert Date Format
 * Orders With Maximum Quantity Above Average
 * Calculate Special Bonus
 * Group Employees of the Same Salary
## 1890. The Latest Login in 2020
```sql
SELECT USER_ID,MAX(TIME_STAMP) AS LAST_STAMP FROM LOGINS WHERE YEAR(TIME_STAMP)=2020 GROUP BY USER_ID
```
 * Page Recommendations II
 * Count Salary Categories
 * Leetcodify Friends Recommendations
 * Leetcodify Similar Friends
 * Confirmation Rate
 * Users That Actively Request Confirmation Messages
 * Strong Friendship
 * All the Pairs With the Maximum Number of Common Followers
 * Employees With Missing Information
 * First and Last Call On the Same Day
 * Employees Whose Manager Left the Company
 * Find Cutoff Score for Each School
 * Find Drivers with Improved Fuel Efficiency
 * Find Overbooked Employees
 * Count Number of Experiments
 * The Number of Seniors and Juniors to Join the Company
 * The Number of Seniors and Juniors to Join the Company II
 * Number of Accounts That Did Not Stream
 * Low-Quality Problems
 * Accepted Candidates From the Interviews
 * The Category of Each Member in the Store
 * Account Balance
 * The Winner University
 * The Number of Rich Customers
 * Drop Type 1 Orders for Customers With Type 0 Orders
 * The Airport With the Most Traffic
 * Build the Equation
 * The Number of Passengers In Each Bus I
 * The Number of Passengers In Each Bus II
 * Order Two Columns Independently
## 2173. Longest Winning Streak
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
 * The Change In Global Rankings
 * Finding the Topic of Each Post
 * The Number of Users That Are Eligible For Discount
 * Users With Two Purchases Within Seven Days
 * The Users That Are Eligible for Discount
 * Number of Times a Driver Was a Passenger
 * Dynamic Pivoting of a Table
 * Dynamic Unpivoting of a Table
 * Products With Three or More Orders in Two Consecutive Years
 * Tasks Count in the Weekend
 * Arrange Table By Gender
 * The First Day of the Maximum Recorded Degree in Each City
 * Product Sales Analysis IV
 * Product Sales Analysis V
## 2339. All the Matches of the League
```sql
SELECT
    T1.TEAM_NAME AS HOME_TEAM,
    T2.TEAM_NAME AS AWAY_TEAM
FROM
    TEAMS AS T1
JOIN
    TEAMS AS T2 ON T1.TEAM_NAME != T2.TEAM_NAME;
```
## 2346. Compute the Rank as a Percentage
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
 * Number of Unique Subjects Taught By Each Teacher
 * Generate the Invoice
 * Calculate the Influence of Each Salesperson
 * Sort the Olympic Table
 * Change Null Values in a Table to the Previous Value
 * Employees With Deductions
 * Customers With Strictly Increasing Purchases
 * Form a Chemical Bond
 * Merge Overlapping Events In the Same Hall
 * Concatenate the Name and the Profession
 * Find Latest Salaries
 * Find the Team Size
 * Running Total for Different Genders
 * Restaurant Growth
 * Ads Performance
 * List the Products Ordered in a Period
 * Movie Rating
 * Students With Invalid Departments
 * Activity Participants
 * Number of Trusted Contacts of A Customer
 * Get the Second Most Recent Activity
 * Replace Employee ID With The Unique Identifier
 * Total Sales Amount By Year
 * Capital Gain/Loss
 * Customers Who Bought Products A and B But Not C
 * Top Travellers
## 1412. Find the Quiet Students in All Exams
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
 * NPV Queries
 * Create a Session Bar Chart
 * Evaluate Boolean Expression
 * Apples & Oranges
## 2688. Find Active Users
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
 * Rectangles Area
## 1468. Calculate Salaries
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
 * Sales by Day of the Week
 * Group Sold Products By The Date
 * Friendly Movies Streamed Last Month
 * Countries You Can Safely Invest In
 * Customer Order Frequency
 * Find Users With Valid E-Mails
 * Patients With a Condition
 * The Most Recent Three Orders
## 1543. Fix Product Name Format
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
 * The Most Recent Orders for Each Product
 * Bank Account Summary
 * Unique Orders and Customers Per Month
 * Warehouse Manager
 * Customer Who Visited but Did Not Make Any Transactions
 * Bank Account Summary II
## 1596. The Most Frequently Ordered Products for Each Customer
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
 * Sellers With No Sales
## 1613. Find the Missing IDs
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
## 1623. All Valid Triplets That Can Represent a Country
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
## 1633. Percentage of Users Attended a Contest
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
