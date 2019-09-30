use employees_mod;
-- The names of the tables in the employees_mod database
show tables;

-- Exploring the attributes of the t_employees table
SELECT 
    *
FROM
    t_employees
LIMIT 10;

-- Select 
SELECT 
    emp_no, from_date, to_date
FROM
    t_dept_emp;


-- SELECT DISTINCT
SELECT DISTINCT
    emp_no, from_date, to_date
FROM
    t_dept_emp;


-- Male and female employees working in the company each year
SELECT 
    YEAR(from_date) calender_year,
    COUNT(emp_no) num_of_employees,
    gender
FROM
    t_employees
        LEFT JOIN
    t_dept_emp USING (emp_no)
WHERE
    YEAR(from_date) >= 1990
GROUP BY YEAR(from_date) , gender
ORDER BY YEAR(from_date);

--  Male manager to female manager from different departments for each starting from 1990
select * from t_dept_manager limit 10;
select * from t_departments limit 10;
select * from t_employees limit 10;


select 
	Year(from_date) calender_year, count(emp_no) no_of_manager, gender, dept_name
from t_employees emp
right join t_dept_manager using (emp_no)
left join t_departments using (dept_no)
WHERE 
	Year(from_date) >= 1990
GROUP BY calender_year,gender, dept_name
order by calender_year;


select  
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calender_year,
    CASE
		WHEN YEAR(dm.to_date) >= e.calender_year AND YEAR(dm.from_date) <= e.calender_year THEN 1
        ELSE 0
	END AS active
FROM
	(SELECT 
		YEAR(hire_date) AS calender_year
	FROM
		t_employees
	GROUP BY calender_year) e
		CROSS JOIN
	t_dept_manager dm
		JOIN
	t_departments d ON dm.dept_no = d.dept_no
		JOIN
	t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calender_year;

-- average salary of female versus male employees in the entire company until year 2002
SELECT 
	e.gender,
    d.dept_name,
    ROUND(AVG(s.salary),2) as salary,
    YEAR(s.from_date) as calender_year
FROM
	t_salaries s
		JOIN
	t_employees e ON s.emp_no = e.emp_no
		JOIN
	t_dept_emp de ON de.emp_no = e.emp_no
		JOIN
	t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no, e.gender, calender_year
HAVING calender_year <= 2002
ORDER BY d.dept_no;

-- Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range
DROP PROCEDURE IF EXISTS filter_salary;




