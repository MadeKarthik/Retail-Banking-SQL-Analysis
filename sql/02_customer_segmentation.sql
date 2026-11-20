-- ======================================================================
-- SPRINT 4.1 - Understand Customer Profile and Segmentation
-- ======================================================================
-- Business objective: The bank wants to understand its customer base and identify differences between customer groups.
-- Analytical questions:
--   1. How is the customer base split across segments, genders and states?
--   2. Do income and credit score differ between segments?
--   3. How many customers are KYC verified and how many are active?
--   4. How long have customers been with the bank?
USE retail_banking;

-- Query 1 - Total customers in each segment
SELECT
    segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;
-- Insight: Student is largest (100); other segments are close in size (73 to 97).

-- Query 2 - Gender distribution
SELECT
    gender,
    COUNT(*) AS total_customers
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;
-- Insight: Roughly balanced: Male 190, Non-binary 156, Female 154.

-- Query 3 - Customers by state
SELECT
    state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC;
-- Insight: CA (92) and TX (58) hold 30% of customers.

-- Query 4 - Average annual income by customer segment
SELECT
    segment,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers
GROUP BY segment
ORDER BY average_income DESC;
-- Insight: Income differs only ~13% between segments; segments are not income-driven.

-- Query 5 - Average credit score by segment
SELECT
    segment,
    ROUND(AVG(credit_score), 2) AS average_credit_score
FROM customers
GROUP BY segment
ORDER BY average_credit_score DESC;
-- Insight: All segments average 679 to 687; credit quality is similar.

-- Query 6 - KYC status analysis
SELECT
    kyc_status,
    COUNT(*) AS total_customers
FROM customers
GROUP BY kyc_status;
-- Insight: Only 143 (28.6%) verified; 105 failed KYC.

-- Query 7 - Active vs inactive customers
SELECT
    is_active,
    COUNT(*) AS total_customers
FROM customers
GROUP BY is_active;
-- Insight: 375 active, 125 inactive; every Failed-KYC customer is inactive.

-- Query 8 - Customer tenure analysis
SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, customer_since,
            (SELECT MAX(transaction_date) FROM transactions))
        ), 2
    ) AS average_customer_tenure_years
FROM customers;
-- Insight: Average tenure is 6.89 years (to the latest transaction date).
