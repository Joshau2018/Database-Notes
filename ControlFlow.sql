-- 3 kinds of tables = Global has ## infront can be seen by all
-- loacal = # only current session can see it
-- Table varible = @ clears after use, ,any rows = dont use

-- Control flow
-- IF conditional/filter 
-- IF Boolean expr BEGIN S* END [ELSE Begin s* end]
-- cant run twice
-- EXISTS (sub-qury)
-- IF exists (select * from sys.tables Where name = 'MovieRoles')
	-- DROP TABLE MovieRoles
IF exists (select * from sys.tables Where name = 'TempMovies')
	PRINT 'Already exists'
ELSE
	CREATE TABLE TempMovies (ID int identity, Name VARCHAR(100))


Create table #localTable (ID INT IDENTITY, Name VARCHAR(100))
Insert into #localTable (Name) values ('BOB'), ('Sue'), ('sam'), ('mike')
SELEcT * FROM #localTable
DROP TABLE #localTable


Declare @earliestDate DATETIME, @latestDate DATETIME
SELEcT @earliestDate = Min(ReleaseDate)
	, @latestDate = Max(Releasedate) FROM Movies GROUP BY ReleaseDate
IF ABS(DateDIFF(day, @earlestDae))


-- WARNING DANGROUS
-- While boolean-expr Begin s* END 
-- If no value a variable is NULL
-- loops are easy to mess up which is why we should try to avoid using them in sql
DECLARE @index INT = 0
DECLARE @sum INT = 0
WHILE @Index < 10
Begin
	set @sum = @sum + @index
	set @index = @index + 1
END
PRINT @sum

DECLARE @calendar TABLE (value DateTime)

-- BREAK - exits loop imediently
-- CONTINUE - exits current itteration and tries again
DECLARE @startDate DateTime = '1/1/2024'
DEclare @enddate DateTime = '12/31/2024'
WHILE @StartDate <= @enddate
Begin
	IF DATEPART(WEEKDAY, @startDate) BETWEEN 2 AND 6
	BEGIN
		Insert into @calendar Values (@startDate)
	END
	set @startDate = DATEADD(Day, 1, @startDate)
END

-- Cursor: Looping through resuls
-- Rule 1 - don't do it!!!
-- no @
-- no '*' must specify columns
-- takes a lot of time and runs through a lot of mem
-- @@FETCH_STATUS = 0 if row was fetched and -1 if not
Declare movieCursor Cursor from select exvar1, exvar2, exvar3 from exTable --(any querry)
Open movieCursor; -- ; is a must
FETCH NEXT FRom movieCursor into @exvar1, @exvar2, @exvar3; --(must specify values) same order as in select
While @@FETCH_STATUS = 0
Begin
	-- processes row
	print Formatmessage('%s [%d] %s', @exvar1, @exvar2, @exvar3)
	-- fetches next row
	FETCH NEXT FRom movieCursor into @exvar1, @exvar2, @exvar3; -- must exactlu match 1st row
End

-- Clean up
CLOSE movieCursor
Deallocate movieCursor 
-- not recommended 
