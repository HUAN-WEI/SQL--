SELECT
        tl.request_session_id AS [�ڪ�SID]
        ,tl.resource_type AS [�귽����]
        ,DB_NAME(tl.resource_database_id) AS [��Ʈw�W��]
        ,(CASE resource_type
                WHEN 'OBJECT' THEN OBJECT_NAME(tl.resource_associated_entity_id)
                ELSE (SELECT
                                        OBJECT_NAME(object_id)
                                FROM sys.partitions
                                WHERE hobt_id = resource_associated_entity_id)
        END) AS [����W��]
        ,tl.resource_description AS [�귽����]
        ,tl.request_mode AS [��w����]
        ,tl.request_status AS [���A]
        ,wt.blocking_session_id AS [�Q����SID]
        ,c.connect_time AS [�s���ɶ�]
        ,txt.text AS [�̪����y�k]
	   ,lock_txt.text AS [�Q���몺����y�k]
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


