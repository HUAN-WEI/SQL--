SELECT
        tl.request_session_id AS [我的SID]
        ,tl.resource_type AS [資源類型]
        ,DB_NAME(tl.resource_database_id) AS [資料庫名稱]
        ,(CASE resource_type
                WHEN 'OBJECT' THEN OBJECT_NAME(tl.resource_associated_entity_id)
                ELSE (SELECT
                                        OBJECT_NAME(object_id)
                                FROM sys.partitions
                                WHERE hobt_id = resource_associated_entity_id)
        END) AS [物件名稱]
        ,tl.resource_description AS [資源說明]
        ,tl.request_mode AS [鎖定類型]
        ,tl.request_status AS [狀態]
        ,wt.blocking_session_id AS [被阻塞SID]
        ,c.connect_time AS [連接時間]
        ,txt.text AS [最近執行語法]
	   ,lock_txt.text AS [被阻塞的執行語法]
FROM sys.dm_tran_locks AS tl
LEFT JOIN sys.dm_os_waiting_tasks AS wt
        ON tl.lock_owner_address = wt.resource_address
LEFT JOIN sys.dm_exec_connections AS c
        ON tl.request_session_id = c.session_id
LEFT JOIN sys.dm_exec_connections AS d
        ON wt.blocking_session_id = d.session_id
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) txt 
OUTER APPLY sys.dm_exec_sql_text(d.most_recent_sql_handle) lock_txt 
WHERE resource_type != 'DATABASE'
  AND tl.request_session_id > 50 
ORDER BY tl.request_session_id


