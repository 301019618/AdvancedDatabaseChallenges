--Chapter1 Advanced Challenge
--In this chapter, the normalization process was shown for just the BOOKS table. The other tables in the JustLee Books database are shown after normalization.
--Because the database needs to contain data for each customer�s order, perform the steps for normalizing the following data elements to 3NF:
--� Customer�s name and billing address
--� Quantity and retail price of each item ordered
--� Shipping address for each order
--� Date each order was placed and the date it was shipped
--Assume the unnormalized data in the list is stored in one table. Provide your instructor with a list of the tables you have identified at each step of the 
--normalization process (that is, 1NF, 2NF, 3NF) and the attributes, or fields, in each table. Remember that each customer can place
--more than one order, each order can contain more than one item, and an item can appear on more than one order.
1--For CUSTOMERS: customer#, Frist name, Last name, billing address 
1--Orders: order#, shipping address, quantity, retail price, order date, ship date
2--For CUSTOMERS: customer#, first name, last name, billing address
--For ORDERS: order#, shipping address, order date, ship date
--For ORDERITEMS: order#, item#, quantity, retail price
3--For CUSTOMERS: customer#, first name, last name, billing address
--For ORDERS: order#, shipping address, order date, ship date
--For ORDERITEMS: order#, item#, quantity, 
--For BOOKS:  retail price
--These entities might be considered before normalization 
--first name, last name, billing address, quantity, retail price, shipping address, order date, ship date

--Chapter2 Advanced Challenge
--The management of JustLee Books has submitted two requests. The first is for a mailing list of all customers stored in the CUSTOMERS table. 
--The second is for a list of the percentage of profit generated by each book in the BOOKS table. The requests are as follows:

--1.Create a mailing list from the CUSTOMERS table. The mailing list should display the name, address, city, state, and zip code for each customer. 
--Each customer�s name should be listed in order of last name followed by first name, separated with a comma, and have the column header �Name.� 
--The city and state should be listed as one column of output, with the values separated by a comma and the column header �Location.�
SELECT (lastname ||','||firstname) as "Name", address, (city ||','|| state) as "Location"
FROM customers;

--2.To determine the percentage of profit for a particular item, subtract the item�s cost from the retail price to calculate the dollar amount of profit,
--and then divide the profit by the item�s cost. The solution is then multiplied by 100 to determine the profit percentage for each book. 
--Use a SELECT statement to display each book�s title and percentage of profit. For the column displaying the percentage markup, use �Profit %� as the column heading.
SELECT title,
(round ((retail-cost)/cost*100) || '%') as "profit%"
FROM books;


--Chapter3 Advanced Challenge
--Two new columns must be added to the ACCTMANAGER table: one to indicate the commission classification assigned to each employee and another to
--contain each employee�s benefits code. The commission classification column should be able to store integers up to a maximum value of 99 and be named
--Comm_id. The value of the Comm_id column should be set to a value of 10 automatically if no value is provided when a row is added. The benefits code
--column should also accommodate integer values up to a maximum of 99 and be named Ben_id.
ALTER table acctmanager
ADD (comm_id NUMBER (2) DEFAULT 10,
Ben_id NUMBER (2));
--A new table, COMMRATE, must be created to store the commission rate schedule and must contain the following columns:
--� Comm_id: A numeric column similar to the one added to the ACCTMANAGER table
--� Comm_rank: A character field that can store a rank name allowing up to 15 characters
--� Rate: A numeric field that can store two decimal digits (such as .01 or .03)
CREATE table commrate
( Comm_id NUMBER (2) default 10,
Comm_rank varchar2 (15),
Rate NUMBER (2,2));
--� A new table, BENEFITS, must be created to store the available benefit plan options and must contain the following columns:
--� Ben_id: A numeric column similar to the one added to the ACCTMANAGER table
--� Ben_plan: A character field that can store a single character value
--� Ben_provider: A numeric field that can store a three-digit integer
--� Active: A character field that can hold a value of Y or N
CREATE table Benefits
(
Ben_id NUMBER (2) default 10,
Ben_plan char (1),
Ben_provider NUMBER (3),
Active varchar2 (1));
--Chapter4 Advanced Challenge
--Create two tables based on the E-R model shown in Figure 4-41 and the business rules in the following list for a work order tracking database. 
--Include all the constraints in the CREATE TABLE statements. You should have only two CREATE TABLE statements and no ALTER TABLE statements. 
--Name all constraints except NOT NULLs.(Table Project and Workorders)
CREATE table project
(
Proj# NUMBER (10) not null,
P_name varchar2(10) not null,
P_desc  varchar(20),
P_budget NUMBER (10,2),
CONSTRAINT Proj#_PK PRIMARY KEY (Proj#),
CONSTRAINT P_name_UK UNIQUE (P_name));

