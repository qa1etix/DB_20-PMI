SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

SELECT 'СЕАНС 1: Первое чтение баланса счета 2' as info;
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

-- ЖДЕМ выполнения Окна 2...
SELECT pg_sleep(5);

SELECT 'СЕАНС 1: Второе чтение (значение изменилось!)' as info;
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

COMMIT;