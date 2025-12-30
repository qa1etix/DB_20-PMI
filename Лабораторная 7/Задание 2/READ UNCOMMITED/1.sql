SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;

UPDATE accounts SET balance = balance + 500 WHERE A_ID = 1;

SELECT A_ID, balance FROM accounts WHERE A_ID = 1;

-- ЖДЕМ выполнения Окна 2...
SELECT pg_sleep(5);

ROLLBACK;

SELECT A_ID, balance FROM accounts WHERE A_ID = 1;