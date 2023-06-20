--CASH to NSE COm : from MG13....rpt file 

--Total1 ,Total3,Total3,Total4 : From MG13 PEak Generated file 

--Total t, Total t+1 , total t+2 , TOT marging : MG13...rpt file 

--WITH ID as (


--select   ClientCode from mg13data
--)


WITH CTE as (
select md.ClientCode,isnull([VARM+ELM],0) as[VARM+ELM] ,isnull(MinMargin,0) as MinMargin,
isnull([Additional Margin],0) as [Additional Margin CASH],isnull(MTM,0) as 'M2MCASH' ,
isnull(SPANMarginF,0) as SPANFNO,ISNULL([Extreme Loss MarginF],0) as ELMFNO,ISNULL(DeliveryMarginF,0) as DellMarginFNO,ISNULL(M2MF,0) as M2MFNO,
isnull(SPANMarginC,0) as SPANCDS,ISNULL([Extreme Loss MarginC],0) as ELMCDS,ISNULL(M2MC,0) as M2MCDS,
ISNULL(InitialMarginMcx,0) as IMMCX,ISNULL(OtherMarginMcx,0) as OthersMCX,ISNULL(M2MMcx,0) as M2MMCX,
ISNULL(InitialMarginNcdx,0) as IMNCDX,ISNULL(OtherMarginNcdx,0) as OthersNCDX,ISNULL(M2MNcdx,0) as M2MNCDX,
ISNULL(SPANMarginCOMM,0) as SPANCOM,ISNULL([Extreme Loss MarginCOMM],0) as ELMCOM,ISNULL(M2MCOMM,0) as M2MCOM,
ISNUll(TotalPeak1,0) as Total1,isnull(TotalPeak2,0) as Total2,ISNULL(TotalPeak3,0) as Total3,ISNULL(TotalPeak4,0) as Total4, ISNULL(NULL,0) as Filler1,
isNULL([Total T],0) as TotalT,ISNULL([Total T+1],0) as [TotallT+1],ISNULL([Total T+2],0) as [TotalT+2],
ISNULL(md.Total,0) as 'TotMargin',isNULL(pd.PledgeVal,0) as Pledge,
ISNULL(fa.CollVal,0) as 'PledgeRequired', ISNULL(NULL,0) as Filler2,
ISNULL(round(epip.Val,2),0) as 'EPI_T-1DAY',ISNULL(NULL,0) as 'EPIT(to reduce on T+2)',ISNULL(round(epic.Val,2),0) as 'EPI_TDAY',
ISNULL(NULL,0) as 'EPI_T+1',ISNULL(NULL,0) as 'EPI_T+2' , ISNULL(NULL,0) as Filler3,
ISNULL(ceiling(pay.Credit),0) as 'Payout_T' , ISNULL(NULL,0) as Filler4,ISNULL(fa.FundedAmt,0) as 'Funded Amount',
ISNULL(ceiling(dr.Total),0) as ' Deriv T-1 Debit Bill', ISNULL(NULL,0) as Filler5,
ISNULL(round(lb.LedgerBalanceT,2),0) as 'LedgerBalance'
--Isnull(TotalPeak1,0) as 'Total1',isnull(TotalPeak2,0) as 'Total2',ISNULL(TotalPeak3,0) as 'Total3',ISNULL(TotalPeak4,0) as 'Total4'
from    MG13Data md 
full outer join (select Distinct ClientId,TotalPeak1,TotalPeak2,TotalPeak3,TotalPeak4 from MG13PEAKGenerated ) as mg on md.ClientCode = mg.ClientId 
full outer join (Select Distinct Clientcode,PledgeVal from Pledge) as pd on md.ClientCode = pd.Clientcode
full outer join (Select Distinct Clientcode,FundedAmt,CollVal from FundedValue) as fa on md.ClientCode = fa.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from EPIPREV group by Party) as epip on md.ClientCode = epip.ClientCode
full outer join (Select Distinct Party as ClientCode , sum(convert(float,[Value])) as Val from EPICURRENT group by Party ) as epic on md.ClientCode = epic.ClientCode
full outer join (Select Distinct ClientCode ,sum(convert(float,Credit)) as Credit from Payout group by ClientCode ) as pay on md.ClientCode = pay.ClientCode
full outer join (Select Distinct ClientCode,Total from Derivatives) as dr on md.ClientCode = dr.ClientCode
full outer join (Select Distinct  ClientCode,sum(LedgerBalanceT) as LedgerBalanceT from LedgerBalance group by ClientCode) as lb on md.ClientCode = lb.ClientCode
where  md.ClientCode is NOT NULL
--and ReportDate = 20230607
and md.ClientCode = '080184'
group by md.[ClientCode],MinMargin,[Additional Margin],MTM,SPANMarginC,SPANMarginCOMM,SPANMarginF,[Extreme Loss MarginC],[Extreme Loss MarginCOMM],[Extreme Loss MarginF]
,M2MF,M2MC,M2MCOMM,M2MMcx,M2MNcdx,OtherMarginMcx,OtherMarginNcdx,[VARM+ELM],DeliveryMarginF,InitialMarginMcx,InitialMarginNcdx,TotalPeak1
,TotalPeak2,TotalPeak3,TotalPeak4,[Total T],[Total T+1],[Total T+2]
,md.Total,PledgeVal,CollVal,epic.Val,epip.Val,pay.Credit,fa.FundedAmt,dr.Total,lb.LedgerBalanceT

)

select ClientCode,[VARM+ELM],MinMargin,[Additional Margin CASH],M2MCASH,SPANFNO,ELMFNO,DellMarginFNO,
M2MFNO,SPANCDS,ELMCDS,M2MCDS,IMMCX,OthersMCX,M2MMCX,IMNCDX,OthersNCDX,M2MNCDX,
SPANCOM,ELMCOM,M2MCOM,Total1,Total2,Total3,Total4,Filler1,TotalT,[TotallT+1],[TotalT+2],TotMargin,Pledge,PledgeRequired,Filler2
,[EPI_T-1DAY],[EPIT(to reduce on T+2)],EPI_TDAY
,[EPI_T+1],[EPI_T+2],Filler3,
Payout_T,Filler4,[Funded Amount],[ Deriv T-1 Debit Bill],Filler5

,(convert(float,Payout_T) + Filler4 + [ Deriv T-1 Debit Bill]) as 'AddiAssetsforPeak',
ISNULL(NULL,0) as
'LedgerT',ISNULL(NULL,0) as 'FNO',ISNULL(NULL,0) as 'CDS',ISNULL(NULL,0)
as 'MCX',ISNULL(NULL,0) as 'NCDEX',LedgerBalance,

ceiling( convert(real,Pledge)-PledgeRequired + EPI_TDAY + LedgerBalance + Filler3 + convert(real,[Funded Amount])) as 'Assets'---AE5-AF5+AJ5+AY5+AM5+AP5
from CTE

--=AE5-AF5+AJ5+AY5+AM5+AP5

--AE5 : Pledge 
--Af5 : pledge requried 
--Aj5 : Epitday 
--ay5 : ledgerbalance 
--am5 : filler3
--ap5 : Funded Amount


