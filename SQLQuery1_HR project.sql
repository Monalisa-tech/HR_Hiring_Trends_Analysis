create database hr_recuirementdb
use hr_recuirementdb

create table hr_rect
(position Varchar(max),full_name Varchar(max),Gender Varchar(max),Salary Varchar(max),Department Varchar(max),DepartmentName Varchar(max),
Division Varchar(max),AssignmentCategory Varchar(max),Title Varchar(max),HiringAnalyst Varchar(max),VacancyStatus Varchar(max),
VacancyDate Varchar(max),BudgetDate Varchar(max),PostingDate Varchar(max),InterviewDate Varchar(max),OfferDate Varchar(max),
AcceptanceDate Varchar(max),SecurityCheckDate Varchar(max),HireDate Varchar(max))

select* from hr_rect

bulk insert hr_rect
from 'C:\Users\USER\Desktop\Hr_recruitement.csv'
with (fieldterminator=',',Rowterminator='\n',Firstrow=2,maxerrors=20);

----Error checking and validation----

Select case when isdate(VacancyDate)=0 then 'Date is not valid'
            when isdate(BudgetDate)=0 then 'Date is not valid'
			when isdate(PostingDate)=0 then 'Date is not valid'
			when isdate(InterviewDate)=0 then 'Date is not valid'
			when isdate(OfferDate)=0 then 'Date is not valid'
			when isdate(AcceptanceDate)=0 then 'Date is not valid'
			when isdate(SecurityCheckDate)=0 then 'Date is not valid'
			when isdate(HireDate)=0 then 'Date is not valid'
			else 'Date is valid' End as Date_inspection
			from hr_rect 


			------Data restoring by Alter table one by one----

	alter table hr_rect
	alter column VacancyDate date

	alter table hr_rect
	alter column BudgetDate  date

	alter table hr_rect
	alter column PostingDate date

	alter table hr_rect
	alter column InterviewDate date

	alter table hr_rect
	alter column OfferDate date

	alter table hr_rect
	alter column AcceptanceDate date

	alter table hr_rect
	alter column SecurityCheckDate date

	alter table hr_rect
	alter column HireDate date

	alter table hr_rect
	alter column salary money

select* from hr_rect
where ISNUMERIC(salary)=0


-----Data Cleaning assuming n ---

select salary,REPLACE(salary,substring(salary,patindex('%[^0-9]%',salary),1),''),
substring(salary,patindex('%[^0-9]%',salary),1),patindex('%[^0-9]%',salary) from hr_rect
where ISNUMERIC(salary)=0

Update hr_rect set salary=REPLACE(salary,substring(salary,patindex('%[!--@#$%Z^&*()_+]%',salary),1),'')
where ISNUMERIC(salary)=0

----check the data patterns:How the vacancies distributed by the gensers----

select Gender as 'Gend_distribution',department,count(position) as 'vacancies_distributed' from hr_rect
group by Gender,Department
order by Gender

select Department,
        isnull([M],0) as 'Male_Vacancy',
		isnull([F],0) as 'FeMale_Vacancy'

	from	(select  department,gender,count(position) as 'vacancies'
		from hr_rect
		group by gender,department)
		AS base_table
Pivot 
   (sum (vacancies) for gender in ([M],[F]))
   AS Pivot_table


   select department,(case when Gender='F' then Gender else ''end) as Female_dist,
   (case when Gender='M' then Gender else ''end) as Male_dist,count(position) as 'vacancies' from hr_rect
   group by department,gender

   ----------

   select department,count(position) as 'Total_available_pos',sum(case when vacancystatus='filled' then 1 else 0 end) as 'filled_Position',
   sum(case when vacancystatus='vacant' then 1 else 0 end) as 'Vacant_Position' from hr_rect
    group by department
	order by filled_Position desc

	-----Let check hiring duration in our data(years and months)----

	select concat(datediff(month,min(VacancyDate),max(VacancyDate))/12,'Years',' ',datediff(month,min(VacancyDate),max(VacancyDate))%12,' ', 'Month/s') 
	as total_hiring_duration from hr_rect 


	select min(VacancyDate) as 'firstvacancydate',max(VacancyDate) as 'lastvacancydaterecrd' from hr_rect

------	The Hr_department to analyse the last 5 years recuriment summery-----

select hiredate,DATEADD(year,-5,hiredate) from hr_rect  /* 2010-01-30*/

