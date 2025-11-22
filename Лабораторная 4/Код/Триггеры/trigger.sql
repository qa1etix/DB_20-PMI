CREATE OR REPLACE FUNCTION split_calls_before_insert()
RETURNS TRIGGER AS $$
DECLARE
    v_call_start_time TIMESTAMP;
    v_call_end_time TIMESTAMP;
    v_boundary_00_time TIMESTAMP;
    v_boundary_06_time TIMESTAMP;
    v_duration_part1 INTERVAL;
    v_duration_part2 INTERVAL;
BEGIN
    v_call_start_time := NEW.call_date;
    v_call_end_time := NEW.call_date + NEW.duration;

    v_boundary_00_time := DATE_TRUNC('day', v_call_end_time);
    v_boundary_06_time := DATE_TRUNC('day', v_call_start_time) + INTERVAL '6 hours';

    IF v_call_start_time < v_boundary_00_time AND v_call_end_time > v_boundary_00_time THEN

        v_duration_part1 := v_boundary_00_time - v_call_start_time;
        v_duration_part2 := v_call_end_time - v_boundary_00_time;

        INSERT INTO calls (user_id, city_id, call_date, duration)
        VALUES (NEW.user_id, NEW.city_id, v_call_start_time, v_duration_part1);

        INSERT INTO calls (user_id, city_id, call_date, duration)
        VALUES (NEW.user_id, NEW.city_id, v_boundary_00_time, v_duration_part2);

        RETURN NULL;

    ELSIF v_call_start_time < v_boundary_06_time AND v_call_end_time > v_boundary_06_time THEN

        v_duration_part1 := v_boundary_06_time - v_call_start_time;
        v_duration_part2 := v_call_end_time - v_boundary_06_time;

        INSERT INTO calls (user_id, city_id, call_date, duration)
        VALUES (NEW.user_id, NEW.city_id, v_call_start_time, v_duration_part1);

        INSERT INTO calls (user_id, city_id, call_date, duration)
        VALUES (NEW.user_id, NEW.city_id, v_boundary_06_time, v_duration_part2);

        RETURN NULL;

    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER split_calls_before_insert_trigger
BEFORE INSERT ON calls
FOR EACH ROW
EXECUTE FUNCTION split_calls_before_insert();
