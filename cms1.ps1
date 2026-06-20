Import-Module Pode
Import-Module Pode.Web
Import-Module PSSQLite

Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http -Name User
    #Add-PodeEndpoint -Address localhost -Port 8090 -Protocol Http -Name Admin

    Enable-PodeSessionMiddleware -Duration ([int]::MaxValue)


    # this will bind the site to the Admin endpoint
    Use-PodeWebTemplates -Title 'Eric CMS' -Theme Light -EndpointName User

    Add-PodeWebPage -Name 'Add Media' -Icon 'Settings' -Group 'Media' -ScriptBlock {
	New-PodeWebCard -Content @(
    New-PodeWebForm -Name 'AddMedia' -ScriptBlock {
    $WebEvent.Data | Out-Default 
    
    
	#$name = $WebEvent.Data['Name']
	#$date = $WebEvent.Data['Date']
	#$ID_val = $WebEvent.Query['ID_val']

    $MediaFileName = $WebEvent.Data['MediaFileName']
    $MediaTitle = $WebEvent.Data['MediaTitle']
    $MediaType = $WebEvent.Data['MediaType']
    $Creator = $WebEvent.Data['Creator']
    $Service = $WebEvent.Data['Service']
    $Image = $WebEvent.Data['Image']
    $ReleaseDate = $WebEvent.Data['ReleaseDate']
    $Description = $WebEvent.Data['Description']
    $Description1 = $WebEvent.Data['Description1']
    $Description2 = $WebEvent.Data['Description2']
    $Description3 = $WebEvent.Data['Description3']
    $Description4 = $WebEvent.Data['Description4']
    $Description5 = $WebEvent.Data['Description5']
    
    #$content = $WebEvent.Data.Description[1] -replace '\r?\n', '<br>'
    #$content = $WebEvent.Data.Description -replace '<newline>', '\n'

   
	
"YYY0" + $Description | Out-Default

# Define database path
$Database = "/home/eric/dev/pode_test1/data.db"

# Create a Table
$QueryCreate = "CREATE TABLE IF NOT EXISTS Media (Id INTEGER PRIMARY KEY, MediaFileName TEXT, MediaTitle TEXT, MediaType TEXT, 
Creator Text, Service Text, Image Text, ReleaseDate Text, Description1 Text, Description2 Text, Description3 Text, Description4 Text, Description5 Text)"
Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

# Insert Data
$QueryInsert = "INSERT INTO Media (MediaFileName, MediaTitle, MediaType, Creator, Service, Image, ReleaseDate, Description1, Description2, Description3, Description4, Description5) VALUES ('$MediaFileName', '$MediaTitle', '$MediaType', '$Creator','$Service','$Image','$ReleaseDate','$Description1', '$Description2', '$Description3', '$Description4', '$Description5')"
#$QueryInsert = "INSERT INTO Media (MediaFileName, MediaTitle, MediaType, Creator, Service, Image, ReleaseDate, Description) VALUES ('$MediaFileName', '$MediaTitle', '$Creator','$Service','$Image','$ReleaseDate','$Description')"
Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

# Select Data
$Media = Invoke-SqliteQuery -Query "SELECT * FROM Media" -DataSource $Database
$Media | Format-Table | Out-Default

#param([string]$value)

"YYY1" + $ID_val + $value | Out-Default

#Move-PodeWebUrl -Url '/pages/thankyou'

    } -Content @(
        New-PodeWebTextbox -Name 'MediaFileName' -DisplayName 'Media File Name'
        New-PodeWebTextbox -Name 'MediaTitle' -DisplayName 'Media Title'
        New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('TVshow', 'Movie', 'Book','Album')
        New-PodeWebTextbox -Name 'Creator' -DisplayName "Creator/Artist/Author"
        New-PodeWebRadio -Name 'Service' -Options @('NetworkTV', 'Netflix', 'AppleTV','Hulu', 'Prime','Max', 'Libby','Kindle','Hoopla','NA')
        New-PodeWebFileUpload -Name 'Image'
        New-PodeWebTextbox -Name 'ReleaseDate' -DisplayName "Release Date" -Type Date
        New-PodeWebTextbox -Name 'Description' -Multiline
        New-PodeWebTextbox -Name 'Description1'
        New-PodeWebTextbox -Name 'Description2'
        New-PodeWebTextbox -Name 'Description3'
        New-PodeWebTextbox -Name 'Description4'
        New-PodeWebTextbox -Name 'Description5'



       
        
        #New-PodeWebTextbox -Name 'Description' -Label 'Description' -Multiline -Value "Line 1$([Environment]::NewLine)Line 2"


        New-PodeWebText -Value '   Markdown Cheat Sheet' -Style Bold
        New-PodeWebList -Items @(
        New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Headings:	# H1 ## H2 ### H3 (up to ###### H6)'
         )
        New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Bold:	**bold text** or __bold text__'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Italic	*text* or _text_'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Unordered List: Use asterisks (*), pluses (+), or hyphens (-)'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Ordered List: Use any integer followed by a period (.)'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Link: [Link title](URL)'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Image: ![Alt text](image URL)'
         )
         New-PodeWebListItem -Content @(
            New-PodeWebText -Value 'Code Blocks: ```python
            s = "Python syntax highlighting"
            print(s)
            ```'
         )
        )
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

Add-PodeWebPage -Name 'Markdown Entry' -Layouts @(
New-PodeWebCard -Content @(
    New-PodeWebCodeEditor -Name 'Editor' -Language 'markdown' -Upload {
        $WebEvent.Data | Out-Default
    }
)
)


}
