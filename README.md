# HR_Hiring_Trends_Analysis
Data-driven project that explores hiring patterns, recruitment trends, and workforce analytics.
Description:
This project analyzes HR recruitment trends, hiring efficiency, and workforce planning using SQL for data processing and Power BI for visualization. The dataset includes job positions, hiring status, salary provisions, analyst performance, and hiring trends over the past five years. The objective is to provide data-driven insights to optimize hiring strategies, reduce time-to-hire, and improve workforce management.

Data Sources & Processing steps:
1.SQL Database & Table Creation
2.Data Ingestion & Cleaning
3.Data Transformation & Querying in SQL

Data Processing & SQL Operations:
📌 Database Structure (hr_recuirementdb)
Table: hr_rect – Contains key HR data fields such as:
Position, Full_Name, Gender, Salary, Department, HiringAnalyst, VacancyStatus, VacancyDate, OfferDate, HireDate
Data Source: Recruitment data loaded from Hr_recruitement.csv

📌 SQL Queries & Data Transformations
✔️ Vacancy Status Check – Tracks long-standing open positions.
✔️ Hiring Efficiency Calculation – Measures hiring speed & analyst performance.
✔️ Salary & Budget Benchmarking – Compares department-wise salary distribution.
✔️ Trend Analysis Queries – Extracts insights for multi-year hiring trends.

Key Insights from Power BI Dashboards
1️⃣ HR Hiring KPIs & Efficiency Metrics
Total Positions (Vacant vs. Filled) – Overview of all job positions and their current status.
Avg. Time to Fill a Position – Measures the average duration from vacancy posting to candidate hiring.
Acceptance Rate by Candidates – Analyzes offer acceptance trends.
2️⃣ Department-Wise Hiring Trends
Top Hiring Departments – Identifies which departments have the highest recruitment activity.
Salary Provision by Department – Compares salary allocations across different teams.
New Employee Salary Trends – Examines salary benchmarks for new hires.
3️⃣ Hiring Analyst Performance Analysis
Hiring Efficiency by Analyst – Ranks analysts based on successful hires.
Multiple Offer Releases – Tracks instances where multiple offers were released for a position.
4️⃣ Multi-Year Hiring Trends (1-5 Years)
Hiring Volume Over Time – Tracks recruitment patterns over multiple years.
Time Taken from Vacancy to Offer Release – Evaluates the time required to finalize candidates.
Seasonal & Fixed-Time Trends – Identifies hiring peaks in different periods.
5️⃣ Workforce Planning & Attrition Analysis
Attrition Report by Department – Assesses employee turnover trends.
Avg. Salary Analysis – Compares salaries across different roles and experience levels.
Budget Time Analysis – Evaluates budget allocation vs. actual hiring costs.

 Project Outcomes & Business Impact:
 
✅ Hiring Efficiency – Tracks recruitment speed, analyst performance, and hiring trends.
✅ Salary Insights – Analyzes pay gaps and salary provisions across departments.
✅ Recruitment Bottlenecks – Identifies roles with long hiring durations.
✅ Workforce Planning – Helps HR teams optimize hiring strategies based on real data.
✅ Seasonal Trends – Recognizes peak hiring months for better planning.


This project is developed using the following tools and technologies:
✅ Database & Querying:
MS SQL Server – For storing and querying recruitment data
Azure SQL & Google Cloud SQL – Cloud-based database management
SQL Queries – Data extraction, transformation, and trend analysis
✅ Data Visualization & Reporting:
Power BI – Interactive dashboards & recruitment trend analysis
DAX (Data Analysis Expressions) – For creating calculated metrics & KPIs
✅ Data Processing & Storage:
Excel/CSV Files – Recruitment data storage & pre-processing
ETL Process – Data extraction, cleaning, and transformation
✅ Development & Version Control:
Git & GitHub – Project versioning and collaboration
This stack enables efficient data processing, analysis, and visualization to provide actionable insights for HR decision-making. 
