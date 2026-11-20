-- ======================================================================
-- SPRINT 4.5 - Understand Card Usage and Product Engagement
-- ======================================================================
-- Business objective: The bank wants to understand how customers use its card products and how card usage relates to their broader banking relationship.
-- Analytical questions:
--   1. How do Debit and Credit cards compare in number, limit, balance and points?
--   2. How many cards are active and how do networks compare?
--   3. Which customers hold multiple cards or products?
--   4. How many cards are expired?
--   5. Which account types carry the most cards and balances?
USE retail_banking;

-- Query 1 - Number of cards by card type
SELECT
    card_type,
    COUNT(*) AS total_cards
FROM cards
GROUP BY card_type
ORDER BY total_cards DESC;
-- Insight: Debit 358 (60%), Credit 242 (40%).

-- Query 2 - Active and inactive cards
SELECT
    is_active,
    COUNT(*) AS total_cards
FROM cards
GROUP BY is_active;
-- Insight: Only 37 of 600 cards (6%) are active.

-- Query 3 - Average credit limit by card type
SELECT
    card_type,
    ROUND(AVG(credit_limit), 2) AS average_credit_limit
FROM cards
GROUP BY card_type;
-- Insight: Credit average limit 24,295; Debit has no limit.

-- Query 4 - Total outstanding balance by card type
SELECT
    card_type,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding
FROM cards
GROUP BY card_type
ORDER BY total_outstanding DESC;
-- Insight: All 2.46M card debt is on Credit cards (~42% utilisation).

-- Query 5 - Reward points by card type
SELECT
    card_type,
    ROUND(AVG(reward_points), 2) AS average_reward_points,
    SUM(reward_points) AS total_reward_points
FROM cards
GROUP BY card_type
ORDER BY total_reward_points DESC;
-- Insight: Average points almost equal for Debit and Credit (~24.5k).

-- Query 6 - Card usage by network
SELECT
    network,
    COUNT(*) AS total_cards,
    SUM(CASE WHEN is_active = 'Yes' THEN 1 ELSE 0 END)
        AS active_cards
FROM cards
GROUP BY network
ORDER BY total_cards DESC;
-- Insight: Networks used equally; active rate 5.4% to 6.9%.

-- Query 7 - Identify customers with multiple cards
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(cd.card_id) AS total_cards
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN cards cd
    ON a.account_id = cd.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(cd.card_id) > 1
ORDER BY total_cards DESC;
-- Insight: 169 customers hold multiple cards; top holders have 11 and 12.

-- Query 8 - Identify customers using multiple banking products
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,

    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT cd.card_id) AS total_cards,
    COUNT(DISTINCT l.loan_id) AS total_loans

FROM customers c

LEFT JOIN accounts a
    ON c.customer_id = a.customer_id

LEFT JOIN cards cd
    ON a.account_id = cd.account_id

LEFT JOIN loans l
    ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

HAVING
    COUNT(DISTINCT a.account_id)
    + COUNT(DISTINCT cd.card_id)
    + COUNT(DISTINCT l.loan_id) > 1

ORDER BY total_accounts DESC;
-- Insight: 346 customers (69%) hold more than one product item (counts items, not product types).

-- Query 9 - Identify expired and valid cards
SELECT
    card_id,
    card_type,
    expiry_date,
    CASE
        WHEN expiry_date < (
            SELECT MAX(transaction_date)
            FROM transactions
        )
        THEN 'Expired'
        ELSE 'Valid'
    END AS card_status
FROM cards;
-- Insight: 445 cards (74%) expired, 155 valid (today = latest transaction_date).

-- Query 10 - Card usage across account types
SELECT
    a.account_type,
    cd.card_type,
    COUNT(cd.card_id) AS total_cards,
    ROUND(AVG(cd.outstanding_balance), 2)
        AS average_outstanding
FROM accounts a
JOIN cards cd
    ON a.account_id = cd.account_id
GROUP BY a.account_type, cd.card_type
ORDER BY total_cards DESC;
-- Insight: IRA and CD carry most cards; Checking fewest. Savings-linked credit cards have the highest average balance (12,369).
