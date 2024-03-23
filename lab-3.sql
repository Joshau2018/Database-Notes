-- Joshua Klarich's Lab 3
USE WideWorldImporters;
GO

-- Scenerio 1
UPDATE Application.Cities
SET LatestRecordedPopulation += 1000
WHERE CityName in ('Hurst', 'Bedford', 'Euless') 
      AND StateProvinceID = 45
   
-- Scenerio 2
UPDATE Purchasing.PurchaseOrders
SET OrderDate = DATEADD(YEAR, 7, OrderDate)
WHERE OrderDate >= '01/01/2015'

-- Scenerio 3
SELECT TOP 100 InvoiceID, CustomerID, ( 'XXX-' + RIGHT(CustomerPurchaseOrderNumber, 4)) AS PurchaseOrderNumberMask
FROM Sales.Invoices
WHERE  CustomerPurchaseOrderNumber IS NOT NULL
ORDER BY InvoiceDate DESC, PurchaseOrderNumberMask

-- Scenerio 4
SELECT TOP 500 CustomerID, CustomerName, ISNULL(CreditLimit, 1000000)
FROM Sales.Customers
ORDER BY CreditLimit, CustomerName

-- Scenerio 5
SELECT CustomerID, ('Tailspin Toys') AS name, Replace(SUBSTRING( CustomerName, 16, LEN(CustomerName)), ')', '') AS location
FROM Sales.Customers
WHERE CustomerName LIKE 'Tailspin Toys%'
ORDER BY location

-- Scenerio 6
SELECT PersonID, FullName, PreferredName AS [first name], trim(REPLACE(FullName, PreferredName, '')) AS [last name],
      CASE
      WHEN IsPermittedToLogon = 1 THEN LogonName
      ELSE NULL
      END [logon name]
FROM Application.People
ORDER BY [last name], [first name]