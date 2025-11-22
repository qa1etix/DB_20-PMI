CREATE OR REPLACE PROCEDURE get_callers_to_city_via_temp_table(
    p_city_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS callers_result;
    
    CREATE TEMP TABLE callers_result AS
    SELECT DISTINCT
        u.U_ID,
        u.fio,
        c.call_date,
        c.duration,
        ct.city_name
    FROM calls c
    JOIN users u ON c.user_id = u.U_ID
    JOIN city ct ON c.city_id = ct.city_id
    WHERE ct.city_name = p_city_name
      AND c.call_date >= date_trunc('month', CURRENT_DATE)
    ORDER BY u.fio, c.call_date;
END;
$$;

CALL get_callers_to_city_via_temp_table('Москва');

SELECT * FROM callers_result;