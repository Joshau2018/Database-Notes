-- functions can accept some arguements with limitation, must return a value, pretty flexable
-- dunctions can run scripts like sp's can but are more restrictive
-- not designed to run outside of the database
-- sp's are not easy to chain together so most of the time functs are used
-- CAN be called anywhere a SELECT is needed
-- Limits:
--  CAN ONLY use input only paramaters
--  NO STORED PREDCEDURE CALLS; but can be used vice versa
--  NO error handling or RAISEERROR
--  NO inserts or deletes inside a funct; No modification can be mad inside funts
-- *NO SELECTs unless assinging to a variable 
-- create a funct to return True or False based upon a bit column
-- Create Function  FunctionName (Parameters) RETurns ReturnType 
-- This is a scalor funct
Create Function  GetBoolean (
  @value BIT
) RETurns VARchar(5)
AS BEGIN
	IF @value = 1
		RETURN 'TRUE'
	RETURN 'FALSE'
END

-- DO NOT OVER USE FUNCTIONS
-- ITS NOT LIKE PROGRAMMING LANGUAGES
-- Can effect profermance a lot
SELECT MovieId, Title, IsBlackWhite, dbo.GetBoolean(IsBlackWhite)
FROM Movies
WhERe dbo.GetBoolean(IsBlackWhite) = 'TRUE'

-- Create a funct to create formtted movie name
--- To moify change create to UPDAT or alt use drop
ALTER FUNCTION GetFormattedTitle (
	@title varchar(100)
	,@releaseDate Date = NULL
) rETURNS VARCHAR(120)
AS BEGIN
	--if @releaseDate IS NULL
		--RETURN @title
	return @title + ' (' + COALESCE(CAST(YEAR(@releaseDate) AS VARCHAR(4)), '?')  + ')'
END

SELECT MovieId, Title, ReleaseDate, dbo.GetFormattedTitle(Title, ReleaseDate)
FROM Movies

-- Create a funct to generate a number table
-- Not reccomended from Professor
-- Table value funct
ALTER FUNCTION GenerateNumberTable (
	@minValue INT = 1,
	@maxValue INT = 100
) RETURNS TABLE
AS RETURN WITH Number AS (
	SELECT @minValue Value
	UNION ALL
	SELECT VALUE + 1
	From Number
	WHERE Value < @maxValue
) SELECT Value From Number -- Basically returns the selcect statement as a Table
-- Has to be in the FROM
SELECT * FROM dbo.GenerateNumberTable(1, 20)

-- Create a funct to generate a calander
CREATE FUNCTION GenerateCalendar (
	@startDate DATE,
	@endDate DATE
) RETURNS @results TABLE (value DATE)
AS BEGIN
	WHILE @startDate <= @endDate
	BEGIN
		INSERT INTO @results Values (@startdate)

		SET @startDate = DATEADD(day, 1, @startDate) -- for performance reasons dont use a temp var
	END
	RETURN
END

SELECT * FROM dbo.GenerateCalendar('1/1/2024', GETDATE())
