-- You are given 2 tables, One containing the available Books and the other containing the Books that have been bought by a customer. You have to find the Id’s of all the ‘Famous’ Books. A book is called ‘Famous’ if it is bought by at least 3 customers.

-- my approach : 

SELECT   b.Id as Id
FROM     Books b JOIN BoughtBooks bb ON b.Id=bb.BooksId
GROUP BY bb.BooksId
HAVING   COUNT(bb.Id) >= 3


-- more easy solution: no need for the first table. 

SELECT   BooksId as Id
FROM     BoughtBooks
GROUP BY 1
HAVING   count(BooksId)>=3