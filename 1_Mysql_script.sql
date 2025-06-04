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

/*
	1.
	>> FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
		* This tells MySQL that the customer_id in the Accounts table must match a valid customer_id in the Customers table.
		* It prevents orphan records — you can't insert an account for a non-existent customer.
	2.
    >>ON DELETE CASCADE
		* If a customer is deleted from the Customers table, all their accounts will also be automatically deleted from the Accounts table.
		* Use Case Example: If a customer closes all relationships with the bank and their record is removed, this ensures their accounts are also cleaned up.
	3.
    >> ON UPDATE CASCADE
		* If a customer’s customer_id is updated (rare but possible, especially with custom IDs), then all related records in Accounts are automatically updated.
		* This keeps foreign key relationships intact if primary key values change.
*/

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

