-- 1. USER ENGAGEMENT ANALYSIS
/*A. Showing which Customers left reviews after having their 
purchased products delivered to them*/

SELECT 
o.customer_id, o.order_id, o.order_status,
r.review_score
FROM 
olist_orders_dataset$ o
JOIN
olist_order_reviews_dataset$ r
ON
o.order_id = r.order_id
WHERE o.order_status LIKE '%delivered%'

/*B. Showing the average review score for different 
product categories delivered to customers*/

SELECT 
p.product_category_name, pt.product_category_name_english,
AVG(r.review_score) AS avg_review_score
FROM 
olist_orders_dataset$ o
JOIN
olist_order_reviews_dataset$ r
ON
o.order_id = r.order_id
JOIN
olist_order_items_dataset$ i
ON
o.order_id = i.order_id
JOIN
olist_products_dataset$ p
ON
i.product_id = p.product_id
JOIN
product_category_name_translati$ pt
ON
p.product_category_name = pt.product_category_name
WHERE o.order_status LIKE '%delivered%'
GROUP BY p.product_category_name, pt.product_category_name_english
ORDER BY avg_review_score DESC;

--C. Showing the average review score for different sellers
SELECT 
s.seller_id,
AVG(r.review_score) AS avg_review_score
FROM 
olist_orders_dataset$ o
JOIN
olist_order_reviews_dataset$ r
ON
o.order_id = r.order_id
JOIN
olist_order_items_dataset$ i
ON
o.order_id = i.order_id
JOIN
olist_sellers_dataset$ s
ON
i.seller_id = s.seller_id
WHERE o.order_status LIKE '%delivered%'
GROUP BY s.seller_id
ORDER BY avg_review_score DESC;

--D. Showing frequency of orders by customers
SELECT
c.customer_id,
COUNT(o.order_id) AS order_frequency
FROM
olist_customers_dataset$ c
LEFT JOIN
olist_orders_dataset$ o
ON
c.customer_id = o.customer_id
GROUP BY c.customer_id;

--E. Showing the order value of customers

EXEC sp_rename 'olist_order_items_dataset$.order_item_id', 'order_quantity', 'COLUMN';
SELECT
c.customer_id,
o.order_id,
o.order_delivered_customer_date,
SUM(i.price * i.order_quantity) AS order_value
FROM
olist_customers_dataset$ c
JOIN
olist_orders_dataset$ o
ON
c.customer_id = o.customer_id
JOIN
olist_order_items_dataset$ i
ON
o.order_id = i.order_id
GROUP BY 
c.customer_id,
o.order_id,
o.order_delivered_customer_date
ORDER BY
order_value DESC;

