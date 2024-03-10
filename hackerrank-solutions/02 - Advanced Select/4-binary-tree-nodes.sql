-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

-- Root: If node is root node.
-- Leaf: If node is leaf node.
-- Inner: If node is neither root nor leaf node.


SELECT   CASE
            WHEN P is null THEN CONCAT(N, ' Root')
            WHEN N IN (select distinct P from BST) THEN CONCAT(N, ' Inner')
            ELSE CONCAT(N, ' Leaf')
            END 
FROM     BST
ORDER BY N