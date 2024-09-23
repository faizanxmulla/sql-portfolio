### Problem Statement



**Dataset** - [Drive Link](https://drive.google.com/file/d/1oQTYGNkO7-4gwgWDeY2YwMkeP_vH78ju/view)


### Expected Output

| timeframe | timeframe_id | ty_sales | ly_sales | by_sales |
|-----------|--------------|----------|----------|----------|
| FY         | FY           | 6577.106  | 5925.134  | 46990.171  |
| MTD        | MTD          | 1092.828  | 1945.918  | 787.53   |
| QTD        | QTD          | 6577.106  | 6260.911  | 1493.292  |
| QUARTER 1  | 1            | 6577.106  | 7477.419  | 1744.772  |
| QUARTER 2  | 2            | NULL     | 12990.586 | 8913.687  |
| QUARTER 3  | 3            | NULL     | 8108.672  | 9392.316  |
| QUARTER 4  | 4            | NULL     | 30649.133 | 27002.396 |
| YTD        | YTD          | 6577.106  | 6260.911  | 1493.292  |
| month      | 1            | 3485.978  | 830.096   | 242.78   |
| month      | 2            | 1998.3   | 2521.76  | 462.982   |
| month      | 3            | 1092.828  | 4125.563  | 1039.01  |
| month      | 4            | NULL     | 2607.685  | 2935.351  |
| month      | 5            | NULL     | 2799.612  | 861.832   |
| month      | 6            | NULL     | 7583.289  | 5116.504  |
| month      | 7            | NULL     | 1183.512  | 3.366     |
| month      | 8            | NULL     | 2963.094    | 3562.276  |
| month      | 9            | NULL     | 3962.066  | 5763.674  |
| month      | 10           | NULL     | 191.286  | 4733.624  |
| month      | 11           | NULL     | 9004.573  | 5301.095  |
| month      | 12           | NULL     | 21453.274 | 16967.677 |


### Solution Query

```sql
-- derive the `bi_metrics` table from the `order_details` & the `timeframes` table.

SELECT   timeframe,
         timeframe_id,
         SUM(CASE WHEN o.order_date BETWEEN t.start_date_ty AND t.end_date_ty THEN sales END) AS ty_sales,
         SUM(CASE WHEN o.order_date BETWEEN t.start_date_ly AND t.end_date_ly THEN sales END) AS ly_sales,
         SUM(CASE WHEN o.order_date BETWEEN t.start_date_lly AND t.end_date_lly THEN sales END) AS lly_sales
FROM     order_details o JOIN timeframes t ON o.order_date BETWEEN t.start_date_ty AND t.end_date_ty
                                           OR o.order_date BETWEEN t.start_date_ly AND t.end_date_ly
                                           OR o.order_date BETWEEN t.start_date_lly AND t.end_date_lly
GROUP BY 1, 2
ORDER BY 1, 2
```