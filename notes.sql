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
