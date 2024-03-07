-- UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

-- Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.


SELECT count(policy_holder_id) as member_count
FROM (
    SELECT   policy_holder_id, count(case_id) as call_count
    FROM     callers
    GROUP BY policy_holder_id
    HAVING   count(case_id) >= 3
) as call_records


-- my approach: 

SELECT   count(policy_holder_id) as member_count
FROM     callers
GROUP BY policy_holder_id
HAVING   count(case_id) >= 3


-- remarks: didnt realize the need the use subquery. also as the member count is 0; lead to some confusion.
