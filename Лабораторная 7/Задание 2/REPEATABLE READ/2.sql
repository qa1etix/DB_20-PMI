SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

SELECT A_ID, balance, debtor_status FROM accounts WHERE A_ID = 2;

UPDATE accounts SET debtor_status = true WHERE A_ID = 2;

SELECT A_ID, balance, debtor_status FROM accounts WHERE A_ID = 2;

COMMIT;