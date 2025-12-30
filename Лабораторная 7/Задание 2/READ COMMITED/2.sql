SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

--СЕАНС 2: Изменяем баланс счета 2--
UPDATE accounts SET balance = balance - 300 WHERE A_ID = 2;

--После изменения--
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

COMMIT;