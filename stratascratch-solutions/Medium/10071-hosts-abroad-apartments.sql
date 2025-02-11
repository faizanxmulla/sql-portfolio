SELECT COUNT(distinct h.host_id)
FROM   airbnb_hosts h JOIN airbnb_apartments a
ON     h.host_id = a.host_id and nationality <> a.country