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
 * Swap Salary
 * Customers Who Bought All Products
 * Actors and Directors Who Cooperated At Least Three Times
 * Product Sales Analysis I
 * Product Sales Analysis II
 * Product Sales Analysis III
 * Project Employees I
 * Project Employees II
 * Project Employees III
 * Sales Analysis I
 * Sales Analysis II
 * Sales Analysis III
 * Game Play Analysis V
 * Unpopular Books
 * New Users Daily Count
 * Highest Grade For Each Student
 * Reported Posts
 * Active Business
 * User Purchase Platform
 * Reported Posts II
 * User Activity for the Past 30 Days I
 * User Activity for the Past 30 Days II
 * Article Views I
 * Article Views II
 * Market Analysis I
 * Market Analysis II
 * Product Price at a Given Date
 * Immediate Food Delivery I
 * Immediate Food Delivery II
 * Reformat Department Table
 * Monthly Transactions I
 * Tournament Winners
 * Last Person to Fit in the Bus
 * Monthly Transactions II
 * Queries Quality and Percentage
 * Team Scores in Football Tournament
 * Report Contiguous Dates
 * Number of Comments per Post
 * Average Selling Price
 * Page Recommendations
 * All People Report to the Given Manager
 * Students and Examinations
 * Find the Start and End Number of Continuous Ranges
 * Weather Type In Each Country
 * Server Utilization Time
 * Consecutive Available Seats II
 * Invalid Tweets II
 * Employee Task Duration and Concurrent Tasks
 * Calculate Parking Fees and Duration
 * Second Day Verification
 * Find Top Scoring Students
 * Find Top Scoring Students II
 * Find Cities in Each State
 * Bitwise User Permissions Analysis
 * Year on Year Growth Rate
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
 * Consecutive Numbers
 * Employees Earning More Than Their Managers
 * Duplicate Emails
 * Customers Who Never Order
 * Department Highest Salary
 * Department Top Three Salaries
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
 * Friend Requests II: Who Has the Most Friends
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
 * Find Active Users
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
 * The Latest Login in 2020
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
 * Longest Winning Streak
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
 * All the Matches of the League
 * Compute the Rank as a Percentage
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
 * Find the Quiet Students in All Exams
 * NPV Queries
 * Create a Session Bar Chart
 * Evaluate Boolean Expression
 * Apples & Oranges
 * Active Users
 * Rectangles Area
 * Calculate Salaries
 * Sales by Day of the Week
 * Group Sold Products By The Date
 * Friendly Movies Streamed Last Month
 * Countries You Can Safely Invest In
 * Customer Order Frequency
 * Find Users With Valid E-Mails
 * Patients With a Condition
 * The Most Recent Three Orders
 * Fix Product Name Format
 * The Most Recent Orders for Each Product
 * Bank Account Summary
 * Unique Orders and Customers Per Month
 * Warehouse Manager
 * Customer Who Visited but Did Not Make Any Transactions
 * Bank Account Summary II
 * The Most Frequently Ordered Products for Each Customer
 * Sellers With No Sales
 * Find the Missing IDs
 * All Valid Triplets That Can Represent a Country
 * Percentage of Users Attended a Contest
