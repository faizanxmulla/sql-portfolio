SELECT CASE WHEN number_of_reviews=0 THEN 'NO'
            WHEN number_of_reviews BETWEEN 1 and 5 THEN 'FEW'
            WHEN number_of_reviews BETWEEN 6 and 15 THEN 'SOME'
            WHEN number_of_reviews BETWEEN 16 and 40 THEN 'MANY'
            ELSE 'A LOT' END as reviews_qualification,
       price
FROM   airbnb_search_details



-- NOTE: solved on first attempt