DROP TABLE IF EXISTS Department;

CREATE TABLE Department (
    department_id integer NOT NULL,
    department_name VARCHAR(50),
    CONSTRAINT department_pk PRIMARY KEY (department_id)
);

INSERT INTO Department(department_id, department_name)
VALUES  (1, 'HR'),
        (2, 'IT'),
        (3, 'Finance');

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    employee_id INTEGER NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    hire_date DATE,
    department_id INTEGER NOT NULL,
    job_title VARCHAR(50),
    salary FLOAT,
    experience INTEGER
);

INSERT INTO Employee(employee_id, first_name, last_name, birthdate, hire_date, department_id, job_title, salary, experience)
VALUES  (1, 'Reza', 'Rezvani', '1980-05-15', '2005-08-10', 1, 'Manager', 65000.00, 10),
        (2, 'Zahra', 'Salimi','1985-03-20', '2008-07-22', 2, 'Engineer', 55000.00, 7),
        (3, 'Amin', 'Nouri', '1990-12-10', '2010-11-05', 3, 'Analyst', 	60000.00, 8),
        (4, 'Maryam', 'Ranjbar', '1982-07-30', '2007-06-15', 2, 'Manager', 70000.00, 12),
        (5, 'Farhad', 'Abbasi', '1988-09-25', '2009-04-18', 3, 'Director', 80000.00, 11),
        (6, 'Sima', 'Rahmani', '1987-02-17', '2006-03-29', 1, 'Coordinator', 48000.00, 15);

DROP TABLE IF EXISTS Salary_Grade;

CREATE TABLE Salary_Grade(
    grade_id INTEGER NOT NULL,
    min_salary FLOAT,
    max_salary FLOAT
);

INSERT INTO Salary_Grade(grade_id, min_salary, max_salary)
VALUES  (1, 45000.00, 60000.00),
        (2, 60001.00, 75000.00),
        (3, 75001.00, 90000.00);

-- First Part
SELECT grade_id, SUM(salary)
FROM salary_grade JOIN employee ON salary>Salary_Grade.min_salary AND salary<Salary_Grade.max_salary
GROUP BY grade_id
ORDER BY grade_id;

-- Second Part
SELECT MAX_SAL.department_id, first_name, last_name, Employee.salary
FROM (
         SELECT department_id, MAX(salary) AS salary
         FROM Employee
         GROUP BY department_id
     ) AS MAX_SAL
JOIN employee ON employee.salary = MAX_SAL.salary;

-- Third Part
CREATE OR REPLACE FUNCTION calc_avg_exp(input_department_name VARCHAR(50))
RETURNS FLOAT AS $$
DECLARE
    res FLOAT := 0;
    sum FLOAT := 0;
    cnt FLOAT := 0;
BEGIN
    SELECT SUM(experience), COUNT(*)
    INTO sum, cnt
    FROM employee
    JOIN Department D on Employee.department_id = D.department_id
    WHERE department_name = input_department_name;

    IF cnt > 0 THEN
        res := sum / cnt;
    END IF;

    RETURN res;
END;
$$ LANGUAGE plpgsql;

SELECT calc_avg_exp('HR'); -- This will return the sum of 5 and 7, which is 12

-- Forth Part
SELECT department_name, calc_avg_exp(department_name)
FROM department
WHERE 8 < calc_avg_exp(department_name);

-- Fifth PArt
CREATE OR REPLACE FUNCTION calc_higher_than_avg()
RETURNS TABLE (d_name varchar, d_avg float) AS $$
DECLARE
    total_avg FLOAT := 0;
BEGIN
    SELECT avg(experience)
    INTO total_avg
    FROM Employee;

    RETURN QUERY
    SELECT department_name, calc_avg_exp(department_name)
    FROM department
    WHERE total_avg < calc_avg_exp(department_name);

END;
$$ LANGUAGE plpgsql;

SELECT calc_higher_than_avg();

