SELECT Sum(CASE
             WHEN review_stars IN ( 4, 5 ) THEN 1
             ELSE 0
           end) AS
       business_num,
       Round(100 * ( Sum (CASE
                            WHEN review_stars IN ( 4, 5 ) THEN 1
                            ELSE 0
                          end) :: NUMERIC / Count(business_id) ), 2) AS
       top_business_pct
FROM   reviews; 