-- Percentage Orders by Status Order
WITH RankedStatus AS (
SELECT 
	order_status as Order_Status,
	CAST(
		CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10, 2)) * 100 / (SELECT COUNT(DISTINCT(order_id)) FROM [E-Commerce-Public].dbo.orders_dataset
		)	AS DECIMAL(10, 2)) AS Perc_of_Status_Orders,
	ROW_NUMBER() OVER (ORDER BY 
					CAST(
						CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10, 2)) * 100 
							/ (SELECT COUNT(DISTINCT(order_id)) FROM [E-Commerce-Public].dbo.orders_dataset
						)	AS DECIMAL(10, 2)) DESC) AS Status_Rank
FROM [E-Commerce-Public].dbo.orders_dataset
GROUP BY order_status
)

SELECT 
	Order_Status,
	Perc_of_Status_Orders
FROM RankedStatus
WHERE Status_Rank <= 4

UNION ALL

SELECT 
	'others' AS Order_Status,
	SUM(Perc_of_Status_Orders)
FROM RankedStatus
WHERE Status_Rank >= 5
ORDER BY Perc_of_Status_Orders DESC


-- Percentage Revenues by Payment Order
SELECT opd.payment_type,
	CAST(
	SUM(oid.price) * 100 / (SELECT SUM(price) FROM [E-Commerce-Public].dbo.order_items_dataset)
	AS DECIMAL(10, 3)) AS Perc_Total_Revenue
FROM [E-Commerce-Public].dbo.order_payments_dataset opd
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON opd.order_id = oid.order_id
GROUP BY opd.payment_type
ORDER BY Perc_Total_Revenue DESC

-- Percentage Revenues by Payment Order
SELECT opd.payment_type,
	CAST(
		CAST(COUNT(DISTINCT(oid.order_id)) AS DECIMAL(10, 2)) * 100 
		/ (SELECT COUNT(DISTINCT(order_id)) FROM [E-Commerce-Public].dbo.order_items_dataset)
	AS DECIMAL(10, 2)) AS Perc_Total_Revenue
FROM [E-Commerce-Public].dbo.order_payments_dataset opd
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON opd.order_id = oid.order_id
GROUP BY opd.payment_type
ORDER BY Perc_Total_Revenue DESC


-- Total Revenues by Months
SELECT DATEPART(MONTH, order_purchase_timestamp) AS Monthly,
	CAST(SUM(price) AS DECIMAL(10, 2)) AS Total_Revenue
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON od.order_id = oid.order_id
GROUP BY DATEPART(MONTH, order_purchase_timestamp)
ORDER BY DATEPART(MONTH, order_purchase_timestamp)


