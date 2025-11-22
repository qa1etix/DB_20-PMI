CREATE OR REPLACE FUNCTION prevent_city_deletion_with_calls()
RETURNS TRIGGER AS $$
DECLARE
    v_call_count BIGINT;
BEGIN
    -- Добавлен оператор SELECT COUNT(*)
    SELECT COUNT(*)
    INTO v_call_count
    FROM calls
    WHERE city_id = OLD.city_id;

    IF v_call_count > 0 THEN
        RAISE EXCEPTION 'Невозможно удалить населенный пункт "%", так как с ним связаны звонки.', OLD.city_name;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER check_calls_before_city_delete
BEFORE DELETE ON city
FOR EACH ROW
EXECUTE FUNCTION prevent_city_deletion_with_calls();
