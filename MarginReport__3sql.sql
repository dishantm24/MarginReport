--CASH to NSE COm : from MG13....rpt file 

--Total1 ,Total3,Total3,Total4 : From MG13 PEak Generated file 

--Total t, Total t+1 , total t+2 , TOT marging : MG13...rpt file 

--WITH ID as (
																				

--select   ClientCode from mg13data
--)


DROP TABLE	IF EXISTS MarginReportFinal;


WITH CTE as (
select md.ClientCode,isnull([VARM_ELM],0) as[VARM+ELM] ,isnull(MinMargin,0) as MinMargin,
isnull([Additional_Margin],0) as [Additional Margin CASH],isnull(MTM,0) as 'M2MCASH' ,
isnull(SPANMarginF,0) as SPANFNO,ISNULL([Extreme_Loss_MarginF],0) as ELMFNO,ISNULL(DeliveryMarginF,0) as DellMarginFNO,ISNULL(M2MF,0) as M2MFNO,
isnull(SPANMarginC,0) as SPANCDS,ISNULL([Extreme_Loss_MarginC],0) as ELMCDS,ISNULL(M2MC,0) as M2MCDS,
ISNULL(InitialMarginMcx,0) as IMMCX,ISNULL(OtherMarginMcx,0) as OthersMCX,ISNULL(M2MMcx,0) as M2MMCX,
ISNULL(InitialMarginNcdx,0) as IMNCDX,ISNULL(OtherMarginNcdx,0) as OthersNCDX,ISNULL(M2MNcdx,0) as M2MNCDX,
ISNULL(SPANMarginCOMM,0) as SPANCOM,ISNULL([Extreme_Loss_MarginCOMM],0) as ELMCOM,ISNULL(M2MCOMM,0) as M2MCOM,
ISNUll(TotalPeak1,0) as Total1,isnull(TotalPeak2,0) as Total2,ISNULL(TotalPeak3,0) as Total3,ISNULL(TotalPeak4,0) as Total4, ISNULL(NULL,0) as Filler1,
isNULL(round([Total_T],2),0) as TotalT,ISNULL([Total_T_1],0) as [TotallT+1],ISNULL([Total_T_2],0) as [TotalT+2],
ISNULL(md.Total,0) as 'TotMargin',isNULL(pd.PledgeVal,0) as Pledge,
ISNULL(fa.CollVal,0) as 'PledgeRequired', ISNULL(NULL,0) as Filler2,
ISNULL(round(epip.Val,2),0) as 'EPI_T-1DAY',ISNULL(round(epic.Val,2),0) as 'EPIT(to reduce on T+2)',ISNULL(round(epic.Val,2),0) as 'EPI_TDAY',
ISNULL(round(epi1.Val,2),0) as 'EPI_T+1',ISNULL(round(epi2.Val,2),0) as 'EPI_T+2' , ISNULL(NULL,0) as Filler3,
ISNULL(ceiling(pay.Credit),0) as 'Payout_T' , ISNULL(NULL,0) as Filler4,ISNULL(fa.FundedAmt,0) as 'Funded Amount',
ISNULL(ceiling(dr.Total),0) as ' Deriv T-1 Debit Bill', ISNULL(NULL,0) as Filler5,
ISNULL(round(lb.LedgerBalanceT,2),0) as 'NetLedgerT',ISNULL(round(lb.CashBillT1,2),0) as 'NetCashBillT+1',ISNULL(round(lb.ReceiptT1,2),0) as 'ReceiptT+1',
ISNULL(round(lb.DeriBillT,2),0) as 'DerivativeBillT'
,ISNULL(round(lb.CashBillT2,2),0) as 'NetCashBillT+2',ISNULL(round(lb.ReceiptT2,2),0) as 'ReceiptT+2',
ISNULL(round(lb.DeriBillT1,2),0) as 'DerivativeBillT+1'
,iSNULL(NULL,0) as 'CDST+1Bill',ISNULL(NULL,0) as 'MCXT+1Bill',
isnull(NULL,0) as 'NCDEXT+1Bill',iSNULL(NULL,0) as 'CDST+2Bill',ISNULL(NULL,0) as 'MCXT+2Bill',
isnull(NULL,0) as 'NCDEXT+2Bill'
--Isnull(TotalPeak1,0) as 'Total1',isnull(TotalPeak2,0) as 'Total2',ISNULL(TotalPeak3,0) as 'Total3',ISNULL(TotalPeak4,0) as 'Total4'
from    MG13Data md 
full outer join (select Distinct ClientId,TotalPeak1,TotalPeak2,TotalPeak3,TotalPeak4 from MG13PEAKGenerated ) as mg on md.ClientCode = mg.ClientId 
full outer join (Select Distinct Clientcode,PledgeVal from Pledge) as pd on md.ClientCode = pd.Clientcode
full outer join (Select Distinct Clientcode,FundedAmt,CollVal from FundedValue) as fa on md.ClientCode = fa.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from [EPIT-1] group by Party) as epip on md.ClientCode = epip.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from EPIT group by Party ) as epic on md.ClientCode = epic.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from [EPIT+1] group by Party ) as epi1 on md.ClientCode = epi1.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from [EPIT+2] group by Party ) as epi2 on md.ClientCode = epi2.ClientCode
full outer join (Select Distinct ClientCode ,sum(convert(float,Credit)) as Credit from Payout group by ClientCode ) as pay on md.ClientCode = pay.ClientCode
full outer join (Select Distinct ClientCode,Total from Derivatives) as dr on md.ClientCode = dr.ClientCode
full outer join (Select Distinct  ClientCode,sum(LedgerBalanceT) as LedgerBalanceT,sum(CashBillT1) as CashBillT1 ,sum(ReceiptT1) as ReceiptT1,sum (DeriBillT) as DeriBillT
,sum(CashBillT2) as CashBillT2  ,sum(ReceiptT2) as ReceiptT2 ,sum(DeriBillT1)  as DeriBillT1 from LedgerBalance_new group by ClientCode) as lb on md.ClientCode = lb.ClientCode
where  md.ClientCode is NOT NULL
--and ReportDate = 20230607
--and  md.ClientCode = '01UR088'
group by md.[ClientCode],MinMargin,[Additional_Margin],MTM,SPANMarginC,SPANMarginCOMM,SPANMarginF,[Extreme_Loss_MarginC],[Extreme_Loss_MarginCOMM],[Extreme_Loss_MarginF]
,M2MF,M2MC,M2MCOMM,M2MMcx,M2MNcdx,OtherMarginMcx,OtherMarginNcdx,[VARM_ELM],DeliveryMarginF,InitialMarginMcx,InitialMarginNcdx,TotalPeak1
,TotalPeak2,TotalPeak3,TotalPeak4,[Total_T],[Total_T_1],[Total_T_2]
,md.Total,PledgeVal,CollVal,epic.Val,epip.Val,epi1.Val,epi2.Val,pay.Credit,fa.FundedAmt,dr.Total,lb.LedgerBalanceT,lb.CashBillT1,lb.DeriBillT,lb.ReceiptT1
,lb.CashBillT2,lb.DeriBillT1,lb.ReceiptT2

),

