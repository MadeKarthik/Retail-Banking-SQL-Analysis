-- ======================================================================
-- DATABASE SETUP (tables created parents first; foreign keys are NOT unique)
-- ======================================================================
DROP DATABASE IF EXISTS retail_banking;
CREATE DATABASE retail_banking;
USE retail_banking;

CREATE TABLE branches (
  branch_id VARCHAR(10) PRIMARY KEY,
  branch_name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(30) NOT NULL,
  region VARCHAR(30) NOT NULL,
  opening_date DATE,
  employee_count INT DEFAULT 0
);

CREATE TABLE customers (
  customer_id VARCHAR(20) PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE,
  gender VARCHAR(20),
  city VARCHAR(50),
  state VARCHAR(30),
  customer_since DATE,
  kyc_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
  segment VARCHAR(30) NOT NULL,
  annual_income DECIMAL(12,2),
  credit_score INT,
  is_active VARCHAR(3) NOT NULL DEFAULT 'Yes'
);

CREATE TABLE accounts (
  account_id VARCHAR(20) PRIMARY KEY,
  customer_id VARCHAR(20) NOT NULL,
  branch_id VARCHAR(10) NOT NULL,
  account_type VARCHAR(30) NOT NULL,
  open_date DATE NOT NULL,
  close_date DATE NULL,
  current_balance DECIMAL(15,2) NOT NULL DEFAULT 0,
  interest_rate DECIMAL(5,2) DEFAULT 0,
  overdraft_limit DECIMAL(12,2) DEFAULT 0,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE cards (
  card_id VARCHAR(20) PRIMARY KEY,
  account_id VARCHAR(20) NOT NULL,
  card_type VARCHAR(20) NOT NULL,
  issue_date DATE,
  expiry_date DATE,
  credit_limit DECIMAL(12,2) DEFAULT 0,
  outstanding_balance DECIMAL(12,2) DEFAULT 0,
  reward_points INT DEFAULT 0,
  is_active VARCHAR(3) NOT NULL DEFAULT 'Yes',
  network VARCHAR(20),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE transactions (
  transaction_id VARCHAR(20) PRIMARY KEY,
  account_id VARCHAR(20) NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_time TIME,
  transaction_type VARCHAR(30) NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  channel VARCHAR(30),
  description VARCHAR(50),
  balance_after DECIMAL(15,2),
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
  loan_id VARCHAR(20) PRIMARY KEY,
  customer_id VARCHAR(20) NOT NULL,
  branch_id VARCHAR(10) NOT NULL,
  loan_type VARCHAR(30) NOT NULL,
  principal_amount DECIMAL(15,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  tenure_months INT NOT NULL,
  disbursement_date DATE,
  maturity_date DATE,
  emi_amount DECIMAL(12,2),
  outstanding_balance DECIMAL(15,2) DEFAULT 0,
  loan_status VARCHAR(30) NOT NULL,
  purpose VARCHAR(50),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE loan_payments (
  payment_id VARCHAR(20) PRIMARY KEY,
  loan_id VARCHAR(20) NOT NULL,
  payment_date DATE,
  scheduled_amount DECIMAL(12,2),
  paid_amount DECIMAL(12,2) DEFAULT 0,
  principal_paid DECIMAL(12,2) DEFAULT 0,
  interest_paid DECIMAL(12,2) DEFAULT 0,
  penalty DECIMAL(12,2) DEFAULT 0,
  days_late INT DEFAULT 0,
  payment_method VARCHAR(30),
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);
