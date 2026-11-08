/*Task 2
Millie’s Music Emporium PostgreSQL Privileges
1.	Admin Privileges
Admin is taking as the staff assigned with the database system administrator role responsible managing and maintaining the database, he/she should have full access or privilege on all the tables
Admin should be granted all privileges (GRANT CREATE, SELECT, INSERT, UPDATE, DELETE, TRUNCATE, EXECUTE, REFERENCES, CONNECT, USAGE, CONNECT, TRIGGER) on all the tables to enable him/her view, add, edit and remove customer records; maintains product records and price; manage transaction records and order; manages stock quantities and store stock records; and manage store information*/

-- ******************************************
CREATE ROLE Admin NOLOGIN;
-- Creating Admin Privileges
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON customer TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON transaction_tbl TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON product TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON warehouse_item TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON store TO admin;
/*
2.	Customer Privileges
A customer is assumed to be an application user who browses products and make purchases, he/she is expected to be given limited privilege on all the tables 
While customer be granted INSERT and SELECT privilege on customer and transaction table to enable them register as new customer and create new purchases, only SELECT privilege should be granted on other tables*/

-- ******************************************
--Creating customer role
CREATE ROLE customer NOLOGIN;
-- Creating Customer Privileges
GRANT INSERT, SELECT ON Customer TO customer;
GRANT INSERT, SELECT ON transaction_tbl TO customer;
GRANT SELECT ON product TO customer;
GRANT SELECT ON warehouse_item TO customer;
GRANT SELECT ON store TO customer;
--*********************************************

/*Justifications for the Privilege Granted to the two Database users
The admin user gets full access to all the tables, as this role entails the management of customer information, stock, store, products, and transaction information. The customer gets restricted access based on the principle of least privilege, which implies that users only get access to perform a specific task, hence cannot get full access to all the tables (Baldwin, 1990; Juba, Vannahme, and Volkov, 2015). The customer, therefore, gets limited access to the database to be able to perform tasks such as browsing, accessing store and stock information, registering, and making purchases. The restriction of update and delete access enhances data integrity, hence improving database security (Odirichukwu and Asagba, 2017).*/
