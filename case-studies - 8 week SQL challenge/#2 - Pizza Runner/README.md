## [Case Study 2 : Pizza Runner](https://8weeksqlchallenge.com/case-study-2/)

<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="Image" width="450" height="450">

## Table Of Contents

- [Introduction](#introduction)

- [Dataset](#dataset)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Solutions](#case-study-solutions)
- [Relevant Links](#relevant-links)
- [Contributing](#contributing)
- [Support](#support)

## Introduction

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Dataset

Key datasets for this case study

- **`runners`** : The table shows the registration_date for each new runner

- **`customer_orders`** : Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

- **`runner_orders`** : After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

- **`pizza_names`** : Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

- **`pizza_recipes`** : Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

- **`pizza_toppings`** : The table contains all of the topping_name values with their corresponding topping_id value

## Entity Relationship Diagram

![image](https://github.com/faizanxmulla/sql-portfolio/assets/71728480/138d7a99-b7ca-4531-b649-0f663c87e97a)


## Case Study Solutions

- [0. Data Cleaning](Data-Cleaning.md)

- [1. Pizza Metrics](1.%20Pizza-Metrics.md)

- [2. Runner and Customer Experience](2.%20Runner-and-Customer-Experience.md)

- [3. Ingredient Optimisation](3.%20Ingredient-Optimisation.md)

- [4. Pricing and Ratings](4.%20Pricing-and-Ratings.md)

- [5. Bonus DML Challenges](5.%20Bonus-DML-Challenges.md)

## Relevant Links

- [Entity Relationaship Diagram - dbdiagram.io](https://dbdiagram.io/d/Pizza-Runner-5f3e085ccf48a141ff558487?utm_source=dbdiagram_embed&utm_medium=bottom_open)


## Contributing

`Contributions` are always welcome !!

If you would like to contribute to the project, please `fork` the repository and make a `pull request`.

## Support

If you have any doubts, queries or, suggestions then, please connect with me on [LinkedIn](https://www.linkedin.com/in/faizanxmulla/).

Do ⭐ the repository, if it inspired you, gave you ideas of your own or helped you in any way !!
