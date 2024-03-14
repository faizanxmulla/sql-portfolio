-- Each node in the tree can be one of three types:
--  - Leaf: if the node is a leaf node.
--  - Root: if the node is the root of the tree.
--  - Inner: If the node is neither a leaf node nor a root node.

-- Write a query to print the node id and the type of the node. Sort your output by the node id.



SELECT id, 
       CASE WHEN p_id IS NULL THEN 'Root'
            WHEN id NOT IN (SELECT p_id 
                            FROM   Tree
                            WHERE  p_id IS NOT NULL) THEN 'Leaf'
            ELSE 'Inner'
            END as type 
FROM Tree


-- remarks: was stuck trying implementing the 'INNER' condition, where could have directly used 'ELSE' clause.