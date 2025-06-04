EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;


DECLARE @HTMLBody NVARCHAR(MAX);

SET @HTMLBody = 
    N'<style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
    </style>
    <h3>Index Metadata Report</h3>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Name</th>
            <th>Column Type</th>
        </tr>';

SELECT @HTMLBody = @HTMLBody +
    N'<tr><td>' + s.name + '.' + t.name + 
    N'</td><td>' + i.name + 
    N'</td><td>' + i.type_desc + 
    N'</td><td>' + c.name + 
    N'</td><td>' + ty.name + 
    N'</td></tr>'
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
INNER JOIN sys.tables t ON i.object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE i.is_primary_key = 0 AND i.is_unique_constraint = 0;

SET @HTMLBody = @HTMLBody + N'</table>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'MyMailProfile',
    @recipients = 'recipient@example.com',
    @subject = 'SQL Server Index Metadata Report',
    @body = @HTMLBody,
    @body_format = 'HTML';


