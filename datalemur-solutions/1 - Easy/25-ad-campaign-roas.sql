SELECT   advertiser_id,
         ROUND(SUM(revenue::NUMERIC) / SUM(spend::NUMERIC), 2) AS ROAS
FROM     ad_campaigns
GROUP BY 1
ORDER BY 1
