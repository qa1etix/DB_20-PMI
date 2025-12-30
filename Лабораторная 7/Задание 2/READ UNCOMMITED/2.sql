SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;

SELECT 'Транзакция 2: Читаем баланс счета 1' as info;
SELECT A_ID, balance FROM accounts WHERE A_ID = 1;
-- Результат: 1000₽ (не видит изменения первой транзакции!)

-- 2. Уменьшаем баланс на 50 (отталкиваясь от 1000)
UPDATE accounts SET balance = balance - 50 WHERE A_ID = 1;

-- 3. Видим 950₽
SELECT 'После -50:' as info;
SELECT A_ID, balance FROM accounts WHERE A_ID = 1;

COMMIT;