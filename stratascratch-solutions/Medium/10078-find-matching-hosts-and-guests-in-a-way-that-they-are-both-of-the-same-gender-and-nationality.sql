SELECT distinct h.host_id, g.guest_id
FROM   airbnb_hosts h JOIN airbnb_guests g
ON     h.nationality=g.nationality and h.gender = g.gender