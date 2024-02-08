-- comments

-- T-SQL

-- Keywords: Uppercase, Tables/columns - Pascal cased, Everthing else -- doesn't matter

-- F5 also can execute

-- F5/Executing runs everything

-- Selecting/highlighting code makes it where only that plack of code runs

-- Databases are created to get sets of data at a time 

-- USE Database ID - sets the active connection o the given Database
USE AP;
GO

SELECT *
FROM Vendors 

-- Batch runs everything before Go
GO

-- Databaes DO NOT WORK as structured programing langueges
SELECT * FROM Terms

-- Indicator to the query engine that the statement is done; Useful for setting up other statements; Unimportant rn.
; 

-- ID [ID] 
-- Query
-- FROM Specify the table that contains the table that I want
-- Select - How we get data out of the database; requires 2 claues;
-- SELECT * then from then edit SELECT
-- SPECIFY THE COLUMNS!!
-- As Column Name [Alias]; also as is optional.
Select VendorID, LEFT(VendorName, 10) VenShortName, VendorAddress1 AS AdressLine1, VendorAddress2, VendorCity -- As Column Name [Alias]; also 'AS' is optional. Used to give it a better name
FROM Vendors

--BIT = 1 or 0; 1 = true; 0 = false;
-- TOP clause - TOP int x; A limitor; Must have an order by
Select TOP 10
InvoiceID, InvoiceNumber, InvoiceTotal, PaymentTotal, CreditTotal, PaymentTotal + CreditTotal PaidTotal
--,	CASE PaymentTotal 
--	WHEN InvoiceTotal - CreditTotal THEN 1 
--	ELSE 0 
--	END IsPaidInFull
 , CASE WHEN PaymentTotal = InvoiceTotal - CreditTotal THEN 1
   ELSE 0
   END IsPaidInFull
FROM Invoices
ORDER BY InvoiceDueDate DESC, VendorID

-- DISTINCT - Gets rid of dublicates 
Select DISTINCT TOP 10 VendorID
From Invoices
ORDER BY VendorID

--Limited to first N. cannot be variable
SELECT TOP 10 InvoiceId, InvoiceNumber, InvoiceDuedate
From Invoices
ORDER By InvoiceDueDate

--Paging
-- Offset Clause- OFFSET expr ROW
--Fet clause- First/Next exprs Rows only ; returns the nxt rows
SELECT InvoiceId, InvoiceNumber, InvoiceDuedate
From Invoices
ORDER By InvoiceDueDate
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

-- Filtering
SELECT InvoiceID, VendorID, InvoiceNumber, InvoiceDueDate, InvoiceTotal
FROM Invoices
WHERE InvoiceTotal >= 1000 OR VendorID < 110-- Where clause, larger the table the slower it runs
ORDER by vendorId, InvoiceDueDate

Select VendorID, VendorName, VendorCity, VendorState
From Vendors
--Where VendorState = 'CA' or VendorState = 'AZ' or VendorState = 'OH' -- There is NO " " only ' '
Where VendorState not in ('CA', 'AZ', 'OH') --Series of ors basically, works with any data type
Order By VendorName

--BETWEEN is superior than x > 500 AND x < 1000
Select InvoiceID, InvoiceNumber, InvoiceTotal
From  Invoices
Where InvoiceTotal BETWEEN 100 AND 500
Order By InvoiceDueDate

--Havent paid
-- NULL is NUll yet NULL is not true not false NULL is NUll but NULL does not equal NULL amd NULL Is not not NULL so NULL is just NULL
Select InvoiceId, VendorId, InvoiceNumber, InvoiceDueDate
From Invoices
--Where PaymentDate = NUll


Select VendorId, VendorName, VendorAddress1, VendorAddress2, 
-- VendorAddress1 + ' ' + ISNULL(VendorAddress2, '')
 VendorAddress1 + ' ' + COAlesce(VendorAddress2, ' ') -- COALESCE looks for the first un-null 
From Vendors
Where VendorAddress2 IS NULL

--ALL Vendors with PO Boxes
Select VendorId, VendorName, VendorAddress1, VendorAddress2 
From Vendors
-- Add % before and after to signify that no matter how many characters; _ matches any one other character; 
-- [A-Z] any letter or number; [azedefe] only does those specific character; [^xc} negates them;[%] menas matches it at that specfic point
-- NOT LIKE works just like the NOT IS
WHERE VendorAddress1 LIKE '%PO Box%' OR VendorAddress2 LIKE '%Po Box%'

-- GET current date; Local or UTC
Select GETDATE(), GETUTCDATE()

SELECT InvoiceId, InvoiceNumber, InvoiceDueDate
From Invoices

--WHERE MONTH(InvoiceDueDate) = 1 OR MONTH(InvoiceDueDate) = 12
--Where DAY(InvoiceDueDate) in (30, 31)
-- Where YEAR(InvoiceDueDate) = 2019
Where InvoiceDueDate BETWEEN '1/1/2019' AND '12/31/2019'--Superior Way
ORDER BY InvoiceDueDate

-- Get the InvoiceId, invoiceTotal
-- 


--SELECT InvoiceId, InvoiceTotal, InvoiceDueDate
--FROM Invoices 
--WHERE VendorId = 110

--SELECT TOP 10 InvoiceDueDate, InvoiceId, InvoiceTotal
--FROM Invoices
--WHERE VendorId = 110
--ORDER BY InvoiceDate DESC

--SELECT InvoiceDueDate, InvoiceId, InvoiceTotal, VendorID
--From Invoices
--WHERE InvoiceDueDate between '1/1/2020' AND '1/31/2020'
--primary key only/uniaraly id/indentifys row in table 

