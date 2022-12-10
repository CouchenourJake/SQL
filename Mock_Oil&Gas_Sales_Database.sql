--This doc demonstrates how to create tables and query them.
--I have included mock data, that resembles a small-scale version of data I work with as an Inventory Specialist.

--This table contains information of components/sales items. The table includes multiple values both qualitative and quantitative.
CREATE TABLE Components
(TracID varchar(50),
Part# varchar(50),
Description varchar(50),
CatCode int,
Size int,
ProductLine varchar(50),
Stat_us varchar(50)
)

--This table contains information of component cost of goods (COGs).
CREATE TABLE ComponentCost
(Part# varchar(50),
Description varchar(50), 
Cost decimal(7,2)
)

--Data entry for Component table.
INSERT INTO Components VALUES
('MC123456-1', '888-888-888', 'Piston Pipe', 2, 8, 'DrillTool','In'),
('MC4564654-14', '888-123-888', 'Lock Tube', 1, 8, 'DrillTool','Used'),
('JC658456-1', '875-888-888', 'Piston Tube', 2, 8.75, 'DrillTool','Sold'),
('MC1546456-1', '856-888-838', 'Lower Tube', 1, 8, 'DrilTool','In'),
('KL1sdf2-02-36', '900999', 'Piston', 1, 9, 'HookTool','In'),
('MC18456-1', '888-888-888', 'Piston Pipe', 2, 8, 'DrillTool','In'),
('MF4562654-14', '888-123-888', 'Lock Tube', 1, 8, 'DrillTool','In'),
('JC6587956-1', '875-888-888', 'Piston Tube', 2, 8.75, 'DrillTool','Sold'),
('LC178945456-1', '856-888-838', 'Lower Tube', 1, 8, 'DrilTool','Sold'),
('KL18882-02-36', '900999', 'Piston', 1, 9, 'HookTool','In'),
('MJ465456-1', '888-888-888', 'Piston Pipe', 2, 8, 'DrillTool','In'),
('JK4564-155', '888-123-888', 'Lock Tube', 1, 8, 'DrillTool','Sold'),
('JC658456-2-39', '875-888-888', 'Piston Tube', 2, 8.75, 'DrillTool','In'),
('MC198756-189', '856-888-838', 'Lower Tube', 1, 8, 'DrilTool','In'),
('KL1s562-02-41', '900999', 'Piston', 1, 9, 'HookTool','In')

--Data entry for ComponentCost table.
INSERT INTO ComponentCost VALUES
('900999', 'Piston', 100.33),
('856-888-838', 'Lower Tube', 500.89),
('875-888-888', 'Piston Tube', 30899.10),
('888-123-888', 'Lock Tube', 600.69),
('888-888-888', 'Piston Pipe',1400.89)

--Scenario #1: A customer wants to know how much 8.75 inch Piston Tube cost.
SELECT Cost
FROM ComponentCost
WHERE Description = 'Piston Tube' AND Part# = '875-888-888'
--The Cost is $30899.10 

--Scenario #2: A member from the field sales team calls and needs to find out what we have showing 'In' stock for 9 inch components.
SElECT *
FROM Components
WHERE Stat_us = 'In' AND Size = 9
--The query returns back that we have three 9-inch Pistons for a HookTool.

--Scenario #3: The same customer previously mentioned would like to purchase two of the pistons, and wants to know the total cost for both.
--The customer is also requesting a 10% discount.
SELECT SUM(Cost) - SUM(Cost*.10) AS CustomerQuote
FROM ComponentCost
INNER JOIN ( 
SElECT TOP(2) *
FROM Components
WHERE Stat_us = 'In' AND Size = 9
 )AS CusQuo
ON ComponentCost.Part# = CusQuo.Part#
--The customer's quote is $180.59 .

--Scenario #4: Management is requesting to see everything that has been sold.
SELECT Cost, Sold.*
FROM ComponentCost
INNER JOIN
(SELECT *
FROM Components
WHERE Stat_us = 'Sold') AS Sold
ON ComponentCost.Part# = Sold.Part#
ORDER BY Cost

--Scenario #5: Engineering just called and said that I need to pull all items with a TracID that has a sequence of '456'. 
--The raw material that was used for this lot/TracID is out of spec. All items need to be accounted for.
SELECT *
FROM Components
WHERE TracID LIKE '%456%'
-- There were 10 items that had this TracID sequance

--Scenario #6: Management has requested that I contact the customers that have purchased the defective items. 
--Engineering also posted and official bulletin stating that only items with a TracID sequence of '456' and have a CatCode of '2' need to be recalled.
--I also need to find out how much of a financial loss my buisness will face after refunding the customer.

SELECT * 
FROM (
SELECT *
FROM Components
WHERE TracID LIKE '%456%' 
AND CatCode = 2 
AND Stat_us = 'Sold'
) AS Defect
JOIN ComponentCost ON
Defect.Part# = ComponentCost.Part# 
--There is only one item that meets both conditions. If there were multiple items I would write the following query to find the sum total.
SELECT SUM(Cost) AS DefectTotal  
FROM (
SELECT *
FROM Components
WHERE TracID LIKE '%456%' 
AND CatCode = 2 
AND Stat_us = 'Sold'
) AS Defect
INNER JOIN ComponentCost ON
Defect.Part# = ComponentCost.Part# 
--The total amount we will have to refund our customer is $30899.10 .

