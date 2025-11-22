--Тестовые данные для триггеров

DELETE FROM calls;
DELETE FROM transactions;
DELETE FROM accounts;
DELETE FROM users;
DELETE FROM city;

ALTER SEQUENCE users_u_id_seq RESTART WITH 1;
ALTER SEQUENCE transactions_t_id_seq RESTART WITH 1;
ALTER SEQUENCE city_city_id_seq RESTART WITH 1;
ALTER SEQUENCE calls_call_id_seq RESTART WITH 1;

INSERT INTO city(city_name, d_cost, n_cost) values
('No city', 0.00, 0.00),
('СПб', 1.00, 2.00),
('Москва', 2.00, 3.00),
('Ярославль', 4.00, 5.00);

SELECT * FROM CITY;

INSERT INTO users(fio, city_id, inn, adress, legal_entity_name) values
('Иванов Иван Иванович', 2, '1234567890', 'СПб, ул. Гагарина, 3', NULL),
('Хлебов Григорий Анатольевич', 3, '1234567899', 'СПб, ул. Ленина, 5', NULL);

SELECT * FROM USERS;

INSERT INTO accounts(A_ID, balance, debtor_status) values
(1, 10, false),
(2, 100, false);

SELECT * FROM ACCOUNTS;

INSERT INTO CALLS(user_id, city_id, call_date, duration) values
(1, 1, CURRENT_TIMESTAMP - INTERVAL '1 day', '8 hours'), 
(2, 2, CURRENT_TIMESTAMP - INTERVAL '2 days', '15 minutes');
--Должно появиться 3 звонка и 3 транзакции...

SELECT * FROM CALLS;

SELECT * FROM TRANSACTIONS;

--B. Обновляем стоимость
UPDATE CITY 
SET d_cost = 0.02, n_cost = 0.02
WHERE city_id = 1

SELECT * FROM CITY
--C. Удаление населенного пункта
DELETE FROM city
WHERE city_id = 4

DELETE FROM CITY
WHERE city_id = 3

DELETE FROM CITY
WHERE city_id = 2


