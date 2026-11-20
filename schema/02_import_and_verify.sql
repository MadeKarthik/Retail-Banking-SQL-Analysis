USE retail_banking;

-- DATA IMPORT: use Workbench > Table Data Import Wizard for each CSV, in this order:
-- branches, customers, accounts, loans, transactions, cards, loan_payments.
-- If accounts.close_date fails on blank values, import with LOAD DATA instead (change the path):
-- LOAD DATA LOCAL INFILE 'C:/path/accounts.csv' INTO TABLE accounts
--   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
--   (account_id,customer_id,branch_id,account_type,open_date,@close_date,current_balance,interest_rate,overdraft_limit,status)
--   SET close_date = NULLIF(@close_date,'');

-- Verify the import (expected: 40, 500, 700, 300, 5000, 600, 2000)
SELECT 'branches' AS table_name, COUNT(*) AS total FROM branches
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL SELECT 'loans', COUNT(*) FROM loans
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL SELECT 'cards', COUNT(*) FROM cards
UNION ALL SELECT 'loan_payments', COUNT(*) FROM loan_payments;
