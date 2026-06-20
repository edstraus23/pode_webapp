Import-Module -Name Pode.Web
Import-Module PSSQLite

Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http -Name User
    #Add-PodeEndpoint -Address localhost -Port 8090 -Protocol Http -Name Admin

    # this will bind the site to the Admin endpoint
    Use-PodeWebTemplates -Title 'Example' -Theme Dark -EndpointName User

    Add-PodeWebPage -Name 'Example' -Icon 'Settings' -Group 'Groups' -ScriptBlock {
	New-PodeWebCard -Content @(
    New-PodeWebForm -Name 'Example' -ScriptBlock {
    $WebEvent.Data | Out-Default
	$name = $WebEvent.Data['Name']
	$date = $WebEvent.Data['Date']
	$ID_val = $WebEvent.Query['ID_val']

	

# Define database path
$Database = "/home/eric/dev/pode_test1/Names.SQLite"

# Create a Table
$QueryCreate = "CREATE TABLE IF NOT EXISTS Users (Id INTEGER PRIMARY KEY, Name TEXT, Age INTEGER)"
Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

# Insert Data
$QueryInsert = "INSERT INTO Users (Name, Age) VALUES ('$name', 30), ('Bob', 25)"
Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

# Select Data
$Users = Invoke-SqliteQuery -Query "SELECT * FROM Users" -DataSource $Database
$Users | Format-Table | Out-Default

"YYY" + $ID_val | Out-Default

Move-PodeWebUrl -Url '/pages/thankyou'

    } -Content @(
        New-PodeWebTextbox -Name 'Name' -AutoComplete {
            return @('billy', 'bobby', 'alice', 'john', 'sarah', 'matt', 'zack', 'henry')
        }
        New-PodeWebTextbox -Name 'Password' -Type Password -PrependIcon Lock
        New-PodeWebTextbox -Name 'Date' -Type Date
        New-PodeWebTextbox -Name 'Time' -Type Time
        New-PodeWebDateTime -Name 'DateTime' -NoLabels
        New-PodeWebCredential -Name 'Credentials' -NoLabels
        New-PodeWebCheckbox -Name 'Checkboxes' -Options @('Terms', 'Privacy') -AsSwitch
        New-PodeWebRadio -Name 'Radios' -Options @('S', 'M', 'L')
        New-PodeWebSelect -Name 'Role' -Options @('User', 'Admin', 'Operations') -Multiple
        New-PodeWebRange -Name 'Cores' -Value 30 -ShowValue
    )
)
 }

 # Define the destination page

Add-PodeWebPage -Name 'ThankYou' -Hide -Layouts @(
    New-PodeWebCard -Content @(
     New-PodeWebHeader -Value 'Thank You for Submitting!' -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'
    )
)


Add-PodeWebPage -Name Charts -Icon 'bar-chart-2' -Group 'Groups' -Layouts @(
   New-PodeWebContainer -Content @(
    New-PodeWebChart -Name 'Top Processes' -Type Bar -AutoRefresh -ScriptBlock {
        Get-Process |
            Sort-Object -Property CPU -Descending |
            Select-Object -First 10 |
            ConvertTo-PodeWebChartData -LabelProperty ProcessName -DatasetProperty CPU, Handles
    }
)
)

}
