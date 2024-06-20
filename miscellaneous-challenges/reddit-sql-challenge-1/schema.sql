CREATE TABLE IF NOT EXISTS customers (
    customer_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100)    NOT NULL,
    join_date     DATE            NOT NULL
);

CREATE TABLE IF NOT EXISTS default_rates (
    rate_id       SERIAL PRIMARY KEY,
    daily_rate    DECIMAL(10, 2)  NOT NULL
);

CREATE TABLE IF NOT EXISTS cars (
    car_id        SERIAL PRIMARY KEY,
    brand         VARCHAR(50)     NOT NULL,
    model         VARCHAR(50)     NOT NULL,
    model_year    INT             NULL,
    plate         VARCHAR(10)     NOT NULL,
    rate_id       INT             NOT NULL,
    CONSTRAINT fk_car_rate FOREIGN KEY(rate_id) REFERENCES default_rates(rate_id)
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id    SERIAL PRIMARY KEY,
    out_date      DATE            NOT NULL,
    ret_date      DATE            NOT NULL,
    customer_id   INT             NOT NULL,
    car_id        INT             NOT NULL,
    discount      DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    is_cancelled  BOOLEAN         NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_bkg_cust FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_bkg_car  FOREIGN KEY(car_id)      REFERENCES cars(car_id)
);

CREATE TABLE IF NOT EXISTS extras (
    extra_id      SERIAL PRIMARY KEY,
    booking_id    INT             NULL,
    customer_id   INT             NULL,
    trans_date    DATE            NOT NULL,
    description   VARCHAR(100)    NOT NULL DEFAULT '',
    amount        DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_ext_bkg  FOREIGN KEY(booking_id)  REFERENCES bookings(booking_id),
    CONSTRAINT fk_ext_cust FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id    INT             NOT NULL,
    line_id       INT             NOT NULL,
    invoice_date  DATE            NOT NULL,
    customer_id   INT             NOT NULL,
    customer_name VARCHAR(100)    NOT NULL,
    booking_id    INT             NULL,
    extra_id      INT             NULL,
    line_descr    VARCHAR(100)    NULL,
    amount        DECIMAL(10, 2)  NOT NULL,
    PRIMARY KEY(invoice_id, line_id),
    CONSTRAINT fk_inv_bkg  FOREIGN KEY(booking_id)  REFERENCES bookings(booking_id),
    CONSTRAINT fk_inv_cust FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_inv_extr FOREIGN KEY(extra_id)    REFERENCES extras(extra_id)
);

INSERT INTO customers (customer_id, name, join_date) VALUES
(1, 'test', '2020-01-01'),
(2, 'Georg Becker', '2020-01-02'),
(3, 'Erwin Biegel', '2020-02-01'),
(4, 'Adam Carstens', '2020-04-04'),
(5, 'Günther Claudius', '2020-03-10'),
(6, 'Emma Bading', '2020-04-01')
ON CONFLICT (customer_id) DO NOTHING;


INSERT INTO default_rates (rate_id, daily_rate) VALUES
(1, 320.00),
(2, 480.00)
ON CONFLICT (rate_id) DO NOTHING;


INSERT INTO cars (car_id, brand, model, model_year, plate, rate_id) VALUES
(1, 'Oldsmobile', '442 W-30', 1970, '2BAD', 1),
(2, 'BMW', 'M3', 2020, 'U2SLOW', 2),
(3, 'Mercedes', 'SL550', 2019, 'C2H5OH', 2),
(4, 'Mercedes', 'AMG GT', 2020, 'D14BLK', 2),
(5, 'Mercedes', 'GLS63', 2020, 'R123FFF', 1),
(6, 'Lincoln', 'Navigator', 2020, 'TRE440', 1),
(7, 'Chevrolet', 'Corvette', 2020, 'CDE500', 1),
(8, 'Porsche', 'Cayman', 2020, '718BFF', 1),
(9, 'McLaren', '720S', 2020, 'R14ERT', 2),
(10, 'Porsche', '911 GT3', 2018, 'HYE99', 1)
ON CONFLICT (car_id) DO NOTHING;


