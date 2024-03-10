-- Given a table LABOURERS, match all the pairs of Labourers that are from the same country, along with the country name. Keep the ordering by Name of the first laborer, then second laborer, and then Country name.


SELECT   l1.Name as Labourer1, l2.Name as Labourer2, l1.Country as Country
FROM     LABOURERS l1, LABOURERS l2
WHERE    l1.Country = l2.Country and l1.Name <> l2.Name
ORDER BY 1, 2, 3