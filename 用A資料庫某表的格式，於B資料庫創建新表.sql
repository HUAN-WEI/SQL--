--用A資料庫某表的格式，於B資料庫創建新表
BEGIN TRANSACTION 
SELECT * INTO TEST.dbo.CONTROLPLAN FROM TBLOPQCREASONDETAIL WHERE 1=0
ROLLBACK


SELECT * FROM TEST.dbo.CONTROLPLAN 