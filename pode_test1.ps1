Import-Module Pode.Web
Import-Module PSSQLite

# Define the database path
$databasePath = Join-Path -Path (Get-Location) -ChildPath "Test.db"

# --- Database Setup (Run once to create the DB and a sample table) ---
function Setup-Database {
    if (-not (Test-Path -Path $databasePath)) {
        Write-Host "Creating new database and sample data..."
        New-SQLiteDatabase -FullName $databasePath | Out-Null
        Invoke-SqliteQuery -DataSource $databasePath -Query "CREATE TABLE IF NOT EXISTS Users (Id INTEGER PRIMARY KEY, Name TEXT, Role TEXT);" | Out-Null
        Invoke-SqliteQuery -DataSource $databasePath -Query "INSERT INTO Users (Name, Role) VALUES ('Alice', 'Admin'), ('Bob', 'User');" | Out-Null
    }
}

# --- Pode Server Configuration ---
Start-PodeServer {
    # Initialize the database
    Setup-Database

    # Add a basic endpoint
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http

    # Use Pode.Web templates
    Use-PodeWebTemplates -Title 'PSQLite Example' -Theme Dark

    # Add a page to display users
    Add-PodeWebPage -Name 'Users' -Icon 'account-group' -ScriptBlock {
        # Retrieve data from the SQLite database
        $users = Invoke-SqliteQuery -DataSource $databasePath -Query "SELECT * FROM Users" | Select-Object -Property Name, Role

        # Create a Pode.Web table to display the users
        New-PodeWebCard -Content @(
            New-PodeWebTable -Name 'UsersTable' -ScriptBlock {
                foreach ($user in $users) {
                    # Return an ordered hashtable for each row
                    [ordered]@{
                        Name = $user.Name
                        Role = $user.Role
                    }
                }
            }
        )
    }
}

