USE WideWorldImporters;
GO

--  Scenerio 1
SELECT SupplierName, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode
FROM Purchasing.Suppliers

-- Scenerio 2
SELECT StateProvinceName, SalesTerritory, CountryID
FROM Application.StateProvinces
WHERE SalesTerritory = 'Southeast'
ORDER BY StateProvinceName

-- Scenerio 3
SELECT CustomerID, TransactionDate, TransactionAmount
FROM Sales.CustomerTransactions
WHERE TransactionAmount < 0 AND YEAR(TransactionDate) = 2015
ORDER BY TransactionDate DESC, TransactionAmount ASC

-- Scenerio 4
SELECT CountryName, Continent, Region, Subregion
FROM Application.Countries
WHERE LatestRecordedPopulation > 1000000 AND Continent != 'Oceania'

--Scenerio 5
SELECT TOP 10
    StockItemName, RecommendedRetailPrice, Tags
FROM Warehouse.StockItems
WHERE IsChillerStock = 1 OR StockItemName LIKE 'USB%'
ORDER BY StockItemName

-- Scenerio 6
SELECT InvoiceId, InvoiceDate, CustomerName
FROM Sales.Invoices si JOIN Sales.Customers sc ON si.CustomerID = sc.CustomerID
WHERE InvoiceDate BETWEEN '1/1/2016'AND '3/1/2016' AND CustomerName NOT LIKE '%Toys%'
ORDER BY CustomerName, InvoiceDate

-- Scenerio 7
SELECT c.ColorName
FROM Warehouse.Colors  c LEFT JOIN Warehouse.StockItems si ON c.ColorId = si.ColorID
WHERE si.ColorID is NULL

-- Scenerio 8
SELECT CityName, StateProvinceName, sp.StateProvinceCode
FROM Application.Cities c JOIN Application.StateProvinces sp ON c.StateProvinceID = sp.StateProvinceID
WHERE CityName LIKE 'A%' AND sp.SalesTerritory = 'Southeast'
ORDER BY StateProvinceName DESC, CityName

-- Scenerio 9
SELECT CustomerID Id, CustomerName 'Name', 'Consumer' 'Type'
FROM Sales.Customers
UNION
SELECT SupplierID, SupplierName, 'Supplier'
FROM Purchasing.Suppliers
ORDER BY 'Name'

-- Scenerio 10
SELECT c.CityID, sp.StateProvinceName, coun.CountryName, sp.SalesTerritory
FROM Application.Cities c
JOIN Application.StateProvinces sp ON c.StateProvinceID = sp.StateProvinceID
JOIN Application.Countries coun
ON sp.CountryID = coun.CountryID
WHERE sp.SalesTerritory = 'Southeast' OR sp.SalesTerritory = 'Southwest'
