CREATE DATABASE giraffe;

# COMPANY EXAMPLES
CREATE TABLE employee
(
	emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,		#This is foreign key, but as the table having this column has not created yet, cant set foreign key as of now
    branch_id INT
);

CREATE TABLE branch
(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

#Set foreign key for employee table
ALTER TABLE employee
ADD FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY (super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;

CREATE TABLE `client`
(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with
(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES `client`(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier
(
	branch_id INT,
    supplier_name VARCHAR(40),
    supplier_type VARCHAR(40),
    PRIMARY KEY (branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

#Insert data to employee and branch table
#---Corporate branch
INSERT INTO employee
VALUES (100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);	#As there is no data in branch table yet, branch_id will be left blank for now

INSERT INTO branch
VALUES (1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee
VALUES (101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

#---Scranton branch
INSERT INTO employee
VALUES (102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);	#As there is no data in branch table yet, branch_id will be left blank for now

INSERT INTO branch
VALUES (2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee
VALUES (103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2),
	   (104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2),
       (105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

#---Stamford branch
INSERT INTO employee
VALUES (106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);	#As there is no data in branch table yet, branch_id will be left blank for now

INSERT INTO branch
VALUES (3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee
VALUES (107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3),
	   (108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


#Insert data
INSERT INTO `client`
VALUES (400, 'Dunmore Highschool', 2),
	   (401, 'Lackawana Country', 2),
       (402, 'FedEx', 3),
       (403, 'John Daly Law, LLC', 3),
       (404, 'Scranton Whitepages', 2),
       (405, 'Times Newspaper', 3),
       (406, 'FedEx', 2);

INSERT INTO branch_supplier
VALUES (2, 'Hammer Mill', 'Paper'),
	   (2, 'Uni-ball', 'Writing Untensils'),
       (3, 'Patriot Paper', 'Paper'),
       (2, 'J.T.Forms & Labels', 'Custom Forms'),
       (3, 'Uni-ball', 'Writing Untensils'),
       (3, 'Hammer Mill', 'Paper'),
       (3, 'Stamford Labels', 'Custom Forms');

INSERT INTO works_with
VALUES (105, 400, 55000),
	   (102, 401, 267000),
       (108, 402, 22500),
       (107, 403, 5000),
	   (108, 403, 12000),
       (105, 404, 33000),
       (107, 405, 26000),
	   (102, 406, 15000),
       (105, 406, 130000);

#Query
SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM `client`;
SELECT * FROM works_with;
SELECT * FROM branch_supplier;

SELECT *
FROM employee
ORDER BY salary DESC
LIMIT 2,3;

SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

SELECT DISTINCT sex
FROM employee;

SELECT sex
FROM employee
GROUP BY sex;

SELECT COUNT(emp_id) AS no_of_emp
FROM employee;

SELECT COUNT(super_id) AS no_of_emp_having_supervisor
FROM employee;

SELECT COUNT(*)	#Count no of female emp who was born after 1970
FROM employee
WHERE sex = 'F' and YEAR(birth_date) > 1970;

SELECT AVG(salary) AS avg_of_all_emp, SUM(salary) AS sum_of_all_emp
FROM employee;

SELECT sex, COUNT(sex)
FROM employee
GROUP BY sex;

WITH cte_eg AS
(
SELECT emp_id, SUM(total_sales) AS sales
FROM works_with
GROUP BY emp_id
)
SELECT * 
FROM cte_eg
ORDER BY sales DESC;

SELECT *
FROM `client`
WHERE client_name LIKE '%LLC%';

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%Labels%';

SELECT *
FROM employee
WHERE birth_date LIKE '____-10%';

#Union - the number of columns to retrieve in all union tables must be same, and they must have similar data type
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch;

SELECT first_name AS emp_branch_client_name
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM `client`;

SELECT total_sales
FROM works_with
UNION
SELECT salary
FROM employee;

#Join
INSERT INTO branch
VALUES (4, 'Buffalo', NULL, NULL);

SELECT *
FROM branch;

#Find all branches and their manager
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
	ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, employee.branch_id, branch.branch_name
FROM employee
JOIN branch
	ON employee.branch_id = branch.branch_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
	ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
	ON employee.emp_id = branch.mgr_id;

#Nested Queries
WITH cte_emp_sales_details (id, sales, firstname, lastname) AS
(
	SELECT  works_with.emp_id, works_with.total_sales, emp.first_name, emp.last_name
    FROM works_with
    JOIN employee emp
		ON works_with.emp_id = emp.emp_id
), cte_emp_sales_over_30k AS
(
	SELECT id, firstname, lastname, SUM(sales) AS sales
    FROM cte_emp_sales_details
    GROUP BY works_with.emp_id, emp.first_name, emp.last_name
)
SELECT *
FROM cte_emp_sales_over_30k
WHERE sales >= 30000;

#Find list of emp sold over 30k to a single client
SELECT  employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
	SELECT works_with.emp_id
    FROM works_with
    WHERE total_sales > 30000
);

#Find all clients who are handled by the branch where Michael Scott manages.
SELECT *
FROM `client`
WHERE branch_id IN (
	SELECT branch_id
    FROM branch
    WHERE mgr_id IN (
       SELECT emp_id
       FROM employee
       WHERE first_name = 'Michael' AND last_name = 'Scott'
    )
);

SELECT *
FROM `client`
WHERE branch_id IN (
	SELECT branch_id
    FROM branch
    WHERE mgr_id = (
       SELECT emp_id
       FROM employee
       WHERE first_name = 'Michael' AND last_name = 'Scott'
       LIMIT 1
    )
);


#ON DELETE SET NULL: if we delete 1 emp and that emp is foreign key in another table X, it will set foreign key in table X to NULL
#ON DELETE CASCADE: if we delete 1 emp and that emp is foreign key in another table X, it will delete the entire row in table X
#ON DELETE CASCADE: recommend to use this for a column if that column is also a part of primary key as primary key canNOT be null

DELETE FROM employee
WHERE emp_id = 102;

SELECT * FROM employee;
SELECT * FROM branch;    

DELETE FROM branch
WHERE branch_id = 2;

SELECT * FROM branch;
SELECT * FROM branch_supplier;  

#Triggers
CREATE TABLE trigger_test(
	message VARCHAR(100)
);

DELIMITER $$
CREATE TRIGGER my_trigger 
	BEFORE INSERT ON employee
    FOR EACH ROW
		BEGIN INSERT INTO trigger_test VALUES('Added new employee');
END$$
DELIMITER ;

INSERT INTO employee
VALUES (102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, 1);

SELECT * FROM employee;
SELECT * FROM trigger_test;

INSERT INTO employee
VALUES (109, 'Duyen', 'Nguyen', '1995-10-15', 'F', 7500000, 100, 1),
	   (110, 'Mit', 'Nguyen', '2011-06-01', 'F', 7500000, 100, 1);

DELIMITER $$
CREATE TRIGGER my_trigger2
	BEFORE INSERT ON employee
    FOR EACH ROW
		BEGIN INSERT INTO trigger_test VALUES(NEW.first_name);
END$$
DELIMITER ;

INSERT INTO employee
VALUES (111, 'Hien', 'Nguyen', '1994-02-15', 'F', 55000, 100, 1);

DELIMITER $$
CREATE TRIGGER my_trigger3
	BEFORE INSERT ON employee
    FOR EACH ROW
		BEGIN 
        IF NEW.sex = 'M' THEN
			INSERT INTO trigger_test VALUES('Added male emp');
		ELSEIF NEW.sex = 'F' THEN
			INSERT INTO trigger_test VALUES('Added female emp');
		ELSE
			INSERT INTO trigger_test VALUES('Added other emp');
		END IF;
END$$
DELIMITER ;

INSERT INTO employee
VALUES (112, 'Lan', 'Truong', '1973-02-15', 'F', 55000, 100, 1);

SELECT * FROM employee;
SELECT * FROM trigger_test;

DROP TRIGGER my_trigger;



