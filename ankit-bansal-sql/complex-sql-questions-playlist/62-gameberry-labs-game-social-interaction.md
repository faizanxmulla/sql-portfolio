### Problem Statement

In the last 7 days, get a distribution of games (% of total games) based on the social interaction that is happening during the games. Please consider the following as the categories for getting the distribution:

- No Social Interaction (No messages, emojis, or gifts sent during the game)

- One sided interaction (Messages, emojis, or gifts sent during the game by only one player)

- Both sided interaction without custom_typed messages

- Both sided interaction with custom_typed_messages from at least one player


### Schema Setup

```sql
CREATE TABLE user_interactions (
    user_id VARCHAR(10),
    event VARCHAR(15),
    event_date DATE,
    interaction_type VARCHAR(15),
    game_id VARCHAR(10),
    event_time TIME
);

INSERT INTO user_interactions VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');
```

### Expected Output




### Solution Query

```sql
WITH CTE as (
	SELECT   game_id, 
	         CASE 
	            WHEN COUNT(interaction_type) = 0 THEN 'No Social Interaction'
	            WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 1 THEN 'One sided interaction'
	            WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2 
	                 and COUNT(DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) = 0 
	            THEN 'Both sided Interaction without custom_typed messages'
	            WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2 
	                and COUNT(DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) >= 1 
	           THEN 'Both sided interaction with custom_typed messages from at least one player'
	         END AS game_type
	FROM     user_interactions
	GROUP BY 1
)
SELECT   game_type, ROUND(100.0 * COUNT(*) / COUNT(*) OVER(), 2) as percentage
FROM     CTE
GROUP BY 1
```