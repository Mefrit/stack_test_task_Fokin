
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
		SELECT Orders1.row_id, Orders1.parent_id, Orders1.group_name
		FROM Orders AS Orders1 
		WHERE Orders1.row_id = @row_id 
		UNION ALL
		SELECT Orders2.row_id, Orders2.parent_id, Orders2.group_name
		FROM Orders AS Orders2
			JOIN Recursive r ON Orders2.parent_id = r.row_id

	)
	SELECT SUM(Items.price) as sum
	FROM Recursive r 
	JOIN OrderItems as Items ON Items.order_id = r.row_id 

);  