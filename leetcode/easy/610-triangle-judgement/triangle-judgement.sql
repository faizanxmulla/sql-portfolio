SELECT *, IF(x+y>z and y+z>x and x+z>y, 'Yes', 'No' ) as triangle
FROM Triangle 


# alternate solution --> using : {CASE, WHEN, THEN, ELSE, END}.

# SELECT x, y, z, 
# CASE WHEN x + y > z and x + z > y and y + z > x THEN 'Yes' ELSE 'No' END as triangle
# FROM Triangle