-- Total Orders by Months
SELECT DATEPART(MONTH, order_purchase_timestamp) AS Monthly,
	COUNT(DISTINCT(order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.orders_dataset
GROUP BY DATEPART(MONTH, order_purchase_timestamp)
ORDER BY DATEPART(MONTH, order_purchase_timestamp)


-- Total Revenues by Hours
SELECT DATEPART(HOUR, order_purchase_timestamp) AS Hourly,
	CAST(SUM(price) AS DECIMAL(10, 2)) AS Total_Revenue
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON od.order_id = oid.order_id
GROUP BY DATEPART(HOUR, order_purchase_timestamp)
ORDER BY DATEPART(HOUR, order_purchase_timestamp)


-- Total Orders by Hours
SELECT DATEPART(HOUR, order_purchase_timestamp) AS Hourly,
	COUNT(DISTINCT(order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.orders_dataset
GROUP BY DATEPART(HOUR, order_purchase_timestamp)
ORDER BY DATEPART(HOUR, order_purchase_timestamp)


-- Top 10 Total Revenues by Customer City
SELECT TOP 10 
	cd.customer_city AS Customer_City,
	ROUND(SUM(oid.price), 2) AS Total_Revenue
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON od.customer_id = cd.customer_id
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON oid.order_id = od.order_id
GROUP BY cd.customer_city
ORDER BY Total_Revenue DESC


-- Top 10 Total Orders by Customer City
SELECT TOP 10
	cd.customer_city,
	COUNT(DISTINCT(od.order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.customers_dataset cd
INNER JOIN [E-Commerce-Public].dbo.orders_dataset od
	ON od.customer_id = cd.customer_id
GROUP BY cd.customer_city
ORDER BY Total_Orders DESC


-- Top 10 Total Revenues by Product
SELECT TOP 10 pcnt.product_category_name_english AS Product_Name,
	CAST(SUM(oid.price) AS DECIMAL(10, 3)) AS Total_Revenue
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
GROUP BY pcnt.product_category_name_english
ORDER BY Total_Revenue DESC


-- Bottom 10 Total Revenues by Product
SELECT TOP 10 pcnt.product_category_name_english AS Product_Name,
	CAST(SUM(oid.price) AS DECIMAL(10, 3)) AS Total_Revenue
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
GROUP BY pcnt.product_category_name_english
ORDER BY Total_Revenue ASC


-- Top 10 Total Orders by Product
SELECT TOP 10 pcnt.product_category_name_english AS Product_Name,
	COUNT(DISTINCT(oid.order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
GROUP BY pcnt.product_category_name_english
ORDER BY Total_Orders DESC


-- Bottom 10 Total Orders by Product
SELECT TOP 10 pcnt.product_category_name_english AS Product_Name,
	COUNT(DISTINCT(oid.order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
GROUP BY pcnt.product_category_name_english
ORDER BY Total_Orders ASC


-- Top 5 Total Revenues by Customer State
SELECT TOP 5
	cd.customer_state AS Customer_State,
	ROUND(SUM(oid.price), 2) AS Total_Revenue
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON od.customer_id = cd.customer_id
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON oid.order_id = od.order_id
GROUP BY cd.customer_state
ORDER BY Total_Revenue DESC


-- Bottom 5 Total Revenues by Customer State
SELECT TOP 5
	cd.customer_state AS Customer_State,
	ROUND(SUM(oid.price), 2) AS Total_Revenue
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON od.customer_id = cd.customer_id
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON oid.order_id = od.order_id
GROUP BY cd.customer_state
ORDER BY Total_Revenue ASC


-- Top 5 Total Orders by Customer State
SELECT TOP 5
	cd.customer_state AS Customer_State,
	COUNT(DISTINCT(oid.order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON od.customer_id = cd.customer_id
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON oid.order_id = od.order_id
GROUP BY cd.customer_state
ORDER BY Total_Orders DESC


-- Bottom 5 Total Orders by Customer State
SELECT TOP 5
	cd.customer_state AS Customer_State,
	COUNT(DISTINCT(oid.order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.orders_dataset od
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON od.customer_id = cd.customer_id
INNER JOIN [E-Commerce-Public].dbo.order_items_dataset oid
	ON oid.order_id = od.order_id
GROUP BY cd.customer_state
ORDER BY Total_Orders ASC


-- Top 5 Avg Review Score by Product
SELECT TOP 5 pcnt.product_category_name_english AS Product_Name,
	CAST(
		CAST(SUM(ord.review_score) AS DECIMAL(10,2)) / COUNT(pcnt.product_category_name)
	AS DECIMAL(10,2))  AS Avg_Review_Score
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
INNER JOIN [E-Commerce-Public].dbo.order_reviews_dataset ord
	ON ord.order_id = oid.order_id
GROUP BY pcnt.product_category_name_english
ORDER BY Avg_Review_Score DESC


-- Bottom 5 Avg Review Score by Product
SELECT TOP 5 pcnt.product_category_name_english AS Product_Name,
	CAST(
		CAST(SUM(ord.review_score) AS DECIMAL(10,2)) / COUNT(pcnt.product_category_name)
	AS DECIMAL(10,2))  AS Avg_Review_Score
FROM [E-Commerce-Public].dbo.order_items_dataset oid
INNER JOIN [E-Commerce-Public].dbo.product_dataset pd
	ON oid.product_id = pd.product_id
INNER JOIN [E-Commerce-Public].dbo.product_category_name_translation pcnt
	ON pcnt.product_category_name = pd.product_category_name
INNER JOIN [E-Commerce-Public].dbo.order_reviews_dataset ord
	ON ord.order_id = oid.order_id
GROUP BY pcnt.product_category_name_english
ORDER BY Avg_Review_Score ASC


-- Top 5 Avg Review Score by Customer State
SELECT TOP 5 cd.customer_state AS State,
	CAST(
		CAST(SUM(ord.review_score) AS DECIMAL(10, 2)) / CAST(COUNT(cd.customer_state) AS DECIMAL(10, 2))
	AS DECIMAL(10, 2)
	) AS Avg_Review_Score
FROM [E-Commerce-Public].dbo.order_reviews_dataset ord
INNER JOIN [E-Commerce-Public].dbo.orders_dataset od
	ON ord.order_id = od.order_id
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON cd.customer_id = od.customer_id
GROUP BY cd.customer_state
ORDER BY Avg_Review_Score DESC

-- Bottom 5 Avg Review Score by Customer State
SELECT TOP 5 cd.customer_state AS State,
	CAST(
	CAST(SUM(ord.review_score) AS DECIMAL(10, 2)) / CAST(COUNT(cd.customer_state) AS DECIMAL(10, 2))
	AS DECIMAL(10, 2)
	) AS Avg_Review_Score
FROM [E-Commerce-Public].dbo.order_reviews_dataset ord
INNER JOIN [E-Commerce-Public].dbo.orders_dataset od
	ON ord.order_id = od.order_id
INNER JOIN [E-Commerce-Public].dbo.customers_dataset cd
	ON cd.customer_id = od.customer_id
GROUP BY cd.customer_state
ORDER BY Avg_Review_Score ASC