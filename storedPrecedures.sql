-- most stored precedures start with sp_ which sp = stored precedures
-- must start with EXEC[UTE] name 
-- gets info of an object
EXEC sp_help 'name here'

-- returns a row for each line of view
-- need the right to view the deffenitions
-- sp_helptext - gets the def of an object such as views
-- sp_who - displays running connections
EXEC sp_helptext 'id of object'

-- sp_who - displays running connections
-- can see who is using the sytstem
-- again need permissions to be able to see
EXEC sp_who

-- sp_depends 'id' | Will dump all the SQL dependencies that the object has
EXEC sp_depends 'id'

-- xp -> Extended procedures
--xp_msver - displays system info; genuinally not used in a script
EXEC xp_msver

-- gives the tables in a cleaner format than sys.tables
-- have to be in the right database already
EXEC sp_tables
EXEC sp_columns 'Table Name'
EXEC sp_databases
-- Programmability -> stored precedures -> can edit them; dont tho
-- if I have the ability to access a stored precedure then it can access anything that I want, but can prevent the user from afecting the table
-- can only be created by adminitration and onece created permament 
-- can have paramaters
-- everything outside the no count test saves time
-- nearly always has a select, so be careful because it returns all as seperate results in the same set

CREATE PROCEDURE AddMovie -- ALTER CAN be used to change a procedure
-- Parramaters | Local varibles | means it req a VARCHAR(100) | sep by ','
	 @title Varchar(100) 
	, @realeaseDate (Date)
	, @rating Varchar(10)
	, @runlength int = 0
	, @summary varchar(255) = NULL
	, @inermissionlen int = NULL
	, @isblackandwhite bit = 0
	, @genre varchar(50) = NULL
AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	--SELECT 'Added movie' + @title, @description
-- set some vals
	IF LEN(ISNULL(@title, '')) = 0
	Begin
		;throw 50000, 'title is required', 0
	end
	SElect * from movies
	
	IF NOt exists (select * from ratings, where description = @rating)
	begin
		;throw 50001, 'ratinf is invalid', 0
	end

	insert Movies (title, runlength, summary, isblackandwhite, MPAARating,
				releasedate, intermissionlen)
			Values (@title, @runlength, @sumry, @isblackandwhite, @rating, @realeaseDate, @isblackandwhite)
	set @movieId = SCOPE_IDENTITY()
	IF @genre IS NOt NULL
	Begin
		declare @genreId int
		SELECT @genreid = genreid FROM Genres where genrename = @genere
		IF @genreId is null
		Begin
			insert into genres (genrenames) values (@genere)
			set @genreId = SCOPE_IDENTITY()
		END
		insert INTO MovieGenres (MovieId, genreId) values (@movieId, @genreId)
	end
	-- return the movieId
	SELECT @movieId
END
GO

-- DROP PROCEDURE IF EXISTS AddMovie | if exists it drops it | always follows
 -- can specify NULL if a parramater is not req and you dont want to, could also use DEFAULT to set as DEFAULT val
EXEC AddMovie 'Paramater if req one', NULL, '01/01/2001'
-- OR
EXEC AddMovie 'Paramater if req one', @releaseDate = '01/01/2001', @rating = 'G' -- is also equiv

-- temmp table or table variable
DECLARE @tempTable TABLE (TITLE VARCHAR(100), DESCRIPTION VARCHAR(255), Release DateTime)
INSERT INTO @tempTable (Title, Description, Release)
EXEC AddMovie 'Paramater if req one', @releaseDate = '01/01/2001'
SELECT * FROM @tempTable
-- stored precedures must run solo
-- Dont rely on stored precedures for everything

CREATE PROCEDURE AddMovie -- ALTER CAN be used to change a procedure
-- Parramaters | Local varibles | means it req a VARCHAR(100) | sep by ','
	 @title Varchar(100) 
	, @realeaseDate (Date)
	, @rating Varchar(10)
	, @runlength int = 0
	, @summary varchar(255) = NULL
	, @inermissionlen int = NULL
	, @isblackandwhite bit = 0
	, @genre varchar(50) = NULL
AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT 'Added movie' + @title, @description
	


-- set some vals


	IF LEN(ISNULL(@title, '')) = 0
	Begin
		;throw 50000, 'title is required', 0
	end
	SElect * from movies
	
	IF NOt exists (select * from ratings, where description = @rating)
	begin
		;throw 50001, 'ratinf is invalid', 0
	end

	insert Movies (title, runlength, summary, isblackandwhite, MPAARating,
				releasedate, intermissionlen)
			Values (@title, @runlength, @sumry, @isblackandwhite, @rating, @realeaseDate, @isblackandwhite)
	set @movieId = SCOPE_IDENTITY()
	IF @genre IS NOt NULL
	Begin
		declare @genreId int
		SELECT @genreid = genreid FROM Genres where genrename = @genere
		IF @genreId is null
		Begin
			insert into genres (genrenames) values (@genere)
			set @genreId = SCOPE_IDENTITY()
		END
		insert INTO MovieGenres (MovieId, genreId) values (@movieId, @genreId)
	end
	-- return the movieId
	SELECT @movieId
END
GO

-- DROP PROCEDURE IF EXISTS AddMovie | if exists it drops it | always follows
 -- can specify NULL if a parramater is not req and you dont want to, could also use DEFAULT to set as DEFAULT val
EXEC AddMovie 'Paramater if req one', NULL, '01/01/2001'
-- OR
EXEC AddMovie 'Paramater if req one', @releaseDate = '01/01/2001', @rating = 'G' -- is also equiv

-- temmp table or table variable
DECLARE @tempTable TABLE (TITLE VARCHAR(100), DESCRIPTION VARCHAR(255), Release DateTime)
INSERT INTO @tempTable (Title, Description, Release)
EXEC AddMovie 'Paramater if req one', @releaseDate = '01/01/2001'
SELECT * FROM @tempTable
-- stored precedures must run solo

CREATE PROCEDURE GetGenreCount
	  @genre VARCHAR(100)
	, @doesExist BIT OUTPUT -- SqL calls it output but is actually Input->Output
AS BEGIN 
	set NOCOUNT ON;
	IF NOT EXISTS (SELECT * FROM Generes WHERE GenereName = @genre)
	BEGIN
		SET @doesExist = 0
		RETURN 0
	END
	SET @doesExist = 1
	DECLARE @count INT
	SELECT @count = COUNT(*) from Genres g JOIN MoviGeneres mg ON g.GenereId = mg.GenereId
	WHERE g.GenereName = @genere
	GROUP BY mg.GenereId

	RETURN @count
END

EXEC GetGenreCount 'Comedy' -- There is no reult captured since its only returning not printing

-- Thus you have to do this
DECLARE @result INT
DECLARE @doesExist BIT
EXEC @result = GetGenreCount 'GenreName', @doesExists OUTPUT -- req the OUTPUT
PRINT @result
PRINT @doesExist

-- 