-- get unpaid invoices 
--SELECT TOP 10 InvoiceId, VendorID, InvoiceTotal, InvoiceDueDate
--FROM Invoices
--WHERE PaymentDate is NULL
--ORDER BY InvoiceID

--SELECT VendorID, VendorName, VendorContactFName, VendorContactLName, VendorAddress1
--FROM Vendors
--WHERE VendorID IN (72, 83, 80, 123, 110, 106, 37)

SELECT TOP 10 InvoiceId, Invoices.VendorID, InvoiceTotal, InvoiceDueDate
	,VendorName, VendorContactFName, VendorContactLName
	-- Aliases R OP
FROM Invoices
	JOIN Vendors ON Invoices.VendorID = Vendors.VendorID
WHERE PaymentDate is NULL
ORDER BY InvoiceID

SELECT v.VendorID, VendorName, InvoiceID
FROM   Invoices i CROSS JOIN Vendors v --on v.VendorID = i.VendorID
ORDER BY VendorID

SELECT TermsDueDays, VendorId, VendorName
FROM Vendors v JOIN Terms t ON t.TermsID = v.DefaultTermsID
WHERE t.TermsDueDays > 30--TermsDueDays > 30t.TermsID IN (4, 5)

--USE WideWorldImporters
--GO
--Select ColorID
--From Warehouse.StockItems

--Select ColorName
--FROM Warehouse.Colors

--Select *
--FROM 

--SELECT CustomerID, CustomerName, c.BuyingGroupID
--FROM Sales.Customers c JOIN Sales.BuyingGroups bg ON c.BuyingGroupID = bg.BuyingGroupID -- If I only want whats in both do inner; 
--ORDER BY CustomerName

SELECT 'Current' Type, VendorId, VendorName, VendorContactLName, VendorContactFName
FROM Vendors
WHERE VendorID IN (1, 44, 76, 94)
UNION -- Gives the ability to run 2 quaries AS a SINGLE result
SELECT 'Updates', VendorID, 'N/A', LastName, FirstName -- Make sure that the columns alling with the first Select
FROM ContactUpdates
Where VendorID IN (1, 44, 76, 94)

--temp holiday
SELECT '1/1/2024' DataVal, 'NewYearsDay' DateName
UNION
SELECT '1/15/2024', 'MLK DAY'
UNION 
SELECT '2/19/2024', 'Presidents Day'
UNION 
SELECT '7/4/2024', 'Forth of July'
UNION -- where 'all' goes
SELECT '1/1/2024', 'NewYearsDay' -- GETS RID of duplicates unless all is above

SELECT DISTINCT VendorID
FROM Invoices
EXCEPT -- INTERSECT= GIves me all the rows in both; opp of union gets all except
SELECT Vendorid FROM Vendors Where VendorState = 'TX'

-- Aggregates; An aggregate function will run a function of all the rows and return a single one
SELECT COUNT(InvoiceID)
FROM Invoices
WHERE VendorId = 123

SELECT COUNT(*) UseColmnName
FROM Invoices
Where YEAR(InvoiceDueDate) = 2020

Select MIN(InvoiceTotal) si, MAX(InvoiceTotal) li
FROM Invoices
Where VendorId = 123 

-- SUM() func can be used to add up all values in column
-- AVG() func can be used for avg
SELECT MAX(InvoiceTotal) FROM Invoices

SELECT VendorID, MIN(InvoiceTotal) SmallestInvoice, MAX(InvoiceTotal) LargestInvoice
From Invoices
WHERE YEAR(InvoiceDueDate) = 2020
GROUP BY VendorID
ORDER BY VendorID

SELECT i.VendorID, v.VendorName, COUNT(*)
FROM Invoices i JOIN Vendors v on i.VendorID = v.VendorID
GROUP BY i.VendorId, v.VendorID -- WHen grouping only group by necessary colmns 
ORDER BY i.VendorID

SELECT VendorID, COUNT(*)
FROM Invoices
-- HAVING CLause used after grouping, Can have aggregates
GROUP BY VendorID HAVING COUNT(*) >= 3
ORDER BY VendorID

-- Get the invoices in CA 
SELECT VendorID
FROM Vendors
WHERE VendorState = 'CA'

--Invoices
SELECT InvoiceId, v.VendorID, VendorState
From Invoices i JOIN Vendors v on v.VendorID = i.VendorID
WHERE i.VendorID NOT IN (SELECT VendorID FROM Vendors WHERE VendorState = 'CA')


SELECT InvoiceId, v.VendorID, VendorState
From Invoices i JOIN Vendors v on v.VendorID = i.VendorID
WHERE VendorState = 'CA'
ORDER BY i.VendorID, InvoiceId

-- Number 7
SELECT v.VendorID
FROM Vendors v LEFT JOIN Invoices i ON v.VendorId = i.VendorID
WHERE InvoiceID IS NULL

SELECT InvoiceId, InvoiceTotal
FROM Invoices
WHERE InvoiceTotal > (SELECT AVG(InvoiceTotal) FROM Invoices)

--AVG invoice Total for vendor
SELECT TOP 10 i.VendorID, InvoiceTotal, a.avg
FROM Invoices i Join (SELECT VendorID, AVG(InvoiceTotal) avg FROM Invoices GROUP BY VendorID) a ON i.VendorID = a.VendorID
WHERE i.InvoiceTotal > a.avg 
ORDER BY i.VendorID, InvoiceTotal
