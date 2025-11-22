CREATE OR REPLACE PROCEDURE calculate_avg_calls_per_day()
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS avg_calls_per_city;

    CREATE TEMPORARY TABLE avg_calls_per_city (
        city_id BIGINT PRIMARY KEY,
        avg_daily_calls NUMERIC(10, 2)
    );

    INSERT INTO avg_calls_per_city (city_id, avg_daily_calls)
    SELECT
        c.city_id,
        COALESCE(AVG(daily_counts.call_count), 0)
    FROM
        city c
    LEFT JOIN (
        SELECT
            city_id,
            DATE_TRUNC('day', call_date) AS call_day,
            COUNT(call_id) AS call_count
        FROM
            calls
        GROUP BY
            city_id, call_day
    ) AS daily_counts ON c.city_id = daily_counts.city_id
    GROUP BY
        c.city_id;

    COMMIT;
END;
$$;

CREATE OR REPLACE PROCEDURE identify_high_call_days()
LANGUAGE plpgsql
AS $$
BEGIN
    CALL calculate_avg_calls_per_day();

    DROP TABLE IF EXISTS high_call_days_report;

    CREATE TABLE high_call_days_report (
        report_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        city_id BIGINT NOT NULL,
        city_name TEXT NOT NULL,
        call_date DATE NOT NULL,
        daily_calls_count BIGINT NOT NULL,
        avg_daily_calls NUMERIC(10, 2) NOT NULL
    );

    INSERT INTO high_call_days_report (city_id, city_name, call_date, daily_calls_count, avg_daily_calls)
    SELECT
        dc.city_id,
        ci.city_name,
        dc.call_day::DATE,
        dc.call_count,
        ac.avg_daily_calls
    FROM
        (
            SELECT
                city_id,
                DATE_TRUNC('day', call_date) AS call_day,
                COUNT(call_id) AS call_count
            FROM
                calls
            GROUP BY
                city_id, call_day
        ) AS dc
    JOIN
        avg_calls_per_city ac ON dc.city_id = ac.city_id
    JOIN
        city ci ON dc.city_id = ci.city_id
    WHERE
        dc.call_count > ac.avg_daily_calls;
    COMMIT;
END;
$$;

CALL identify_high_call_days();
SELECT * FROM high_call_days_report