select departmentname,gender,coalesce(avg(case when hiredate>=dateadd(year,-1,max_date) then salary end),0) as 'avg_salrecentlyhired',
coalesce(avg(case when hiredate<dateadd(year,-5,max_date) then salary end),0) as 'hired5yersback' 
from (select departmentname,hiredate,gender,salary,vacancystatus,(select max(hiredate) from hr_rect) as Max_date from hr_rect) hr_rcd
group by departmentname,gender 

----Genderwise paygap analysis---

with gender_avg_sal AS (select gender ,avg(salary) as avg_sal 
from hr_rect 
group by gender)

select gvs.gender as genM,gvs1.gender as genf,
gvs.Avg_sal-gvs1.Avg_sal as sal_gap
from
gender_avg_sal gvs
cross join gender_avg_sal gvs1
where gvs.gender='M' and gvs1.gender='f'

select 74228.7267-69700.592   /* pay gap value=4528.1347*/

----The Organisation wants to analyse the avg_time for hiring----

with hiredays as(select department,full_name,datediff(day,postingdate,hiredate) as 'daystoHire' from hr_rect)
select department,avg(daystoHire) as 'avg_daytohire' from hiredays
group by department 

-----Department wise salary analyse----
select departmentname,
  min(salary) as minsal,
  avg(salary) as meansal,
  max(salary) as maxsal

from hr_rect
group by departmentname

-----The organisations wants to analyse the whole requirement pipeline----

select* from hr_rect

with rect_pipeline as (select full_name,
                      datediff(day,vacancydate,budgetdate) as 'vacancytobudget',
					  datediff(day,budgetdate,postingdate) as 'budgettoposting',
					  datediff(day,postingdate,interviewdate) as 'postingtointerview',
					  datediff(day,interviewdate,offerdate) as 'interviewtooffer',
					  datediff(day,offerdate,acceptancedate) as 'offertoacceptance',
					  datediff(day,acceptancedate,securitycheckdate) as 'acceptancetosecurity',
					  datediff(day,securitycheckdate,hiredate) as 'securitytohire' from hr_rect)
	
	select full_name, avg(vacancytobudget) as 'avg_vacancytobudget',
	                  avg( budgettoposting)as 'avg_budgettoposting',
	                  avg(postingtointerview) as 'avg_postingtointerview',
					  avg(interviewtooffer) as 'avg_interviewtooffer',
	                  avg(offertoacceptance) as 'avg_offertoacceptance',
					  avg(acceptancetosecurity) as 'avg_acceptancetosecurity',
					  avg(securitytohire) as 'avg_securitytohire' from rect_pipeline where full_name is not null group by full_name

-----Department wise recuirement efficiency  (title wise their first released)---

select distinct title from hr_rect

----1.Department wise recuirement efficiency analysis----
with rect_days as (select departmentname,datediff(day,vacancydate,hiredate) as 'Hire_days' from hr_rect)
select departmentname,avg(hire_days) as avg_time_taken
from rect_days
group by departmentname 

----2.Title wise their 1st vacancy released----
select title,min(postingdate) as 'firstreleasedate',
year(min(postingdate)) as 'the_year',datename(month,min(postingdate)) as 'releasedmonth',datename(weekday,min(postingdate))as 'the_day' from hr_rect
group by title 


