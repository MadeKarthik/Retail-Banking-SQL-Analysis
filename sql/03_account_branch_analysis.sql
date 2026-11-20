-- ======================================================================
-- SPRINT 4.2 - Understand Account Usage and Branch Activity
-- ======================================================================
-- Business objective: The bank wants to understand how its accounts are being used and how account activity differs across account types and branches.
-- Analytical questions:
--   1. Which account types are most common and hold the most money?
--   2. How do interest rates differ by account type?
--   3. How are accounts and balances spread across branches?
--   4. How many accounts are active versus closed?
--   5. Which customers hold more than one account?
USE retail_banking;

-- Query 1 - Number of accounts by account type
SELECT
    account_type,
    COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type
ORDER BY total_accounts DESC;
-- Insight: Account types evenly used (103 to 136); IRA most common.

-- Query 2 - Average account balance by account type
SELECT
    account_type,
    ROUND(AVG(current_balance), 2) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY average_balance DESC;
-- Insight: CD (22,057) and IRA (21,279) have ~5x the balance of Savings and Checking.

-- Query 3 - Total balance by account type
SELECT
    account_type,
    ROUND(SUM(current_balance), 2) AS total_balance
FROM accounts
GROUP BY account_type;
-- Insight: IRA + CD hold 5.50M of 10.20M total balance (54%).

-- Query 4 - Account distribution across branches
SELECT
    b.branch_name,
    COUNT(a.account_id) AS total_accounts
FROM branches b
LEFT JOIN accounts a
    ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_accounts DESC;
-- Insight: Pittsburgh (28) and San Diego (27) lead; smallest branches have 9. Group by branch_id because names repeat.

-- Query 5 - Average balance across branches
SELECT
    b.branch_name,
    ROUND(AVG(a.current_balance), 2) AS average_balance
FROM branches b
JOIN accounts a
    ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY average_balance DESC;
-- Insight: Atlanta (27,885) is ~6x Omaha (4,629) in average balance.

-- Query 6 - Active and closed accounts
SELECT
    status,
    COUNT(*) AS total_accounts
FROM accounts
GROUP BY status;
-- Insight: 497 Active, 203 Closed (29% closed).

-- Query 7 - Average interest rate by account type
SELECT
    account_type,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate
FROM accounts
GROUP BY account_type
ORDER BY average_interest_rate DESC;
-- Insight: CD 4.62% highest, Checking 0.24% lowest; rate rises with balance.

-- Query 8 - Customers with multiple bank accounts
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(a.account_id) AS total_accounts
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY total_accounts DESC;
-- Insight: 211 customers (42%) hold 2+ accounts; 134 customers have no account.
