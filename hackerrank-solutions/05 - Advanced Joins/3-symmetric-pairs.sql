-- Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.

-- Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.



SELECT   a.x, a.y
FROM     Functions a join Functions b on a.x=b.y and b.x=a.y
WHERE    a.x<=a.y 
GROUP BY 1, 2
HAVING   count(a.x)>1 or a.x<a.y
ORDER BY 1

-- OR -- 

SELECT   a.x, a.y
FROM     Functions a, Functions b
WHERE    a.x<=a.y and a.x=b.y and b.x=a.y
GROUP BY 1, 2
HAVING   count(a.x)>1 or a.x<a.y
ORDER BY 1



-- my initial approach : 

SELECT   a.x, a.y
FROM     Functions a, Functions b
WHERE    a.x=b.y and b.x=a.y and a.x<=a.y
ORDER BY 1


-- remarks: initially didnt get the idea of using the conditions in ON clause. but later, got it. also couldnt get the HAVING statement.