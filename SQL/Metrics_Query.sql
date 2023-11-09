---- Metrics
-- Total Revenues
SELECT ROUND(SUM(price), 2) AS Total_Revenues
FROM [E-Commerce-Public].dbo.order_items_dataset

-- Average Order Items
SELECT CAST(
	CAST(SUM(order_item_id) AS DECIMAL(10, 2)) / CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10, 2))
	AS DECIMAL(10, 2)) AS Avg_Order_Items
FROM [E-Commerce-Public].dbo.order_items_dataset

-- Total Orders
SELECT COUNT(DISTINCT(order_id)) AS Total_Orders
FROM [E-Commerce-Public].dbo.order_items_dataset

-- Average Review Score
SELECT CAST(
	CAST(SUM(review_score) AS DECIMAL(10, 2)) / CAST(COUNT(DISTINCT(review_id)) AS DECIMAL(10, 2))
	AS DECIMAL(10, 2)) AS Avg_Review_Score
FROM [E-Commerce-Public].dbo.order_reviews_dataset

-- Average Freight Values
SELECT CAST(
	CAST(SUM(freight_value) AS DECIMAL(10, 2)) / CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10, 2))
	AS DECIMAL(10, 2)) AS Avg_Freight_Values
FROM [E-Commerce-Public].dbo.order_items_dataset
