CREATE OR REPLACE FUNCTION update_debtor_balances()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id BIGINT;
    v_total_old_cost NUMERIC(15,2);
    v_total_new_cost NUMERIC(15,2);
BEGIN
    -- Проверяем, изменились ли d_cost или n_cost
    IF OLD.d_cost IS DISTINCT FROM NEW.d_cost OR OLD.n_cost IS DISTINCT FROM NEW.n_cost THEN
        
        -- Временная таблица для хранения пересчётов
        CREATE TEMPORARY TABLE temp_balance_corrections (
            user_id BIGINT,
            balance_change NUMERIC(15,2)
        );

        -- Вычисляем изменения баланса для каждого должника в изменённом городе
        INSERT INTO temp_balance_corrections (user_id, balance_change)
        SELECT
            c.user_id,
            SUM(
                -- Вычисляем разницу старой и новой стоимости
                (EXTRACT(EPOCH FROM c.duration) / 60) * 
                CASE
                    WHEN EXTRACT(HOUR FROM c.call_date) < 6 THEN OLD.n_cost - NEW.n_cost
                    ELSE OLD.d_cost - NEW.d_cost
                END
            ) AS balance_change
        FROM
            calls c
        WHERE
            c.city_id = NEW.city_id
            AND c.user_id IN (SELECT A_ID FROM accounts WHERE debtor_status = TRUE)
        GROUP BY
            c.user_id;

        -- Обновляем балансы на основе вычислений из временной таблицы
        UPDATE accounts
        SET balance = accounts.balance + tbc.balance_change
        FROM temp_balance_corrections tbc
        WHERE accounts.A_ID = tbc.user_id;

        -- Обновляем статус должника
        UPDATE accounts
        SET debtor_status = (balance < 0);

        -- Удаляем временную таблицу
        DROP TABLE temp_balance_corrections;

    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recompute_debtor_balances
AFTER UPDATE OF n_cost, d_cost ON city
FOR EACH ROW
EXECUTE FUNCTION update_debtor_balances();
