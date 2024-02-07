## List of Questions + Solutions

### `A. General Song Information`

1. What are the top 5 most streamed songs in 2023?

```sql
SELECT   track_name,
         streams
FROM     spotify
WHERE    released_year = 2023
ORDER BY streams DESC
LIMIT    5;
```

**Result Set :**

| track_name                            | streams   |
| ------------------------------------- | --------- |
| Ella Baila Sola                       | 725980112 |
| Shakira: Bzrp Music Sessions, Vol. 53 | 721975598 |
| TQG                                   | 618990393 |
| La Bebe - Remix                       | 553634067 |
| Die For You - Remix                   | 518745108 |

<br>

2. How many unique artists contributed to the dataset?

```sql
SELECT COUNT(DISTINCT artist(s)_name) AS unique_artists_count
FROM   spotify
```

**Result Set :**

| unique_artists_count |
| -------------------- |
| 595                  |

<br>

3. What is the distribution of songs across different release years?

```sql
SELECT   CONCAT(FLOOR(released_year / 10) * 10, '-', FLOOR(released_year / 10) * 10 + 11) AS decade_range,
         COUNT(*) AS songs_count
FROM     spotify
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
decade_range | songs_count |
--|--|
1930-1939 |	1 |
1940-1949 |	2 |
1950-1959 |	9 |
1960-1969 |	4 |
1970-1979 |	4 |
1980-1989 |	8 |
1990-1999 |	4 |
2000-2009 |	6 |
2010-2019 |	99 |
2020-2029 |	725 |
<br>

4. Who are the top 10 artists based on popularity, and what are their tracks' average danceability and energy?

```sql
SELECT   artist_name,
         AVG(`danceability_%`) AS avg_danceability,
         AVG(`energy_%`) AS avg_energy
FROM     spotify
GROUP BY artist_name
ORDER BY SUM(streams) DESC
LIMIT    10;
```

**Result Set :**
artist_name | streams | avg | avg_energy|
--|--|--|--|
Taylor Swift | 800840817 | 59.6061 | 56.0909 |
Bad Bunny | 303236322 | 75.1579 | 66.7368 |
The Weeknd | 1647990401 | 59.1500 | 63.4500 |
Olivia Rodrigo | 140003974 | 51.2857 | 50.5714 |
Harry Styles | 743693613 | 62.4000 | 56.4000 |
Doja Cat | 1329090101 | 80.0000 | 59.6667 |
SZA | 1163093654 | 57.9474 | 52.6842 |
BTS | 118482347 | 67.1250 | 69.0000 |
Bruno Mars | 1481349984 | 61.6667 | 52.6667 |
Ed Sheeran | 195576623 | 69.0000 | 78.0000 |
<br>

### `B. Spotify Metrics`

1. Which song is present in the highest number of Spotify playlists?

```sql
SELECT   track_name,
         artist_name,
         MAX(in_spotify_playlists) AS highest_playlists_count
FROM     spotify;
```

**Result Set :**
track_name | artist_name | highest_playlists_count|
|--|--|--|
Seven (feat. Latto) (Explicit Ver.) | Latto, Jung Kook | 29499 |

<br>

2. Is there a correlation between the number of streams and a song's presence in Spotify charts?

```sql
SELECT   ROUND((
           COUNT(*) * SUM(streams * in_spotify_charts) -
           SUM(streams) * SUM(in_spotify_charts)
         ) /
         SQRT(
           (COUNT(*) * SUM(streams * streams) - (SUM(streams) * SUM(streams))) *
           (COUNT(*) * SUM(in_spotify_charts * in_spotify_charts) - (SUM(in_spotify_charts) * SUM(in_spotify_charts)))
         ), 4) AS correlation_coeff
