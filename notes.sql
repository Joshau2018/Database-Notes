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
