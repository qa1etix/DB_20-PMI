SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

--Экран 1: Первое чтение баланса счета 2--
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

-- ЖДЕМ выполнения Окна 2...

--Экран 1: Второе чтение (значение изменилось!--
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

COMMIT;