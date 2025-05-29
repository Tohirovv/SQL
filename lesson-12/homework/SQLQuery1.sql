---Task1---
go
DECLARE @name NVARCHAR(255);
DECLARE @i INT = 1;
DECLARE @count INT;
DECLARE @sql NVARCHAR(MAX);

-- Count user databases (excluding system ones)
SELECT @count = COUNT(1)
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

WHILE @i <= @count
BEGIN
    -- Get the i-th user database name
    ;WITH cte AS (
        SELECT name, ROW_NUMBER() OVER(ORDER BY name) AS rn
        FROM sys.databases 
        WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
    )
    SELECT @name = name FROM cte WHERE rn = @i;

    -- Build dynamic SQL to get column info
    SET @sql = '
    SELECT 
        ''' + @name + ''' AS DatabaseName,
        TABLE_SCHEMA AS SchemaName,
        TABLE_NAME AS TableName,
        COLUMN_NAME AS ColumnName,
        DATA_TYPE + 
            CASE 
                WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN 
                    ''('' + CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN ''max'' 
                                ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) END + '')''
                ELSE ''''
            END AS DataType
    FROM [' + @name + '].INFORMATION_SCHEMA.COLUMNS;
    ';

    -- Execute the SQL
    EXEC sp_executesql @sql;

    -- Increment counter
    SET @i = @i + 1;
END;
go
---Task2---
create procedure dbo.GetProceduresAndFunctionsInfo
    @DatabaseName NVARCHAR(255) = NULL
AS
begin 
 SET NOCOUNT ON;

    -- Temporary table to store results
    CREATE TABLE #ProcFuncParams (
        DatabaseName SYSNAME,
        SchemaName SYSNAME,
        ObjectName SYSNAME,
        ObjectType VARCHAR(20),
        ParameterName SYSNAME,
        DataType NVARCHAR(100),
        MaxLength NVARCHAR(20)
    );

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @name NVARCHAR(255);

    IF @DatabaseName IS NOT NULL
    BEGIN
        -- Sanitize and quote database name
        SET @sql = '
        INSERT INTO #ProcFuncParams
        SELECT 
            ''' + @DatabaseName + ''' AS DatabaseName,
            s.name AS SchemaName,
            o.name AS ObjectName,
            CASE o.type 
                WHEN ''P'' THEN ''Stored Procedure''
                WHEN ''FN'' THEN ''Scalar Function''
                WHEN ''TF'' THEN ''Table-Valued Function''
                WHEN ''IF'' THEN ''Inline Table-Valued Function''
                ELSE o.type_desc END AS ObjectType,
            p.name AS ParameterName,
            TYPE_NAME(p.user_type_id) AS DataType,
            CASE 
                WHEN p.max_length = -1 THEN ''max''
                ELSE CAST(p.max_length AS NVARCHAR)
            END AS MaxLength
        FROM [' + @DatabaseName + '].sys.objects o
        INNER JOIN [' + @DatabaseName + '].sys.schemas s ON o.schema_id = s.schema_id
        LEFT JOIN [' + @DatabaseName + '].sys.parameters p ON o.object_id = p.object_id
        WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'')
        ORDER BY s.name, o.name, p.parameter_id;
        ';
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        DECLARE @i INT = 1, @count INT;

        SELECT @count = COUNT(*) FROM sys.databases 
        WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

        WHILE @i <= @count
        BEGIN
            ;WITH cte AS (
                SELECT name, ROW_NUMBER() OVER (ORDER BY name) AS rn
                FROM sys.databases 
                WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
            )
            SELECT @name = name FROM cte WHERE rn = @i;

            SET @sql = '
            INSERT INTO #ProcFuncParams
            SELECT 
                ''' + @name + ''' AS DatabaseName,
                s.name AS SchemaName,
                o.name AS ObjectName,
                CASE o.type 
                    WHEN ''P'' THEN ''Stored Procedure''
                    WHEN ''FN'' THEN ''Scalar Function''
                    WHEN ''TF'' THEN ''Table-Valued Function''
                    WHEN ''IF'' THEN ''Inline Table-Valued Function''
                    ELSE o.type_desc END AS ObjectType,
                p.name AS ParameterName,
                TYPE_NAME(p.user_type_id) AS DataType,
                CASE 
                    WHEN p.max_length = -1 THEN ''max''
                    ELSE CAST(p.max_length AS NVARCHAR)
                END AS MaxLength
            FROM [' + @name + '].sys.objects o
            INNER JOIN [' + @name + '].sys.schemas s ON o.schema_id = s.schema_id
            LEFT JOIN [' + @name + '].sys.parameters p ON o.object_id = p.object_id
            WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'')
            ORDER BY s.name, o.name, p.parameter_id;
            ';

            EXEC sp_executesql @sql;
            SET @i = @i + 1;
        END
    END

    -- Return the result
    SELECT * FROM #ProcFuncParams
    ORDER BY DatabaseName, SchemaName, ObjectName;

    DROP TABLE #ProcFuncParams;
END;

EXEC dbo.GetProceduresAndFunctionsInfo;
EXEC dbo.GetProceduresAndFunctionsInfo @DatabaseName = 'MyAppDB';


