SELECT   pp.name, AVG(amount)
FROM     postmates_partners pp JOIN postmates_orders po ON pp.id=po.seller_id
                               JOIN postmates_markets pm ON po.city_id=pm.id
WHERE    pm.name='Boston' and pp.name LIKE '%Pizza%'
GROUP BY 1