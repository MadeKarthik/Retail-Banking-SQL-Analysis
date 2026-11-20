-- ======================================================================
-- SPRINT 3 - BASIC ANALYSIS / DATA EXPLORATION
-- ======================================================================
USE retail_banking;

-- Question 11 - What is the total number of customers?
SELECT COUNT(*) FROM customers;
-- Result: 500 customers.

-- Question 12 - What is the total number of accounts?
SELECT COUNT(*) FROM accounts;
-- Result: 700 accounts.

-- Question 13 - What are the different account types available?
SELECT DISTINCT account_type
FROM accounts
ORDER BY account_type;
-- Result: 6 account types.

-- Question 14 - How many customers are currently active?
SELECT COUNT(*) AS active_customers
FROM customers
WHERE is_active = 'Yes';
-- Result: 375 of 500 customers are active.

-- Question 15 - What are the different transaction types available?
SELECT DISTINCT transaction_type
FROM transactions
ORDER BY transaction_type;
-- Result: 6 transaction types.

-- Question 16 - What is the total amount of completed transactions?
SELECT
    SUM(amount) AS total_completed_transaction_amount
FROM transactions
WHERE status = 'Completed';
-- Result: 10,976,552.36 (only Completed transactions moved money).

-- Question 17 - What are the different loan types available?
SELECT DISTINCT loan_type
FROM loans
ORDER BY loan_type;
-- Result: 6 loan types.

-- Question 18 - What is the total number of loans?
SELECT COUNT(*) AS total_loans
FROM loans;
-- Result: 300 loans.

-- Question 19 - What are the different card types available?
SELECT DISTINCT card_type
FROM cards
ORDER BY card_type;
-- Result: Credit and Debit.

-- Question 20 - What is the total outstanding loan balance?
SELECT
    SUM(outstanding_balance) AS total_outstanding_balance
FROM loans;
-- Result: 53,441,891.25 outstanding.
