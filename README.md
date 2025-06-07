# Banking System Project using SQL

## Project Overview

**Project Title**: Banking System

This project showcases my SQL skills by developing a simplified core banking system banking system using SQL. It includes key tables such as Customers, Accounts, and Transactions.
In this project, I also created various database objects like views, stored procedures, and triggers, and performed data analysis to gain insights from the data.

![Bank](https://github.com/PASUPULETIYUVARAJ3028/Banking-System-SQL-Project/blob/main/bank-01-Converted-01-1024x428.png)

## Objective
This project demonstrates the implementation of a banking system using SQL. It includes the creation and management of tables, as well as the execution of CRUD operations.
The project simulates the back-end database logic of a real-world banking system, focusing on SQL querying, stored procedures, triggers, and view.
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

-- **Task 2:** Retrieved and displayed data from various tables.
```sql
-- Displaying 10 records from customers table
SELECT * FROM customers LIMIT 10;
-- Displaying 10 records from Accounts table
SELECT * FROM Accounts LIMIT 10;
-- Displaying 10 records from Transactions table
SELECT * FROM Transactions LIMIT 10;
```

-- **Task 3:** Updated records in the customer table.
```sql
-- Updating customer email in customer table.
-- old email - (email = 'megan.chang@example.com')
-- new email - (email = 'megan3028@gmail.com') 
UPDATE customers
SET
	email = 'megan3028@gmail.com'
WHERE
	customer_id = 1;
        
-- Displaying updated customer details using customer_id
SELECT * FROM customers WHERE customer_id = 1;

-- Saving modification in DB.
COMMIT;
```

-- **Task 4:** Removed records from the cusomter table as needed.
```sql
-- Deleting customer in customers table.
DELETE FROM customers WHERE customer_id = 2;
```

-- **step 3:** Data Analysis

-- **Task 5:** Get the total balance of a customer across all their accounts.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        SUM(a.balance) as total_amount
        
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
GROUP BY
		c.customer_id,
        customer_names;
```

-- **Task 6:** Find all transactions for a customer in the last 30 days.
```sql

-- last date in transcation
SELECT MAX(transaction_date) FROM Transactions;
-- Output: 2025-04-25

-- Removing 30 days from '2025-04-25'
SELECT '2025-04-25' - interval 30 day;
-- Output: 2025-03-26

-- Find all transactions for a customer in the last 30 days.
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        t.transaction_type,
        t.amount,
        t.transaction_date
        
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id

WHERE
	 t.transaction_date >= '2025-04-25' - interval 30 day;
```

--  **Task 7:** List customers who have more than one account.
``` sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        count(*) as No_of_accounts
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
GROUP BY
		c.customer_id,
        customer_names
HAVING
	No_of_accounts > 1;
```

-- **Task 8:** Retrieve customers with zero balance in all accounts.
``` sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
GROUP BY
		c.customer_id,
        customer_names
HAVING
		sum(a.balance) = 0;
```

-- **Task 9:** Get the highest balance account and the customer who owns it.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        ROUND(SUM(a.balance),0) as total_balance
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
GROUP BY
		c.customer_id,
        customer_names
ORDER BY
		total_balance DESC;
```

-- **Task 6:** List all transactions where the amount exceeds 10,000.
```sql
SELECT * FROM Transactions 
WHERE amount > 10000
ORDER BY amount DESC;
```

-- **Task 7:** Show the number of transactions per account.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.account_id,
        a.account_type,
        count(t.transaction_id) as no_of_transaction
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id
GROUP BY
		 c.customer_id,
         customer_names,
        a.account_id,
        a.account_type;
```

-- **Task 8:** Find the average balance of accounts by account type.
```sql
SELECT account_type, avg(balance) FROM Accounts
GROUP BY account_type;
```

-- **Task 9:** Get a list of all customers with their account balances.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.account_id,
        a.balance as previous_balance,
        t.transaction_type,
        t.amount,
        CASE 
			WHEN t.transaction_type = 'deposit' THEN (a.balance + t.amount)
            -- Transfer
            ELSE (a.balance - t.amount)
		END AS current_balance
            
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id;
```
-- **Task 10:** Find all transfers made from one account to another.
```sql
SELECT *
FROM Transactions
WHERE transaction_type = 'transfer';
```

-- **Task 11:** Count how many accounts each customer has.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        count(a.account_id) AS No_of_accounts
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
GROUP BY
		c.customer_id,customer_names;
```

-- **Task 12:** Get a report of total deposits and withdrawals per account.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.account_id,
        sum(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) as Total_deposits,
		sum(CASE WHEN t.transaction_type = 'withdrawal' THEN t.amount ELSE 0 END) as total_withdrawals,
		sum(CASE WHEN t.transaction_type = 'transfer' THEN t.amount ELSE 0 END) as total_transfer

FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id
GROUP BY
		 c.customer_id, customer_names,a.account_id;
```


-- **Task 13:** Retrieve customers who haven’t made any transactions.
```sql
SELECT  
		c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
		a.account_id,
        count(t.transaction_id) AS no_of_transaction
FROM
		accounts as a 
        LEFT JOIN Transactions as t
        ON
        a.account_id = t.account_id
        JOIN customers AS c
        ON 
        a.customer_id = c.customer_id 

GROUP BY
		a.account_id, c.customer_id, customer_names
HAVING
		count(t.transaction_id) = 0;
```

-- **Task 14:** Find customers who made a transaction today.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        t.transaction_date

FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id
WHERE
		 t.transaction_date = current_time();
```

-- **Task 15:** List the last 5 transactions for a specific account. example account_id = 1;
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.account_id,
        a.account_type,
        t.transaction_id
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
        join Transactions as t
        ON
        a.account_id = t.account_id
WHERE
		 a.account_id = 1;
```

-- **Task 16:** Get total number of customers created in the last 1 year.

```sql
SELECT
		COUNT(*) AS total_rows
FROM 
		customers
WHERE 
		created_at >= CURDATE() - INTERVAL 1 YEAR;
```

-- **Task 17:** Get accounts with no transactions at all.
```sql
SELECT
		a.account_id,
		a.account_type,
		t.transaction_id
FROM
		accounts as a LEFT JOIN Transactions as t
		ON
		a.account_id = t.account_id
WHERE
		t.transaction_id IS NULL;
```

-- **Task 18:** Find customers whose total balance is more than 50,000.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.balance
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
WHERE 
		a.balance >= 50000
GROUP BY
		c.customer_id, customer_names, a.balance;
```

-- **Task 19:** Get top 5 customers by total balance.
```sql
SELECT 
        c.customer_id,
        concat(c.first_name ,' ',c.last_name) as customer_names,
        a.balance
FROM
		customers AS c join accounts As a 
		ON
        c.customer_id = a.customer_id
ORDER BY
		a.balance DESC
LIMIT 5;
```

-- **Task 20:** Get total transaction volume per day for the past 7 days.
```sql
SELECT 
		transaction_date, SUM(amount) AS total_amount
FROM 
		Transactions
WHERE 
		transaction_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY 
		transaction_date;
```

### Step 4: Stored Procedures
```sql
DELIMITER $$
-- perform_transaction
CREATE PROCEDURE perform_transaction (
		IN t_transaction_id int,
        IN t_from_account_id int,
        IN t_transaction_type varchar(20),
        IN t_amount decimal(12,2),
        IN t_transaction_date date,
        IN t_to_account_id int
        )

BEGIN
DECLARE v_balance DECIMAL(15,2);
DECLARE v_count INT;

    -- Get current balance
    SELECT balance INTO v_balance FROM Accounts WHERE account_id = t_from_account_id;
    /*
		=> IF v_balance IS NULL THEN
				1. This checks if the variable v_balance is NULL.
				2. v_balance is likely a local variable (declared earlier) intended to hold a value from a query, such as a balance retrieved from a bank account table.
				3. If v_balance is NULL, it could mean that no such account exists or the query didn't return a result.

		=> SIGNAL SQLSTATE '45000'
			1. SIGNAL is used to raise a custom error/exception.
			2.'45000' is a generic SQLSTATE value used to signal an unhandled user-defined exception.
			3. This essentially halts execution and throws an error.
    */
    
    -- checking 'v_balance' is null or not. if 'v_balance' is null then account does not exist in accounts table.
	IF v_balance IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account does not exist';
	END IF;
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++
    -- checking to_account_id exist or not
    -- Check if account exists
    SELECT COUNT(*) INTO v_count FROM accountS WHERE account_id = t_to_account_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account does not exist';
    END IF;
    
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++

      -- Perform action based on type
    IF t_transaction_type  = 'deposit' THEN
        -- Update balance
        UPDATE Accounts SET balance = balance + t_amount WHERE account_id = t_from_account_id;

        -- Insert into transactions
        INSERT INTO Transactions 
        (transaction_id, account_id, transaction_type, amount, transaction_date, reference_account_id)
        VALUES 
        (t_transaction_id, t_from_account_id, t_transaction_type, t_amount,t_transaction_date,t_to_account_id);
-- ++++++++++++++++++++++++++++++++++++++++++++++++
	ELSEIF t_transaction_type = 'withdrawal' THEN
        -- Check balance
        IF v_balance < t_amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
        END IF;

        -- Update balance
        UPDATE Accounts SET balance = balance - t_amount WHERE account_id = t_from_account_id;

        -- Insert into transactions
         INSERT INTO Transactions 
        (transaction_id, account_id, transaction_type, amount, transaction_date, reference_account_id)
        VALUES 
        (t_transaction_id, t_from_account_id, t_transaction_type, t_amount,t_transaction_date,t_to_account_id);
-- ++++++++++++++++++++++++++++++++++++
       ELSEIF t_transaction_type = 'transfer' THEN
        -- Validate target account
        IF t_to_account_id IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Target account required for transfer';
        END IF;

        -- Check balance
        IF v_balance < t_amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance for transfer';
        END IF;

        -- Debit source account
        UPDATE Accounts SET balance = balance - t_amount WHERE account_id = t_from_account_id;

        -- Credit target account
        UPDATE Accounts SET balance = balance + t_amount WHERE account_id = t_to_account_id;

        -- Insert transaction
        INSERT INTO Transactions 
        (transaction_id, account_id, transaction_type, amount, transaction_date, reference_account_id)
        VALUES 
        (t_transaction_id, t_from_account_id, t_transaction_type, t_amount,t_transaction_date,t_to_account_id);
        
        
		ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid transaction type';
    END IF;

END $$

DELIMITER ;

CALL perform_transaction(36,3,'transfer',1000,'2025-05-31',1);

SELECT * FROM accounts WHERE account_id = 1;
SELECT * FROM accounts WHERE account_id = 3;
```

#### Step 5: Triggers

-- **Task 1:** checking referenced account exists or not & checking for sufficient balance on withdrawal.
```sql
DELIMITER $$

CREATE TRIGGER validate_transaction_before_insert

BEFORE INSERT ON Transactions
FOR EACH ROW

BEGIN
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_count INT;

    -- Check if the referenced account exists
   SELECT COUNT(*) INTO v_count 
    FROM Accounts 
    WHERE account_id = NEW.reference_account_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Account does not exist';
    END IF;

    -- Check for sufficient balance on withdrawal
    IF NEW.transaction_type = 'withdrawal' THEN
        -- Get the current balance
        SELECT balance INTO v_balance 
        FROM Accounts 
        WHERE account_id = NEW.reference_account_id;

        IF v_balance < NEW.amount THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'You have low balance';
        END IF;
    END IF;

END $$
DELIMITER ;


-- Task 2: transfering money between the customers

DELIMITER $$

CREATE TRIGGER amount_transfer_trigger
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.transaction_type = 'deposit' THEN
     -- credit source account
        UPDATE Accounts 
        SET balance = balance + NEW.amount 
        WHERE account_id = NEW.account_id;
                

    ELSEIF NEW.transaction_type = 'transfer' THEN
     -- credit source account
        UPDATE Accounts 
        SET balance = balance + NEW.amount 
        WHERE account_id = NEW.reference_account_id;
        
	-- -- Debit source account
		 UPDATE Accounts 
         SET balance = balance - NEW.amount 
         WHERE account_id = NEW.account_id;
    

    ELSEIF NEW.transaction_type = 'withdrawal' THEN
        UPDATE Accounts 
        SET balance = balance - NEW.amount 
        WHERE account_id = NEW.account_id;
        
    END IF;
END $$

DELIMITER ;


SELECT * FROM accounts WHERE account_id = 1;
SELECT * FROM accounts WHERE account_id = 3;
SELECT * FROM transactions;

drop trigger amount_transfer_trigger;

insert into transactions values (43,3,'deposit',100,'2025-05-31',1);
```

### Step 6: Create Views & Report

-- **Task 1:** View: Customer Account Summary
```sql
CREATE VIEW customer_account_summary  AS (
	SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    a.account_id,
    a.account_type,
    a.balance
FROM 
    Customers c
JOIN 
    Accounts a ON c.customer_id = a.customer_id
ORDER BY
	a.balance DESC
);

-- DROP VIEW customer_account_summary;
SELECT * FROM customer_account_summary;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++==
-- Task 2: View: Customer Total Balance

CREATE VIEW customer_total_balance AS (
	SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    a.account_id,
    a.account_type,
    sum(a.balance)
FROM 
    Customers c
JOIN 
    Accounts a ON c.customer_id = a.customer_id
GROUP BY
	c.customer_id,
    full_name,
    a.account_id,
    a.account_type
ORDER BY
	a.balance DESC
);

SELECT * FROM customer_total_balance;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Task 3: View: Transaction History with Customer Info
CREATE VIEW transaction_history_of_customer AS (
SELECT 
	a.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    t.account_id,
     a.account_type,
    t.transaction_id,
    t.transaction_date,
    t.transaction_type,
    t.amount
FROM 
    Transactions t
JOIN 
    Accounts a ON t.account_id = a.account_id
JOIN 
    Customers c ON a.customer_id = c.customer_id
);

SELECT * FROM transaction_history_of_customer;
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Task 4: CREATE VIEW daily_transaction_summary AS
CREATE VIEW daily_transaction_summary AS (
SELECT 
    transaction_date,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) AS total_deposit,
    SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS total_withdrawal,
    SUM(CASE WHEN transaction_type = 'transfer' THEN amount ELSE 0 END) AS total_transfer
FROM 
    Transactions
GROUP BY 
    transaction_date );

