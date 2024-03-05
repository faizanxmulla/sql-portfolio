SELECT   Concat(name, '(', Substring(occupation, 1, 1), ')')
FROM     occupations
ORDER BY name;

SELECT  'There are a total of',
         Count(*) AS count,
         Concat(Lower(occupation), 's.')
FROM     occupations
GROUP BY occupation
ORDER BY count, occupation; 