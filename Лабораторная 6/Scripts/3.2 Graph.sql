
WITH debtors AS (
    SELECT 
        u.fio,
        u.inn,
        a.balance,
        a.debtor_status
    FROM 
        Users u,
        has_account ha,
        Accounts a
    WHERE 
        MATCH(u-(ha)->a)
        AND a.debtor_status = 1
)
SELECT TOP 5 *
FROM debtors
ORDER BY balance;

-- второй запрос
WITH avg_call_duration AS (
    SELECT AVG(DATEDIFF(SECOND, '00:00:00', duration)) as avg_seconds
    FROM Calls
),
user_calls AS (
    SELECT 
        u.fio,
        c.call_id,
        c.duration,
        c.call_date,
        DATEDIFF(SECOND, '00:00:00', c.duration) as duration_seconds,
        mc.call_cost
    FROM 
        Users u,
        made_call mc,
        Calls c
    WHERE 
        MATCH(u-(mc)->c)
)
SELECT TOP 5
    uc.fio,
    uc.call_id,
    uc.duration,
    uc.duration_seconds,
    uc.call_date,
    uc.call_cost,
    acd.avg_seconds as average_duration
FROM 
    user_calls uc,
    avg_call_duration acd
WHERE 
    uc.duration_seconds > acd.avg_seconds
ORDER BY 
    uc.duration_seconds DESC;