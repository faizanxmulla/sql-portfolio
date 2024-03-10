WITH space_demand AS (
    SELECT   datacenter_id, SUM(monthly_demand) AS total_monthly_demand
    FROM     forecasted_demand
    GROUP BY 1
)
SELECT   dc.datacenter_id,
         (dc.monthly_capacity - sd.total_monthly_demand) AS spare_capacity
FROM     datacenters AS dc JOIN space_demand AS sd USING(datacenter_id)
ORDER BY 1