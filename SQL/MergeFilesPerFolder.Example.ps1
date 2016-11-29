#Remove-Item *.sql

Get-Content ..\db\database\TuscanyProfileDB.sql | Add-Content CreateDB.sql
Get-Content ..\db\tbls\*.sql | Add-Content CreateTables.sql
Get-Content ..\db\foreignKeys\*.sql | Add-Content CreateForeignKeys.sql
Get-Content ..\db\indexes\*.sql | Add-Content CreateIndexes.sql
Get-Content ..\db\sprocs\*.sql | Add-Content CreateSprocs.sql
