WITH clean_cols_cte AS (
    SELECT   poster,
             UNNEST(string_to_array(replace(replace(post_keywords, '[', ''), ']', ''), ',')) AS cleaned_keywords
    FROM     facebook_posts
    GROUP BY 1, 2
)
SELECT   a.poster AS poster1,  
         b.poster AS poster2,
         COUNT(DISTINCT CASE WHEN a.cleaned_keywords = b.cleaned_keywords THEN b.cleaned_keywords END) / 
         COUNT(DISTINCT a.cleaned_keywords)::float AS overlap
FROM     clean_cols_cte a LEFT JOIN clean_cols_cte b ON a.poster != b.poster
WHERE    b.poster IS NOT NULL AND 
         LOWER(b.cleaned_keywords) NOT LIKE '%spam%' AND 
         LOWER(a.cleaned_keywords) NOT LIKE '%spam%'
GROUP BY 1, 2
ORDER BY 1