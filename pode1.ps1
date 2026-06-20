# Prerequisites: Install-Module -Name PSSQLite -Scope CurrentUser
Import-Module Pode
Import-Module PSSQLite

$dbPath = "/home/eric/dev/pode_test1/test.db"

Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http

    Add-PodeRoute -Method Get -Path '/users' -ScriptBlock {
        # Query SQLite database
        $users = Invoke-SqliteQuery -DataSource $dbPath -Query "SELECT * FROM Users"
        
        # Return results as JSON
        Write-PodeJsonResponse -Value $users
    }
}

