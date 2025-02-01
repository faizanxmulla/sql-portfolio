SELECT distinct winery
FROM   winemag_p1
WHERE  lower(description) ~ '\y(plum|cherry|rose|hazelnut)\y'