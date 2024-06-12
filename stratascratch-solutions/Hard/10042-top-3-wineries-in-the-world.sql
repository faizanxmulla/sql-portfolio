WITH compute_avg_points AS (
    SELECT   country, winery, AVG(points) AS avg_points
    FROM     winemag_p1
    GROUP BY 1, 2
),
rank_wineries AS (
    SELECT country, 
           winery, 
           avg_points, 
           DENSE_RANK() OVER(PARTITION BY country ORDER BY avg_points DESC, winery ASC) AS dr
    FROM   compute_avg_points
),
select_top_3_wineries AS (
    SELECT country,
           CASE WHEN dr = 1 THEN winery || ' (' || ROUND(avg_points) || ')' ELSE NULL END AS top_winery,
           CASE WHEN dr = 2 THEN winery || ' (' || ROUND(avg_points) || ')' ELSE NULL END AS second_winery,
           CASE WHEN dr = 3 THEN winery || ' (' || ROUND(avg_points) || ')' ELSE NULL END AS third_winery
    FROM   rank_wineries
)
SELECT   country,
         COALESCE(MAX(top_winery), 'No top winery') AS top_winery,
         COALESCE(MAX(second_winery), 'No second winery') AS second_winery,
         COALESCE(MAX(third_winery), 'No third winery') AS third_winery
FROM     select_top_3_wineries
GROUP BY 1
ORDER BY 1