FROM     spotify;
```

**Result Set :**

| correlation_coeff |
| ----------------- |
| 0.1859            |

**Approach**:

my first approach:

```sql
SELECT   track_name, SUM(streams), in_spotify_charts
FROM     spotify
GROUP BY 1
ORDER BY 3 DESC
LIMIT    40;
```

alternatively, we can directly use the correlation formula :

if we were using `PostgreSQL` or `Oracle`, we could have directly used the `CORR()` function. but it is not supported by `MySQL, MS-SQL & SQLite`.

The formula for calculating the correlation coefficient (r) between two variables X and Y is given by:

<img title="" alt="" src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.LKHbm_e4XNMtpvitEPGwRQHaD3%26pid%3DApi&f=1&ipt=167812915d144f6e3e2dac6e1e99638c08ffa89f0846873769f8222017f1b5c2&ipo=images">

<br>

3. What is the average BPM (Beats Per Minute) of songs on Spotify?

```sql
SELECT AVG(bpm) as average_bpm
FROM   spotify
```

**Result Set :**

| average_bpm |
| ----------- |
| 123.0800    |

<br>

4. What is the average danceability of the top 15 most popular songs?

```sql
SELECT AVG(`danceability_%`) AS top15_avg_danceability
FROM (
    SELECT   track_name, streams, `danceability_%`
    FROM     spotify
    ORDER BY streams DESC
    LIMIT    15
) AS top_15_songs;
```

**Result Set :**
top15_avg_danceability |
--|
66.1333 |
<br>

### `C. Apple Music Metrics`:

1. How many songs made it to both Apple Music charts and Spotify charts?

```sql
SELECT SUM(CASE WHEN in_spotify_charts IS NOT NULL AND in_apple_charts IS NOT NULL THEN 1 ELSE 0 END) AS      common_songs_count
FROM   spotify;
```

alternative:

```sql
SELECT   COUNT(*) AS common_songs_count
FROM     spotify
WHERE    in_apple_charts IS NOT NULL AND in_spotify_charts IS NOT NULL;
```

**Result Set :**

| common_songs_count |
| ------------------ |
| 862                |

**my approach**: wrong as it answers the question : "How many songs are present in `either` Spotify charts `or` Apple Music charts?"

```sql
SELECT SUM(CASE WHEN track_name IN (in_spotify_charts, in_apple_charts) THEN 1 ELSE 0 END) AS common_songs_count
FROM   spotify;
```

<br>




### `D. Deezer Metrics`:

1. Are there any trends in the presence of songs on Deezer charts based on the release month?

```sql
SELECT   released_month,
         COUNT(*) AS songs_count
FROM     spotify
WHERE    in_deezer_charts IS NOT NULL
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
released_month | songs_count |
--|--|
1 | 97 |
2 | 59 |
3 | 83 |
4 | 64 |
5 | 122 |
6 | 77 |
7 | 60 |
8 | 42 |
9 | 46 |
10 | 66 |
11 | 72 |
12 | 74 |

<br>

2. How many songs are common between Deezer and Spotify playlists?

```sql
SELECT SUM(CASE WHEN in_spotify_playlists IS NOT NULL AND in_deezer_playlists IS NOT NULL THEN 1 ELSE 0 END) AS common_songs_count
FROM   spotify;
```

alternative:

```sql
SELECT   COUNT(*) AS common_songs_count
FROM     spotify
WHERE    in_deezer_playlists IS NOT NULL AND in_spotify_playlists IS NOT NULL;
```

**Result Set :**

| common_songs_count |
| ------------------ |
| 862                |

<br>

### `E. Shazam Metrics`:

1. Do songs that perform well on Shazam charts have higher danceability percentages? _(not sure about the solution)_

```sql
SELECT   `danceability_%`,
         COUNT(*) AS songs_count
FROM     spotify
WHERE    in_shazam_charts IS NOT NULL
GROUP BY 1
ORDER BY streams DESC
LIMIT    20;
```

**Result Set :**

<br>

2. What is the distribution of speechiness percentages for songs on Shazam charts?

```sql
SELECT   CONCAT(FLOOR(`speechiness_%` / 5) * 5, '-', FLOOR(`speechiness_%` / 5) * 5 + 5) AS speechiness_distribution,
         COUNT(*) AS songs_count
FROM     spotify
WHERE    in_shazam_charts IS NOT NULL
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
speechiness_distribution | songs_count |
--|--|
0-5 |	292 |
10-15 |	83 |
15-20 |	35 |
20-25 |	41 |
25-30 |	30 |
30-35 |	32 |
35-40 |	23 |
40-45 |	8 |
45-50 |	6 |
5-10 |	310 |
55-60 |	1 |
60-65 |	1 |
<br>

### `F. Audio Features`:

1. Is there a noticeable difference in danceability percentages between songs in major and minor modes?

```sql
SELECT   DISTINCT mode, AVG(`danceability_%`) as avg_danceability
FROM     spotify
GROUP BY 1
```

**Result Set :**
mode | avg_danceability |
--|--|
Major |	65.5714 |
Minor |	69.5672 |


<br>

2. How does the distribution of acousticness percentages vary across different keys?

```sql
SELECT DISTINCT spotify.key, AVG(`acousticness_%`) AS avg_acousticness
FROM spotify
GROUP BY 1
ORDER BY 1;
```

**Result Set :**

key | avg_acousticness |
--|--|
| | 30.5568 |
A |	30.3676 |
A# |	26.9434 |
B |	23.7260 |
C# |	22.0286 |
D |	28.0423 |
D# |	31.2000 |
E |	29.0000 |
F |	28.5663 |
F# |	31.8000 |
G |	28.0690 |
G# |	22.9765 |
<br>

3. Are there any trends in the energy levels of songs over the years?

```sql
SELECT   CONCAT(FLOOR(released_year / 10) * 10, '-', FLOOR(released_year / 10) * 10 + 10) AS decade_range,
         ROUND(AVG(`energy_%`), 2) as avg_energy
