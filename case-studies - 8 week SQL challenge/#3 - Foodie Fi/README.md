## [Case Study 3 : Foodie Fi](https://8weeksqlchallenge.com/case-study-3/)
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" alt="Image" width="450" height="450">



## Table Of Contents
  - [Introduction](#introduction)

  - [Dataset](#dataset)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  - [Contributing](#contributing)
  - [Support](#support) 
    

## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions


## Dataset
Key datasets for this case study : 

### 1. **`plans`** : 

Customers can choose which plans to join Foodie-Fi when they first sign up.

There are 5 customer plans.

- `Basic plan` - customers have limited access and can only stream their videos and is only available monthly at $9.90

- `Pro plan` - customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

- `Trial plan` - Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

- `Churn plan` - When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.


### 2. **`subscriptions`** : 

Customer subscriptions show the exact date where their specific plan_id starts.

If customers downgrade from a pro plan or cancel their subscription — the higher plan will remain in place until the period is over — the start_date in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan — the higher plan will take effect straightaway.

When customers churn, they will keep their access until the end of their current billing period, but the start_date will be technically the day they decided to cancel their service.


## Entity Relationship Diagram


![image](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/8267170d-39fc-4907-8425-ed6c185f14be)



## Case Study Solutions
- [1. Customer Journey](1.%20Customer-Journey.md)

- [2. Data Analysis](2.%20Data-Analysis.md)

- [3. Challenge Payment Question](3.%20Challenge-Payment.md)

- [4. Outside the Box Questions](4.%20Outside-the-Box-Questions.md)




## Contributing
`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.


## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!
