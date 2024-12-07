SELECT   zipcode, 
         ROUND(AVG(CAST(SUBSTRING(host_response_rate FROM 1 FOR LENGTH(host_response_rate) - 1) AS NUMERIC)), 2) as avg_host_response_rate
FROM     airbnb_search_details
WHERE    cleaning_fee IS TRUE
         and host_response_rate IS NOT NULL
GROUP BY zipcode



-- NOTE: 

-- my initial attempt: IFNULL(AVG(SUBSTR(host_response_rate, 1, LEN(host_response_rate)-1), 0)::numeric)
-- had to look up syntax for SUBSTRING 

-- also didn't write the WHERE conditions