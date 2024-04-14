## [Case Study 7 : Balanced Tree Clothing Co.](https://8weeksqlchallenge.com/case-study-7/)
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/7.png" alt="Image" width="450" height="450">



## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset](#dataset)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  - [Contributing](#contributing)
  - [Support](#support) 
  

## Introduction
Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.



## Dataset
Key datasets for this case study : 

### 1. **`Product Details`** : 

`balanced_tree.product_details` includes all information about the entire range that Balanced Clothing sells in their store.

product_id |	price |	product_name |	category_id |	segment_id |	style_id |	category_name |	segment_name |	style_name |
|--|--|--|--|--|--|--|--|--|
c4a632 |	13 |	Navy Oversized Jeans - Womens |	1 |	3 |	7 |	Womens |	Jeans |	Navy Oversized |
e83aa3 |	32 |	Black Straight Jeans - Womens |	1 |	3 |	8 |	Womens |	Jeans |	Black Straight |
e31d39 |	10 |	Cream Relaxed Jeans - Womens |	1 |	3 |	9 |	Womens |	Jeans |	Cream Relaxed |
d5e9a6 |	23 |	Khaki Suit Jacket - Womens |	1 |	4 | 10 |	Womens |	Jacket |	Khaki Suit |



### 2. **`Product Sales`** : 

`balanced_tree.sales` contains product level information for all the transactions made for Balanced Tree including quantity, price, percentage discount, member status, a transaction ID and also the transaction timestamp.

prod_id |	qty |	price |	discount |	member |	txn_id |	start_txn_time |
|--|--|--|--|--|--|--|
c4a632 |	4 |	13 |	17 |	t |	54f307 |	2021-02-13 01:59:43.296 |
5d267b |	4 |	40 |	17 |	t |	54f307 |	2021-02-13 01:59:43.296 |
b9a74d |	4 |	17 |	17 |	t |	54f307 |	2021-02-13 01:59:43.296 |
2feb6b |	2 |	29 |	17 |	t |	54f307 |	2021-02-13 01:59:43.296 |


### 3. **`Product Hierarcy & Product Price`** : 

Thes tables are used only for the bonus question where we will use them to recreate the balanced_tree.product_details table.

`balanced_tree.product_hierarchy`: 

id |	parent_id |	level_text |	level_name |
|--|--|--|--|
1 |	  |	Womens |	Category |
2 |	  |	Mens |	Category |
3 |	1 |	Jeans |	Segment |
4 |	1 |	Jacket |	Segment |
5 |	2 |	Shirt |	Segment |



`balanced_tree.product_prices`:

id |	product_id |	price |
|--|--|--|
7 |	c4a632 |	13 |
8 |	e83aa3 |	32 |
9 |	e31d39 |	10 |
10 |	d5e9a6 |	23 |



## Entity Relationship Diagram

![image](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/3215b26a-b28c-4562-86e6-e07ffda2b30b)




## Case Study Solutions
- [1. High Level Sales Analysis](1.%20High-Level-Sales-Analysis.md)

- [2. Transaction Analysis](2.%20Transaction-Analysis.md)

- [3. Product Analysis](3.%20Product-Analysis.md)

- [4. Reporting Challenge](4.%20Reporting-Challenge.md)

- [5. Bonus Challenge](5.%20Bonus-Challenge.md)



## Contributing
`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.


## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!
