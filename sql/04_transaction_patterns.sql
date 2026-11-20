-- ======================================================================
-- SPRINT 4.3 - Analyze Transaction Patterns
-- ======================================================================
-- Business objective: The bank wants to understand how customers use their accounts and how money moves through the banking system.
-- Analytical questions:
--   1. Which transaction types and channels are most common?
--   2. How large are transactions by type and channel?
--   3. What are customers paying for (descriptions)?
--   4. How does activity move over time?
--   5. Which accounts and account types are most active?
USE retail_banking;

-- Query 1 - Number of transactions by transaction type
SELECT
    transaction_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;
-- Insight: Six types almost equally frequent (784 to 858).

-- Query 2 - Transaction volume by channel
SELECT
    channel,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY channel
ORDER BY total_transactions DESC;
-- Insight: Online 1,470 is busiest; Online + Mobile = half of all transactions.

-- Query 3 - Total transaction amount by channel
SELECT
    channel,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
WHERE status = 'Completed'
GROUP BY channel
ORDER BY total_amount DESC;
-- Insight: Online moves 31.5% of the 10.98M completed value.

-- Query 4 - Average transaction amount by type
SELECT
    transaction_type,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
WHERE status = 'Completed'
GROUP BY transaction_type
ORDER BY average_amount DESC;
-- Insight: Credit averages ~40% more than debits; Fee and Interest averages are unusually large, validate.

-- Query 5 - Monthly transaction trends
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;
-- Insight: Completed value grew 39% from 2022 (2.92M) to 2024 (4.07M); Sep 2024 peak, Apr 2024 low. Months before 2022 are very thin.

-- Query 6 - Most common transaction descriptions
SELECT
    description,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY description
ORDER BY total_transactions DESC
LIMIT 10;
-- Insight: Investment and Utility = 54% of transactions; only 7 descriptions exist.

-- Query 7 - Top 10 accounts by transaction activity
SELECT
    account_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_amount
FROM transactions
WHERE status = 'Completed'
GROUP BY account_id
ORDER BY total_transactions DESC
LIMIT 10;
-- Insight: Most active accounts have only 6 to 7 completed transactions; activity is widely spread.

-- Query 8 - Transaction activity by account type
SELECT
    a.account_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_transaction_amount,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
WHERE t.status = 'Completed'
GROUP BY a.account_type
ORDER BY total_transactions DESC;
-- Insight: IRA is most active (2.49M); Checking lowest in value and average size.
