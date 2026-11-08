/*Task 1:  Milllie’s Musical Emporium (MME) Ltd Prototype Database System*/
-- **************************************************
-- Removing tables from the database if they already exist

DROP TABLE IF EXISTS transaction_tbl CASCADE;
DROP TABLE IF EXISTS warehouse_item CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS store CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

-- **************************************************
-- Creating Customer Table to store customer personal and banking details.

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(150) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    bank_address VARCHAR(150) NOT NULL,
    sort_code VARCHAR(8) NOT NULL,
    account_number VARCHAR(10) NOT NULL
);
-- **************************************************

-- Creating Store Table to store information about each store branch.
CREATE TABLE store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_location VARCHAR(50) NOT NULL
);

-- **************************************************

-- Creating Product Table to store the products sold by the business.

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_type VARCHAR(50) NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    cost NUMERIC(10,2) NOT NULL
);

-- **************************************************

-- Creating Warehouse_Item Table to store stock quantities for products in each store.

CREATE TABLE warehouse_item (
    warehouse_item_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);


-- **************************************************

-- Creating Transactions Table to store the record of each purchase transaction made by a customer.
-- Note: Due to the fact that transaction is reserved word in SQL, the table shall be created as transaction_tbl

-- **************************************************

CREATE TABLE transaction_tbl (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivery_datetime TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- **************************************************

-- Inserting Sample Data to test the system.
INSERT INTO customer
(customer_name, address, telephone, date_of_birth, bank_name, bank_address, sort_code, account_number)
VALUES
('Frank Osegie', '12 Main Street, Sunderland', '+44 0714975208', '1995-05-10', 'Commercial Bank', '1 Oxford Road', '86-39-06', '1001395278'),
('Faith Chukwuma', '5 Lily Road, London', '+44 798065192', '1990-08-20', 'Business Bank', '8, Bedrock Road, Central Business District ', '22-11-33', '0284633701');

-- **************************************************

INSERT INTO store (store_name, store_location)
VALUES ('Central Store', 'Shefield'),
		('Musical Store', 'Manchester');

-- **************************************************

INSERT INTO product (product_type, product_name, description, cost)
VALUES
('Instrument', 'Guitar', 'Acoustic guitar', 300.00),
('Book', 'Piano Manual', 'Beginner piano book', 20.00),
('CD', 'Jazz Album', 'Classic jazz collection', 15.00);

-- **************************************************

INSERT INTO warehouse_item (product_id, store_id, quantity)
VALUES
(1, 1, 10),
(2, 1, 15),
(3, 1, 5),
(1, 2, 3),
(2, 2, 0),
(3, 2, 8);

-- ****************************************************************************

-- Task 1B:  Creating Pl/PgSQL Procedures 
-- PROCEDURE 1: Registering New Customer
-- This procedure allows for registration of new customers and validates customer details before --- inserting a new record.

CREATE OR REPLACE PROCEDURE register_new_customer(
    p_customer_name VARCHAR,
    p_address VARCHAR,
    p_telephone VARCHAR,
    p_date_of_birth DATE,
    p_bank_name VARCHAR,
    p_bank_address VARCHAR,
    p_sort_code VARCHAR,
    p_account_number VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Checking  that customer name is provided
    IF p_customer_name IS NULL OR TRIM(p_customer_name) = '' THEN
        RAISE EXCEPTION 'Customer name cannot be empty';
    END IF;

    -- Check that address is provided
    IF p_address IS NULL OR TRIM(p_address) = '' THEN
        RAISE EXCEPTION 'Address cannot be empty';
    END IF;

    -- Check that telephone number is provided
    IF p_telephone IS NULL OR TRIM(p_telephone) = '' THEN
        RAISE EXCEPTION 'Telephone cannot be empty';
    END IF;

    -- Check that date of birth is provided
    IF p_date_of_birth IS NULL THEN
        RAISE EXCEPTION 'Date of birth is required';
    END IF;

    -- Date of birth must be a past date
    IF p_date_of_birth >= CURRENT_DATE THEN
        RAISE EXCEPTION 'Date of birth must be in the past';
    END IF;

    -- Check that bank name is provided
    IF p_bank_name IS NULL OR TRIM(p_bank_name) = '' THEN
        RAISE EXCEPTION 'Bank name cannot be empty';
    END IF;

    -- Check that bank address is provided
    IF p_bank_address IS NULL OR TRIM(p_bank_address) = '' THEN
        RAISE EXCEPTION 'Bank address cannot be empty';
    END IF;

    -- Checking if sort code is provided
    IF p_sort_code IS NULL OR TRIM(p_sort_code) = '' THEN
        RAISE EXCEPTION 'Sort code cannot be empty';
    END IF;

    -- Checking  if account number is provided
    IF p_account_number IS NULL OR TRIM(p_account_number) = '' THEN
        RAISE EXCEPTION 'Account number cannot be empty';
    END IF;

    -- Preventing  duplicated customer records
    IF EXISTS (
        SELECT 1
        FROM customer
        WHERE customer_name = p_customer_name
          AND telephone = p_telephone
          AND date_of_birth = p_date_of_birth
    ) THEN
        RAISE EXCEPTION 'Duplicate customer found';
    END IF;

    -- Insert the new customer into the table
    INSERT INTO customer
    (customer_name, address, telephone, date_of_birth, bank_name, bank_address, sort_code, account_number)
    VALUES
    (p_customer_name, p_address, p_telephone, p_date_of_birth, p_bank_name, p_bank_address, p_sort_code, p_account_number);

    RAISE NOTICE 'New customer registered successfully';
END;
$$;

-- **************************************************

-- PROCEDURE 2: Purchasing Product
-- This procedure checks all business rules before recording a purchase.
-- Rules:
-- 1. Customer must exist
-- 2. Product must exist
-- 3. Store must exist
-- 4. Stock must be available
-- 5. Delivery slot must be free

-- **************************************************

CREATE OR REPLACE PROCEDURE purchase_product(
    p_customer_id INT,
    p_product_id INT,
    p_store_id INT,
    p_delivery_datetime TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_quantity INT;
BEGIN
    -- Check that customer ID is provided
    IF p_customer_id IS NULL THEN
        RAISE EXCEPTION 'Customer ID is required';
    END IF;

    -- Check that product ID is provided
    IF p_product_id IS NULL THEN
        RAISE EXCEPTION 'Product ID is required';
    END IF;

    -- Check that store ID is provided
    IF p_store_id IS NULL THEN
        RAISE EXCEPTION 'Store ID is required';
    END IF;

    -- Check that delivery date and time is provided
    IF p_delivery_datetime IS NULL THEN
        RAISE EXCEPTION 'Delivery date and time is required';
    END IF;

    -- Delivery date must be in the future
    IF p_delivery_datetime <= CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Delivery date and time must be in the future';
    END IF;

    -- Confirm that the customer exists
    IF NOT EXISTS (
        SELECT 1 FROM customer WHERE customer_id = p_customer_id
    ) THEN
        RAISE EXCEPTION 'Customer does not exist';
    END IF;

    -- Confirm that the product exists
    IF NOT EXISTS (
        SELECT 1 FROM product WHERE product_id = p_product_id
    ) THEN
        RAISE EXCEPTION 'Product does not exist';
    END IF;

    -- Confirm that the store exists
    IF NOT EXISTS (
        SELECT 1 FROM store WHERE store_id = p_store_id
    ) THEN
        RAISE EXCEPTION 'Store does not exist';
    END IF;

    -- Retrieve available stock quantity
    SELECT quantity
    INTO v_quantity
    FROM warehouse_item
    WHERE product_id = p_product_id
      AND store_id = p_store_id;

    -- Check that the product exists in the selected store warehouse
    IF v_quantity IS NULL THEN
        RAISE EXCEPTION 'Product not found in this store warehouse';
    END IF;

    -- Check that stock is available
    IF v_quantity <= 0 THEN
        RAISE EXCEPTION 'Insufficient stock';
    END IF;

    -- Check whether the requested delivery slot is already booked
    IF EXISTS (
        SELECT 1
        FROM transaction_tbl
        WHERE store_id = p_store_id
          AND delivery_datetime = p_delivery_datetime
    ) THEN
        RAISE EXCEPTION 'Delivery slot is already booked';
    END IF;

    -- Record the transaction
    INSERT INTO transaction_tbl
    (customer_id, product_id, store_id, delivery_datetime)
    VALUES
    (p_customer_id, p_product_id, p_store_id, p_delivery_datetime);

    -- Reduce stock level by 1 after successful purchase
    UPDATE warehouse_item
    SET quantity = quantity - 1
    WHERE product_id = p_product_id
      AND store_id = p_store_id;

    RAISE NOTICE 'Purchase completed successfully';
END;
$$;


-- **************************************************

-- TEST CALLS - VALID
-- These examples should run successfully.

CALL register_new_customer(
    'Femi Gimbia',
    '99 Church Street',
    '+44 717040806',
    '1998-06-15',
    'HSBC',
    '10 King Avenue',
    '40-50-60',
    '6091820314'
);

CALL purchase_product(
    1,
    1,
    1,
    '2030-06-20 10:00:00'
);

-- **************************************************

-- TEST CALLS - INVALID
-- Uncomment one block at a time to test validation errors.
-- Duplicate customer
-- CALL register_new_customer(
--     ' Frank Osegie',
--     '12 Main Street, Sunderland',
--     '+44 0714975208',
--     '1995-05-10',
--     ''Commercial Bank ',
--     '1 Oxford Road',
--     '86-39-06',
--     '1001395278'
-- );

-- Invalid date of birth
-- CALL register_new_customer(
--     'Future Person',
--     '1 Test Street',
--     '0700111222',
--     '2090-01-01',
--     'NatWest',
--     '2 Bank Street',
--     '11-22-33',
--     '99998888'
-- );

-- Invalid product
-- CALL purchase_product(
--     1,
--     99,
--     1,
--     '2030-06-20 11:00:00'
-- );

-- Insufficient stock
-- CALL purchase_product(
--     1,
--     2,
--     2,
--     '2030-06-20 12:00:00'
-- );

-- Delivery slot already booked
-- CALL purchase_product(
--     2,
--     3,
--     1,
--     '2030-06-20 10:00:00'
-- );


-- **************************************************

-- CHECK DATA
-- Use these queries to verify the inserted and updated records.
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM store;
SELECT * FROM warehouse_item;
SELECT * FROM transaction_tbl;