FROM     spotify
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
decade_range | avg_energy |
--|--|
1930-1940 |	80.00 |
1940-1950 |	20.00 |
1950-1960 |	38.11 |
1960-1970 |	70.75 |
1970-1980 |	61.00 |
1980-1990 |	63.75 |
1990-2000 |	67.50 |
2000-2010 |	70.33 |
2010-2020 |	60.59 |
2020-2030 |	64.98 |
<br>

4. What are the most common song keys for the entire dataset?

```sql
SELECT   `key`, COUNT(*) as songs_count
FROM     spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT    5;
```

**Result Set :**
key | songs_count | 
--|--|
C# |	105 |
|	 |88 |
G |	87 |
G# |	85 |
F |	83 |
<br>



### `G. Artist Impact`:

1. What is the average number of artists contributing to a song that makes it to the charts?

```sql
SELECT AVG(artist_count) as avg_artist_count
FROM   spotify
WHERE  track_name IN (in_spotify_charts, in_apple_charts, in_deezer_charts, in_shazam_charts);
```

**Result Set :**
avg_artist_count |
--|
1.5613 |
<br>

2. Do songs with a higher number of artists tend to have higher or lower danceability percentages?

```sql
SELECT   artist_count, AVG(`danceability_%`) AS avg_danceability
FROM     spotify
GROUP BY 1
ORDER BY 1 DESC;
```

**Result Set :**
artist_count | avg_danceability |
--|--|
8 |	68.5000 |
7 |	62.5000 |
6 |	83.3333 |
5 |	77.8000 |
4 |	74.7333 |
3 |	70.7949 |
2 |	71.0940 |
1 |	64.6826 |
<br>

### `H. Temporal Trends`:

1. How has the distribution of song valence percentages changed over the months in 2023?

```sql
SELECT   released_month, AVG(`valence_%`) AS avg_valence
FROM     spotify
WHERE    released_year='2023'
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
released_month | avg_valence | 
--|--|
1 |	65.00 |
2 |	66.17 |
3 |	52.49 |
4 |	50.20 |
5 |	51.38 |
6 |	52.17 |
7 |	52.08 |
<br>

2. Are there any noticeable trends in the key of songs over the years?

```sql
SELECT    CONCAT(FLOOR(released_year / 5) * 5, '-', FLOOR(released_year / 5) * 5 + 4) AS five_year_range,
          SUBSTRING_INDEX(GROUP_CONCAT(`key` ORDER BY key_count DESC), ',', 1) AS most_common_key
FROM (
          SELECT released_year,
                `key`,
                COUNT(*) AS key_count
          FROM spotify
          GROUP BY released_year, `key`
         ) AS key_counts
GROUP BY 1
ORDER BY 1;
```

**Result Set :**
five_year_range | most_common_key |
--|--|
1930-1934 |	F# |
1940-1944 |	A |
1945-1949 |	C# |
1950-1954 |	 |
1955-1959 |	G |
1960-1964 |	D# |
1965-1969 |	 | 
1970-1974 |	F |
1975-1979 |	B |
1980-1984 |	A |
1985-1989 |	A |
1995-1999 |	G# |
2000-2004 |	C# |
2005-2009 |	F |
2010-2014 |	G# |
2015-2019 |	E |
2020-2024 |	C# |
<br>


### `I. Correlation Analysis`:

If we were using `PostgreSQL` or `Oracle`, we could have directly used the `CORR()` function. but it is not supported by `MySQL, MS-SQL & SQLite`.

The formula for calculating the correlation coefficient (r) between two variables X and Y is given by:

<img title="" alt="" src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.LKHbm_e4XNMtpvitEPGwRQHaD3%26pid%3DApi&f=1&ipt=167812915d144f6e3e2dac6e1e99638c08ffa89f0846873769f8222017f1b5c2&ipo=images">

<br>

1. Is there a correlation between BPM and danceability percentages?

```sql
SELECT   ROUND((
           COUNT(*) * SUM(bpm * `danceability_%`) -
           SUM(bpm) * SUM(`danceability_%`)
         ) /
         SQRT(
           (COUNT(*) * SUM(bpm * bpm) - (SUM(bpm) * SUM(bpm))) *
           (COUNT(*) * SUM(`danceability_%` * `danceability_%`) - (SUM(`danceability_%`) * SUM(`danceability_%`)))
         ), 4) AS correlation_coeff
