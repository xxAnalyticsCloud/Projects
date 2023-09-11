--Performing EDA on coffee shop data

-- Select only the employees who make more than 50k
SELECT *
FROM employees
WHERE salary > 50000;

-- Select all the employees who work in Common Grounds, make more than 50k and are male
SELECT *
FROM employees
WHERE salary > 50000
AND coffeeshop_id = 1
AND gender = 'M';

-- Select all rows from the suppliers table where the supplier is Beans and Barley
SELECT *
FROM suppliers
WHERE supplier_name = 'Beans and Barley';

-- Select all Robusta and Arabica coffee types
SELECT *
FROM suppliers
WHERE coffee_type IN ('Robusta', 'Arabica');

-- Select all employees with missing email addresses
SELECT *
FROM employees
WHERE email IS NULL;

-- Order by salary descending 
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

-- Top 10 highest paid employees
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Return all unique coffeeshop ids
SELECT DISTINCT coffeeshop_id
FROM employees;

-- Extracting dates

SELECT EXTRACT(YEAR FROM hire_date) AS year,
	EXTRACT(MONTH FROM hire_date) AS month,
	EXTRACT(DAY FROM hire_date) AS day
FROM employees;

-- Return the email and the length of emails
SELECT email,
       LENGTH(email) AS email_length
FROM employees;

-- if email has '.com', return true, otherwise false
SELECT email,
      (email like '%.com%') AS dotcom_flag
FROM employees;

-- COALESCE to fill missing emails with custom value
SELECT email,
       COALESCE(email, 'NO EMAIL PROVIDED')
FROM employees;

-- Select difference between maximum and minimum salary
SELECT MAX(salary) - MIN(salary)
FROM employees;

-- Round average salary to nearest integer
SELECT ROUND(AVG(salary),0)
FROM employees;

-- Return the number of employees for each coffeeshop
SELECT coffeeshop_id, COUNT(employee_id)
FROM employees
GROUP BY coffeeshop_id;

-- Return only the coffeeshops with more than 200 employees
SELECT coffeeshop_id,
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
	MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING COUNT(*) > 200
ORDER BY num_of_emp DESC;

-- Return only the coffeeshops with a minimum salary of less than 10k
SELECT coffeeshop_id,
	COUNT(*) AS num_of_emp,
	ROUND(AVG(salary), 0) AS avg_sal,
	MIN(salary) AS min_sal,
	MAX(salary) AS max_sal,
	SUM(salary) AS total_sal
FROM employees
GROUP BY coffeeshop_id
HAVING MIN(salary) < 10000
ORDER BY num_of_emp DESC;

-- If pay is less than 50k, then low pay, otherwise high pay
SELECT employee_id,
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 50000 THEN 'low pay'
		WHEN salary >= 50000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary DESC;

-- If pay is less than 20k, then low pay, if between 20k-50k inclusive, then medium pay
-- if over 50k, then high pay
SELECT employee_id,
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 20000 THEN 'low pay'
		WHEN salary BETWEEN 20000 and 50000 THEN 'medium pay'
		WHEN salary > 50000 THEN 'high pay'
		ELSE 'no pay'
	END
FROM employees
ORDER BY salary DESC;

-- INNER JOIN
SELECT s.coffeeshop_name, l.city, l.country
FROM shops s
JOIN locations l
ON s.city_id = l.city_id;

-- LEFT JOIN
SELECT s.coffeeshop_name, l.city, l.country
FROM shops s
LEFT JOIN locations l
ON s.city_id = l.city_id;

-- RIGHT JOIN
SELECT s.coffeeshop_name, l.city, l.country
FROM shops s
RIGHT JOIN locations l
ON s.city_id = l.city_id;

-- FULL OUTER JOIN
SELECT s.coffeeshop_name, l.city, l.country
FROM shops s
FULL OUTER JOIN locations l
ON s.city_id = l.city_id;

-- Return all cities and countries
SELECT city FROM locations
UNION
SELECT country FROM locations;

-- Basic subqueries with subqueries in the SELECT clause
SELECT first_name,
	last_name,
	salary, 
	(SELECT MAX(salary) FROM employees LIMIT 1)
FROM employees;

-- Subqueries in the WHERE clause
-- Return all US coffee shops
SELECT * 
FROM shops
WHERE city_id IN (SELECT city_id FROM locations
		  WHERE country = 'United States');

-- Return all employees who work in US coffee shops
SELECT *
FROM employees
WHERE coffeeshop_id IN (SELECT coffeeshop_id 
			FROM shops
			WHERE city_id IN (SELECT city_id FROM locations
					  WHERE country = 'United States'));

-- Return all employees who make over 35k and work in US coffee shops
SELECT *
FROM employees
WHERE salary > 35000
AND coffeeshop_id IN (SELECT coffeeshop_id 
		      FROM shops
		      WHERE city_id IN (SELECT city_id FROM locations
					WHERE country = 'United States'));