---To analyse the time taken by the vacancy to release the offer----
 with vacancy_to_offer as(select departmentname,title,Datediff(day,vacancydate,offerdate) as 'Days_to_offer'
 from hr_rect)

 select departmentname,title,
 min(days_to_offer) as 'min_time',
 avg(days_to_offer) as 'avg_time',
 max(days_to_offer) as 'max_time' from vacancy_to_offer
 group by departmentname,title
 order by departmentname

 ----the organisation wants analyse the efficency of hiring analyst-----

 with Analyst_analyses as (select Hiringanalyst,datediff(day,postingdate,hiredate) as 'Dayshire' from hr_rect)
 select Hiringanalyst,avg(dayshire) as 'avg_time',min(dayshire) as 'min_time',max(dayshire) as 'max_time',
 count(*) as 'total_hiring' from Analyst_analyses 
 group by HiringAnalyst
 order by total_hiring desc 

 -----Trend analysis over time for recruitment process (seasonality,fixed time)-----
 select year(Hiredate) as 'the_yearofhire',
 datename(quarter,hiredate) as 'The_hired_qtr',
 month(Hiredate) as 'The_month_of_hire',
 count(*) as 'Total_hiring'
 from hr_rect
 where vacancystatus='Filled'
 group by year(hiredate),datename(quarter,hiredate),month(hiredate)
 order by the_yearofHire

 select year(Hiredate) as 'the_yearofhire',
 datename(quarter,hiredate) as 'The_hired_qtr',
 count(*) as 'Total_hiring'
 from hr_rect
 where vacancystatus='Filled'
 group by year(hiredate),datename(quarter,hiredate)
 order by the_yearofHire

 select department,year(Hiredate) as 'the_year',
 datename(quarter,hiredate) as 'The_hired_qtr',
 datename(month,Hiredate) as 'The_month_of_hire',
 count(*) as 'Total_hiring'
 from hr_rect
 where vacancystatus='Filled'
 group by department,year(hiredate),datename(quarter,hiredate),datename(month,hiredate)
 order by the_year
 -----outcome:Every hiring happened during 1st quarter of each year-----

 select postingdate,datename(month,postingdate) from hr_rect


 with hiringtrend as(select department,year(Hiredate) as 'the_year',
 datename(quarter,hiredate) as 'The_hired_qtr',
 datename(month,Hiredate) as 'The_month_of_hire',
 count(*) as 'Total_hiring'
 from hr_rect
 where vacancystatus='Filled'
 group by department,year(hiredate),datename(quarter,hiredate),datename(month,hiredate))
 
 select the_year, Total_hiring,case when the_year between 1954 and 1964 then '1954-1964'
             when the_year between 1965 and 1975 then '1965-1975'
			 when the_year between 1976 and 1986 then '1976-1986'
			 when the_year between 1987 and 1997 then '1987-1997'
			 when the_year between 1998 and 2008  then '1998-2008'
			 else '2009-2019' end as the_yearsegment
			 from hiringtrend
			 
----Check any muliple offers released------

select position,count(full_name) from hr_rect
where AcceptanceDate is not null
group by position
having count(full_name)>1        /* no candidate have multiple offers*/


-----Calculate the avg time to fulfill the post by the  hiring analyst and also their acceptance rate----

select hiringanalyst,title,avg(datediff(day,postingdate,hiredate)) as avg_time_taken, count(position) as total_vacancies,
cast(sum(case when HireDate is not null then 1 else 0 end) as float) /count(*)*100 as acceptancerate from hr_rect
group by hiringanalyst,title
order by acceptancerate desc

-----if we consider the budget time is that time which is alloted to full fill the position---
---the organisation wants to analyse that on which department is exceeded the budget time limit----

select position,department,datediff(DAY,vacancydate,hiredate) as 'time_to_fill'
,datediff(day,vacancydate,budgetdate) as 'budgetedtimetofill'
from hr_rect
where datediff(DAY,vacancydate,hiredate)>datediff(day,vacancydate,budgetdate) 
order by budgetedtimetofill desc
/*filled position is 8998*/
 ---lets find the min time to fullfill and max time to fullfill as per the position---

 select top 1 position,datediff(DAY,vacancydate,hiredate) as 'timetofill' from hr_rect
 where HireDate is not null
 order by timetofill desc 
 
 select top 1 position,datediff(DAY,vacancydate,hiredate) as 'timetofill' from hr_rect
 where HireDate is not null
 order by timetofill 

 with timetofillcte as(select position,datediff(DAY,vacancydate,hiredate) as timetofill from hr_rect)
 select position,timetofill
 from timetofillcte
 where timetofill=(select max(timetofill) from timetofillcte)
 union all
 select position,timetofill from timetofillcte
 where timetofill=(select min(timetofill) from timetofillcte)


 ---Attrition report by dept with  their avgsalary---

 select departmentname,avg(salary) as 'avg_sal',count(*) as 'total_position',
 sum(case when vacancystatus='vacant' then 1 else 0 end) as 'vacant_pos',
 round(cast(sum(case when vacancystatus='vacant' then 1 else 0 end) as float)/count(*),2) as 'Attrition_rate' from hr_rect 
 group by departmentname
 having round(cast(sum(case when vacancystatus='vacant' then 1 else 0 end) as float)/count(*),2)>0.0
 order by Attrition_rate desc

 -----emp get salary>avg sal----
 select department,avg(salary) as 'avg_sal' from hr_rect
 group by Department

 select*from hr_rect
 where department='HHS' and salary>73891.8314

 select h.departmentname,avg_sal,count(position) as 'total_hire',
 round(count(case when h.salary> av.avg_sal then 1 end)*100.0,2)/count(*) as 'percmore>avg_sal' from hr_rect h
 join avg_salarybydept av
 on h.departmentname=av.departmentname
 group by h.departmentname,av.avg_sal
 order by avg_sal desc 
 