FROM     spotify;
```

**Result Set :**

| correlation_coeff |
| ----------------- |
| - 0.1407          |

<br>

2. How does the presence of live performance elements (liveness) correlate with acousticness percentages?

```sql
SELECT   ROUND((
           COUNT(*) * SUM(`liveness_%` * `acousticness_%`) -
           SUM(`liveness_%`) * SUM(`acousticness_%`)
         ) /
         SQRT(
           (COUNT(*) * SUM(`liveness_%` * `liveness_%`) - (SUM(`liveness_%`) * SUM(`liveness_%`))) *
           (COUNT(*) * SUM(`acousticness_%` * `acousticness_%`) - (SUM(`acousticness_%`) * SUM(`acousticness_%`)))
         ), 4) AS correlation_coeff
FROM     spotify;
```

**Result Set :**

| correlation_coeff |
| ----------------- |
| - 0.0375          |

<br>

### `J. Popularity Analysis`:

1. Do songs with higher valence percentages tend to have more streams on Spotify?

```sql
SELECT
    (SUM(valence_% * streams) - SUM(valence_%) * SUM(streams) / COUNT(*)) / 
    SQRT((SUM(valence_% * valence_%) - POW(SUM(valence_%), 2) / COUNT(*)) * 
    (SUM(streams * streams) - POW(SUM(streams), 2) / COUNT(*))) AS valence_streams_correlation
FROM spotify;
```

**Result Set :** in other words, find the correlation between streams and valence%.

valence_streams_correlation |
--|
-0.0485182610555528 
<br>

2. Is there a relationship between the number of Spotify playlists and the presence on Apple Music charts?

```sql
SELECT
    (SUM(in_spotify_playlists * in_apple_charts) - SUM(in_spotify_playlists) * SUM(in_apple_charts) / COUNT(*)) / 
    SQRT((SUM(in_spotify_playlists * in_spotify_playlists) - POW(SUM(in_spotify_playlists), 2) / COUNT(*)) * 
    (SUM(in_apple_charts * in_apple_charts) - POW(SUM(in_apple_charts), 2) / COUNT(*))) AS correlation
FROM spotify;
```

**Result Set :**


correlation |
--|
0.21466452343493414


<br>

### `K. Miscellaneous`:

1. What is the distribution of key and mode combinations across the dataset?

```sql
SELECT   CONCAT(`key`, '-', `mode`) AS key_mode_combination,
         COUNT(*) AS total_count
FROM     spotify
GROUP BY 1
ORDER BY 2 DESC;
```

**Result Set :**
key_mode_combination | total_count | 
--|--|
-Major |	70 |
C#-Major |	62 |
D-Major |	58 |
G#-Major |	57 |
G-Major |	57 |
F-Minor |	43 |
C#-Minor |	43 |
B-Minor |	42 |
F-Major |	40 |
E-Minor |	40 |
A-Major |	37 |
F#-Minor |	37 |
B-Major |	31 |
A-Minor |	31 |
G-Minor |	30 |
F#-Major |	28 |
A#-Minor |	28 |
G#-Minor |	28 |
A#-Major |	25 |
D#-Minor |	19 |
-Minor |	18 |
E-Major |	14 |
D-Minor |	13 |
D#-Major |	11 |
<br>


<br>

2. Are there any patterns in the release days of songs that make it to the charts?

```sql
SELECT   released_day, COUNT(*) AS songs_count
FROM     spotify
WHERE    in_spotify_charts = 1 
          OR in_apple_charts = 1 
          OR in_deezer_charts = 1 
          OR in_shazam_charts = 1
GROUP BY released_day
ORDER BY released_day;
```

**Result Set :**
released_day | songs_count | 
--|--|
1 |	10 |
2 |	12 |
3 |	5 |
4 |	11 |
5 |	4 |
6 |	8 |
7 |	10 |
8 |	5 |
9 |	4 |
10 |	8 |
11 |	5 |
12 |	4 |
13 |	12 |
14 |	8 |
15 |	1 |
16 |	9 |
17 |	8 |
18 |	6 |
19 |	7 |
20 |	14 |
21 |	6 |
22 |	6 |
23 |	3 |
24 |	13 |
25 |	9 |
26 |	2 |
27 |	7 |
28 |	3 |
29 |	7 |
30 |	6 |
31 |	3 |
<br>

3. How do instrumentalness percentages correlate with energy levels?

```sql
SELECT   ROUND((
           COUNT(*) * SUM(`instrumentalness_%` * `energy_%`) -
           SUM(`instrumentalness_%`) * SUM(`energy_%`)
         ) /
         SQRT(
           (COUNT(*) * SUM(`instrumentalness_%` * `instrumentalness_%`) - (SUM(`instrumentalness_%`) * SUM(`instrumentalness_%`))) *
           (COUNT(*) * SUM(`energy_%` * `energy_%`) - (SUM(`energy_%`) * SUM(`energy_%`)))
         ), 4) AS correlation_coeff
FROM     spotify;
```

**Result Set :**

| correlation_coeff |
| ----------------- |
|   -0.03 |

<br>



