USE [GraphSQL];
GO

DROP TABLE IF EXISTS Calls;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Penalties;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS made_call;
DROP TABLE IF EXISTS lives_in;
DROP TABLE IF EXISTS has_account;
DROP TABLE IF EXISTS performed_transaction;
DROP TABLE IF EXISTS received_penalty;
GO

CREATE TABLE City (
    city_id INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(100) NOT NULL,
    n_cost DECIMAL(10,2) NOT NULL,
    d_cost DECIMAL(10,2) NOT NULL
) AS NODE;
GO

CREATE TABLE Users (
    U_ID INT IDENTITY(1,1) PRIMARY KEY,
    fio NVARCHAR(200) NOT NULL,
    inn NVARCHAR(10) UNIQUE NOT NULL CHECK (LEN(inn) = 10),
    adress NVARCHAR(500) NOT NULL,
    legal_entity_name NVARCHAR(200) NULL
) AS NODE;
GO

CREATE TABLE Accounts (
    A_ID INT PRIMARY KEY,
    balance DECIMAL(15,2) DEFAULT 0.00,
    debtor_status BIT DEFAULT 0
) AS NODE;
GO

CREATE TABLE Transactions (
    T_ID INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type NVARCHAR(10) CHECK (transaction_type IN ('income', 'expense')),
    transaction_date DATETIME DEFAULT GETDATE()
) AS NODE;
GO

CREATE TABLE Calls (
    call_id INT IDENTITY(1,1) PRIMARY KEY,
    call_date DATETIME DEFAULT GETDATE(),
    duration TIME NOT NULL
) AS NODE;
GO

CREATE TABLE Penalties (
    penalty_id INT IDENTITY(1,1) PRIMARY KEY,
    penalty_date DATE NOT NULL,
    penalty_amount DECIMAL(15,2) NOT NULL
) AS NODE;
GO
--
CREATE TABLE lives_in (
    since_date DATE DEFAULT GETDATE()
) AS EDGE;
GO

CREATE TABLE has_account (
    opened_date DATE DEFAULT GETDATE()
) AS EDGE;
GO

CREATE TABLE performed_transaction (
    transaction_purpose NVARCHAR(200)
) AS EDGE;
GO

CREATE TABLE made_call (
    call_cost DECIMAL(10,2)
) AS EDGE;
GO

CREATE TABLE call_to_city (
    roaming BIT DEFAULT 0
) AS EDGE;
GO

CREATE TABLE received_penalty (
    reason NVARCHAR(500)
) AS EDGE;
GO