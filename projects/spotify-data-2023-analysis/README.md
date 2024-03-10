# Spotify Music Analysis - 2023 

<p align="center">  
	<br>
	<a href="https://open.spotify.com/">
        <img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.YQg9PUaYHoYCyG2SqFWSwwHaDt%26pid%3DApi&f=1&ipt=d62add352227128017bbc009d68f3ca869e386ae81a22badab1b028fa5cba1d3&ipo=images"> 
    </a>
    <br>
    <br>
</p>


## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset Description](#dataset-description)

  - [Potential Usecases](#potential-usecases)
  
  - [Getting Started](#getting-started)

  - [Exploratory Analysis](#exploratory-analysis)

  - [Relevant Insights]()

  - [Relevant Links](#relevant-links)


## Introduction 


Welcome to the `"Spotify Music Analysis - 2023"` project! Here, we're exploring a carefully compiled [dataset](https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023) showcasing the standout songs of 2023, as documented by Spotify. 

This dataset goes beyond the usual song collections, offering a complete look into each track's characteristics, popularity, and visibility across different music platforms. It's like a hidden gem of insights waiting to be uncovered!

## Dataset Description 

The [dataset](https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023) provides a comprehensive set of features, including song attributes, popularity metrics, and presence on various music platforms like Spotify, Apple Music, Deezer, and Shazam. 

The dataset empowers users to delve into music analysis, platform comparison, artist impact, temporal trends, and cross-platform presence.

### Key Features 


1. `track_name`: Name of the song

2. `artist(s)_name`: Name of the artist(s) of the song

3. `artist_count`: Number of artists contributing to the song

4. `released_year`: Year when the song was released

5. `released_month`: Month when the song was released

6. `released_day`: Day of the month when the song was released

7. `in_spotify_playlists`: Number of Spotify playlists the song is included in

8. `in_spotify_charts`: Presence and rank of the song on Spotify charts

9. `streams`: Total number of streams on Spotify

10. `in_apple_playlists`: Number of Apple Music playlists the song is included in

11. `in_apple_charts`: Presence and rank of the song on Apple Music charts

12. `in_deezer_playlists`: Number of Deezer playlists the song is included in

13. `in_deezer_charts`: Presence and rank of the song on Deezer charts

14. `in_shazam_charts`: Presence and rank of the song on Shazam charts

15. `bpm`: Beats per minute, a measure of song tempo

16. `key`: Key of the song

17. `mode`: Mode of the song (major or minor)

18. `danceability_%`: Percentage indicating how suitable the song is for dancing

19. `valence_%`: Positivity of the song's musical content

20. `energy_%`: Perceived energy level of the song

21. `acousticness_%`: Amount of acoustic sound in the song

22. `instrumentalness_%`: Amount of instrumental content in the song

23. `liveness_%`: Presence of live performance elements

24. `speechiness_%`: Amount of spoken words in the song


## Potential Use Cases

- `Music Analysis`: Explore patterns in audio features to understand trends and preferences in popular songs.

- `Platform Comparison`: Compare the song's popularity across different music platforms.

- `Artist Impact`: Analyze how artist involvement and attributes relate to a song's success.

- `Temporal Trends`: Identify any shifts in music attributes and preferences over time.

- `Cross-Platform Presence`: Investigate how songs perform across different streaming services.



## Getting Started 

Explore the SQL queries provided in the repository to kickstart your journey into this rich dataset. These queries cover a range of questions and analyses, guiding you through diverse aspects of the dataset.

**Feel free to customize queries and explore your own questions, enabling you to unlock unique insights and contribute to the collective understanding of the musical landscape in 2023.**

Happy querying and may your exploration of this dataset be both insightful and harmonious!!


## Exploratory Analysis

### `General Song Information`:

1. What are the top 5 most streamed songs in 2023?

2. How many unique artists contributed to the dataset?

3. What is the distribution of songs across different release years?

4. Who are the top 10 artists based on popularity, and what are their tracks' average danceability and energy?


### `Spotify Metrics`:

1. Which song is present in the highest number of Spotify playlists?

2. Is there a correlation between the number of streams and a song's presence in Spotify charts?

3. What is the average BPM (Beats Per Minute) of songs on Spotify?

4. What is the average danceability of the top 15 most popular songs? 


### `Apple Music Metrics`:

1. How many songs made it to both Apple Music charts and Spotify charts?


### `Deezer Metrics`:

1. Are there any trends in the presence of songs on Deezer charts based on the release month?

2. How many songs are common between Deezer and Spotify playlists?


### `Shazam Metrics`:

1. Do songs that perform well on Shazam charts have higher danceability percentages?

2. What is the distribution of speechiness percentages for songs on Shazam charts?


### `Audio Features`:

1. Is there a noticeable difference in danceability percentages between songs in major and minor modes?

2. How does the distribution of acousticness percentages vary across different keys?

3. Are there any trends in the energy levels of songs over the years?

4. What are the most common song keys for the entire dataset?

5. In what key is each track from the dataset?


### `Artist Impact`:

1. What is the average number of artists contributing to a song that makes it to the charts?

2. Do songs with a higher number of artists tend to have higher or lower danceability percentages?

### `Temporal Trends`:

1. How has the distribution of song valence percentages changed over the months in 2023?

2. Are there any noticeable trends in the key of songs over the years?

### `Correlation Analysis`:

1. Is there a correlation between BPM and danceability percentages?

2. How does the presence of live performance elements (liveness) correlate with acousticness percentages?

### `Popularity Analysis`:

1. Do songs with higher valence percentages tend to have more streams on Spotify?

2. Is there a relationship between the number of Spotify playlists and the presence on Apple Music charts?

### `Miscellaneous`:

1. What is the distribution of key and mode combinations across the dataset?

2. Are there any patterns in the release days of songs that make it to the charts?

3. How do instrumentalness percentages correlate with energy levels?

### `Extra Questions` : 

1. Do songs in Apple Music playlists have higher valence percentages on average?

2. Which songs have a significant presence across Spotify, Apple Music, Deezer, and Shazam?

3. How does the distribution of streams on Spotify compare to the presence on Apple Music charts?



## Relevant Links

- [Spotify Dataset Link - KAGGLE](https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023)

- [Instant SQL Formatter](http://www.dpriver.com/pp/sqlformat.htm)


## Contributing

`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.

--

Feel free to `add more questions` and contribute to the exploration of this dataset!

If you find any issues with existing questions or their solutions, please `create an issue` and provide the correct solutions.



## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!