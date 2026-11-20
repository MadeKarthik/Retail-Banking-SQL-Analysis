-- ======================================================================
-- SPRINT 4.4 - Evaluate Loan Performance and Repayment Behaviour
-- ======================================================================
-- Business objective: The bank wants to understand how its loans are performing and whether customers are repaying their loans as expected.
-- Analytical questions:
--   1. Which loan types and purposes carry the most lending and exposure?
--   2. What is the status of the loan book?
--   3. How many payments are late, missed or pending, and what penalties result?
--   4. Which payment methods and branches show the most problems?
--   5. Which loans have repeated late payments?
USE retail_banking;

-- Query 1 - Number of loans by loan type
SELECT
    loan_type,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;
-- Insight: Education most common (64); Home least (42).

-- Query 2 - Total principal amount by loan type
SELECT
    loan_type,
    ROUND(SUM(principal_amount), 2) AS total_principal
FROM loans
GROUP BY loan_type
ORDER BY total_principal DESC;
-- Insight: Total lending 72.21M; Education is 22%.

-- Query 3 - Outstanding loan balance by loan type
SELECT
    loan_type,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding,
    ROUND(AVG(outstanding_balance), 2) AS average_outstanding
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding DESC;
-- Insight: 53.44M of 72.21M (74%) still outstanding; Home has highest average balance.

-- Query 4 - Loan status analysis
SELECT
    loan_status,
    COUNT(*) AS total_loans,
    ROUND(SUM(outstanding_balance), 2) AS outstanding_balance
FROM loans
GROUP BY loan_status
ORDER BY total_loans DESC;
-- Insight: Defaulted + In Arrears = 169 loans (56%) holding 39.17M (73% of outstanding). Only 65 Active.

-- Query 5 - Loan distribution by purpose
SELECT
    purpose,
    COUNT(*) AS total_loans,
    ROUND(AVG(principal_amount), 2) AS average_loan_amount
FROM loans
GROUP BY purpose
ORDER BY total_loans DESC;
-- Insight: Home Purchase has the largest average loan (259,769). Purpose and loan_type are recorded independently.

-- Query 6 - Identify late loan payments
SELECT
    payment_id,
    loan_id,
    payment_date,
    scheduled_amount,
    paid_amount,
    days_late,
    status
FROM loan_payments
WHERE days_late > 0
ORDER BY days_late DESC;
-- Insight: 500 of 2,000 payments late (avg 22.5 days, max 44). Some paid far above schedule (lump-sum).

-- Query 7 - Loan repayment performance
SELECT
    status,
    COUNT(*) AS total_payments,
    ROUND(SUM(scheduled_amount), 2) AS total_scheduled,
    ROUND(SUM(paid_amount), 2) AS total_paid
FROM loan_payments
GROUP BY status;
-- Insight: Only 573 (29%) paid on time; 468 missed (2.82M scheduled, 0 collected).

-- Query 8 - Total penalties by payment method
SELECT
    payment_method,
    COUNT(*) AS total_payments,
    ROUND(SUM(penalty), 2) AS total_penalties
FROM loan_payments
GROUP BY payment_method
ORDER BY total_penalties DESC;
-- Insight: Total penalties 93,961.47; Bank Transfer, Cash and Debit Card = 61%. Auto Debit and Online Banking lowest.

-- Query 9 - Branch-wise loan performance
SELECT
    b.branch_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.principal_amount), 2) AS total_principal,
    ROUND(SUM(l.outstanding_balance), 2) AS total_outstanding
FROM branches b
JOIN loans l
    ON b.branch_id = l.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_outstanding DESC;
-- Insight: Austin has largest exposure (2.89M); Jacksonville has 92% of principal still outstanding.

-- Query 10 - Customers with loans and their repayment details
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    l.loan_id,
    l.loan_type,
    l.outstanding_balance,
    COUNT(lp.payment_id) AS total_payments,
    SUM(CASE WHEN lp.days_late > 0 THEN 1 ELSE 0 END)
        AS late_payments
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id
LEFT JOIN loan_payments lp
    ON l.loan_id = lp.loan_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_id,
    l.loan_type,
    l.outstanding_balance
ORDER BY late_payments DESC;
-- Insight: One row per loan; 241 of 300 loans have at least one late payment.