INSERT INTO bookings (booking_id, out_date, ret_date, customer_id, car_id, discount, is_cancelled) VALUES
(1, '2020-02-04', '2020-02-17', 3, 5, -320.00, FALSE),
(2, '2020-02-28', '2020-03-07', 2, 7, -320.00, FALSE),
(3, '2020-03-20', '2020-04-06', 5, 5, -320.00, FALSE),
(4, '2020-04-08', '2020-04-22', 6, 3, -480.00, FALSE),
(5, '2020-04-09', '2020-04-14', 2, 9, 0.00, FALSE),
(6, '2020-04-19', '2020-04-24', 6, 8, 0.00, TRUE),
(7, '2020-04-19', '2020-05-05', 3, 8, -320.00, FALSE),
(8, '2020-04-27', '2020-05-17', 3, 4, -480.00, FALSE),
(9, '2020-05-03', '2020-05-14', 5, 1, -320.00, FALSE),
(10, '2020-05-11', '2020-05-15', 5, 10, 0.00, FALSE),
(11, '2020-05-28', '2020-06-06', 5, 9, -480.00, FALSE),
(12, '2020-06-01', '2020-06-15', 6, 4, -480.00, FALSE),
(13, '2020-06-10', '2020-06-29', 3, 10, -320.00, FALSE),
(14, '2020-06-25', '2020-06-28', 5, 1, 0.00, FALSE),
(15, '2020-07-08', '2020-07-23', 2, 2, -480.00, FALSE),
(16, '2020-07-08', '2020-08-16', 2, 2, -480.00, FALSE),
(17, '2020-08-01', '2020-08-15', 6, 6, -320.00, FALSE),
(18, '2020-08-22', '2020-08-27', 6, 2, 0.00, FALSE),
(19, '2020-09-02', '2020-09-17', 5, 10, -320.00, FALSE),
(20, '2020-09-25', '2020-10-14', 4, 1, -320.00, FALSE),
(21, '2020-10-11', '2020-10-16', 3, 10, 0.00, TRUE),
(22, '2020-10-22', '2020-10-26', 4, 3, 0.00, FALSE),
(23, '2020-11-15', '2020-12-01', 3, 5, -320.00, FALSE),
(24, '2020-11-19', '2020-11-23', 6, 8, 0.00, FALSE),
(25, '2020-12-13', '2021-01-03', 2, 10, -320.00, FALSE),
(26, '2021-01-06', '2021-01-10', 6, 3, 0.00, FALSE),
(27, '2021-01-26', '2021-02-05', 4, 9, -480.00, FALSE),
(28, '2021-02-07', '2021-02-12', 5, 1, 0.00, FALSE),
(29, '2021-02-12', '2021-02-15', 3, 5, 0.00, FALSE),
(30, '2021-03-01', '2021-03-13', 5, 8, -320.00, FALSE),
(31, '2021-03-18', '2021-03-22', 3, 2, 0.00, FALSE),
(32, '2021-04-06', '2021-04-13', 2, 4, 0.00, FALSE),
(33, '2021-04-21', '2021-04-29', 2, 6, -320.00, FALSE),
(34, '2021-04-26', '2021-05-11', 5, 5, -320.00, FALSE),
(35, '2021-05-20', '2021-06-01', 5, 4, -480.00, FALSE),
(36, '2021-06-04', '2021-06-25', 5, 2, -480.00, FALSE),
(37, '2021-06-13', '2021-06-15', 3, 9, 0.00, FALSE),
(38, '2021-06-19', '2021-07-07', 6, 10, -320.00, FALSE),
(39, '2021-06-29', '2021-07-20', 4, 1, -320.00, FALSE),
(40, '2021-07-02', '2021-07-10', 4, 3, -480.00, FALSE)
ON CONFLICT (booking_id) DO NOTHING;


-- Assuming booking_id 12 doesn't exist in bookings, modify or remove the offending entry.
-- For this example, changing booking_id 12 to a valid booking_id or NULL if necessary.

INSERT INTO extras (extra_id, booking_id, customer_id, trans_date, description, amount) VALUES
(1, NULL, 2, '2020-01-02', 'Joining fee', 1250.00),
(2, NULL, 3, '2020-02-01', 'Joining fee', 1250.00),
(3, 1, NULL, '2020-02-05', 'Photo session', 300.00),
(4, 2, NULL, '2020-03-07', 'Delivery', 100.00),
(5, NULL, 5, '2020-03-10', 'Joining fee', 1250.00),
(6, NULL, 6, '2020-04-01', 'Joining fee', 1250.00),
(7, NULL, 4, '2020-04-04', 'Joining fee', 1250.00),
(8, 5, NULL, '2020-04-14', 'Cleaning', 190.00),
(9, 8, NULL, '2020-04-27', 'Delivery', 70.00),
(10, 7, NULL, '2020-05-05', 'Cleaning', 150.00),
(11, 8, NULL, '2020-05-17', 'Collection', 70.00),
(12, 13, NULL, '2020-06-15', 'Collection', 50.00), -- changed from 12 to 13
(13, NULL, 6, '2020-06-15', 'Photo session', 300.00),
(14, 29, NULL, '2021-02-15', 'Road Tolls', 30.00),
(15, 31, NULL, '2021-03-22', 'Cleaning', 85.00),
(16, 37, NULL, '2021-06-13', 'Delivery', 120.00),
(17, 37, NULL, '2021-06-15', 'Road Tolls', 18.00);




--======================================================================================================

SELECT * FROM customers;
SELECT * FROM default_rates;
SELECT * FROM cars;
SELECT * FROM bookings;
SELECT * FROM extras;
SELECT * FROM invoices;


-- customers (customer_id, name, join_date)
-- default_rates (rate_id, daily_rate)
-- cars (car_id, brand, model, model_year, plate, rate_id)
-- bookings (booking_id, out_date, ret_date, customer_id, car_id, discount, is_cancelled)
-- extras (extra_id, booking_id, customer_id, trans_date, description, amount)
-- invoices (invoice_id, line_id, invoice_date, customer_id, customer_name, booking_id, extra_id, line_descr, amount)

--======================================================================================================


