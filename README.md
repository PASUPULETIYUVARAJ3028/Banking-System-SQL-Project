# Banking System using SQL Project 

## Project Overview

**Project Title**: Banking System

## Objective
This project demonstrates the implementation of a banking system using SQL. It includes the creation and management of tables, as well as the execution of CRUD operations.
The project simulates the back-end database logic of a real-world banking system, focusing on data modeling, SQL querying, stored procedures, triggers, and ACID-compliant transactions.
The goal is to design and implement a relational database for a simplified core banking system."

### Step 1: Create DataBase & Tables
## Project Structure
### 1. Database Setup
![ERD](https://github.com/PASUPULETIYUVARAJ3028/Banking-System-SQL-Project/blob/main/ER_diagram.png)

- **Database Creation**: Created a database named `banking_System`.
- **Table Creation**: Created tables for Customers, Accounts, and Transactions. Each table includes relevant columns and relationships.
```sql
-- Create the database
CREATE DATABASE banking_System;
-- Using the database
USE banking_System;

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    created_at DATE 
);

-- Create the Accounts table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type ENUM('Savings', 'Current') NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00 CHECK (balance >= 0),
    created_at DATE, 
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer') NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    transaction_date DATE, 
    reference_account_id INT DEFAULT NULL,  -- Used in case of transfer
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (reference_account_id) REFERENCES Accounts(account_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
```


### Step 2:  CRUD Operations

- **Create**: Inserted sample records into the tables.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the customer table.
- **Delete**: Removed records from the cusomter table as needed.