CTE1 as (
select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH,SPANFNO,ELMFNO,DellMarginFNO,
M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,
SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge,PledgeRequired,Filler2
,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY
,[EPI_T+1],[EPI_T+2],Filler3,
Payout_T,Filler4,[Funded Amount],[ Deriv T-1 Debit Bill],Filler5
,(convert(float,Payout_T) + Filler4 + [ Deriv T-1 Debit Bill]) as 'AddiAssetsforPeak',
ISNULL(NULL,0) as
'LedgerT',ISNULL(NULL,0) as 'FNO',ISNULL(NULL,0) as 'CDS',ISNULL(NULL,0) as 'MCX',ISNULL(NULL,0) as 'NCDEX',NetLedgerT,
round(convert(real,Pledge)-PledgeRequired + EPI_TDAY + NetLedgerT + Filler3 + [Funded Amount],2) as 'Assets'---AE5-AF5+AJ5+AY5+AM5+AP5
,CASE when  ([NetCashBillT+1] - [EPIT(to reduce on T+2)]) > 0 then  ([NetCashBillT+1] - [EPIT(to reduce on T+2)])
else 0 
end as 'cond1',
(DerivativeBillT + [CDST+1Bill] + [MCXT+1Bill] + [NCDEXT+1Bill]) as 'Sum(BF:BI)'  ,
Case when M2MMCX < 0 then -(M2MMCX)
else 0
end as 'cond2', 
Case when M2MNCDX < 0 then -(M2MNCDX)
else 0 
end as 'cond3',
Case when ([NetCashBillT+2] - [EPI_T+1]) > 0 then ([NetCashBillT+2] - [EPI_T+1])
else 0 
end as 'cond4',
([DerivativeBillT+1] + [CDST+2Bill]+ [MCXT+2Bill] + [NCDEXT+2Bill]) as 'Sum(BM:BP)'

from CTE

),


