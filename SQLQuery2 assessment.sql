create table employees(employee_id int, employee_name varchar(20), department_id int, salary int);
insert into employees values (1, 'John Doe', 1, 100000), (2, 'Jane Smith', 1, 95000), (3, 'Alice Brown', 2, 120000), (4, 'Bob Johnson', 2, 110000), (5,'Charlie Black', 3, 80000);

select * from employees;

create table sales(sale_id int, product_id int, sale_date date, sale_amount int);
insert into sales values (1, 1, '2023-06-01',100),(2, 1 , '2023-06-02', 150),(3,1,'2023-06-03',200),(4,1,'2023-06-04',250),(5,2,'2023-06-01',300),(6,2,'2023-06-02',350),(7,2,'2023-06-03',400),(8,2,'2023-06-04',450);

select * from sales;
create table categories(category_id int, category_name varchar(20));
insert into categories values (1,'electronics'),(2,'clothing'),(3,'Groceries');

select * from categories;

create table customers(customer_id int, customer_name varchar(20));
insert into customers values (1, 'Alice'),(2,'Bob'),(3,'charlie');
select * from customers;

create table products(product_id int, product_name varchar(20), price int);
insert into products values (1, 'laptop', 1000),(2, 'laptop',1200),(3,'phone',800),(4,'Tablet', 600),(5,'Tablet',650);
select * from Products;

create table department(department_id int, department_name varchar(20));
insert into department values (1, 'HR'),(2,'Finance');
select * from department;

create table orders (order_id int, customer_id int, order_date date);
insert into orders values (2043, 1, '2023-06-01'),(2044, 2, '2023-06-02'),(2045,3,'2023-06-03'),(2046,1,'2023-06-04');
select * from orders;

create table purchases(purchase_id int, customer_id int, category_id int);
insert into purchases values (1,1,1),(2,1,2),(3,1,3),(4,2,1),(5,2,2);
select * from purchases;

--1. names of all employees who work in the same department as the employee with the highest salary
SELECT e1.employee_name
FROM employees e1
WHERE e1.department_id = (
    SELECT department_id
    FROM employees
    WHERE salary = (
        SELECT MAX(salary)
        FROM employees
    )
);

--2. calculate the 7-day moving average of sales for each product.
SELECT
    product_id,
    sale_date,
    sale_amount,
    AVG(sale_amount) OVER (
        PARTITION BY product_id
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM
    sales
ORDER BY
    product_id,
    sale_date;

--3.Names of customers who have made a purchase in all
SELECT c.customer_name
FROM customers c
JOIN purchases p ON c.customer_id = p.customer_id
JOIN categories ca ON p.category_id = ca.category_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM categories);


--4. products with the same name but different prices
select product_name from products
group by product_name
having COUNT(DISTINCT price) > 1;


--5. for second highest salary
select MAX(salary) as second_highesr_salary
from employees where salary < (select MAX(salary) from employees);

--6. Total sales for each customer, including those with no sales
SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(s.sale_amount), 0) AS total_sales
FROM 
    customers c
LEFT JOIN 
    sales s ON c.customer_id = s.customer_id,
GROUP BY 
    c.customer_id, c.customer_name;


--7. Department with more than five employees and their average 

SELECT 
    d.department_name,
    AVG(e.salary) AS average_salary
FROM 
    employees e
JOIN 
    department d ON e.department_id = d.department_id
GROUP BY 
    d.department_name
HAVING 
    COUNT(e.employee_id) > 5;

--8. employees without an assigned manager 

alter table employees add manager_id int;
select * from employees;

update employees set manager_id=2 where employee_id=4;
SELECT 
    employee_name
FROM 
    employees
WHERE 
    manager_id IS NULL;
--9. You have a SQL database table named "orders", with columns "order_id", "customer_id", and "order_date".
--Write a query to update the order date for order number 2045 to "2023-07-23" and save the changes permanently to the database with the COMMIT function.

BEGIN TRANSACTION;

UPDATE orders
SET order_date = '2023-07-23'
WHERE order_id = 2045;

COMMIT;
