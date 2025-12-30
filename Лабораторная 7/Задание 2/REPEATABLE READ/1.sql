SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

SELECT A_ID, balance FROM accounts WHERE debtor_status = true;

-- ЖДЕМ выполнения Окна 2

SELECT A_ID, balance FROM accounts WHERE debtor_status = true;

COMMIT;