CTE2 as (
 
select ClientCode ,MAX(TOTALA) as 'TOTALA' from

(Select ClientCode,Total1 as TOTALA from CTE
UNION
Select ClientCode,Total2 as TOTALA from CTE
UNIOn
Select ClientCode,Total3 as TOTALA from CTE
UNIOn
Select ClientCode,Total4 as TOTALA from CTE
UNIOn
Select ClientCode,Filler1 as TOTALA from CTE
) cc Group by ClientCode
)

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],[Total Capital T&T+1&T+2],FinalFullRec,FinalShortFall,ShortFallForPeak,[ShortFallForPeak100%],
Case when [ShortFallForPeak100%] > FinalShortFall then [ShortFallForPeak100%]
else FinalShortFall
end as 'MaxofMarginandPeakShortfall'
into venturaDb..MarginreportFinal

from (
 

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],[Total Capital T&T+1&T+2],FinalFullRec,
case when FinalFullRec  IS NULL then 0 
else (TotMargin - FinalFullRec)
end as 'FinalShortFall',
case when AssetsForPeak > TOTALA then 0
else (TOTALA - Cond8)
end as 'ShortFallForPeak',
case when AssetsForPeak > TOTALA then 0
else (TOTALA - Cond8)
end as 'ShortFallForPeak100%'



from (

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],[Total Capital T&T+1&T+2]

,case when [Total Capital T&T+1&T+2] > 0 then cond6 
else 0 

end as 'FinalFullRec'
,TOTALA,Cond8


from(

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],[Total Capital T&T+1&T+2] 

, case when TotMargin > [Total Capital T&T+1&T+2]  then cond5 
else NULL
end as 'cond6'
,TOTALA,Cond8

from
(
Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],[Total Capital T&T+1&T+2],

Case when   TotMargin< [Total Capital T&T+1&T+2] then TotMargin
when [Total Capital T&T+1&T+2] < TotMargin then [Total Capital T&T+1&T+2]
else 0 
end as 'cond5'
,TOTALA,Cond8


from(
Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds],[UtizationoutofT+2Funds],
(Assets + [UtizationoutofT+1Funds] + [UtizationoutofT+2Funds]) as 'Total Capital T&T+1&T+2',TOTALA,Cond8

