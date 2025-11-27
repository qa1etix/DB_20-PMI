--Создание представления
CREATE OR REPLACE VIEW users_mask as 
SELECT
	u_id,
	FIO,
	overlay(inn placing '***' from 5 for 10) as INN
	FROM users;

GRANT SELECT ON users_mask TO operator_;
REVOKE ALL ON users FROM operator_;

--Маскирование с RLS (Row level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY masked ON users FOR ALL TO operator_ USING(true);

CREATE OR REPLACE FUNCTION mask_users_data()
RETURNS TABLE(FIO TEXT, INN TEXT, CITY_ID BIGINT) AS $$
BEGIN
    IF pg_has_role(current_user, 'operator_', 'MEMBER') THEN
        RETURN QUERY
        SELECT
            u.FIO,
            overlay(u.INN placing '***' from 5 for 10) as INN,
            u.city_id
        FROM users u;
    ELSE 
        RETURN QUERY 
        SELECT 
            u.FIO, 
            u.INN, 
            u.CITY_ID
        FROM users u;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE VIEW users_mask_RLS AS SELECT * FROM mask_users_data();	
GRANT SELECT ON users_mask_RLS TO manager, operator_;