### Problem Statement

Write a SQL to determine phone numbers that satisfy below conditions:

1. the numbers have both incoming and outgoing calls

2. the sum of duration of outgoing calls should be greater than the sum of duration of incoming calls.


### Schema Setup

```sql
CREATE TABLE call_details (
    call_type VARCHAR(10),
    call_number VARCHAR(12),
    call_duration INT
);

INSERT INTO call_details (call_type, call_number, call_duration) VALUES
('OUT', '181868', 13),
('OUT', '2159010', 8),
('OUT', '2159010', 178),
('SMS', '4153810', 1),
('OUT', '2159010', 152),
('OUT', '9140152', 18),
('SMS', '4162672', 1),
('SMS', '9168204', 1),
('OUT', '9168204', 576),
('INC', '2159010', 5),
('INC', '2159010', 4),
('SMS', '2159010', 1),
('SMS', '4535614', 1),
('OUT', '181868', 20),
('INC', '181868', 54),
('INC', '218748', 20),
('INC', '2159010', 9),
('INC', '197432', 66),
('SMS', '2159010', 1),
('SMS', '4535614', 1);
```

### Expected Output

call_number |
--|
2159010 |


### Solution Query

```sql
WITH both_services_enabled_numbers AS (
    SELECT   call_number, 
             SUM(call_duration) FILTER(WHERE call_type='INC') AS total_incoming,
             SUM(call_duration) FILTER(WHERE call_type='OUT') AS total_outgoing
    FROM     call_details
    WHERE    call_type IN ('OUT', 'INC')
    GROUP BY 1
    HAVING   COUNT(DISTINCT call_type) >= 2
)
SELECT call_number 
FROM   both_services_enabled_numbers
WHERE  total_outgoing > total_incoming

```