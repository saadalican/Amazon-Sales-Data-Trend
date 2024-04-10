/* 1. What transaction type has the maximum and minimum returns */

SELECT Payment_type, sum(return) AS max_returns
FROM ecommerce_customer_data
GROUP BY Payment_type
Order by max_returns DESC;

----------------------------

/* 2. Which transaction type has high churn */

SELECT payment_type, total_churns
FROM (
    SELECT payment_type, SUM(churn) AS total_churns
    FROM ecommerce_customer_data
    GROUP BY payment_type
) AS payment_returns
ORDER BY total_churns DESC;

----------------------------

/* 3. Total Number of returns based on product categories */

SELECT product_category, SUM(return) AS total_returns
FROM ecommerce_customer_data
GROUP BY product_category
ORDER BY total_returns DESC;

----------------------------

/* 4. Average product value purchased for each category*/

SELECT 
    product_category,
    AVG(total_purchase) AS Avg_total_purchase_value
FROM ecommerce_customer_data
    GROUP BY 
        product_category;
		
----------------------------

/* 5. Each product category total units sold */

SELECT 
    product_category,
    SUM(quantity) AS total_quantity_purchased
FROM ecommerce_customer_data
GROUP BY 
    product_category
	Order BY total_quantity_purchased DESC;

---------------------------
/* 6. Each product category total revenue*/

SELECT 
    product_category,
    SUM(total_purchase) AS total_purchased
FROM ecommerce_customer_data
GROUP BY 
    product_category
	Order BY total_purchased DESC;

---------------------------
/* 7. Avg customer Age for each product category */

SELECT 
    product_category,
    SUM(customer_age * quantity) / SUM(quantity) AS avg_age
FROM 
    ecommerce_customer_data
GROUP BY 
    product_category;

---------------------------
/* 8. Top 10 customers with maximum value purchased. */

SELECT 
    customer_id, customer_name,
    SUM(total_purchase) AS total_purchased_amount
FROM 
    ecommerce_customer_data
GROUP BY 
    customer_id
ORDER BY 
    total_purchased_amount DESC
LIMIT 10;

---------------------------
/* 9. Maximum transaction type for each product category. */

SELECT 
    product_category,
    payment_type,
    COUNT(quantity) AS transaction_count
FROM ecommerce_customer_data
GROUP BY 
    product_category, payment_type
	Order by transaction_count DESC;
	
---------------------------
/* 10. Age groups and total purchased quantity for each. */

SELECT 
    CASE 
        WHEN customer_age >= 18 AND customer_age < 30 THEN '18-29'
        WHEN customer_age >= 30 AND customer_age < 40 THEN '30-39'
        WHEN customer_age >= 40 AND customer_age < 50 THEN '40-49'
        WHEN customer_age >= 50 AND customer_age <= 70 THEN '50-70'
    END AS age_group,
    SUM(quantity) AS total_purchased_quantity
FROM 
    ecommerce_customer_data
GROUP BY 
    CASE 
        WHEN customer_age >= 18 AND customer_age < 30 THEN '18-29'
        WHEN customer_age >= 30 AND customer_age < 40 THEN '30-39'
        WHEN customer_age >= 40 AND customer_age < 50 THEN '40-49'
        WHEN customer_age >= 50 AND customer_age <= 70 THEN '50-70'
    END
	Order by age_group ASC;

---------------------------
/* 11. Total category products sold each month. */

SELECT 
    EXTRACT(YEAR FROM purchase_date) AS year,
    EXTRACT(MONTH FROM purchase_date) AS month,
    product_category,
    SUM(quantity) AS max_quantity_purchased
FROM 
    ecommerce_customer_data
GROUP BY 
    EXTRACT(YEAR FROM purchase_date), EXTRACT(MONTH FROM purchase_date), product_category
ORDER BY 
    EXTRACT(YEAR FROM purchase_date), EXTRACT(MONTH FROM purchase_date), product_category;
	
---------------------------
/* 12. Maximum category products sold each month. */	

SELECT 
    year,
    month,
    product_category,
    max_quantity_purchased
FROM (
    SELECT 
        EXTRACT(YEAR FROM purchase_date) AS year,
        EXTRACT(MONTH FROM purchase_date) AS month,
        product_category,
        SUM(quantity) AS max_quantity_purchased,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM purchase_date), EXTRACT(MONTH FROM purchase_date) ORDER BY SUM(quantity) DESC) AS rn
    FROM 
        ecommerce_customer_data
    GROUP BY 
        EXTRACT(YEAR FROM purchase_date), EXTRACT(MONTH FROM purchase_date), product_category
) AS subquery
WHERE 
    rn = 1;

---------------------------
/* 13. Total orders per category based genders */	

SELECT Gender, product_category, COUNT(*) AS total_orders
FROM ecommerce_customer_data
GROUP BY Gender, product_category
ORDER BY gender;




