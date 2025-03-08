SELECT distinct(feedback_id), feedback_text, source_channel, comment_category
FROM   customer_feedback
WHERE  source_channel='social_media'
       and comment_category <> 'short_comments'


-- NOTE: didnt put distinct initially.