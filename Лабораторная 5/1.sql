--Создание роли

CREATE ROLE manager WITH LOGIN
	PASSWORD '1234';
GO

CREATE ROLE operator_ WITH LOGIN
	PASSWORD '4321'
GO

GRANT CONNECT ON DATABASE lab TO Manager, operator_	

GRANT ALL PRIVILEGES ON TABLE users TO manager;
GRANT ALL PRIVILEGES ON TABLE accounts TO manager;

GRANT EXECUTE ON FUNCTION hello_func TO operator_;
REVOKE EXECUTE ON FUNCTION hello_func() FROM PUBLIC;

GRANT SELECT ON TABLE calls TO operator_;
GRANT SELECT ON TABLE city  TO operator_;

--Выбор роли
SET ROLE Manager;

SELECT * FROM city
SELECT * FROM users

SET ROLE operator_;

SELECT * FROM CITY;
SELECT * FROM CALLS;

RESET ROLE;

SELECT current_user, session_user;

SELECT 
    has_function_privilege('manager', 'hello_func()', 'EXECUTE') as manager_can_execute,
    has_function_privilege('operator_', 'hello_func()', 'EXECUTE') as operator_can_execute;

SELECT 
    has_function_privilege('public', 'hello_func()', 'EXECUTE') as public_can_execute;