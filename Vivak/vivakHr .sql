# TASK 2. Created schema VivaKHR
CREATE SCHEMA IF NOT EXISTS VivaKHR;
# Used VivaKHR
USE VivaKHR;
# When I created the structure I decided to add a column to store the id from the files provided by the client
# just in case in the future they provide me more files, so I can match THE actual schema with the client's schema

# Created table regions
CREATE TABLE regions (
	region_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
	region_name VARCHAR (40) UNIQUE NOT NULL
);

# Created table countries
CREATE TABLE countries (
	country_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    country_code CHAR(2) UNIQUE NOT NULL, # added this column to store the id from the files provided by the client
	country_name VARCHAR (40) UNIQUE NOT NULL,
	region_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
    CONSTRAINT country_region_fk FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

# Created table locations
CREATE TABLE locations (
	location_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    location_code CHAR(4) UNIQUE NOT NULL, # added this column to store the id from the files provided by the client
	street_address VARCHAR (40) NOT NULL,
	postal_code VARCHAR (12) DEFAULT NULL,
	city VARCHAR (40) NOT NULL,
	state_province VARCHAR (40) DEFAULT NULL,
	country_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
    CONSTRAINT location_country_fk FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

# Created table departments
CREATE TABLE departments (
	department_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    department_name VARCHAR (40) UNIQUE NOT NULL
);

# Created table organization_structure
CREATE TABLE organization_structure (
	job_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    job_title VARCHAR(40) UNIQUE NOT NULL,
    min_salary DOUBLE(7,2) NOT NULL, # task 2.1 salary-related column must be double with 2 decimals
    max_salary DOUBLE(7,2) NOT NULL, # task 2.1 salary-related column must be double with 2 decimals
    reports_to INT DEFAULT NULL, # task 2.2 id column or foreign key must be integer
    department_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
    CONSTRAINT org_fk FOREIGN KEY (reports_to) REFERENCES organization_structure(job_id),
    CONSTRAINT org_department_fk FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

# Created table employees
CREATE TABLE employees (
	employee_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    employee_code INT DEFAULT NULL, # added this column to store the id from the files provided by the client
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(40) UNIQUE NOT NULL,
    phone_number VARCHAR(20) DEFAULT NULL,
	salary DOUBLE(7,2) NOT NULL, # task 2.1 salary-related column must be double with 2 decimals
    hire_date DATE DEFAULT (CURRENT_DATE()), # task 2.4 date column must be date
    job_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
    location_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
    report_to INT DEFAULT NULL, # task 2.3 must contain this column to record the id of the employee's manager
	experience_at_VivaK TINYINT DEFAULT NULL, # task 2.5 must contain this column to include number of months each employee worked
    last_performance_rating TINYINT DEFAULT NULL, # task 2.6 must contain this column to include performance rating (0-10) of each employee
    salary_after_increment DOUBLE(7,2) DEFAULT NULL, # task 2.7 must contain this column to include the salary anticipated
    annual_dependent_benefit DOUBLE(7,2) DEFAULT NULL, #task 2.8 must contain this column to include the dependent bonus each employee receives per dependent
    CONSTRAINT employee_job_fk FOREIGN KEY (job_id) REFERENCES organization_structure(job_id),
	CONSTRAINT employee_location_fk FOREIGN KEY (location_id) REFERENCES locations(location_id),
    CONSTRAINT employee_fk FOREIGN KEY (report_to) REFERENCES employees(employee_id)
);

# Created table dependents
CREATE TABLE dependents (
	dependent_id INT AUTO_INCREMENT PRIMARY KEY, # task 2.2 id column or foreign key must be integer
    dependent_code INT DEFAULT NULL, # added this column to store the id from the files provided by the client
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    relationship SET('Child','Spouse') NOT NULL,
    employee_id INT NOT NULL, # task 2.2 id column or foreign key must be integer
	CONSTRAINT dependent_employee_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

# TASK 3. Import and clean the data
# Dumping data for table regions using script provided by the client
INSERT INTO regions(region_id,region_name) 
VALUES (1,'Europe'), (2,'Americas'), (3,'Asia'), (4,'Middle East and Africa');
# Task 3.1 checking duplicates of regions
SELECT region_name, COUNT(region_name)
FROM regions
GROUP BY region_name
HAVING COUNT(region_name) > 1;
select *
from employees;
# Dumping data for table countries using script provided by the client
INSERT INTO countries(country_id,country_code,country_name,region_id) 
VALUES (101,'AR','Argentina',2), (102,'AU','Australia',3), (103,'BE','Belgium',1),
(104,'BR','Brazil',2), (105,'CA','Canada',2), (106,'CH','Switzerland',1),
(107,'CN','China',3), (108,'DE','Germany',1), (109,'DK','Denmark',1), 
(110,'EG','Egypt',4), (111,'FR','France',1), (112,'HK','HongKong',3), 
(113,'IL','Israel',4), (114,'IN','India',3), (115,'IT','Italy',1),
(116,'JP','Japan',3), (117,'KW','Kuwait',4), (118,'MX','Mexico',2),
(119,'NG','Nigeria',4), (120,'NL','Netherlands',1), (121,'SG','Singapore',3),
(122,'UK','United Kingdom',1), (123,'US','United States of America',2), (124,'ZM','Zambia',4),
(125,'ZW','ZimbabI',4);
# task 3.1 checking duplicates of countries
SELECT country_code, COUNT(country_code), country_name, COUNT(country_name)
FROM countries
GROUP BY country_code, country_name
HAVING (COUNT(country_code) > 1) 
AND (COUNT(country_name) > 1) ;

# Dumping data for table locations using script provided by the client
INSERT INTO locations(location_id,location_code,street_address,postal_code,city,state_province,country_id) 
VALUES (1,1400,'2014 Jabberwocky Rd','26192','Southlake','Texas',123),
(2,1500,'2011 Interiors Blvd','99236','South San Francisco','California',123),
(3,1700,'2004 Charade Rd','98199','Seattle','Washington',123),
(4,1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario',105),
(5,2400,'8204 Arthur St',NULL,'London',NULL,122),
(6,2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford',122),
(7,2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria',108);
# task 3.1 checking duplicates of locations
SELECT location_code, COUNT(location_code), street_address, COUNT(street_address),
postal_code, COUNT(postal_code), city, COUNT(city), state_province, COUNT(state_province)
FROM locations
GROUP BY location_code, street_address, postal_code, city, state_province
HAVING (COUNT(location_code) > 1) 
AND (COUNT(street_address) > 1) 
AND (COUNT(postal_code) > 1) 
AND (COUNT(city) > 1) 
AND (COUNT(state_province) > 1) ;

# Dumping data for table departments using file provided by the client
INSERT INTO departments(department_id,department_name) 
VALUES (1,'Administration'), (2,'Marketing'), (3,'Purchasing'),
(4,'Human ResTHEces'), (5,'Shipping'), (6,'IT'),
(7,'Public Relations'), (8,'Sales'), (9,'Executive'),
(10,'Finance'), (11,'Accounting');
# task 3.1 checking duplicates of departments
SELECT department_name, COUNT(department_name)
FROM departments
GROUP BY department_name
HAVING COUNT(department_name) > 1;

# Dumping data for table organization_structure
# I converted the file provided by the client to .csv format
# I imported it to THE schema in a table called 'org_structure_csv' (it will be deleted after finishing task 3)
# total observations imported 24
# inserted data into organization_structure using the table org_structure_csv except for the column reports_to
INSERT INTO organization_structure(job_id,job_title,min_salary,max_salary,reports_to,department_id) 
SELECT o.job_id, o.job_title, o.min_salary, o.max_salary, null, d.department_id
FROM organization_structure o
join departments d using (department_name);
# updated column reports_to except for the first observation because it doesn't report to anyone
UPDATE organization_structure o
JOIN org_structure_csv c using (job_id)
SET o.reports_to = c.reports_to
WHERE o.job_id > 1;
# task 3.1 checking duplicates of organization_structure
SELECT job_title, COUNT(job_title)
FROM organization_structure
GROUP BY job_title
HAVING (COUNT(job_title) > 1);

# Dumping data for table employees
# I imported a JSON file provided by the client
# I imported it to THE schema in a table called 'employees_json' (it will be deleted after finishing task 3)
# total observations imported 2040
# I decided to clean it before inserting data into THE schema
# task 3.1 checking duplicates of employees_json
select count(distinct employee_id) from employees_json;
select count(distinct email) from employees_json;
select count(dimstinct phone_number) from employees_json;
# found 6 duplicated phone numbers
select phone_number from employees_json group by phone_number having count(*)>1;
# concluded that 6 employees has missing values in phone_number
select * from employees_json where phone_number is null or phone_number = '';
# I decided to keep the missing values in phone_number because I assumed is optional and email is mandatory

# task 3.2a formatting data
# validating floating point data as double in salary
select count(*) from employees_json where cast(salary as unsigned) <> salary;
# concluded that salary doesn't have any floating point value

# task 3.2b formatting data
# validating phone number format +000-000-000-0000
# added new column to store the phone number with the correct format
alter table employees_json add column phone_number_fix varchar(20);
# I imported a schema called 'hr' from a script provided by the client (it will be deleted after finishing task 3)
# total tables imported 3
# added new column to store the department_id (to join table employees_json)
alter table hr.locations add column department_id int;
# updated department_id according to the number of row
set @rownum=0;
update hr.locations set department_id = (@rownum:=1 + @rownum);
# updated phone_number_fix column
update vivakhr.employees_json e 
join hr.locations l using (department_id)
set e.phone_number_fix = concat(
		case when l.country_id in ('US','CA') then '+1'
		when l.country_id = 'UK' then '+44' 
		else '+45' end, '-', replace(e.phone_number,'.','-')
        )
where e.phone_number is not null and e.phone_number != '';

# task 3.2c formatting data
# validating date format yyyy-mm-dd
# added new column to store the date with the correct format
alter table employees_json add column hire_date_fix date;
# updated hire_date_fix column
update employees_json e 
join employees_json e2 using(employee_id)
set e.hire_date_fix = date_format(date(e2.hire_date),'%Y-%m-%d');

# task 3.3b treating missing values
# validating missing values by job_id, salary, manager_id, department_id and hire_date
select count(*) from employees_json where job_id is null or job_id = '';
select count(*) from employees_json where salary is null or salary = '';
select count(*) from employees_json where manager_id is null or manager_id = '';
select count(*) from employees_json where department_id is null or department_id = '';
select count(*) from employees_json where hire_date is null or hire_date = '';
# found 193 employees with missing values in salary
select * from employees_json where salary is null or salary = '';
# I decided to fill the missing values in salary according to the min_salary associated to the job of the employees
# I assumed that if an employee got paid more salary he won't notify the company
# but if he got paid less he will notify the company so it will be easier to fix
# updated employees with missing values in salary
update employees_json e
join orgstructure_csv o using(job_id)
set e.salary = o.min_salary
where e.salary is null or e.salary = '';

# task 3.3a treating missing values
# found that all rows has missing values in manager_id
# I decided to use manager_id column of table employees_json to fill report_to column of table employees
# I found that only 1 employee has the job title of president and doesn't have to report to anyone
select e.job_id,count(*)
from employees_json e
join orgstructure_csv o using(job_id)
group by e.job_id;
# I updated all the employees that report to the president
update employees_json e
join orgstructure_csv o using(job_id)
set e.manager_id = 100
where e.job_id <> 1
and o.reports_to = 1;
# created temporary table to store employee_id and manager_id
create temporary table temp 
select e.employee_id,
(select employee_id from employees_json where job_id=o.Reports_to and department_id=e.department_id) manager_id
from employees_json e
join orgstructure_csv o using(job_id)
where e.job_id <> 1;
# update manager_id column
update employees_json e
join temp t using(employee_id)
join orgstructure_csv o using(job_id)
set e.manager_id = t.manager_id
where e.job_id <> 1
and o.reports_to > 1;

# inserted data into table employees
insert into employees (employee_code,first_name,last_name,email,phone_number,salary,hire_date,job_id,location_id,report_to)
select employee_id,first_name,last_name,email,phone_number_fix,salary,hire_date_fix,job_id,department_id,manager_id
from employees_json;

# Dumping data for table dependents
# I imported a csv file provided by the client
# I imported it to THE schema in a table called 'dependents_csv' (it will be deleted after finishing task 3)
# total observations imported 1790
# I decided to clean it before inserting data into THE schema
# task 3.1 checking duplicates of dependents_csv
# I found there is not dependent duplicated by name
select first_name, last_name from dependents_csv group by first_name, last_name having count(*)>1;
# I found dependent_id is duplicated
select dependent_id, employee_id from dependents_csv group by dependent_id, employee_id having count(*)>1;
# it will be stored in a column called 'dependent_code' because in THE schema the column dependent_id will be unique

# task 3.3 treating missing values
# validating missing values
select * 
from dependents_csv
where dependent_id is null or employee_id is null
or first_name is null or first_name = ''
or last_name is null or last_name = ''
or relationship is null or relationship = '';
# I didn't find any missing values

# added new column to store the employee_id of THE schema
alter table dependents_csv add column employee_id_fix int;
# updated employee_id_fix column
update dependents_csv d
join employees e on e.employee_code = d.employee_id
set employee_id_fix = e.employee_id;
# I found 79 dependents don't have any employee associated
select * from dependents_csv d where d.employee_id_fix is null;
# there isn't any employee with a code less than 100 in THE schema
# I assumed this 79 observations are with an old id or they are simply wrong
# I decided not to include this 79 observations in THE schema

# inserted data into table dependents
insert into dependents (dependent_code,first_name,last_name,relationship,employee_id)
select dependent_id, first_name, last_name, relationship, employee_id_fix
from dependents_csv
where employee_id_fix is not null;

# drop schema hr
drop database hr;
# drop table employees_json
drop table employees_json;
# drop table orgstructure_csv
drop table orgstructure_csv;
# drop table dependents_csv
drop table dependents_csv;

# TASK 4. Calculations and updates
# task 4.1 time difference in months 
# used timestampdiff and current_date functions
update employees
set experience_at_VivaK = (
	SELECT TIMESTAMPDIFF(MONTH, hire_date, CURRENT_DATE())
	);

# task 4.2 random performance rating (0-10)
# modified last_performance_rating column so it can have two decimals
alter table employees 
modify last_performance_rating double(7,2);
# used round and rand functions
update employees
set last_performance_rating = (
	SELECT ROUND((RAND() * (1.00-0.00))+0,2)
    );

# task 4.3 salary after increment
# used case when statement and the formula provided by the client
update employees
set salary_after_increment = (
	select (
		salary * (1 + (0.01 * experience_at_VivaK) 
		+ case when last_performance_rating >= 0.9 then 0.15
		when last_performance_rating >= 0.8 then 0.12
		when last_performance_rating >= 0.7 then 0.10
		when last_performance_rating >= 0.6 then 0.08
		when last_performance_rating >= 0.5 then 0.05
		else 0.02 end)
		)
	);

# task 4.4 annual dependent benefit
# created temporary table to store all the values for getting the annual dependent benefit
create temporary table temp
select e.employee_id, e.job_id, (case when o.job_title like '%Manager%' then 'Managers'
when o.department_name like '%Executive%' then 'Executive'
else 'Other Employees' end) title,
(case when o.job_title like '%Manager%' then 0.15
when o.department_name like '%Executive%' then 0.2
else 0.05 end) dependent_benefit,
salary,
salary*12 annual_salary,
count(d.dependent_id) dependent
from employees e
join organization_structure o using(job_id)
left join dependents d using(employee_id)
group by e.employee_id,e.job_id,o.job_title,o.department_name,salary
order by e.job_id;
# used temporary table and formula provided by the client
update employees e
join temp t using(employee_id)
set e.annual_dependent_benefit = (
	(t.dependent_benefit * t.annual_salary) * t.dependent
	);

# task 4.5 replace email
# used concat and substring_index functions
update employees
set email = concat(
		substring_index(email,'@',1),
        '@vivaK.com'
	);
