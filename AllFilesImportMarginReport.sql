--IF OBJECT_ID('#TEMP_FILES') IS NOT NULL DROP TABLE #TEMP_FILES

drop table if exists #TEMP_FILES
CREATE TABLE #TEMP_FILES
(
FileName VARCHAR(MAX),
DEPTH VARCHAR(MAX),
[FILE] VARCHAR(MAX)
)
 
INSERT INTO #TEMP_FILES
EXEC master.dbo.xp_DirTree 'D:\MarginReportScriptsandDocs\MarginReportAllFiles\',1,1

DELETE FROM #TEMP_FILES WHERE RIGHT(FileName,4) != '.CSV'

--select * from #TEMP_FILES


DECLARE 
--@FILENAME VARCHAR(MAX),@SQL VARCHAR(MAX),
--@FILENAME1 varchar(max),@SQL1 VARCHAR(MAX),
--@FILENAME2 varchar(max),@SQL2 VARCHAR(MAX),
--@FILENAME3  varchar(max),@SQL3 VARCHAR(MAX),
--@FILENAME4  varchar(max),@SQL4 VARCHAR(MAX),
@FILENAME5  varchar(max),@SQL5 VARCHAR(MAX)
--@FILENAME6  varchar(max),@SQL6 VARCHAR(MAX)

--IF OBJECT_ID('venturaDb..Pledge') IS NOT NULL Drop table Pledge
--IF OBJECT_ID('venturaDb..FundedValue') IS NOT NULL Drop table FundedValue
----IF OBJECT_ID('venturaDb..MG13Data') IS NOT NULL Drop table MG13Data
--IF OBJECT_ID('venturaDb..Payout') IS NOT NULL Drop table Payout
----IF OBJECT_ID('venturaDb..EPIPREV') IS NOT NULL Drop table EPIPREV
IF OBJECT_ID('venturaDb..Derivatives') IS NOT NULL Drop table Derivatives
--IF OBJECT_ID('venturaDb..LedgerBalance') IS NOT NULL Drop table LedgerBalance


--CREATE TABLE venturaDb..Pledge
--(
--ClientCode nVARCHAR(MAX),
--PledgeVal real,
--FSPledgeVal real
--)
 

-- CREATE TABLE [dbo].FundedValue
-- (
--SettleDate date ,
--ClientCode nvarchar(max),
--FundedAmt real,
--CollVal real
--)

--Create Table venturaDb..Payout(
--ClientCode nvarchar(max),
--PartyName nvarchar(max),
--Dates date ,
--ChequeNo nvarchar(max),
--Credit Real 

--)

