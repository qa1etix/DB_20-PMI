CREATE OR REPLACE FUNCTION calculate_penalty_by_user(
    p_user_id BIGINT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_debt_start_date DATE;
    v_days_overdue INTEGER;
    v_penalty_amount NUMERIC := 0.00;
    v_N NUMERIC;
    v_a1 NUMERIC := 1.0; 
    v_d NUMERIC := 0.1;  
BEGIN
    SELECT MIN(DATE(t.transaction_date))
    INTO v_debt_start_date
    FROM transactions t
    JOIN accounts a ON t.A_ID = a.A_ID
    WHERE a.A_ID = p_user_id
      AND a.debtor_status = true;

    IF v_debt_start_date IS NULL THEN
        RETURN 0.00;
    END IF;
    v_days_overdue := (CURRENT_DATE - v_debt_start_date) - 3;

  
    IF v_days_overdue > 0 THEN
        v_N := v_days_overdue;
        -- S_N = N/2 * (2*a1 + (N-1)*d)
        v_penalty_amount := (v_N / 2.0) * (2.0 * v_a1 + (v_N - 1.0) * v_d);
    END IF;

    RETURN v_penalty_amount;
END;
$$;

SELECT * FROM ACCOUNTS;
SELECT calculate_penalty_by_user(7);