CREATE table workorders
(
Wo# NUMBER (10) not null,
Proj# NUMBER (10),
Wo_desc varchar2 (20) not null,
Wo_assigned varchar2(20),
Wo_hours NUMBER (4)not null,
Wo_start DATE,
Wo_due DATE,
Wo_complete char(3),
CONSTRAINT Wo#_PK PRIMARY KEY (Wo#),
CONSTRAINT Proj#_FK FOREIGN KEY (Proj#)
REFERENCES Project (Proj#),
CONSTRAINT Wo_desc_UK UNIQUE (Wo_desc),
CONSTRAINT Wo_hours_CK CHECK (Wo_hours>0),
CONSTRAINT Wo_complete_CK CHECK (Wo_complete IN ('Y', 'N')));
--Chapter5 Advanced Challenge
--Currently, the contents of the Category column in the BOOKS table are the actual name for each category. 
--This structure presents a problem if one user enters COMPUTER for the Computer category and another user enters COMPUTERS. 
--To avoid this and other problems that might occur, the database designers have decided to create a CATEGORY table containing a code and description for each category. 
--The structure for the CATEGORY table should be as follows:
--Create the CATEGORY table and populate it with the given data. Save the changes permanently.
CREATE table category
(catcode varchar(3),catdesc varchar2 (11) not null,
constraint catcode_pk primary key(catcode));
--� Add a column to the BOOKS table called Catcode.
ALTER table books
ADD (catcode varchar2(3));
desc books;
--� Add a FOREIGN KEY constraint that requires all category codes entered in the BOOKS table to already exist in the CATEGORY table. Set the Catcode values for
--the existing rows in the BOOKS table, based on each book�s current Category value.
ALTER table books
ADD CONSTRAINT catcode_FK FOREIGN KEY (catcode)
REFERENCES category;
desc books;
UPDATE books
SET catcode = (SELECT catcode FROM category WHERE catdesc = category);
SELECT * FROM books;

--� Verify that the correct categories have been assigned in the BOOKS table, and save the changes permanently.
SELECT * FROM books;
commit;
--� Delete the Category column from the BOOKS table.
ALTER table books
DROP column category;
SELECT * FROM books;
--
--Chapter7 Advanced Challenge
--The following employee groups should have access to the tables listed below. 
--Account Managers: BOOKS, CUSTOMERS, AUTHORS, PUBLISHERS, PROMOTION
--Data Entry : BOOKS, AUTHORS, BOOKAUTHOR, PUBLISHER
--Customer Service: BOOKS, CUSTOMERS, ORDERS, ORDERITEMS
--Creating privileges
CREATE ROLE actmanager; 
GRANT SELECT ON BOOKS TO actmanager;
GRANT SELECT ON CUSTOMERS TO actmanager;
GRANT SELECT ON AUTHORS TO actmanager;
GRANT SELECT ON PUBLISHER TO actmanager;
GRANT SELECT ON PROMOTION TO actmanager;

CREATE ROLE dataentry; 
GRANT SELECT, INSERT, UPDATE, ALTER ON BOOKS TO dataentry;
GRANT SELECT, INSERT, UPDATE, ALTER ON AUTHORS TO dataentry;
GRANT SELECT, INSERT, UPDATE, ALTER ON BOOKAUTHORS TO dataentry;
GRANT SELECT, INSERT, UPDATE, ALTER ON PUBLISHER TO dataentry;

CREATE ROLE custservice; 
GRANT SELECT, INSERT, UPDATE, ALTER ON BOOKS TO custservice;
GRANT SELECT, INSERT, UPDATE, ALTER ON CUSTOMERS TO custservice;
GRANT SELECT, INSERT, UPDATE, ALTER ON ORDERS TO custservice;
GRANT SELECT, INSERT, UPDATE, ALTER ON ORDERITEMS TO custservice;

--Chapter8 Advanced Challenge
--1.	A manager at JustLee Books requests a list of the titles of all books generating a profit of at least $10.00. 
--The manager wants the results listed in descending order, based on each book�s profit.
SELECT title,(retail-cost) AS Profit
FROM books
WHERE retail-cost >=10
ORDER BY retail-cost;
--2.	A customer service representative is trying to identify all books in the Computer or Family Life category and published by Publisher 1 or Publisher 3. 
--However, the results shouldn�t include any book selling for less than $45.00.
SELECT title 
FROM books
WHERE category IN ('COMPUTER','FAMILY LIFE') AND pubid IN ('1','3') AND retail>=45;
--Chapter9 Advanced Challenge
--Q: The Marketing Department of JustLee Books is preparing for its annual sales promotion.
--Each customer who places an order during the promotion will receive a free gift with each book
--purchased. Each gift will be based on the book�s retail price. JustLee Books also participates in
--co-op advertising programs with certain publishers. If the publisher�s name is included in
--advertisements, JustLee Books is reimbursed a certain percentage of the advertisement costs.
--To determine the projected costs of this year�s sales promotion, the Marketing Department
--needs the publisher�s name, profit amount, and free gift description for each book in the JustLee
--Books inventory.
--Also, the Marketing Department is analyzing books that don�t sell. A list of ISBNs for all
--books with no sales recorded is needed. Use a set operation to complete this task.
--Create a document that includes a synopsis of these requests, the necessary SQL
--statements, and the output requested by the Marketing Department.
SELECT title, name, retail-cost "Profit", gift
FROM books b
LEFT OUTER JOIN publisher USING (pubid)
LEFT OUTER JOIN promotion ON b.retail
BETWEEN minretail AND maxretail;
--Chapter 10 Advanced Challenge
--Management is proposing to increase the price of each book. The amount of the increase will be based on each book�s category, 
--according to the following scale: Computer books, 10%; Fitness books, 15%; Self-Help books, 25%; all other categories, 3%. Create a list that displays
--each book�s title, category, current retail price, and revised retail price. The prices should be displayed with two decimal places. 
--The column headings for the output should be as follows: Title, Category, Current Price, and Revised Price. Sort the results by category. If there�s more
--than one book in a category, a secondary sort should be performed on the book�s title. 

SELECT title,category,round(retail,2),
ROUND (DECODE (category,'COMPUTER',retail*1.1,'FITNESS',retail*1.15,'SELF HELP',retail*1.25,retail*1.03),2) AS "Revised Price"
FROM books
ORDER BY category,title;
--Chapter 11 Advanced Challenge
--JustLee Books has a problem: Book storage space is filling up. As a solution, management is considering limiting the inventory to only those books 
--returning at least a 55% profit. Any book returning less than a 55% profit would be dropped from inventory and not reordered.
--This plan could, however, have a negative impact on overall sales. Management fears that if JustLee stops carrying the less profitable books, 
--the company might lose repeat business from its customers. As part of management�s decision-making process, it wants to know whether current customers purchase
--less profitable books frequently. Therefore, management wants to know how many times these less profitable books have been purchased recently.
--Determine which books generate less than a 55% profit and how many copies of these books have been sold. Summarize your findings for management, and include a copy 
--of the query used to retrieve data from the database tables.
SELECT ISBN, b.TITLE, b.COST, b.RETAIL, o.QUANTITY "# of times ordered",
ROUND(((retail-cost)/retail)*100,1)||'%' "Percent Profit",
SUM(o.quantity) "# of times ordered"
FROM BOOKS b
JOIN ORDERITEMS o
USING (ISBN)
GROUP BY ISBN, b.title, b.cost, b.retail, o.quantity, ROUND(((retail-cost)/retail)*100,1);
















