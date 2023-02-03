
--SELECT resdd001 表單代號,resdd002 resdd002,resdd003 關號,resdd004 支號,resdd005 流水號,resdd006 簽核序號,resdd007 收件人員工代號,resdd008 	簽核人員工代號,	resdd009 收件時間,resdd010 初次讀取時間,resdd011 最近讀取時間 ,resdd012 簽核時間,resdd013 讀取次數,resdd014 簽核狀態碼,resdd015 簽核結果,resdd016 簽核意見,resdd018 表單型態,CREATOR,CREATE_DATE,MODIFIER,MODI_DATE,FLAG 
--FROM resdd

--SELECT * FROM erpma 

--訂單的單人簽核時間--
SELECT TC001,TC002,CFIELD01,TC003 訂單日期,TC004 客戶代號,TC053 客戶全名,TC015,TC018,TC048 簽核狀態碼,A.CREATOR,(SELECT resak002 from resak WHERE resak001=A.CREATOR),A.CREATE_DATE,CREATE_TIME,TC039 單據日期,A.MODIFIER,(SELECT resak002 from resak WHERE resak001=A.MODIFIER),A.MODI_DATE,MODI_TIME
,resdd001 表單代號,resdd002 resdd002,resdd003 關號,resdd004 支號,resdd005 流水號,resdd006 簽核序號,resdd007 收件人員工代號,(SELECT resak002 from resak WHERE resak001=resdd007),resdd008 	簽核人員工代號,(SELECT resak002 from resak WHERE resak001=resdd008),	resdd009 收件時間,resdd010 初次讀取時間,resdd011 最近讀取時間 ,resdd012 簽核時間,resdd013 讀取次數
,CASE WHEN resdd014='4' THEN '已通知'
	WHEN resdd014='6' THEN '已會辦'
	WHEN resdd014='7' THEN '已簽核'
	END 簽核狀態碼
,CASE WHEN resdd015 ='2' THEN '同意'
	WHEN resdd015 ='4' THEN '會辦完成'
	WHEN resdd015 ='8' THEN '已通知'
	END 簽核結果
,resdd016 簽核意見--,resdd018 表單型態,resdd.CREATOR,resdd.CREATE_DATE,resdd.MODIFIER,resdd.MODI_DATE,resdd.FLAG 
,CASE 
  WHEN resdd009 !='' AND resdd012 !='' THEN DATEDIFF(minute,resdd009,resdd012) 
  ELSE 0 
END AS '單人簽核時間(分)'
,CASE
	WHEN resdd009 ='' OR resdd012 =' ' THEN '0分'
	WHEN DATEDIFF(minute,resdd009,resdd012)>=1440 THEN CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)/1440) + '日' + CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440/60) + '時'+ CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分'
	WHEN  DATEDIFF(minute,resdd009,resdd012)>=60 THEN CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440/60) + '時'+ CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分'
	ELSE CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分' END
FROM [SUMMER].[dbo].[COPTC] A
LEFT JOIN erpma ON A.TC001=erpma.erpma003 AND A.TC002=erpma.erpma004
LEFT JOIN resdd ON erpma.erpma002=resdd.resdd002 AND erpma.erpma001=resdd.resdd001
WHERE erpma019='COPR08' AND A.CREATE_DATE  LIKE '202212%' AND 	TC027 ='Y' AND resdd015 !='3' AND resdd015 !='7' AND resdd015 !='9' AND resdd015 !='11'
--AND CFIELD01='2201-20220221002'
ORDER BY TC003,TC002,CREATE_TIME,resdd002,resdd003,resdd004,resdd005  

--訂單的總簽核時間--
SELECT DISTINCT TC001,TC002,CFIELD01,TC003 訂單日期,TC004 客戶代號,TC053 客戶全名,TC015,TC018,TC048 簽核狀態碼,A.CREATOR,(SELECT resak002 from resak WHERE resak001=A.CREATOR),A.CREATE_DATE,CREATE_TIME,TC039 單據日期,A.MODIFIER,(SELECT resak002 from resak WHERE resak001=A.MODIFIER),A.MODI_DATE,MODI_TIME
--,DATEDIFF(minute,resdd009,resdd012)
--,CASE WHEN DATEDIFF(minute,resdd009,resdd012)>=1440 THEN CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)/1440) + '日' + CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440/60) + '時'+ CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分'
--WHEN  DATEDIFF(minute,resdd009,resdd012)>=60 THEN CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440/60) + '時'+ CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分'
--ELSE CONVERT(varchar,DATEDIFF(minute,resdd009,resdd012)%1440%60) + '分' END
,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' ) AS '簽核的總花費時間(分)'
,CASE WHEN (select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )>=1440 THEN CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )/1440) + '日' + CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )%1440/60) + '時'+ CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )%1440%60) + '分'
	WHEN  (select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )>=60 THEN CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )%1440/60) + '時'+ CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )%1440%60) + '分'
	ELSE CONVERT(varchar,(select sum(DATEDIFF(minute,resdd009,resdd012)) from resdd C where  C.resdd001=B.resdd001 AND C.resdd002=B.resdd002 and resdd012 !='' )%1440%60) + '分' END AS '簽核的總花費時間'
FROM [SUMMER].[dbo].[COPTC] A
LEFT JOIN erpma ON A.TC001=erpma.erpma003 AND A.TC002=erpma.erpma004
LEFT JOIN resdd B ON erpma.erpma002=B.resdd002 AND erpma.erpma001=B.resdd001
WHERE erpma019='COPR08' AND A.CREATE_DATE  LIKE '202212%' 
AND TC027 ='Y' AND resdd015 !='3' AND resdd015 !='7' AND resdd015 !='9' AND resdd015 !='11'
ORDER BY TC003,TC002,CREATE_TIME
--AND CFIELD01='2201-20220221002'
--ORDER BY resdd002,resdd003,resdd004,resdd005 

--select * from resdd WHERE CFIELD01='2201-20220221002'


SELECT FLAG,TC048 簽核狀態碼,CREATOR,CREATE_DATE,CREATE_TIME,TC039 單據日期,MODIFIER,MODI_DATE,MODI_TIME,TC001,TC002,CFIELD01,TC003 訂單日期,TC004 客戶代號,TC053 客戶全名,TC015,TC018
FROM [SUMMER].[dbo].[COPTC]
WHERE CREATE_DATE LIKE '202212%'AND TC027 ='Y' AND TC048='3'
ORDER BY CREATOR
