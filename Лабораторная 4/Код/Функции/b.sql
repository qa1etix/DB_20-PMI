CREATE OR REPLACE FUNCTION get_cities_without_calls(
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS TABLE (
    city_name TEXT
)
LANGUAGE sql
AS $$
    SELECT c.city_name
    FROM city c
    WHERE c.city_id NOT IN (
        SELECT DISTINCT city_id
        FROM calls
        WHERE call_date BETWEEN p_start_date AND p_end_date
    );
$$;

SELECT * FROM get_cities_without_calls('2024-01-01 00:00:00', '2024-01-10 23:59:59');
