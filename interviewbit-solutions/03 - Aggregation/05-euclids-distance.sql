-- Given a table HOUSES, find the euclidean distance between points with the largest X and Y coordinate, and the points with the smallest X and Y coordinate.

-- The Euclidean Distance between 2 points P(x1, y1) and Q(x2, y2) is defined as: sqrt((x1 - x2)2 + (y1 - y2)2).


SELECT SQRT(POW(MAX(XCoordinate) - MIN(XCoordinate), 2) + POW(MAX(YCoordinate) - MIN(YCoordinate), 2)) as A
FROM   HOUSES