from (

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
[UtizationoutofT+1Funds], 
case when [TotalT+2] < 0 OR ([CreditAvailableonT+1] + [CreditAvailableonT+2] - [UtizationoutofT+1Funds]) < [TotalT+2] then round(([CreditAvailableonT+1] + [CreditAvailableonT+2] - [UtizationoutofT+1Funds]),2)
when  [TotalT+2] < 0 OR [TotalT+2] < ([CreditAvailableonT+1] + [CreditAvailableonT+2] - [UtizationoutofT+1Funds]) then round([TotalT+2],2)
else 0 
end as 'UtizationoutofT+2Funds',TOTALA,Cond8
from (

Select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH ,SPANFNO 
,ELMFNO,DellMarginFNO,M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge
,PledgeRequired,Filler2,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY,[EPI_T+1],[EPI_T+2],Filler3,Payout_T,Filler4,[Funded Amount],
[ Deriv T-1 Debit Bill],Filler5,AddiAssetsforPeak,LedgerT,FNO,CDS,MCX,NCDEX,NetLedgerT,Assets,Comparision,NULLData,AssetsForPeak,[NetCashBillT+1],[ReceiptT+1],DerivativeBillT,
[CDST+1Bill],[MCXT+1Bill],[NCDEXT+1Bill],[CreditAvailableonT+1],[NetCashBillT+2],[ReceiptT+2],[DerivativeBillT+1],[CDST+2Bill],[MCXT+2Bill],[NCDEXT+2Bill],[CreditAvailableonT+2],
Case when [TotallT+1] < 0 OR [CreditAvailableonT+1] <[TotallT+1] then [CreditAvailableonT+1]
 when [TotallT+1] < 0 OR  [TotallT+1] < [CreditAvailableonT+1] then [TotallT+1]
 else 0 
 ENd as  'UtizationoutofT+1Funds',
case when AssetsForPeak  > 0 then AssetsForPeak
else 0 
end as 'Cond8',TOTALA

from (
Select c.ClientCode,c.[VARM+ELM],c.MinMargin,c.[Additional Margin CASH],c.M2MCASH,c.SPANFNO
,c.ELMFNO,c.DellMarginFNO,c.M2MFNO,c.SPANCDS,c.ELMCDS,c.M2MCDS,c.IMMCX,c.OthersMCX,c.OthersNCDX,c.M2MMCX,c.IMNCDX,c.M2MNCDX,c.SPANCOM,c.ELMCOM,
c.M2MCOM,c.Total1,c.Total2,c.Total3,c.Total4,c.Filler1,c.TotalT,c.[TotallT+1],c.[TotalT+2],c.TotMargin,c.Pledge,c.PledgeRequired,c.Filler2,
c.[EPI_T-1DAY],c.[EPIT(to reduce on T+2)],c.EPI_TDAY,c.[EPI_T+1],c.[EPI_T+2],c.Filler3,c.Payout_T,c.Filler4,c.[Funded Amount],c.[ Deriv T-1 Debit Bill],
c.Filler5,c1.AddiAssetsforPeak,c1.LedgerT,c1.FNO,c1.CDS,c1.MCX,c1.NCDEX,c1.NetLedgerT,c1.Assets,
case when Assets<0 OR   Assets < c1.TotalT then Assets
when Assets<0 OR   c1.TotalT < Assets then  c1.TotalT
else 0
end as 'Comparision',ISNULL(NULL,0) as 'NULLData',
Case when  (convert(float,c1.Pledge)-c1.PledgeRequired+ c1.EPI_TDAY + c1.NetLedgerT + c1.[Funded Amount] + AddiAssetsforPeak) > 0 then
round(convert(float,c1.Pledge)-c1.PledgeRequired+ c1.EPI_TDAY + c1.NetLedgerT + c1.[Funded Amount] + AddiAssetsforPeak,2)
else 0
end as 'AssetsForPeak',c.[NetCashBillT+1],c.[ReceiptT+1],c.DerivativeBillT,c.[CDST+1Bill],c.[MCXT+1Bill],c.[NCDEXT+1Bill]

,(c.[EPI_T+1] + c1.cond1 + c.[ReceiptT+1] + c1.[Sum(BF:BI)] + c1.cond2+ c1.cond3) as 'CreditAvailableonT+1'
,c.[NetCashBillT+2],c.[ReceiptT+2],c.[DerivativeBillT+1],c.[CDST+2Bill],c.[MCXT+2Bill],c.[NCDEXT+2Bill],

((c.[EPI_T+2] + c1.cond4 + c.[ReceiptT+2] + c1.[Sum(BM:BP)])) AS 'CreditAvailableonT+2',TOTALA


from CTE1 c1  inner join CTE c on c1.ClientCode = c.ClientCode
inner join CTE2 c2 on c1.ClientCode = c2.ClientCode
) as a 
) as b
) as c
) as d 
) as e
) as f 
) as g 
) as h 

