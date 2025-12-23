use [GraphSQL];

DELETE FROM lives_in;
DELETE FROM has_account;
DELETE FROM call_to_city;
DELETE FROM made_call;
DELETE FROM received_penalty;
DELETE FROM performed_transaction;
DELETE FROM Transactions;
DELETE FROM Calls;
DELETE FROM Penalties;
DELETE FROM Accounts;
DELETE FROM Users;
DELETE FROM City;
GO
--
DBCC CHECKIDENT ('City', RESEED, 0);
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Transactions', RESEED, 0);
DBCC CHECKIDENT ('Calls', RESEED, 0);
DBCC CHECKIDENT ('Penalties', RESEED, 0);
GO

--
IF NOT EXISTS (SELECT 1 FROM City WHERE city_name = N'Москва')
BEGIN
    INSERT INTO City (city_name, n_cost, d_cost) 
    VALUES (N'Москва', 2.50, 5.00);
END

IF NOT EXISTS (SELECT 1 FROM City WHERE city_name = N'Санкт-Петербург')
BEGIN
    INSERT INTO City (city_name, n_cost, d_cost) 
    VALUES (N'Санкт-Петербург', 2.00, 4.50);
END

IF NOT EXISTS (SELECT 1 FROM City WHERE city_name = N'Новосибирск')
BEGIN
    INSERT INTO City (city_name, n_cost, d_cost) 
    VALUES (N'Новосибирск', 1.50, 3.00);
END

--
DECLARE @MoscowId INT, @SpbId INT, @NovosibirskId INT;
SELECT @MoscowId = city_id FROM City WHERE city_name = N'Москва';
SELECT @SpbId = city_id FROM City WHERE city_name = N'Санкт-Петербург';
SELECT @NovosibirskId = city_id FROM City WHERE city_name = N'Новосибирск';

IF NOT EXISTS (SELECT 1 FROM Users WHERE inn = '1234567890')
BEGIN
    INSERT INTO Users (fio, inn, adress, legal_entity_name)
    VALUES (N'Иванов Иван Иванович', '1234567890', N'ул. Ленина, 1', N'ООО "Ромашка"');
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE inn = '0987654321')
BEGIN
    INSERT INTO Users (fio, inn, adress, legal_entity_name)
    VALUES (N'Петров Петр Петрович', '0987654321', N'пр. Мира, 10', NULL);
END
--
DECLARE @User1Id INT, @User2Id INT;
SELECT @User1Id = U_ID FROM Users WHERE inn = '1234567890';
SELECT @User2Id = U_ID FROM Users WHERE inn = '0987654321';

IF NOT EXISTS (SELECT 1 FROM Accounts WHERE A_ID = @User1Id)
BEGIN
    INSERT INTO Accounts (A_ID, balance, debtor_status)
    VALUES (@User1Id, 15000.00, 0);
END

IF NOT EXISTS (SELECT 1 FROM Accounts WHERE A_ID = @User2Id)
BEGIN
    INSERT INTO Accounts (A_ID, balance, debtor_status)
    VALUES (@User2Id, -5000.00, 1);
END

DECLARE @User1Id INT, @User2Id INT;
SELECT @User1Id = U_ID FROM Users WHERE inn = '1234567890';
SELECT @User2Id = U_ID FROM Users WHERE inn = '0987654321';

DECLARE @MoscowId INT, @SpbId INT, @NovosibirskId INT;
SELECT @MoscowId = city_id FROM City WHERE city_name = N'Москва';
SELECT @SpbId = city_id FROM City WHERE city_name = N'Санкт-Петербург';
SELECT @NovosibirskId = city_id FROM City WHERE city_name = N'Новосибирск';

--
INSERT INTO lives_in ($from_id, $to_id, since_date)
SELECT 
    (SELECT $node_id FROM Users WHERE U_ID = @User1Id),
    (SELECT $node_id FROM City WHERE city_id = @MoscowId),
    CAST('2020-01-15' AS DATE);

INSERT INTO lives_in ($from_id, $to_id, since_date)
SELECT 
    (SELECT $node_id FROM Users WHERE U_ID = @User2Id),
    (SELECT $node_id FROM City WHERE city_id = @SpbId),
    CAST('2021-03-20' AS DATE);

