## [Case Study 4 : Data Bank](https://8weeksqlchallenge.com/case-study-4/)
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/4.png" alt="Image" width="450" height="450">



## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset](#dataset)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  - [Contributing](#contributing)
  - [Support](#support) 
  

## Introduction
Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!



## Dataset
Key datasets for this case study : 

### 1. **`regions`** : 

The regions table contains the region_id and their respective region_name values

region_id |	region_name |
|--|--|
1 |	Africa |
2 |	America |
3 |	Asia |
4 |	Europe |
5 |	Oceania |


### 2. **`Customer Nodes`** : 

Customers are randomly distributed across the nodes according to their region - this also specifies exactly which node contains both their cash and data.

This random distribution changes frequently to reduce the risk of hackers getting into Data Bank’s system and stealing customer’s money and data!

Below is a sample of the top 5 rows of the `data_bank.customer_nodes` : 


customer_id |	region_id |	node_id |	start_date |	end_date |
|--|--|--|--|--|
1 |	3 |	4 |	2020-01-02 |	2020-01-03 |
2 |	3 |	5 |	2020-01-03 |	2020-01-17 |
3 |	5 |	4 |	2020-01-27 |	2020-02-18 |
4 |	5 |	4 |	2020-01-07 |	2020-01-19 |
5 |	3 |	3 |	2020-01-15 |	2020-01-23 |



### 3. **`Customer Transactions`** : 

This table stores all customer deposits, withdrawals and purchases made using their Data Bank debit card.

Below is a sample of the top 5 rows of the `data_bank.customer_transactions` : 


customer_id |	txn_date |	txn_type |	txn_amount |
|--|--|--|--|
429 |	2020-01-21 |	deposit |	82 |
155 |	2020-01-10 |	deposit |	712 |
398 |	2020-01-01 |	deposit |	196 |
255 |	2020-01-14 |	deposit |	563 |
185 |	2020-01-29 |	deposit |	626 |


## Entity Relationship Diagram

![image](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/9eb590d1-4234-462e-987d-f836a424ba05)




## Case Study Solutions
- [1. Customer Nodes Exploration](1.%20Customer-Nodes-Exploration.md)

- [2. Customer Transactions](2.%20Customer-Transactions.md)

- [3. Data Allocation](3.%20Data-Allocation.md)

- [4. Extra Challenge](4.%20Extra-Challenge.md)

- [5. Extension Request](5.%20Extension-Request.md)




## Contributing
`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.


## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!
