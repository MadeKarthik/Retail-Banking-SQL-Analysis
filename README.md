# Retail Banking Transaction Analysis - MySQL

Business analytics project on a retail banking database, written in MySQL.
"Today" is the latest `transaction_date` in the data (2025-02-22).

## Project Structure
```
Retail-Banking-SQL-Analysis/
├── README.md
├── schema/
│   ├── 01_create_tables.sql          # database + 7 tables
│   └── 02_import_and_verify.sql      # CSV import notes + row-count check
├── data/
│   └── README.md                     # CSV files and expected row counts
├── sql/
│   ├── 01_data_exploration.sql       # Sprint 3  - basic analysis
│   ├── 02_customer_segmentation.sql  # Sprint 4.1 - customer profile
│   ├── 03_account_branch_analysis.sql# Sprint 4.2 - accounts and branches
│   ├── 04_transaction_patterns.sql   # Sprint 4.3 - transactions
│   ├── 05_loan_performance.sql       # Sprint 4.4 - loans and repayment
│   └── 06_card_usage.sql             # Sprint 4.5 - cards and products
└── docs/
    ├── 01_analytical_thinking.md     # Sprint 1.4
    └── 02_conclusions_and_recommendations.md
```

## Database Tables
branches, customers, accounts, cards, transactions, loans, loan_payments

## How to Run
1. Open MySQL Workbench
2. Run `schema/01_create_tables.sql`
3. Import the CSVs (see `data/README.md`), then run `schema/02_import_and_verify.sql`
4. Run the files in `sql/` in order

## Key Findings
- Only 29% of customers are KYC verified
- 56% of loans are Defaulted or In Arrears (73% of outstanding balance)
- Only 29% of loan payments are on time
- 74% of cards are expired and only 6% are active
- IRA and CD accounts hold 54% of all balances

## Tools
MySQL, MySQL Workbench
