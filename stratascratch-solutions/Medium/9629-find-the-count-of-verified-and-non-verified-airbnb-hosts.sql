SELECT   host_identity_verified, COUNT(id) as n_hosts
FROM     airbnb_search_details
GROUP BY host_identity_verified



-- NOTE: very easy; shouldn't be in the Medium section