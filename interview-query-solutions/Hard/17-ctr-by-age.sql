SELECT   FLOOR((search_time - birthdate) / 3650) AS age_group,
         ROUND(SUM(has_clicked) / COUNT(*), 5) AS ctr
FROM     search_events AS se JOIN users AS u ON u.id = se.user_id
WHERE    YEAR(search_time) = 2021
GROUP BY 1
ORDER BY 2 DESC, 1 DESC
LIMIT    3