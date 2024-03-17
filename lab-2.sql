-- Joshua Klarich's lab 2
USE WideWorldImporters;
GO

-- Scenerio 1 and 1 row returned
SELECT MIN(Temperature) LowestTemperatur, MAX(Temperature) AS [Highest Tempature]
FROM Warehouse.VehicleTemperatures

-- Scenerio 2 and 10 rows returned
SELECT SalespersonPersonID, COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY SalespersonPersonID
ORDER BY TotalOrders DESC

--Scenerio 3 and 657 rows returned
SELECT CustomerID, COUNT(*) AS TotallInvoices
FROM Sales.Invoices
WHERE YEAR(InvoiceDate) = 2015
GROUP BY CustomerID
ORDER BY TotallInvoices, CustomerID

-- Scenerio 4 and 32 rows returnd 
;WITH Sol AS(
    SElECT ol.OrderID, (Quantity * UnitPrice) AS TotalOrderPrice
    FROM Sales.OrderLines ol 
        JOIN Sales.Invoices i ON ol.OrderID = i.OrderID 
        JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
    WHERE c.CustomerName = 'Debbie Molina' AND YEAR(InvoiceDate) = 2016
)

SELECT so.OrderID, TotalOrderPrice
FROM Sales.Orders so
    JOIN Sol sl ON so.OrderID = sl.OrderId
ORDER BY TotalOrderPrice Desc

-- Scenerio 5 and 52 rows returned
;WITH total AS(
 SELECT o.CustomerID, COUNT(*) TotalOrders
    FROM sales.Orders o JOIN Sales.Invoices i ON i.OrderID = o.OrderID
    WHERE YEAR(InvoiceDate) = 2016 
    GROUP BY o.CustomerID
)
SELECT DISTINCT o.CustomerID, TotalOrders
FROM Sales.Orders o JOIN total t ON o.CustomerID = t.CustomerID
WHERE TotalOrders >= 20
ORDER BY TotalOrders DESC, CustomerID

-- Scenerio 6 and returns 50 rows
SELECT DISTINCT TOP 50 ord.StockItemId, sub.StockItemName, sub.Quantity
FROM Sales.OrderLines ord 
JOIN Warehouse.StockItems wsi ON ord.StockItemID = wsi.StockItemID
JOIN (
    SELECT DISTINCT stock.StockItemName AS StockItemName, SUM(quant) Quantity
    FROM Sales.OrderLines ord JOIN Warehouse.StockItems stock ON ord.StockItemID = stock.StockItemID
    JOIN (
          SELECT DISTINCT OrderId, SUM(Quantity) AS Quant
          FROM Sales.OrderLines ol JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
          GROUP BY OrderID) quan ON ord.OrderID = quan.OrderID
    GROUP BY stock.StockItemName) sub ON wsi.StockItemName = sub.StockItemName
ORDER BY Quantity DESC

-- Scenerio 7 and returns 10 rows
SELECT TOP 10 c.CustomerID, CustomerName, [Total Orders]
FROM Sales.Customers c 
JOIN (SELECT CustomerId, COUNT(*) AS [Total Orders]
FROM Sales.Orders 
GROUP BY CustomerID) count ON c.CustomerID = count.CustomerID
ORDER BY [Total Orders] DESC

-- Scenerio 8 and returns 9
SELECT DeliveryMethodID, DeliveryMethodName
FROM Application.DeliveryMethods
Where DeliveryMethodID NOT IN (SELECT DeliveryMethodID FROM sales.Customers)
ORDER BY DeliveryMethodName
