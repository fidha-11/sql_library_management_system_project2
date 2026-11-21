--Library management system- project 2

--creating branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
	branch_id VARCHAR(10) primary key, 
	manager_id VARCHAR(10), 
	branch_address VARCHAR(55), 
	contact_no VARCHAR(10));

DROP TABLE IF EXISTS employees;
create table employees(
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(15),
	salary int,
	branch_id varchar(10)
);

DROP TABLE IF EXISTS books;
create table books(
	isbn varchar(20) primary key,
	book_title VARCHAR(75)	,
	category VARCHAR(15)	,
	rental_price	FLOAT,
	status	VARCHAR(30),
	author	VARCHAR(40),
	publisher VARCHAR(55)

);
DROP TABLE IF EXISTS members;
CREATE TABLE members(
	member_id	varchar(10) primary key,
	member_name	varchar(25),
	member_address	varchar(75),
	reg_date date
);
drop table if exists issued_status;
create table issued_status(
	issued_id varchar(10) primary key,
	issued_member_id varchar(10) ,
	issued_book_name varchar(75),
	issued_date date,
	issued_book_isbn varchar(75),
	issued_emp_id varchar(25)

);

drop table if exists returned_status;
create table returned_status(
	return_id	varchar(10) primary key,
	issued_id	varchar(10),
	return_book_name	varchar(75),
	return_date	date ,
	return_book_isbn varchar(20)
);

--FOREIGN KEY
ALTER TABLE issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

ALTER TABLE issued_status
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn); 

ALTER TABLE issued_status
add constraint fk_employees
foreign key(issued_emp_id)
references employees(emp_id);

ALTER TABLE branch
ADD CONSTRAINT branch_pkey
PRIMARY KEY (branch_id);

ALTER TABLE employees
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);

ALTER TABLE returned_status
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id);

alter table books
alter column category type varchar(25);

alter table branch
alter column contact_no type varchar(20);



SELECT * FROM BOOKS;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM returned_status;
select * from members;

--project task
--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books(isbn, book_title, category, rental_price, status , author, publisher)
values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00 , 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

--task 2.  Update an Existing Member's Address

update members
set member_address= '125 Main St'
where member_id = 'C101';

--task 3.  Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete from issued_status
where issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status
where issued_emp_id = 'E101';

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id, count(issued_id) as total_book_issued
from issued_status
group by issued_emp_id
having count(issued_id) > 1;

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_counts as
select b.isbn , book_title, count(ist.issued_id) as no_issued
from books as b
join 
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1,2;

select * from book_counts;


--Retrieve All Books in a Specific Category:

select * from books
where category = 'Classic';

--Task 8: Find Total Rental Income by Category

select
b.category,
Sum(b.rental_price),
count(*)
from issued_status as ist
join books as b
on b.isbn = ist.issued_book_isbn
group by 1;

--task 9: List Members Who Registered in the Last 180 Days:

select * 
from members
where reg_date >=current_date- INTERVAL '180 days' ;

insert into members(member_id,member_name, member_address, reg_date)
values ('C120','sam', '145 main strt', '2024-06-01'),
('C130','tim', '133 main strt', '2024-05-01');


--task 10.List Employees with Their Branch Manager's Name and their branch details: 
select e.*,
e2.emp_name as manager,
b.branch_id
from employees as e
join
branch as b
on b.branch_id = e.branch_id
join
employees as e2
on
b.manager_id = e2.emp_id;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
select * from books
where rental_price > '7';

select * from expensive_books;


--Task 12: Retrieve the List of Books Not Yet Returned

select distinct ist.issued_book_name
from issued_status as ist
left join
returned_status as rs
on rs.issued_id = ist.issued_id
where rs.return_id is NULL;



