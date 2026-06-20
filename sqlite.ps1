# Install and Import
Install-Module -Name PSSQLite -Force
Import-Module PSSQLite

# Define database path
$Database = "/home/eric/dev/pode_test1/Names.SQLite"

# Create a Table
$QueryCreate = "CREATE TABLE IF NOT EXISTS Users (Id INTEGER PRIMARY KEY, Name TEXT, Age INTEGER)"
Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

# Insert Data
$QueryInsert = "INSERT INTO Users (Name, Age) VALUES ('Alice', 30), ('Bob', 25)"
Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

# Select Data
$Users = Invoke-SqliteQuery -Query "SELECT * FROM Users" -DataSource $Database
$Users | Format-Table
