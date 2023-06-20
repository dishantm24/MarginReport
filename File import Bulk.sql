--IF OBJECT_ID('#TEMP_FILES') IS NOT NULL DROP TABLE #TEMP_FILES

drop table if exists #TEMP_FILES
CREATE TABLE #TEMP_FILES
(
FileName VARCHAR(MAX),
DEPTH VARCHAR(MAX),
[FILE] VARCHAR(MAX)
)
 
INSERT INTO #TEMP_FILES
EXEC master.dbo.xp_DirTree 'D:\Test\',1,1

--select * from #TEMP_FILES


DECLARE @FILENAME VARCHAR(MAX),@SQL VARCHAR(MAX)
 
IF OBJECT_ID('venturaDb..Pledge_t') IS NOT NULL Drop table Pledge_t




CREATE TABLE venturaDb..Pledge_t
(
ClientCode nVARCHAR(MAX),
PledgeVal float,
FSPledgeVal float
)


 
WHILE EXISTS(SELECT * FROM #TEMP_FILES)
BEGIN
   BEGIN TRY
      SET @FILENAME = (SELECT top 1 FileName FROM #TEMP_FILES )
      SET @SQL = 'BULK INSERT Pledge_t
      FROM ''D:\Test\' + @FILENAME +'''
      WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

      PRINT @SQL
      EXEC(@SQL)
   END TRY
   BEGIN CATCH
      PRINT 'Failed processing : ' + @FILENAME
   END CATCH

   DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME
END 

--ORIGINAL DATA TYPES
SELECT * FROM venturaDb..Pledge_t

