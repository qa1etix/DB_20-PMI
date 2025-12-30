SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

SELECT 'СЕАНС 2: Изменяем баланс счета 2' as info;
UPDATE accounts SET balance = balance - 300 WHERE A_ID = 2;

SELECT 'После изменения:' as info;
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

COMMIT;