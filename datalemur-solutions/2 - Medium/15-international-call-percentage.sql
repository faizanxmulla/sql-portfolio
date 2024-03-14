-- A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

-- What percentage of phone calls are international? Round the result to 1 decimal.

-- Assumption:
-- The caller_id in phone_info table refers to both the caller and receiver.



SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE caller.country_id <> receiver.country_id) / COUNT(*), 1) AS international_calls_pct
FROM   phone_calls AS calls LEFT JOIN phone_info AS caller ON calls.caller_id = caller.caller_id
                            LEFT JOIN phone_info AS receiver ON calls.receiver_id = receiver.caller_id


-- other approaches: SUM CASE

-- remarks: should have figured out on own to use the LEFT joins.