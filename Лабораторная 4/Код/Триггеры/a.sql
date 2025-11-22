CREATE OR REPLACE FUNCTION process_call_transaction()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id BIGINT;
    v_city_id BIGINT;
    v_duration INTERVAL;
    v_call_date TIMESTAMP;
    v_cost_per_minute NUMERIC(10,2);
    v_call_cost NUMERIC(15,2);
    v_duration_minutes NUMERIC;
BEGIN
    v_user_id := NEW.user_id;
    v_city_id := NEW.city_id;
    v_duration := NEW.duration;
    v_call_date := NEW.call_date;

    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM v_call_date) >= 0 AND EXTRACT(HOUR FROM v_call_date) < 6 THEN ct.n_cost
            ELSE ct.d_cost
        END
    INTO v_cost_per_minute
    FROM city ct
    WHERE ct.city_id = v_city_id;

    v_duration_minutes := EXTRACT(EPOCH FROM v_duration) / 60;

    v_call_cost := v_duration_minutes * v_cost_per_minute;

    INSERT INTO transactions (A_ID, amount, transaction_type, transaction_date)
    VALUES (v_user_id, v_call_cost, 'expense', v_call_date);

    UPDATE accounts
    SET balance = balance - v_call_cost
    WHERE A_ID = v_user_id;

    UPDATE accounts
    SET debtor_status = true
    WHERE A_ID = v_user_id AND balance < 0;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_call_transaction
AFTER INSERT ON calls
FOR EACH ROW
EXECUTE FUNCTION process_call_transaction();

