SELECT   birthday, ni.name, AVG(rating) as avg_rating
FROM     nominee_filmography nf JOIN nominee_information ni ON nf.name = ni.name
GROUP BY 1, 2
ORDER BY 1



-- NOTE: very basic question; shouldn't even be in Medium section.