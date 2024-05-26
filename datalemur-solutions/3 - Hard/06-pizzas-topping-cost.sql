-- Given a list of pizza toppings, consider all the possible 3-topping pizzas, and print out the total cost of those 3 toppings. Sort the results with the highest total cost on the top followed by pizza toppings in ascending order.

-- Break ties by listing the ingredients in alphabetical order, starting from the first ingredient, followed by the second and third.

-- Notes:

-- - Do not display pizzas where a topping is repeated. For example, ‘Pepperoni,Pepperoni,Onion Pizza’.

-- - Ingredients must be listed in alphabetical order. For example, 'Chicken,Onions,Sausage'. 'Onion,Sausage,Chicken' is not acceptable.



SELECT   CONCAT(p1.topping_name, ',', p2.topping_name, ',', p3.topping_name) as pizza, 
         (p1.ingredient_cost + p2.ingredient_cost + p3.ingredient_cost) as total_cost
FROM     pizza_toppings p1 JOIN pizza_toppings p2 ON p1.topping_name < p2.topping_name
                           JOIN pizza_toppings p3 ON p2.topping_name < p3.topping_name
ORDER BY 2 DESC, 1


-- note: alternate approach using recursive CTE or Cross Join.