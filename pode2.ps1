Import-Module -Name Pode.Web
Import-Module PSSQLite

Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http -Name User
    #Add-PodeEndpoint -Address localhost -Port 8090 -Protocol Http -Name Admin

    # this will bind the site to the Admin endpoint
    Use-PodeWebTemplates -Title 'Example' -Theme Dark -EndpointName User

        Add-PodeWebPage -Name 'Example' -Icon 'Settings' -ScriptBlock {
	New-PodeWebCard -Content @(
        New-PodeWebForm -Name 'Example' -ScriptBlock {
        $WebEvent.Data | Out-Default
	$name = $WebEvent.Data['Name']
	$date = $WebEvent.Data['Date']

$newObject = [PSCustomObject]@{
    Name  = "$name"
    Value = 2
}

	 $filePath = '/home/eric/dev/pode_test1/data.json'
         $jsonData = Get-Content -Path $filePath -Raw | ConvertFrom-Json
# Append a single object
[array]$jsonData += $newObject
	 #$jsonData | Out-Default


$jsonData | ConvertTo-Json -Depth 99 | Set-Content -Path $filePath -Encoding UTF8
#$jsonData | ConvertTo-Json -Depth 99 | Out-Default


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

}
