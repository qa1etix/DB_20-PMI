CREATE OR REPLACE FUNCTION hello_func()
RETURNS text
language sql
IMMUTABLE
COST 1
AS $$
	SELECT 'Hello!';
	$$;

SELECT hello_func();
