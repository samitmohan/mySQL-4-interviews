CREATE DATABASE temp;
USE temp;
CREATE TABLE student (
	id INT PRIMARY KEY;
	name VARCHAR(255)
);
INSERT INTO student VALUES(1, "samit");

-- show tables; show databases;
SELECT * FROM student;

-- DATA TYPES.
-- varchar (variable) and char (fixed)
-- date (YYYY-MM-DD) or datetime (YYYY-MM-DD HH:MM:SS), 
-- time, enum (one of the present values), 
-- set (one or many of the present values), boolean (0/1), decimal
-- col INT UNSIGNED (can't be negative)
-- TRUNCATE : remove tuples, delete table = DROP
-- RENAME, ALTER TABLE (modify table structure) [DDL]
-- DML : data modification language (INSERT, UPDATE, DELETE)
-- DCL (control language) : Access [GRANT, REVOKE]
-- TCL (atomic transaction) : START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT.

-- Managing : 
CREATE DATABASE IF NOT EXISTS db-name;
DROP DATABASE IF EXISTS temp;

-- FK : Referential key to PK.
insert into title(worker_ref_id, worker_title, affected_from) values
    -> (001, 'Manager', '2016-02-20 00.00.00'),
    -> (002, 'Executive', '2016-06-11 00.00.00'),
    -> (003, 'Executive', '2016-06-11 00.00.00'),
    -> (004, 'Manager', '2016-06-11 00.00.00'),
    -> (005, 'Asst. Manager', '2016-06-11 00.00.00'),
    -> (006, 'Lead', '2016-06-11 00.00.00')
    -> );

select * from worker WHERE salary > 8000;

-- BETWEEN clause (low and high value are inclusives.)
select * from worker WHERE salary BETWEEN 80000 AND 500000;

-- IN (reduces OR conditions)
-- workers in HR OR Admin dept

select * from workers where department = "HR" OR department = "Admin";

-- better way : IN to search.
select * from worker where department in ("HR", "Admin");
select * from worker where department NOT IN ("HR", "Admin");

-- for null
select * from worker where salary is NULL;

-- Pattern Matching.
-- '*' any number of character, '_' only one character (WILDCARD)
-- '%' any number of character, '_' only one character (WILDCARD)
select * from worker where first_name LIKE '%i%'; -- any word which has i
select * for worker where first_name LIKE "%i"; -- word which has i in the end.

select * from worker ORDER BY salary DESC;
select DISTINCT department from worker;

-- group by used for aggregation functions.
-- group by rule : list of name after select should be same for group by.
select COUNT(department) from worker GROUP BY department;

-- find average salary per department
select department, AVG(salary) from worker GROUP BY department;
select department, COUNT(department) from worker GROUP BY department;
select department, AVG(salary) from worker;

-- having clause : need to filter. Only used with ahving.
-- use WHERE with select.
-- if need to filter in group by we use = HAVING.
-- out of the categories made by group by, we need to know particular thing (similary to where)
 
-- dept and count having more than 2 workers
select department, count(department) from worker group by department having COUNT(department) > 2;

-- where vs having?? having used in aggregation with GROUP BY, where is used to filter in select (no groupby)

-- UNIQUE : create table customer (name varchar(255) UNIQUE)
-- CHECK : consistency constraint.
create table account(id int primary key, name varchar(255) UNIQUE, balance INT, CONSTRAINT acc_balance_chk CHECK(balance > 1000));

-- DEFAULT 0 (if no value then default 0)
-- balance INT NOT NULL DEFAULT 0

-- ALTER.
-- add new column (interest rate)
ALTER TABLE account ADD interest FLOAT NOT NULL DEFAULT 0;

-- MODIFY : data type
ALTER table account MODIFY interest DOUBLE NOT NULL DEFAULT 0;
-- change column - rename (old name new name with data type)
ALTER table account CHANGE COLUMN interest interest_new FLOAT NOT NULL;

