select   state, count(business_id)
from     yelp_business
where    stars=5
group by 1
order by 2 desc, 1
limit    6



-- remarks: suprisingly easy problem; in the hard section.