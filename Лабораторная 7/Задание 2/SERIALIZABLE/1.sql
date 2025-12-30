SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;

--СЕАНС 1: Читаем баланс--
SELECT A_ID, balance FROM accounts WHERE A_ID = 2;

-- ЖДЕМ выполнения Окна 2

-- Пытаемся изменить данные
UPDATE accounts SET balance = balance + 100 WHERE A_ID = 2;
--Ловим блок

COMMIT;