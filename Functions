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