--CREATE TABLE venturaDb..EPIPREV
--(

--DATES date ,
--ClientCode nvarchar(max),
--Name  varchar(max),
--Scrip bigINT,
--AccName varchar(max),
--ISIN nvarchar(max),
--Setno bigINT,
--QTY bigINT,
--Value real


CREATE TABLE Derivatives (

ClientCode Nvarchar(max),
FNOBILL real ,
CDSBILL  real,
MCXBill  real,
NCDEXBIll real,
Total  real

)


--CREATE TABLE LedgerBalance (

--ClientCode Nvarchar(max),
--LedgerBalanceT real ,
--CashBillT1 real,
--ReceiptT1 int,
--DeriBillT real,
--CashBillT2 int,
--ReceiptT2 int,
--DeriBillT1 int,
--CashBillT0 real,
--FD real 
--)

--CREATE TABLE dbo.MG13Data
--(
--DATES date ,
--ClientCode nvarchar(max),
--[VARM_ELM] real,
--MinMargin real,
--Additional_Margin real,
--MTM real,
--SPANMarginF real,
--Extreme_Loss_MarginF real,
--DeliveryMarginF real,
--M2MF real,
--SPANMarginC real,
--Extreme_Loss_MarginC real,
--M2MC real,
--InitialMarginMcx real,
--OtherMarginMcx real,
--M2MMcx real,
--InitialMarginNcdx real,
--OtherMarginNcdx real,
--M2MNcdx real,
--SPANMarginCOMM real,
--Extreme_Loss_MarginCOMM real,
--M2MCOMM real,
--CashPeakMargin real,
--FNOPeakMargin real,
--CURPeakMargin real,
--MCXPeakMargin real,
--NCDEXPeakMargin real,
--COMMPeakMargin real,
--Total_T real,
--Total_T_1 real,
--Total_T_2 real,
--Total real

--)


WHILE EXISTS(SELECT * FROM #TEMP_FILES)
BEGIN

---Pledge table 
   --BEGIN TRY
   --   SET @FILENAME = (SELECT top 1 FileName FROM #TEMP_FILES )
   --   SET @SQL = 'BULK INSERT Pledge
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL
   --   EXEC(@SQL)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME
   --END CATCH
------FUNDEDVALUETABLE------------------------------------------------
   --   BEGIN TRY
   --   SET @FILENAME1 = (SELECT top 1 FileName FROM #TEMP_FILES  )
   --   SET @SQL1 = 'BULK INSERT FundedValue
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME1 +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL1
   --   EXEC(@SQL1)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME1
   --END CATCH

   -------------------------------MG13data-------------------------------------------------

   --      BEGIN TRY
   --   SET @FILENAME2 = (SELECT top 1 FileName FROM #TEMP_FILES  )
   --   SET @SQL2 = 'BULK INSERT MG13Data
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\MG13Data.csv' + @FILENAME2 +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL2
   --   EXEC(@SQL2)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME2
   --END CATCH

   -------------------------------Payout---------------------------------------------

   --     BEGIN TRY
   --   SET @FILENAME3 = (SELECT top 1 FileName FROM #TEMP_FILES  )
   --   SET @SQL3 = 'BULK INSERT Payout
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME3 +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL3
   --   EXEC(@SQL3)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME3
   --END CATCH

   -----------------------EPIPREV----------------------------------------


   
   --     BEGIN TRY
   --   SET @FILENAME4 = (SELECT top 1 FileName FROM #TEMP_FILES  )
   --   SET @SQL4= 'BULK INSERT EPIPREV
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME4 +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL4
   --   EXEC(@SQL4)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME4
   --END CATCH


   -----Derivatives-------------------------------
        BEGIN TRY
      SET @FILENAME5 = (SELECT top 1 FileName FROM #TEMP_FILES  )
      SET @SQL5 = 'BULK INSERT Derivatives
      FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME5 +'''
      WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

      PRINT @SQL5
      EXEC(@SQL5)
   END TRY
   BEGIN CATCH
      PRINT 'Failed processing : ' + @FILENAME5
   END CATCH

----------------------------------Ledger Balance ---------------------------------------
   --     BEGIN TRY
   --   SET @FILENAME6 = (SELECT top 1 FileName FROM #TEMP_FILES  )
   --   SET @SQL6 = 'BULK INSERT LedgerBalance
   --   FROM ''D:\MarginReportScriptsandDocs\MarginReportAllFiles\' + @FILENAME6 +'''
   --   WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');'

   --   PRINT @SQL6
   --   EXEC(@SQL6)
   --END TRY
   --BEGIN CATCH
   --   PRINT 'Failed processing : ' + @FILENAME6
   --END CATCH

--DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME
--DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME1
----DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME2
--DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME3
--DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME4
DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME5
--DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME6
END 

--ORIGINAL DATA TYPES
--SELECT * FROM venturaDb..Pledge


--select * from FundedValue


--select * from MG13Data


--select * from Derivatives

--select * from EPICurrent

--drop table LedgerBalance

--select * from LedgerBalance


BULK insert venturaDb..Payout from 'D:\MarginReportScriptsandDocs\MarginReportAllFiles\Todays Payout details with client code_07062023_2.rpt'
with(FIELDTERMINATOR =',',ROWTERMINATOR ='\n')

truncate table MG13Data

select * from MG13Data

select * from payout

delete from payout where ClientCode = 'Party Code'


BULK insert venturaDb..MG13Data from 'D:\MarginReportScriptsandDocs\MarginReportAllFiles\mg13test.csv'
with(DataFiletype = 'char',FIELDTERMINATOR =',',ROWTERMINATOR ='\n')


drop table LedgerBalance

drop table FundedValue

Truncate table EPIPREV

 exec xp_cmdshell 'bcp venturaDb..Payout in D:\MarginReportScriptsandDocs\MarginReportAllFiles\Payout.rpt -c -t, -T -S VSL1184'--payout 

exec xp_cmdshell 'bcp venturaDb..Pledge in D:\MarginReportScriptsandDocs\MarginReportAllFiles\Pledge.rpt -c -t, -T -S VSL1184'--pLedge 

exec xp_cmdshell 'bcp venturaDb..FundedValue in D:\MarginReportScriptsandDocs\MarginReportAllFiles\FundedAmount.rpt -c -t, -T -S VSL1184'--FundedValue 

exec xp_cmdshell 'bcp venturaDb..EPIPREV in D:\MarginReportScriptsandDocs\MarginReportAllFiles\EPIPREV.rpt -c -t, -T -S VSL1184'--EPIPREV 


exec xp_cmdshell 'bcp venturaDb..EPICURRENT in D:\MarginReportScriptsandDocs\MarginReportAllFiles\EPICURRENT.rpt -c -t, -T -S VSL1184'--EPICURRENT 



exec xp_cmdshell 'bcp venturaDb..Derivatives in D:\MarginReportScriptsandDocs\MarginReportAllFiles\Derivatives.csv -c -t, -T -S VSL1184'--EPICURRENT 


exec xp_cmdshell 'bcp venturaDb..MG13Data in D:\MarginReportScriptsandDocs\MarginReportAllFiles\MG13230608_072709.csv -c -t, -T -S VSL1184'--EPICURRENT 




BULK insert venturaDb..LedgerBalance from 'D:\MarginReportScriptsandDocs\MarginReportAllFiles\LedgerBalance_old.csv'
with(FirstROW = 2 ,FIELDTERMINATOR = ',')

select * from MG13Data where ClientCode = '080184'

delete from EPICURRENT where Party = 'Party'



drop table MG13Data
truncate  table Derivatives

select * from ledgerbalance


Ledger baalance ,derivatives ,import rpt in csv as text format and then use import wizard for flat file 