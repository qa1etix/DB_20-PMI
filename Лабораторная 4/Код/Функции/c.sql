CREATE OR REPLACE FUNCTION get_debtors_last_call_summary()
RETURNS TABLE (
    fio TEXT,
    city_name TEXT,
    call_date DATE,
    total_duration INTERVAL,
    total_cost NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH DebtorStatusMoment AS (
        -- Находим момент, когда баланс абонента стал отрицательным
        SELECT
            t.A_ID,
            MIN(t.transaction_date) AS debt_start_moment
        FROM (
            SELECT
                A_ID,
                transaction_date,
                SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END)
                    OVER (PARTITION BY A_ID ORDER BY transaction_date) AS running_balance
            FROM transactions
        ) t
        WHERE t.running_balance < 0
        GROUP BY t.A_ID
    ),
    LastDebtCall AS (
        -- Находим последний звонок, сделанный до или в момент начала задолженности
        SELECT DISTINCT ON (ds.A_ID)
            ds.A_ID,
            c.city_id,
            c.call_date,
            c.duration
        FROM DebtorStatusMoment ds
        JOIN calls c ON ds.A_ID = c.user_id
        WHERE c.call_date <= ds.debt_start_moment
        ORDER BY ds.A_ID, c.call_date DESC
    ),
    DebtorDetails AS (
        -- Собираем информацию о должниках и их последнем звонке
        SELECT
            u.fio,
            ldc.call_date,
            ldc.duration,
            ldc.city_id
        FROM users u
        JOIN accounts a ON u.U_ID = a.A_ID
        JOIN LastDebtCall ldc ON u.U_ID = ldc.A_ID
        WHERE a.debtor_status = true
    )
    -- Финальный запрос, который агрегирует данные
    SELECT
        dd.fio,
        ct.city_name,
        DATE(dd.call_date),
        SUM(dd.duration),
        SUM(EXTRACT(EPOCH FROM dd.duration) / 60 * ct.n_cost)
    FROM DebtorDetails dd
    JOIN city ct ON dd.city_id = ct.city_id
    GROUP BY
        dd.fio,
        ct.city_name,
        DATE(dd.call_date)
    ORDER BY
        dd.fio,
        DATE(dd.call_date);
END;
$$;

SELECT * FROM get_debtors_last_call_summary();

