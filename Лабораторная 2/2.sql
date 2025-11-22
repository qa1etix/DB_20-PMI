drop table if exists calls cascade;
drop table if exists transactions cascade;
drop table if exists accounts cascade;
drop table if exists city cascade;
drop table if exists users cascade;

CREATE table city
(
   city_id bigint generated always as identity primary key,
   city_name TEXT not null,
   n_cost numeric(10,2) not null,
   d_cost numeric(10,2) not null
);

CREATE TABLE users
(
   U_ID bigint generated always as identity primary key,
   fio text not null,
   inn text check (length(inn) = 10) not null unique,
   adress text not null,
   legal_entity_name text,
   city_id bigint DEFAULT(1),
   foreign key (city_id) references city(city_id) ON DELETE SET DEFAULT
);

create table accounts
(
   A_ID bigint primary key,
   balance numeric(15,2) default(0.00),
   debtor_status boolean default(false),
   foreign key (A_ID) references users(U_ID)
);

create table transactions
(
   T_ID bigint generated always as identity primary key,
   A_ID bigint not null,
   amount numeric(15,2) not null,
   transaction_type text check (transaction_type in ('income', 'expense')),
   transaction_date timestamp default(current_timestamp),
   foreign key (A_ID) references accounts(A_ID)
);

CREATE table calls
(
   call_id bigint generated always as identity primary key,
   user_id bigint not null,
   city_id bigint DEFAULT(1) not null,
   call_date timestamp default(current_timestamp),
   duration interval not null,
   foreign key (city_id) references city(city_id) ON DELETE SET DEFAULT,
   foreign key (user_id) references users(U_ID)
);

--Больше не используется
CREATE TABLE penalties (
    penalty_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id bigint NOT NULL,
    penalty_date date NOT NULL,
    penalty_amount numeric(15,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(U_ID)
);