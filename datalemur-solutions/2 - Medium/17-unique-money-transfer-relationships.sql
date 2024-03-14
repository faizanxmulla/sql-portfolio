WITH two_way_relationships AS (
         SELECT payer_id     AS payer,
                recipient_id AS recipient
         FROM   payments
         INTERSECT
         SELECT recipient_id AS payer,
                payer_id     AS recipient
         FROM   payments)
SELECT Count(payer) / 2 AS unique_relationships
FROM   two_way_relationships