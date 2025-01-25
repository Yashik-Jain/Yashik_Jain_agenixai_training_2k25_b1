--Create Database
CREATE DATABASE lms_db;


--Create BOOKS Table
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2),
    copies_available INT,
    publication_year INT NOT NULL CHECK (publication_year >= 1000 AND publication_year <= 9999)
);

--Create Table Authors
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    years_of_experience INT
);

--Create Table Book_Authors (Relationship Table bewteen BOOKS And AUTHORS)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

--CREATE TABLE customers
CREATE TABLE customers (
    c_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    dob DATE
);

--Create Table Transactions (Relationship Table Between BOOKS And CUSTOMERS)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    c_id INT NOT NULL,
    issue_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Issued', 'Returned')) NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (c_id) REFERENCES customers(c_id) ON DELETE CASCADE
);
