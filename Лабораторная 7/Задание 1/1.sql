-- Тестовые данные
TRUNCATE TABLE city, users, accounts, transactions, calls RESTART IDENTITY CASCADE;

INSERT INTO city (city_name, n_cost, d_cost) VALUES 
('Москва', 1.50, 2.50);

INSERT INTO users (fio, inn, adress, legal_entity_name) VALUES
('Иванов Иван Иванович', '1234567890', 'ул. Ленина, 1', NULL),
('Петров Петр Петрович', '0987654321', 'ул. Пушкина, 10', 'ООО "Ромашка"');

INSERT INTO accounts (A_ID, balance, debtor_status) VALUES
(1, 1000.00, false),
(2, 500.00, false);

SELECT * FROM accounts ORDER BY A_ID;
-- 2. Начинаем транзакцию
BEGIN;

-- 3. Делаем перевод между счетами
UPDATE accounts SET balance = balance - 200 WHERE A_ID = 1;
UPDATE accounts SET balance = balance + 200 WHERE A_ID = 2;

SELECT * FROM accounts ORDER BY A_ID;

-- 4. ОТКАТ транзакции
ROLLBACK;

SELECT * FROM accounts ORDER BY A_ID;

-- 5. Новая транзакция с точкой сохранения
BEGIN;

-- Точка сохранения S1
SAVEPOINT S1;
UPDATE accounts SET balance = balance - 300 WHERE A_ID = 1;

SELECT * FROM accounts WHERE A_ID = 1;

-- Откат к S1
ROLLBACK TO S1;

SELECT * FROM accounts WHERE A_ID = 1;

-- Точка сохранения S2
SAVEPOINT S2;
UPDATE accounts SET balance = balance - 150 WHERE A_ID = 1;
UPDATE accounts SET balance = balance + 150 WHERE A_ID = 2;

SELECT * FROM accounts ORDER BY A_ID;

-- 6. ФИКСАЦИЯ транзакции
COMMIT;

SELECT * FROM accounts ORDER BY A_ID;