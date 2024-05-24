SELECT
  ROUND (100.0 * 
    COUNT (case_id) FILTER (
      WHERE call_category IS NULL OR call_category = 'n/a')
    / COUNT (case_id), 1) AS uncategorised_call_pct
FROM callers; 