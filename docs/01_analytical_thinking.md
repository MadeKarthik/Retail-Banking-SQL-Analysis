# Sprint 1.4 - Analytical Thinking (no SQL, logical answers)

| # | Question | Tables and logic |
|---|----------|------------------|
| 1 | Customers and segment | `customers` (customer_id, names, segment, kyc_status, is_active). One table; group by segment. |
| 2 | Customers with more than 1 account | `customers` + `accounts` on customer_id; count accounts per customer, keep count > 1. |
| 3 | Compare branch accounts | `branches` + `accounts` on branch_id; compare counts, balances, status per branch. |
| 4 | Account usage via transactions | `accounts` + `transactions` on account_id; aggregate count and value per account/type/customer. |
| 5 | Common transaction types/channels | `transactions` only (transaction_type, channel, status); count by type and channel. |
| 6 | Customers with loans | `customers` + `loans` on customer_id (loan_type, purpose, loan_status). |
| 7 | On-time loan payments | `loans` + `loan_payments` on loan_id (scheduled_amount, paid_amount, days_late, penalty, status). |
| 8 | Loan performance by branch | `branches` + `loans` (branch_id) + `loan_payments` (loan_id); group by branch. |
| 9 | Customers with cards | `customers` + `accounts` (customer_id) + `cards` (account_id); cards link to customers only through accounts. |
| 10 | Multi-product usage | Start from `customers`; LEFT JOIN accounts, cards (via accounts) and loans; count each per customer. |
