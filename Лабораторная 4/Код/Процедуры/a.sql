CREATE OR REPLACE PROCEDURE get_debtors_list_via_temp_table()
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS debtors_result;
    CREATE TEMP TABLE debtors_result AS
    SELECT 
        u.U_ID,
        u.fio,
        u.inn,
        u.adress,
        a.balance,
        a.debtor_status
    FROM users u
    JOIN accounts a ON u.U_ID = a.A_ID
    WHERE a.debtor_status = true
    ORDER BY u.fio;
END;
$$;

CALL get_debtors_list_via_temp_table();

SELECT * FROM debtors_result;
