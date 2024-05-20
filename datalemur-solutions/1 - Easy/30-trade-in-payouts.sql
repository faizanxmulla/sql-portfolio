-- Apple has a trade-in program where their customers can return the old iPhone device to Apple and Apple gives the customers the trade-in value (known as payout) of the device in cash.

-- For each store, write a SQL query of the total revenue from the trade-in. Order the result by the descending order.

-- `trade_in_transactions` Table:

-- | Column Name      | Type    |
-- | ---------------- | ------- |
-- | transaction_id   | integer |
-- | model_id         | integer |
-- | store_id         | integer |
-- | transaction_date | date    |

-- `trade_in_transactions` Example Input:

-- | transaction_id | model_id | store_id | transaction_date |
-- | -------------- | -------- | -------- | ---------------- |
-- | 1              | 112      | 512      | 01/01/2022       |
-- | 2              | 113      | 512      | 01/01/2022       |

-- `trade_in_payouts` Table:

-- | Column Name   | Type    |
-- | ------------- | ------- |
-- | model_id      | integer |
-- | model_name    | string  |
-- | payout_amount | integer |

-- `trade_in_payouts` Example Input:

-- | model_id | model_name        | payout_amount |
-- | -------- | ----------------- | ------------- |
-- | 111      | iPhone 11         | 200           |
-- | 112      | iPhone 12         | 350           |
-- | 113      | iPhone 13         | 450           |
-- | 114      | iPhone 13 Pro Max | 650           |

-- Example Output:

-- | store_id | payout_total |
-- | -------- | ------------ |
-- | 512      | 800          |



-- Solution:

SELECT   store_id, SUM(payout_amount) as payout_total
FROM     trade_in_transactions tt JOIN trade_in_payouts tp USING(model_id)
GROUP BY 1
ORDER BY 2 DESC

