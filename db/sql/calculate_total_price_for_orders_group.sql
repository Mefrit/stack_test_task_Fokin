
IF OBJECT_ID (N'calculate_total_price_for_orders_group', N'IF') IS NOT NULL  
    DROP FUNCTION calculate_total_price_for_orders_group;  
GO  
CREATE FUNCTION calculate_total_price_for_orders_group (@row_id integer)  
RETURNS TABLE  
AS  
RETURN   
(  
	WITH Recursive 
	AS
	(
		SELECT e.row_id, e.parent_id, e.group_name
		FROM Orders e
		WHERE e.row_id = @row_id 
		UNION ALL
		SELECT e.row_id, e.parent_id, e.group_name
		FROM Orders e
			JOIN Recursive r ON e.parent_id = r.row_id

	)
	SELECT SUM(Items.price) as sum
	FROM Recursive r 
	JOIN OrderItems as Items ON Items.order_id = r.row_id 

);  