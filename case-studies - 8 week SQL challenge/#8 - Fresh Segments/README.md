## [Case Study 8 : Fresh Segmens](https://8weeksqlchallenge.com/case-study-8/)
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/8.png" alt="Image" width="450" height="450">



## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset](#dataset)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  - [Contributing](#contributing)
  - [Support](#support)  

## Introduction
Danny created Fresh Segments, a digital marketing agency that helps other businesses analyse trends in online ad click behaviour for their unique customer base.

Clients share their customer lists with the Fresh Segments team who then aggregate interest metrics and generate a single dataset worth of metrics for further analysis.

In particular - the composition and rankings for different interests are provided for each client showing the proportion of their customer list who interacted with online assets related to each interest for each month.

Danny has asked for your assistance to analyse aggregated metrics for an example client and provide some high level insights about the customer list and their interests.



## Dataset
Key datasets for this case study : 

### 1. **`Interest Metrics`** : 

This table contains information about aggregated interest metrics for a specific major client of Fresh Segments which makes up a large proportion of their customer base.

Each record in this table represents the performance of a specific `interest_id` based on the client’s customer base interest measured through clicks and interactions with specific targeted advertising content.

_month |	_year |	month_year |	interest_id |	composition |	index_value |	ranking |	percentile_ranking |
|--|--|--|--|--|--|--|--|
7 |	2018 |	07-2018 |	32486 |	11.89 |	6.19 |	1 |	99.86 |




### 2. **`Interest Map`** : 

This mapping table links the interest_id with their relevant interest information. You will need to join this table onto the previous interest_details table to obtain the interest_name as well as any details about the summary information.

id |	interest_name |	interest_summary |	created_at |	last_modified |
|--|--|--|--|--|
1 |	Fitness Enthusiasts |	Consumers using fitness tracking apps and websites. |	2016-05-26 14:57:59 |	2018-05-23 11:30:12 |
2 |	Gamers |	Consumers researching game reviews and cheat codes. |	2016-05-26 14:57:59 |	2018-05-23 11:30:12 |
3 |	Car Enthusiasts |	Readers of automotive news and car reviews. |	2016-05-26 14:57:59 |	2018-05-23 11:30:12 |



## Entity Relationship Diagram





## Case Study Solutions
- [1. Data Exploration and Cleaning](1.%20Data-Exploration-&-Cleaning.md)

- [2. Interest Analysis](2.%20Interest-Analysis.md)

- [3. Segment Analysis](3.%20Segment-Analysis.md)

- [4. Index Analysis](4.%20Index-Analysis.md)




## Contributing
`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.


## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!