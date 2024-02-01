-- Build a DATABASE.

CREATE database IF NOT EXISTS walmartSales;

USE walmartSales;


-- Create a TABLE.
CREATE TABLE IF NOT EXISTS wm_sales_data (
    invoice_id VARCHAR 20 NOT NULL PRIMARY KEY,
    branch VARCHAR 10 NOT NULL,
    CITY VARCHAR 10 NOT NULL,
    customer_type VARCHAR 30 NOT NULL,
    gender VARCHAR 10 NOT NULL,
    product_line VARCHAR 100 NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR 15 NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12 , 4 ) NOT NULL,
    rating FLOAT
);


-- FEATURE ENGINEERING

-- 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening..

ALTER TABLE wm_sales_data ADD COLUMN time_of_day VARCHAR(30);

UPDATE wm_sales_data
SET    time_of_day = ( CASE
                        WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN
                        "morning"
                        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN
                        "afternoon"
                        ELSE "evening"
                    END ); 


-- 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri).

ALTER TABLE wm_sales_data ADD COLUMN day_name VARCHAR(10);

UPDATE wm_sales_data
SET    day_name = Dayname(date); 



-- 3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).

ALTER TABLE wm_sales_data ADD COLUMN month_name VARCHAR(15);

UPDATE wm_sales_data
SET    month_name = Monthname(date); 