select * from MarginreportFinal

---- Utization out of T+1 Funds =IF(AB5>0,MIN(BJ5,AB5),0)

--To summarize, the formula checks if the value in BC5 is greater than the maximum value 
--in the range V5:Z5. If it is, it returns 0. If BC5 is not greater than the maximum, 
--it calculates the difference between the maximum value
--in V5:Z5 and BC5 (if BC5 is greater than 0) or 0 (if BC5 is not greater than 0).


--AB5 TotalT+1,BJ5 :CreditAvailbleonT+1



--Utization out of T+1 Funds=IF(AC5>0,MIN(BQ5+BJ5-BR5,AC5),0)

--AC5 :TOTAL t+2 , Bq : credit avaailble on t+2 
--,BJ5 :CreditAvailbleonT+1,BR5 : UtizationoutofT+1Funds

--AK5 + IF(BD5-AI5>0, BD5-AI5, 0) + BE5 + SUM(BF5:BI5) + IF(O5<0, -O5, 0) + IF(R5<0, -R5, 0)

--The formula adds up the following terms:

--The value in cell AK5.--[EPI_T+1
--The result of the first IF function, which is either 
--the difference between the values in cells BD5 and AI5 
--(if the difference is greater than zero) or 0.--AI5 :
--EPI T  (to reduce on T+2),BD5 : NetCashT+1----Case/IFELSE 
--The value in cell BE5. REceptT+1
--The sum of the values in the range of cells BF5 to BI5. BF5: DerivativesT+1--SUM(BF5+0+0+0)
--The result of the second IF function, which is either 
--the negative value of O5 (if O5 is less than zero) or 0. O5 :m2mmcx--Case/If
--The result of the third IF function, which is either
--the negative value of R5 (if R5 is less than zero) or 0. R5:M2mNCDEX-Case/If

--AL5 + IF(BK5-AK5>0, BK5-AK5, 0) + BL5 + SUM(BM5:BP5)
--The value in cell AL5--EPI?_T+2
--The result of the IF function, which is either the difference : BK5 : CashbillT+2 ,AK5: EPI_T+1
--between the values in cells BK5 and AK5 (if the difference is greater than zero) or0 
--The value in cell BL5.ReceiptT+2 
--The sum of the values in the range of cells BM5 to BP5. BM5 (DeerivativeT+1 + 0 + 0+ 0)

----=AE5-AF5+AJ5+AY5+AM5+AP5

----AE5 : Pledge 
----Af5 : pledge requried 
----Aj5 : Epitday 
----ay5 : ledgerbalance 
----am5 : filler3
----ap5 : Funded Amount

--=IF(AE5-AF5+AJ5+AY5+AP5+AS5>0,AE5-AF5+AJ5+AY5+AP5+AS5,0)

--AE5 : Pledge 
--Af5 : pledge requried 
--Aj5 : Epitday
--ay5 : ledgerbalance 
--ap5 : Funded Amount
--AS5 : Addi Asets for peak 



----MG13Data --Done in rpt 
----Payout--rpt

----select * from  MG13Data where ClientCode = '080184'

--select ClientCode,min(Valuef)  as fsfsdfff


--from (select ClientCode ,PledgeVal  as Valuef  from Pledge 
--union
--select ClientCode ,FSPledgeVal  as Valuef  from Pledge )cc
--where ClientCode ='92246011'
--group by ClientCode

