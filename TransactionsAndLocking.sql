-- ensure that movie and genere are atomic and consistant
-- A stored procedure will run an insert first since it is atomic
-- Ex. If there was a movie that got added but the genere does not exist it will insert the movie but fail the genre
-- @@TRANCOUNT/TRANACTION count increments everytime it has to call a transaction 
-- ,and decrements everytime commit or ROLLBACK is called
-- if transactions fail then it will not change once a rollback is called
-- nlike in programming langueages nested transactions are not neested transactions
-- Meaning no matter what lvl it fails it fails everything
-- EX if it fails at lvl 5 you cant fix it at lvl 4 it just stops
-- If testing Transactions in ssms might be diffferent than what the application sees
-- This is due to it being the same session if the session ends and transaction is not commited it auto rollbacks
-- Transactions makes it all one block so that if one section fails it all does
-- TRANSACTIONS are made to make something that o
BEGIN TRY
	BEGIN TRAN 
		-- stored procedure
	COMMIT
END TRY BEGIN CATCH 
	ROLLBACK

	;THROW
END CATCH


BEGIN TRAN
	BEGIN TRY
		EXEC AddMovie 'Some Movie', 'PG', '01/01/2012', 10, @genere='idk random'
	END TRY BEGIN CATCH
		ROLLBACK
	END CATCH
COMMIT -- only decrements count

--
-- 
DECLARE @title VARCHAR(100) = 'Some Movie 3'
DECLARE @genere VARCHAR(20) = 'Comedy'
DECLARE @releasedate Date = '01/01/2020'
DECLARE @runLen INT = 100
DECLARE @actorFirstName VARCHAR(100) = 'John'
DECLARE @actorLastName VARCHAR(100) = 'Snow'
DECLARE @role VARCHAR(100) = 'Luke SkyWalker'
DECLARE @newMovies TABLE (MovieId INT)

BEGIN TRAN
	BEGIN TRY
		EXEC AddMovie @title, @rating = 'PG', @releasedate = @releasedate, @runLen = @runLen, @genere = @genere
		SELECT @movieId = MovieId FROM @newMovies
		-- Insert 
		IF @actorLastName IS NOT NULL
		BEGIN
			DECLARE @actorID INT
			SELECT @actorID = ActorID FROM Actors WHERE FirstName = @actorFirstName
														AND LastName = @actorLastName
			IF @actorID IS NOT NULL
			BEGIN
				INSERT INTO Actors (FirstName, LastName) values (@actorFirstName, @actorLastName)
			END
			INSERT INTO MovieRoles (MovieID, ActorId, Role) Values (@movieId, @actorId, @role)
		END
	END TRY BEGIN CATCH
		ROLLBACK
	END CATCH
IF @@TRANCOUNT > 0 -- This is one way to stop over commiting
	COMMIT

SELECT * FROM Movies m LEFT JOIN MovieRoles mrr ON m.MovieId = mr.MovieId
	LEFT JOIN Actors a on mr.ActorId = a.ActorId
ORDER BY m.MovieId DESC
 

 -- Locking | VERY BAD SITUATION
 -- Deadlock occurs when 2+ sessions compete for the same shared resources 
 -- lock types: shared (read), exclusive (write)
 -- a true deadlock ocurs typically involving transactions
 -- while I'm updating no one else can touch it
 -- SQL will fail the one it feels like is the greater failer, usually the second
 -- To test run both at the same time
 -- Locking lvls: rows, pages, table, database | The higher the lock the more likely errors will occur
 Begin TRAN
	UPDATE Movies
	SET Title = Title

	-- ONLY FOR TESTING PURPOSES!
	WAITFOR DELAY '00:00:10'
	UPDATE Actors
	SET FirstName = FirstName
commit

-- Meanwhile in another session
 Begin TRAN
	UPDATE Actors
	SET FirstName = FirstName

	-- ONLY FOR TESTING PURPOSES!
	WAITFOR DELAY '00:00:10'
	UPDATE Movies
	SET Title = Title
commit

-- Concurrency issues
-- transactions allow multiple statements run atomic, at cost of locking
-- locking prevents isolation issues
-- Lost updates (LU) -- Updates are lost in concurrent calls
SET Transaction Isolation Level Read uncommitted
BEGIN TRAN
	SELECT * FROM Movies WHere movieid = 1
	UPDATE MOvies SET Title = Title + ' new ' WHERE movieid = 1
	WAITFOR delay '00:00:10'
	SELECT * FROM Movies WHere movieid = 1 
ROLLBACK
-- at same time as
SET Transaction Isolation Level Read uncommitted
BEGIN TRAN
	UPDATE MOvies SET RunLength += 100 WHERE movieid = 1
	WAITFOR delay '00:00:10'
	SELECT * FROM Movies WHere movieid = 1 
ROLLBACK

-- DIRTY READS (DR) - reading data that was never committed, difficult to diagnose
SET Transaction Isolation Level Read uncommitted
BEGIN TRAN
	SELECT * FROM Movies WHere movieid = 1
	UPDATE MOvies SET Title = Title + ' new ' WHERE movieid = 1
	WAITFOR delay '00:00:10'
	SELECT * FROM Movies WHere movieid = 1 
ROLLBACK
-- Same time as
SELECT * FROM Movies WHere movieid = 1 

-- Non-repeatable reads (NR)
-- occur when you run the same exact querry but the data are different
-- When in the same block and results vary even though its the same command
SET Transaction Isolation Level Read uncommitted
BEGIN TRAN
	SELECT * FROM Movies WHere movieid = 1
	UPDATE MOvies SET Title = Title + ' new ' WHERE movieid = 1
	WAITFOR delay '00:00:10'
	UPDATE MOvies SET ReleaseDate = DATEADD(year, 1, ReleaseDate) WHERE movieid = 1
	WAITFOR delay '00:00:10'
	SELECT * FROM Movies WHere movieid = 1 
ROLLBACK
-- same time as
SELECT * FROM Movies WHere movieid = 1 
WAITFOR delay '00:00:10'
SELECT * FROM Movies WHere movieid = 1 

-- Phantom reads (PR) - running same query multiple times and returns different rows


-- Isolatuin lvls 
-- Y = prevents, N = allows
-- Level            | LU | DR | NR | PR |
-- READ COMMITED    | N  | Y  | N  | N  | (Default)
-- READ UNCOMMITD   | N  | N  | N  | N  | (no locking) almost always a mistake
-- REPEATABLE READ  | Y* | Y  | Y  | N  | *(deadlocks)
-- SERIALIZABLE     | Y  | Y  | Y  | Y  | (Slower than slow)
-- SNAPSHOT         | Y  | Y  | Y  | Y  | (better than SERIALIZABLE, but does it at the cost of resourses, row-versioning on table) only on tables that need it
-- SET Transaction Isolation Level (lvl)
SET Transaction Isolation Level READCOMMITTED

-- Guide Lines
-- Keep transactions sort
-- reframe from using selects in transactions
-- Use the least restrictive level so READ COMMITED 
-- always lock our tables in the same order 

-- Customize at the query(selects) level; WITH(OPTIONS) tells the engine how we intend to use the results; genuinly lowest lvl
SELECT * FROM Movies WITH (NOLOCK) -- Genuinly used when we do not care about concurency just wanna see the data; means READUNCOMMITTED