--
DECLARE @User1Id INT, @User2Id INT;
SELECT @User1Id = U_ID FROM Users WHERE inn = '1234567890';
SELECT @User2Id = U_ID FROM Users WHERE inn = '0987654321';

INSERT INTO has_account ($from_id, $to_id, opened_date)
SELECT 
    (SELECT $node_id FROM Users WHERE U_ID = @User1Id),
    (SELECT $node_id FROM Accounts WHERE A_ID = @User1Id),
    CAST('2020-01-20' AS DATE);

INSERT INTO has_account ($from_id, $to_id, opened_date)
SELECT 
    (SELECT $node_id FROM Users WHERE U_ID = @User2Id),
    (SELECT $node_id FROM Accounts WHERE A_ID = @User2Id),
    CAST('2021-03-25' AS DATE);

-- Транзакции
INSERT INTO Transactions (amount, transaction_type, transaction_date)
VALUES 
    (1000.00, 'income', CAST('2024-01-10 10:30:00' AS DATE)),
    (500.00, 'expense', CAST('2024-01-11 14:15:00' AS DATE)),
    (2000.00, 'income', CAST('2024-01-12 09:45:00' AS DATE)),
    (300.00, 'expense', CAST('2024-01-13 16:20:00' AS DATE));


DECLARE @User1Id INT, @User2Id INT;
SELECT @User1Id = U_ID FROM Users WHERE inn = '1234567890';
SELECT @User2Id = U_ID FROM Users WHERE inn = '0987654321';
-- Связь транзакций со счетами
INSERT INTO performed_transaction ($from_id, $to_id, transaction_purpose)
SELECT 
    a.$node_id,
    t.$node_id,
    CASE 
        WHEN t.transaction_type = 'income' THEN 'Пополнение счета'
        ELSE 'Оплата услуг'
    END
FROM Accounts a
CROSS JOIN Transactions t
WHERE a.A_ID IN (@User1Id, @User2Id)
AND t.T_ID BETWEEN 1 AND 4;

-- Звонки
INSERT INTO Calls (call_date, duration)
VALUES 
    (CAST('2024-01-10 08:15:00' AS DATE), CAST('00:05:30' AS TIME)),
    (CAST('2024-01-10 12:45:00' AS DATE), CAST('00:12:15' AS TIME)),
    (CAST('2024-01-11 09:30:00' AS DATE), CAST('00:03:45' AS TIME)),
    (CAST('2024-01-12 15:20:00' AS DATE), CAST('00:08:10' AS TIME)),
    (CAST('2024-01-13 11:10:00' AS DATE), CAST('00:15:25' AS TIME));


DECLARE @User1Id INT, @User2Id INT;
SELECT @User1Id = U_ID FROM Users WHERE inn = '1234567890';
SELECT @User2Id = U_ID FROM Users WHERE inn = '0987654321';
-- Связь звонков с пользователями
INSERT INTO made_call ($from_id, $to_id, call_cost)
SELECT 
    u.$node_id,
    c.$node_id,
    CASE 
        WHEN c.call_id % 2 = 0 THEN 10.50
        ELSE 7.25
    END
FROM Users u
CROSS JOIN Calls c
WHERE u.U_ID IN (@User1Id, @User2Id)
AND c.call_id BETWEEN 1 AND 5;


DECLARE @MoscowId INT, @SpbId INT, @NovosibirskId INT;
SELECT @MoscowId = city_id FROM City WHERE city_name = N'Москва';
SELECT @SpbId = city_id FROM City WHERE city_name = N'Санкт-Петербург';
SELECT @NovosibirskId = city_id FROM City WHERE city_name = N'Новосибирск';
-- Связь звонков с городами
INSERT INTO call_to_city ($from_id, $to_id, roaming)
SELECT 
    cl.$node_id,
    ct.$node_id,
    CASE 
        WHEN ct.city_id != @MoscowId THEN 1
        ELSE 0
    END
FROM Calls cl
CROSS JOIN City ct
WHERE cl.call_id BETWEEN 1 AND 5
AND ct.city_id IN (@MoscowId, @SpbId, @NovosibirskId);