SELECT 100.0 * COUNT(search_id) FILTER(WHERE clicked=1 and search_results_position < 4) / COUNT(*) as top_3_clicked,
       100.0 * COUNT(search_id) FILTER(WHERE clicked=0 and search_results_position < 4) / COUNT(*) as top_3_notclicked
FROM   fb_search_events



-- NOTE: could have also used CASE WHEN alternatively.