ALTER table account DROP COLUMN interest_new;
-- rename table
ALTER table account RENAME TO account_details; -- old name to new name

-- update this avalue
UPDATE account_details SET name = 'mohan', balance = 100000 WHERE id = 1;

-- DELETE
DELETE from account_details where id = 1;

-- REPLACE (DML) : 1) Data already present , replace. 2) Data not present, INSERT.
REPLACE INTO account_details values (1, 'samit');

-- JOINS.
-- INNER join : intersection
select c*, o* FROM Customer AS C INNER JOIN Order as o ON c.id = o.cust_id
-- here AS : ALIAS and id(c) = PK, cust_id(o) = FK

-- OUTER JOIN : LEFT (Left all and intersection)
-- Non matching data = NULL
select c.*, o.* FROM Customer as c LEFT JOIN Order as o ON c.id = o.cust_id

-- RIGHT (Right all and intersection) : Interested in knowing only the right side info.
-- Non matching data = NULL

-- FULL JOIN : Union (LEFT AND RIGHT) : No keyword to do full join in mySQL
-- do LeftJoin Union RightJoin
select * from leftTable as l LEFT JOIN rightTable as r ON l.key = r.key 
UNION 
select * from lefTable as l RIGHT JOIN rightTable as r ON l.key = r.key

-- CROSS JOIN : Cartesian Product (leftTable : 5 rows, rightTable : 10 rows) --- Resultant = 50 rows.
select e.*, p.* from Employee as e CROSS JOIN Project as p;

-- SELF JOIN
select e1.id, e2.id, e2.name FROM employee as e1 
INNER JOIN 
employee as e2 ON e1.id = e2.id; -- (Make two tables of same table)

-- WITHOUT JOIN
select * from leftTable, rightTable WHERE leftTable.id = rightTable.id; -- (Not using INNER JOIN)

-- SET operations.
select * from table1 UNION select * from table2;

-- JOIN is for matching columns, SET operations are for unionising row level.
-- in SET operations table syntax should be same. (Row wise) where as JOIN is column wise, datatypes should be same for SET, generates distinct rows. In JOIN they can generate duplicate rows.

select * from T1 INTERSECT select * from T2;
-- MINUS

select id from T1 LEFT JOIN T2 using(id) Where T2.id is NULL;

-- SUB QUERIES
select * from employee where id in (select empID from project group by empID having count(empID) > 1); -- emp details working in more than 1 project.
-- emp details having age > avg(age)
select * from employee where age > (select avg(age) from employee);

-- VIEWS - see only what you want to see.
CREATE VIEW custom as SELECT fname, age from Employee;
-- Now view created whcih only have fname and age.
ALTER VIEW custom as select fname, lname, age from employee;
DROP VIEW if exists custom;

-- Interview Questions

-- select first name from worker in upper case
select UPPER(first_name) from worker;

-- unique values in dept
select distinct department from worker;

-- first 3 char of first name
select substring(first_name, 1, 3) from worker;

-- posn of particular char
select INSTR(first_name, 's') from worker where first_name = 'samit';

-- select RTRIM(first_name) from worker; LTRIM etc...
-- LENGTH(department) to find length.

-- order by first name asc and dept desc
select * from worker order by first_name, department DESC;
select * from worker where first_name in ('Samit', "Rishabh");

-- write query whose first name contains a and whose name ends with a.
select * from worker where first_name LIKE "%a%";

select * from worker where first_name LIKE "%a";

-- details of workers who joined in feb'2014
select * from worker where YEAR(joining_date) = 2014 AND MONTH(joining_date) = 02;

-- to get first name and last name whose salary b/w 5k and 10k
select CONCAT(first_name, ' ', last_name) from worker where salary between 50000 and 100000;

-- write query to print details of workers who are also managers.
select * from worker as w INNER JOIN title as t  on w.worker_id = t.worker_ref_id where t.worker_title = "Manager";

