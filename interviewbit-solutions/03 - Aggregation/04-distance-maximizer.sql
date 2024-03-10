-- Given a table HOUSES, find the manhattan distance of the house which is the farthest from John’s house which lies at coordinates (20, 4).

-- Basically you have to find the manhattan distance of some house which is the maximum amongst all the other houses from John’s house.

-- Manhattan Distance between 2 points P(x1, y1), Q(x2, y2) is given as |x1 - x2| + |y1 - y2|.


SELECT MAX(ABS(XCoordinate - 20) + ABS(YCoordinate - 4)) as A
FROM   HOUSES