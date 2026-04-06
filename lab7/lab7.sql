-- Daniel Narewski
-- 4/6/26
-- Lab 7: Transactions and ACID Basics

-- Setup
DROP TABLE IF EXISTS Accounts;

CREATE TABLE Accounts (
  account_id INT PRIMARY KEY,
  owner TEXT NOT NULL,
  balance INT NOT NULL CHECK (balance >= 0)
);

INSERT INTO Accounts (account_id, owner, balance) VALUES
(1, 'Ava', 500),
(2, 'Ben', 300),
(3, 'Cara', 200);

-- Part B: A successful transaction

-- 1. Query balances before
SELECT * FROM Accounts ORDER BY account_id;

-- 2. The Transaction
BEGIN;
UPDATE Accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE Accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

-- 3. Query balances after
SELECT * FROM Accounts ORDER BY account_id;

-- Part C: A rollback example

-- 1. Query balances before
SELECT * FROM Accounts ORDER BY account_id;

-- 2. The Transaction with Rollback
BEGIN;
UPDATE Accounts SET balance = balance - 50 WHERE account_id = 3;
ROLLBACK;

-- 3. Query balances after
SELECT * FROM Accounts ORDER BY account_id;
