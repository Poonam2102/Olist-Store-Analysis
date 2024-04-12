CREATE DATABASE project;
USE project;

SELECT * FROM olist;

#KPI1(Card)
SELECT order_status, 
COUNT(order_status) AS orders
FROM olist
GROUP BY order_status;

#KPI2(Card)
SELECT * FROM olist
WHERE payment_payment_value > 8000;

#KPI3
SELECT *
FROM(
SELECT customer_id,
product_product_category_name,
payment_payment_value,
payment_payment_sequential,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY payment_payment_value DESC) AS pay_rank 
FROM olist) AS top_product
WHERE pay_rank <= 3;

#KPI4 Average Time taken for reviewing (Card)
SELECT
AVG(DATEDIFF(review_review_answer_timestamp,review_review_creation_date)) AS review_reponse_days 
FROM olist;

#KPI5
SELECT customer_customer_city, 
AVG(orderitems_freight_value) AS freight_charge,
AVG(DATEDIFF(order_delivered_customer_date,order_delivered_carrier_date)) AS export_days
FROM olist
GROUP BY customer_customer_city
ORDER BY AVG(orderitems_freight_value) DESC
LIMIT 10;

#KPI6
SELECT *,
(days_estimated_for_arrival - days_taken_for_arrival) AS days_saved
FROM
(SELECT
order_purchase_timestamp,
order_delivered_customer_date,
order_estimated_delivery_date,
DATEDIFF(order_delivered_customer_date,order_purchase_timestamp) AS days_taken_for_arrival,
DATEDIFF(order_estimated_delivery_date,order_purchase_timestamp) AS days_estimated_for_arrival,
review_review_score,
seller_seller_city
FROM olist) AS delivery
WHERE (days_estimated_for_arrival - days_taken_for_arrival) < 0
ORDER BY days_saved
LIMIT 10;

#KPI7
SELECT *
FROM(
SELECT
customer_customer_city,
product_product_category_name,
COUNT(orderitems_product_id) AS product_count,
DENSE_RANK() OVER (PARTITION BY customer_customer_city ORDER BY (COUNT(orderitems_product_id))) AS _drank
FROM olist
GROUP BY product_product_category_name, customer_customer_city) AS product
WHERE _drank <= 3;

#KPI8
SELECT
product_product_category_name,
orderitems_price,
orderitems_freight_value,
customer_customer_city,
DATEDIFF(orderitems_shipping_limit_date,order_delivered_carrier_date) AS days_in_travelling,
review_review_score
FROM
(SELECT
DISTINCT product_product_category_name,
orderitems_price, 
orderitems_freight_value,
customer_customer_city,
order_delivered_carrier_date,
orderitems_shipping_limit_date,
review_review_score
FROM olist
WHERE orderitems_price < orderitems_freight_value
ORDER BY orderitems_freight_value DESC) AS shipment
WHERE DATEDIFF(orderitems_shipping_limit_date,order_delivered_carrier_date) > 0
AND review_review_score = 5
ORDER BY DATEDIFF(orderitems_shipping_limit_date,order_delivered_carrier_date) DESC;

#KPI9(card)
SELECT COUNT(review_review_score) AS shipment_count
FROM
(SELECT
DISTINCT product_product_category_name,
orderitems_price, 
orderitems_freight_value,
customer_customer_city,
order_delivered_carrier_date,
orderitems_shipping_limit_date,
review_review_score
FROM olist
WHERE orderitems_price < orderitems_freight_value
ORDER BY orderitems_freight_value DESC) AS shipment;


/*SET SQL_SAFE_UPDATES = 0;

UPDATE olist
SET review_review_creation_date = SUBSTRING(review_review_creation_date,1,10);

SELECT * FROM olist;

UPDATE olist
SET order_purchase_timestamp = SUBSTRING(order_purchase_timestamp,1,10);

UPDATE olist
SET review_review_answer_timestamp = SUBSTRING(review_review_answer_timestamp,1,10);

UPDATE olist
SET review_review_creation_date = str_to_date(review_review_creation_date, '%d-%m-%Y');

UPDATE olist
SET review_review_answer_timestamp = str_to_date(review_review_answer_timestamp, '%d-%m-%Y');

UPDATE olist
SET order_purchase_timestamp = str_to_date(order_purchase_timestamp, '%d-%m-%Y');

--
UPDATE olist
SET order_approved_at = SUBSTRING(order_approved_at,1,10);
UPDATE olist
SET order_approved_at = str_to_date(order_approved_at, '%d-%m-%Y');

UPDATE olist
SET order_delivered_carrier_date = SUBSTRING(order_delivered_carrier_date,1,10);
UPDATE olist
SET order_delivered_carrier_date = str_to_date(order_delivered_carrier_date, '%d-%m-%Y');

UPDATE olist
SET order_delivered_customer_date = SUBSTRING(order_delivered_customer_date,1,10);
UPDATE olist
SET order_delivered_customer_date = str_to_date(order_delivered_customer_date, '%d-%m-%Y');

UPDATE olist
SET order_estimated_delivery_date = SUBSTRING(order_estimated_delivery_date,1,10);
UPDATE olist
SET order_estimated_delivery_date = str_to_date(order_estimated_delivery_date, '%d-%m-%Y');

UPDATE olist
SET orderitems_shipping_limit_date = SUBSTRING(orderitems_shipping_limit_date,1,10);
UPDATE olist
SET orderitems_shipping_limit_date = str_to_date(orderitems_shipping_limit_date, '%d-%m-%Y');

SELECT
pe.product_category_name_english 
FROM olist o JOIN product_eng pe ON pe.product_category_name_english = o.product_product_category_name
GROUP BY pe.product_category_name_english;

SELECT
DISTINCT customer_id,
product_product_category_name,
COUNT(payment_payment_sequential) AS sequential_payment,
ROUND(SUM(payment_payment_value),2) AS pay
FROM olist
GROUP BY product_product_category_name, customer_id;

SELECT product_product_category_name, 
payment_payment_value,
DENSE_RANK() OVER (PARTITION BY product_product_category_name ORDER BY payment_payment_value) AS _drank
FROM olist;

SELECT 
product_product_category_name,
ROUND(SUM(payment_payment_value),2) AS pay
FROM olist
GROUP BY product_product_category_name;

SELECT
ROW_NUMBER() OVER (PARTITION BY product_product_category_name)
FROM olist;

SELECT
customer_id,
product_product_category_name,
COUNT(orderitems_product_id) AS count_of_products,
SUM(payment_payment_sequential) AS payment_sequential
FROM olist
GROUP BY customer_id,
product_product_category_name;*/