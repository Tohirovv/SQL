USE lessons;
GO

--=========================
--       Task 1
--=========================

DROP TABLE IF EXISTS student;
CREATE TABLE student (
    id INTEGER,
    name VARCHAR(100),
    age INTEGER
);
ALTER TABLE student
ALTER COLUMN id INT NOT NULL;

--=========================
--       Task 2
--=========================

DROP TABLE IF EXISTS product;

CREATE TABLE product (
    product_id INT CONSTRAINT UQ_product_product_id UNIQUE,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

ALTER TABLE product
DROP CONSTRAINT UQ_product_product_id;

ALTER TABLE product
ADD CONSTRAINT UQ_product_id_name UNIQUE (product_id, product_name);

--=========================
--       Task 3
--=========================
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT CONSTRAINT PK_orders_order_id PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE
);

ALTER TABLE orders
DROP CONSTRAINT PK_orders_order_id;

ALTER TABLE orders
ADD CONSTRAINT PK_orders_order_id PRIMARY KEY (order_id);

--=========================
--       Task 4
--=========================
-- Drop the item table first since it references category
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS category;

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT CONSTRAINT FK_item_category FOREIGN KEY REFERENCES category(category_id)
);

ALTER TABLE item
DROP CONSTRAINT FK_item_category;

ALTER TABLE item
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id);

--=========================
--       Task 5
--=========================
DROP TABLE IF EXISTS account;

-- Create with named constraints
CREATE TABLE account (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10, 2) CONSTRAINT CK_account_balance CHECK (balance >= 0),  
    account_type VARCHAR(50) CONSTRAINT CK_account_type CHECK (account_type IN ('Saving', 'Checking')) 
);

-- Insert valid data
INSERT INTO account VALUES 
(1, 2.5, 'Saving'),
(2, 5.0, 'Checking');

-- Drop constraints by name
ALTER TABLE account DROP CONSTRAINT CK_account_balance;
ALTER TABLE account DROP CONSTRAINT CK_account_type;

-- Insert data that would violate constraints (for testing)
INSERT INTO account VALUES 
(3, -1.0, 'Invalid'); -- This will work now because constraints are dropped

-- Re-add constraints
ALTER TABLE account ADD CONSTRAINT CK_account_balance CHECK (balance >= 0);
ALTER TABLE account ADD CONSTRAINT CK_account_type CHECK (account_type IN ('Saving', 'Checking'));

-- This will now fail
-- INSERT INTO account VALUES (4, -1.0, 'Invalid');

SELECT * FROM account;

--=========================
--       Task 6
--=========================

DROP TABLE IF EXISTS customer;

CREATE TABLE customer
(
    customer_id INT PRIMARY KEY,
    name VARCHAR(55),
    city VARCHAR(255) CONSTRAINT DF_city DEFAULT 'Unknown'
);

ALTER TABLE customer DROP CONSTRAINT DF_city;

ALTER TABLE customer ADD CONSTRAINT DF_city DEFAULT 'Unknown' FOR city;

-- Task 7

DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice
(
    invoice_id INT IDENTITY(1, 1), --default values are also 1 and 1
    amount DECIMAL(10,2)
);

INSERT INTO invoice (amount)
VALUES
    (100.50),
    (200.75),
    (150.00),
    (300.25),
    (400.80);

SELECT * FROM invoice;

SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id, amount) VALUES (100, 500.00);

SET IDENTITY_INSERT invoice OFF;

-- Task 8

DROP TABLE IF EXISTS books;

CREATE TABLE books
(
    book_id INT PRIMARY KEY IDENTITY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK(price > 0),
    genre VARCHAR(255) DEFAULT 'Unknown'
);

INSERT INTO books (title, price) VALUES ('Untitled Book', 20.00);

-- This will fail due to NOT NULL constraint
-- INSERT INTO books (title, price, genre) VALUES (NULL, 10.99, 'Mystery');

-- This will fail due to CHECK constraint
-- INSERT INTO books (title, price, genre) VALUES ('Free Book', 0, 'Education');

INSERT INTO books (title, price, genre) VALUES ('Free Book', 0.01, 'Education');

SELECT * FROM books;

-- task 9

-- First make sure we're not in the library database when trying to drop it
USE master;
GO

DROP DATABASE IF EXISTS library;
GO

CREATE DATABASE library;
GO

USE library;
GO

-- Drop tables in correct order (child tables first)
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
GO

CREATE TABLE Book (
    book_id INT IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INT CHECK (published_year > 0)
);

CREATE TABLE Member (
    member_id INT IDENTITY PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    email VARCHAR(255) UNIQUE DEFAULT 'No email',
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE Loan (
    loan_id INT IDENTITY PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

INSERT INTO Member (name, email, phone_number) 
VALUES
    ('Alice', 'alice@example.com', '123-456-7890'),
    ('Bob', 'bob@example.com', '987-654-3210'),
    ('John', 'john@example.com', '555-666-7777');

INSERT INTO Book (title, author, published_year) VALUES
    ('1984', 'George Orwell', 1949),
    ('To Kill a Mockingbird', 'Harper Lee', 1960),
    ('The Great Gatsby', 'F.Scott Fitzgerald', 1925);

INSERT INTO Loan (book_id, member_id, loan_date) VALUES (1, 1, '2024-02-01');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 2, '2024-02-03');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (3, 3, '2024-02-05');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 1, '2024-02-10');

SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Loan;