SELECT * FROM daily_transaction_summary;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Task 5: View: Transfer Details
CREATE VIEW transfer_details AS (
SELECT 
    t.transaction_id,
    t.transaction_date,
    t.amount,
    t.account_id AS from_account,
    t.reference_account_id AS to_account,
    c_from.customer_id AS from_customer_id,
    CONCAT(c_from.first_name, ' ', c_from.last_name) AS from_customer,
    c_to.customer_id AS to_customer_id,
    CONCAT(c_to.first_name, ' ', c_to.last_name) AS to_customer
FROM 
    Transactions t
JOIN 
    Accounts a_from ON t.account_id = a_from.account_id
JOIN 
    Customers c_from ON a_from.customer_id = c_from.customer_id
LEFT JOIN 
    Accounts a_to ON t.reference_account_id = a_to.account_id
LEFT JOIN 
    Customers c_to ON a_to.customer_id = c_to.customer_id
WHERE 
    t.transaction_type = 'transfer');

SELECT * FROM transfer_details;
```

### Project Summary:

This project involves building a simplified core banking system using SQL. It includes key components such as Customers, Accounts, and Transactions tables. The project demonstrates skills in creating and managing database structures, writing SQL queries, and developing objects like views, stored procedures, and triggers. It also includes basic data analysis to gain insights from the banking data.
