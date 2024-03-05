



WITH sum_view_stats AS (
    SELECT challenge_id,
           total_views = Sum(total_views),
           total_unique_views = Sum(total_unique_views)
    FROM   view_stats
    GROUP BY challenge_id),
sum_submission_stats AS (
    SELECT challenge_id,
                total_submissions = Sum(total_submissions),
                total_accepted_submissions = Sum(total_accepted_submissions)
         FROM   submission_stats
         GROUP  BY challenge_id)
SELECT con.contest_id,
       con.hacker_id,
       con.NAME,
       Sum(total_submissions),
       Sum(total_accepted_submissions),
       Sum(total_views),
       Sum(total_unique_views)
FROM   contests con INNER JOIN colleges col ON con.contest_id = col.contest_id
                    INNER JOIN challenges cha ON cha.college_id = col.college_id
                    LEFT JOIN sum_view_stats vs ON vs.challenge_id = cha.challenge_id
                    LEFT JOIN sum_submission_stats ss ON ss.challenge_id = cha.challenge_id
GROUP BY 1, 2, 3
HAVING (Sum(total_submissions) + Sum(total_accepted_submissions) + Sum(total_views) + Sum(total_unique_views) ) <> 0
ORDER BY 1



-- Explanation :  The tables Submission_Stats, View_Stats contains multiple entries for same contest id. Hence we need to calculate sum by grouping with contest id before joining.


-- remarks: couldn't figure out on own to calculate sum before joining. 