-- only odd rows from table
select * from worker where MOD(worker_id, 2) != 0;

-- creating clone table
create table worker_clone LIKE worker;
insert into worker_clone select * from worker;

-- current date and time.
select curdate(); select now() 

-- show top n records of table order by desc salary
select * from worker order by salary desc LIMIT 5;

-- highest salary
select * from worker order by salary desc LIMIT 4, 1; 

-- lowest
select * from worker order by salary desc LIMIT 5, 5;
# lowest sal
select max(salary) from worker where salary not in (select max(salary) from worker);

-- remove max and then tell max (second highest) ^
-- dept which has less than 3 ppl in it
select department, count(department) as c from worker group by department having c < 3;

-- last 5 records
(select * from worker order by worker_id desc limit 5) order by worker_id;

-- highest salary in each dept.
select max(salary) as maxSal, department from worker group by department;

-- names of workers who earn highest
select first_name, salary from worker where salary = (select max(salary) from worker);

-- write a query to add multiple columns in a table.
INSERT INTO workers VALUES (), (), (),

-- write a query to add / delete multiple cols in a table.
ALTER TABLE users ADD email varchar(255) NOT NULL UNQIUE, ADD password...
ALTER TABLE users DROP COLUMN email, DROP COLUMN password...

-- 2nd highest salary in a table
select salary from worker order by desc limit 0,1;
select max(salary) from worker where salary < (select max (salary) from worker);

-- finding and deleting all duplicate values.
select email, count(*) as duplicates from employee group by email having count(*) > 1;
select email from Person group by email having count(*) > 1;
DELETE FROM employees WHERE email IN(select email from employees group by email having COUNT(*) > 1);

-- select nth max salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N = N-1;
  RETURN (
      SELECT DISTINCT(salary) from Employee order by salary DESC
      LIMIT 1 OFFSET N 
  );
END

-- Rank
# Write your MySQL query statement below
Select score, dense_rank() over (Order By score DESC) as 'rank' from Scores ;

-- consecutive number appearing more than 3 times in a row.
select distinct number from logs where (id + 1, number) in (select * from logs)
AND (id + 2, number) in (select * from logs);

-- employees who earn more than their managers. (same table)
SELECT e2.name as Employee
FROM employee e1
INNER JOIN employee e2 ON e1.id = e2.managerID
WHERE
e1.salary < e2.salary

-- Delete duplicate emails from same table.
delete p1 from Person p1,Person p2 where p1.Email = p2.Email And p1.Id > p2.Id

**Where** : Filter records that are necessary based on conditions

**Order By** : Used to filter ASC or DESC (used with WHERE)

**Group By** : Group records with identical data and can be used in conjunction with some aggregation function to produce summarized results

**Having** : Filter records in combination with the GROUP BY (different from WHERE : cannot filter aggregated records)

-- UNION, MINUS, INTERSECT
select name from students MINUS select name from contacts;
-- DELETE statement is used to delete rows from a table.
-- TRUNCATE command is used to delete all the rows from the table and free the space containing the table. (Table still intact, data deleted)
TRUNCATE TABLE Candidates;

-- Aggregate functions : AVG(), COUNT(), MIN(), MAX(), SUM(), FIRST(), LSAT() [all ignore null values except COUNT]

-- swap gender
# Write your MySQL query statement below
UPDATE salary set sex = 
CASE sex
    WHEN 'm' then 'f'
    ELSE 'm'
END;

-- make sure first letter is capital and rest is small. aLice = Alice
select user_id, concat(upper(substr(name, 1, 1)), lower(substr(name, 2, length(name)))) as name from users order by user_id;

-- joins example (filter out people who have less balance)
-- join the Users and Transactions tables based on the account number and then calculate the sum of the amounts for each user.
-- We can then filter the result to include only those users whose balance is higher than 10000.
select u.name, sum(t.amount) as balance from users u JOIN transactions t 
on u.account = t.account group by u.name having balance > 10000
