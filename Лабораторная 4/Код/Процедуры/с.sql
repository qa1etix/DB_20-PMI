CREATE OR REPLACE PROCEDURE get_cities_with_most_calls_cursor(
    p_target_date DATE,
    INOUT p_result_cursor refcursor
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_result_cursor FOR
    WITH city_call_counts AS (
        SELECT 
            ct.city_name,
            COUNT(c.call_id) as call_count
        FROM calls c
        JOIN city ct ON c.city_id = ct.city_id
        WHERE DATE(c.call_date) = p_target_date
        GROUP BY ct.city_name
    )
    SELECT city_name
    FROM city_call_counts
    WHERE call_count = (SELECT MAX(call_count) FROM city_call_counts);
END;
$$;

CALL get_city_with_most_calls('2024-01-10', NULL);


