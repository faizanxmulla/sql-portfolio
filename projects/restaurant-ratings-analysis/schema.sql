CREATE DATABASE restaurant_analysis;

USE restaurant_analysis;

-- Creating customer_ratings table
CREATE TABLE Customer_Ratings (
    Consumer_ID VARCHAR(50),
    Restaurant_ID VARCHAR(50),
    Overall_Rating INT,
    Food_Rating INT,
    Service_Rating INT
);

-- Creating customer_details table
CREATE TABLE Customer_Details(
    Consumer_ID VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    Latitude DECIMAL(10, 6),
    Longitude DECIMAL(10, 6),
    Smoker VARCHAR(50),
    Drink_Level VARCHAR(50),
    Transportation_Method VARCHAR(50),
    Marital_Status VARCHAR(50),
    Children VARCHAR(50),
    Age INT,
    Occupation VARCHAR(50),
    Budget VARCHAR(50)
);

-- Creating customer_preference table
CREATE TABLE Customer_Preference(
    Consumer_ID VARCHAR(50),
    Preferred_Cuisine VARCHAR(50)
);

-- Creating restaurants table
CREATE TABLE Restaurants (
    Restaurant_ID VARCHAR(50),
    Name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    Zip_Code VARCHAR(50),
    Latitude DECIMAL(10, 6),
    Longitude DECIMAL(10, 6),
    Alcohol_Service VARCHAR(50),
    Smoking_Allowed VARCHAR(50),
    Price VARCHAR(50),
    Franchise VARCHAR(50),
    Area VARCHAR(50),
    Parking VARCHAR(100)
);

-- Creating restaurant_cuisines table
CREATE TABLE restaurant_cuisines (
    Restaurant_ID VARCHAR(50),
    Cuisine VARCHAR(50)
);
