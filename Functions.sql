-- Concept of deterministic means for a given input, the same value us returned, can determine the output by input
-- non-determinism fpr a given input, may return a different value; harder to varify because it is diffiult to evaluate correctly
-- These are iportant because sometimes you cannot ue a deterministic/non-deterministic

-- STRINGS
-- FUNCTIONS | Returns | comments
-- LEN (STR | INT | LENGTH of string
-- LTRIM(STR) | Str | 
-- RTRIM(STR) | Str |
-- TRIM(STR)  | Str | NULL always returns null
-- Concat(string*) | Str | Concatenated Strings skipping NULL
-- Concat_WS(Seperator, string*) | Str | Concatenated Strings with seperator, skipping NULL
-- LEFT(string, LEN)
SELECT LEN('Hello') HelloLength, Len('') EmptyLength
SELECT LEN(CAST('Hello' AS VARCHAR(20))) CastLength
DECLARE @hello CHAR(5) = 'Hello'
SELECT LEN(@hello) CastLength, LEN(CAST('Hello' AS CHAR(20))) Cast2Length, LEN('    ') SpaceLength

SELECT '[' + LTRIM(' 1234 ') + ']' LeftValue
SELECT '[' + RTRIM(LTRIM(' 1234 ')) + ']' RightValue
SELECT '[' + RTRIM(' 1234 ') + ']' RightValue
SELECT '[' + TRIM(' 1234 ') + ']' Both2Value
      , CONCAT('[', NULL, ']')
	  , TRIM('\' FROM 'C:\temp\') Path
	  , TRIM('ab' FROM 'aHellob') AnotherTest

SELECT VendorContactFName + ' ' + VendorContactLName AS FullName
		, CONCAT(VendorContactFName, ' ', VendorContactLName) AS ConcatName
		, CONCAT_WS(' ', VendorContactFName, VendorContactLName) AS Concat2Name
FROM Vendors

SELECT LEFT('TCCD (Northeat)', 4) LeftMostChars
	 , RIGHT('123-45-6789', 4) SsnLast4
	 , SUBSTRING('123-456-7891', 5, 3) MiddleChars -- Indexs starts at 1
	 , REPLACE('01/10/2024', '/', '-') ReplacedValue

SELECT REVERSE('abc') ReversedString
	 , LOWER('ABC') LowerString
	 , UPPER('abc') UpperString
	 , '[' + SPACE(10) + ']' SpaceString

-- Numerics
-- Funct      | Returns | comments
-- ABS(n)     |  n      | absolute value
-- CEILING(n) |  Int    | Smallest int >= n
-- FLOOR(n)   |    Int  | Largest Int <= n
-- ROUNDS(value, len[,what])) | Float | Rounds/trumpcates to len digits on right
----------------
SELECT ABS(10) AbsPositive
	,  ABS(-10) AbsNegative
	, CEILING(123.45) FloorValue
	, FLOOR(123.45) FloorValue
	, ROUND(123.565653453, 2, 0) RoundValue
	, ROUND(123.565653453, 2, 1) RoundValue

-- RAND([seed]) | FLOAT | Random values between 0 and 1, exclusive; Using seed makes it lose its randomness 
SELECT RAND(10) RandomValue
	  , RAND() RandomValue1
	  , RAND() RandomValue2
--
SELECT CEILING(Rand()*10) Random1To100
	 , FLOOR(Rand()*11) RandomTo10
	 , FLOOR(RAND() * (20-5)) + 5 Random5To20

--  M to N : FLOOR(RAND() * (n-m+1))+m
SELECT FLOOR(RAND() * (20-5+1))+5 Eandom5To20

-- DateTime
-- GETDATE() | Returns current datatime, in local time
-- GETUTCDATE() | Returns current datatime, in UTC
SELECT GETDATE() CurrentDate
	 , GETUTCDATE () CurrentUtcDate

--  YEAR(GETDATE()) | returns integral year
-- MONTH(GETDATE()) | returns integral month (1-12)
SELECT YEAR(GETDATE()) YearPart
	 , MONTH(GETDATE()) MonthPart
	 , DAY(GETDATE()) DayPart
	 , DATEPART(HOUR, GETDATE()) HoursPart
	 , DATEPART(WEEKDAY, GETDATE()) DofWeekPart
	 , DATEPART(WEEK, GETDATE()) WeekPart

	SELECT TOP 10InvoiceId, InvoiceDueDate, DATEPART(WEEKDAY, InvoiceDueDate), DATENAME(WEEKDAY, InvoiceDueDate) WeekDayName
	FROM Invoices
	WHERE DATEPART(WEEKDAY, InvoiceDueDate) Between 2 AND 6
	ORDER BY InvoiceDueDate DESC

-- CAnuse possitive or negative positive future and negative past
-- DATEADD(part, interval, Date) | Returns new datetime
-- EOMONTH (DATE()) |
SELECT DATEADD(Day, 1, GETDATE()) Tomorrow
	, DATEADD(Day, -1, GETDATE()) Yesterday
	, CAST(CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/01/' + CAST (YEAR(GETDATE()) AS VARCHAR(4)) AS DATETIME) FirstMonth
	, DATEADD(DAY, -(DAY(GETDATE()) - 1), GETDATE()) FirstOfTheMonth
	, EOMONTH(GETDATE()) EndOfMonth

-- DATEDIFF(part, date1, date2) | REturns the difference in parts between the two
SELECT DATEDIFF(DAY, '1/1/2024', GETDATE()) + 1 DayOfYear
     , DATEPART(DAYOFYEAR, GETDATE()) DayOfYear2
	 , DATEADD(day, 1, EOMONTH(DATEADD(month, -1, GETDATE()))) FirstOfMonth

-- DATENAME(part, date) | Returns string equvalent of Date part
-- DATE
SELECT DATENAME(WEEKDAY, GETDATE()) WeekDayName
	 , DATETIMEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1, 0, 0, 0, 0) FirstOfMonth
	 , DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) FirstDayOfMonth2

-- Other
-- ISNULL(expr, value) | Returns expr if not Null or value otherwise
-- coalesce(expr, expr*) | returns first non null
-- IIF(Bool, true, false) | returns the true value if true and false value if false
-- 
SELECT VendorName, ISNULL(VendorContactLName, '(none)') ContactName
	 , COALESCE(VendorContactLName, VendorContactFName, '(none)') ContactPersonName
	 , IIF(DefaultTermsID != 1, 'Not 1', 'Is 1') DefaultTerms -- single '='
	 , CHOOSE(DefaultTermsID, 'First', 'Second', 'Third', 'Fourth') TermsName
FROM Vendors
ORDER BY VendorId DESC

-- Vendor IDs: 1, 2, 3, 4, 5, 6
-- STRING_SPLIT(string, seperator) | Returns a TABLE
-- STRING_AGG(expr, seperator) | returns aggregate string seperated by seperator
SELECT value
SELECT VendorId, vendorName
FROM Vendors v JOIN STRING_SPLIT('1,2,3,4,5,6', ',') x ON v.VendorId = x.value

SELECT STRING_AGG(VendorId, ',')
FROM Vendors WHERE VendorID BETWEEN 1 AND 6
-- What does OLEDB mean
