## [Case Study 5 : Data Mart](https://8weeksqlchallenge.com/case-study-5/)
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/5.png" alt="Image" width="450" height="450">



## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset](#dataset)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  - [Contributing](#contributing)
  - [Support](#support) 
  

## Introduction
Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:


- What was the quantifiable impact of the changes introduced in June 2020?

- Which platform, region, segment and customer types were the most impacted by this change?

- What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?



## Dataset
The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:


1. Data Mart has international operations using a multi-`region` strategy

2. Data Mart has both, a retail and online `platform` in the form of a Shopify store front to serve their customers

3. Customer `segment` and `customer_type` data relates to personal age and demographics information that is shared with Data Mart

4. `transactions` is the count of unique purchases made through Data Mart and sales is the actual dollar amount of purchases.

Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a `week_date` value which represents the start of the sales week.

5 random rows are shown in the table output below from `data_mart.weekly_sales` : 


week_date |	region |	platform |	segment |	customer_type |	transactions |	sales |
|--|--|--|--|--|--|--|
9/9/20 |	OCEANIA |	Shopify |	C3 |	New |	610 |	110033.89 |
29/7/20 |	AFRICA |	Retail |	C1 |	New |	110692 | 	3053771.19 |
22/7/20 |	EUROPE |	Shopify |	C4 |	Existing |	24 |	8101.54 |
13/5/20 |	AFRICA |	Shopify |	null |	Guest |	5287 |	1003301.37 |
24/7/19 |	ASIA |	Retail |	C1 |	New |	127342 |	3151780.41 |


## Entity Relationship Diagram

![image](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/eb182ea6-ba56-465d-b155-e786b252cd4a)




## Case Study Solutions
- [1. Data Cleaning](1.%20Data-Cleaning.md)

- [2. Data Exploration](2.%20Data-Exploration.md)

- [3. Before & After Analysis](3.%20Before-&-After-Analysis.md)

- [4. Bonus Question](4.%20Bonus-Question.md)



## Contributing
`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.


## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!
