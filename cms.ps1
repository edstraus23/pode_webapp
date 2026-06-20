Import-Module Pode
Import-Module Pode.Web
Import-Module PSSQLite

Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 8081 -Protocol Http -Name User
    #Add-PodeEndpoint -Address localhost -Port 8090 -Protocol Http -Name Admin
    Add-PodeStaticRoute -Path '/html' -Source './Public/topics/html'
    Add-PodeStaticRoute -Path '/images' -Source './Public/topics/images'

    Enable-PodeSessionMiddleware -Duration ([int]::MaxValue)


    # this will bind the site to the Admin endpoint
    Use-PodeWebTemplates -Title "Memory Catcher" -Theme Light -EndpointName User


 # Define the Home Page
    Set-PodeWebHomePage -Layouts @(
    New-PodeWebHero -Title 'Welcome!' -Message "This is the Memory Catcher home page" -Content @(
        New-PodeWebText -Value 'This site is under construction' -InParagraph -Alignment Center
    )
)

# Add Media
# =============================
 Add-PodeWebPage -Name 'Add Media' -Group 'Media' -ScriptBlock {
        New-PodeWebCard -Content @(
            
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                # 'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

           New-PodeWebForm -Name 'Example1' -ScriptBlock {
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $MediaFileName = $WebEvent.Data['MediaFileName']
            $MediaTitle = $WebEvent.Data['MediaTitle']
            $MediaType = $WebEvent.Data['MediaType']
            $Creator = $WebEvent.Data['Creator']
            $Service = $WebEvent.Data['Service']
            $Image = $WebEvent.Data['Image']
            $ReleaseDate = $WebEvent.Data['ReleaseDate']
            $ViewDate = $WebEvent.Data['ViewDate']
            $Tags = $WebEvent.Data['Tags']
            $Description = $multiline
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $MediaFileName + ".md"
            $title = "# " + $MediaTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Create a Table
                $QueryCreate = "CREATE TABLE IF NOT EXISTS Media (Id INTEGER PRIMARY KEY, MediaFileName TEXT, MediaTitle TEXT, MediaType TEXT, 
                Creator Text, Service Text, Image Text, ReleaseDate Text, ViewDate Text, Tags Text, Description Text)"
                Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

                # Insert Data
                $QueryInsert = "INSERT INTO Media (MediaFileName, MediaTitle, MediaType, Creator, Service, Image, ReleaseDate, ViewDate, Description) VALUES ('$MediaFileName', '$MediaTitle', '$MediaType', '$Creator','$Service','$Image','$ReleaseDate','$ViewDate', '$Tags', '$Description')"
                Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

                # Select Data
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM Media" -DataSource $Database
                $Media | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'

           } -Content @(
            New-PodeWebTextbox -Name 'MediaFileName' -DisplayName 'Media File Name'
            New-PodeWebTextbox -Name 'MediaTitle' -DisplayName 'Media Title'
            New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('TVshow', 'Movie', 'Book','Album','Song')
            New-PodeWebTextbox -Name 'Creator' -DisplayName "Creator/Artist/Author"
            New-PodeWebRadio -Name 'Service' -Options @('NetworkTV', 'Netflix', 'AppleTV','Hulu', 'Prime','Max', 'Libby','Kindle','Hoopla','NA')
            New-PodeWebFileUpload -Name 'Image'
            New-PodeWebTextbox -Name 'ReleaseDate' -DisplayName "Release Date" -Type Date
            New-PodeWebTextbox -Name 'ViewDate' -DisplayName "Viewing Date" -Type Date
            New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags"
           )

        )

    }
    
# Add People
# =============================
 Add-PodeWebPage -Name 'Add People' -Group 'People' -ScriptBlock {
        New-PodeWebCard -Content @(
            
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                # 'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

           New-PodeWebForm -Name 'People1' -ScriptBlock {
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $PeopleFileName = $WebEvent.Data['PeopleFileName']
            $PeopleTitle = $WebEvent.Data['PeopleTitle']
            $PeopleType = $WebEvent.Data['PeopleType']
            $email = $WebEvent.Data['email']
            $Facebook = $WebEvent.Data['Facebook']
            $LinkedIn = $WebEvent.Data['LinkedIn']
            $Phone = $WebEvent.Data['Phone']
            $Street = $WebEvent.Data['Street']
            $City = $WebEvent.Data['City']
            $State = $WebEvent.Data['State']
            $ZIP = $WebEvent.Data['State']
            $Image = $WebEvent.Data['Image']
            $Parents = $WebEvent.Data['Parents']
            $Spouse = $WebEvent.Data['Spouse']
            $Siblings = $WebEvent.Data['Siblings']
            $Children = $WebEvent.Data['Children']
            $Birthday = $WebEvent.Data['Birthday']
            $Tags = $WebEvent.Data['Tags']
            $Description = $multiline
            
            "YYY" + $PeopleFileName  | Out-Default
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $PeopleFileName + ".md"
            $title = "# " + $PeopleTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description
            

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Create a Table
                $QueryCreate = "CREATE TABLE IF NOT EXISTS People (Id INTEGER PRIMARY KEY, PeopleFileName TEXT, 
                PeopleTitle TEXT, PeopleType TEXT, 
                email Text, Facebook Text, LinkedIn Text, Image Text, Phone Text, Street Text, City Text, State text, ZIP text,
                Parents Text, Spouse Text, Siblings Text, Children Text, Birthday Text, Tags Text, Description Text)"
                Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

                # Insert Data
                $QueryInsert = "INSERT INTO People (PeopleFileName, PeopleTitle, PeopleType, email, 
                Facebook, LinkedIn, Image, Phone, Street, City, State, ZIP, Parents, Siblings, Children,
                Birthday,  Tags, Description) 
                VALUES ('$PeopleFileName', '$PeopleTitle', '$PeopleType', '$email','$Facebook',
                '$LinkedIn','$Image','$Phone','$Street', '$City','$State','$ZIP','$Parents', '$Siblings',
                '$Children','$Birthday', '$Tags', '$Description')"
                Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

                # Select Data
                $People = Invoke-SqliteQuery -Query "SELECT * FROM People" -DataSource $Database
                $People | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'

           } -Content @(
            New-PodeWebTextbox -Name 'PeopleFileName' -DisplayName 'People File Name'
            New-PodeWebTextbox -Name 'PeopleTitle' -DisplayName 'People Title'
            New-PodeWebRadio -Name 'PeopleType' -DisplayName 'People Type' -Options @('Family', 'Friend', 'Athlete','Author','Actor')
            New-PodeWebTextbox -Name 'email' -DisplayName "email"
            New-PodeWebTextbox -Name 'Facebook' -DisplayName "Facebook"
            New-PodeWebTextbox -Name 'LinkedIn' -DisplayName "LinkedIn"
            New-PodeWebTextbox -Name 'Phone' -DisplayName "Phone"
            New-PodeWebTextbox -Name 'Street' -DisplayName "xxx Street"
            New-PodeWebTextbox -Name 'City' -DisplayName "City"
            New-PodeWebTextbox -Name 'State' -DisplayName "State (2 letters)"
            New-PodeWebTextbox -Name 'ZIP' -DisplayName "ZIP"
            
            New-PodeWebFileUpload -Name 'Image'
            New-PodeWebTextbox -Name 'Parents' -DisplayName "Parents (by ID)" 
            New-PodeWebTextbox -Name 'Spouse' -DisplayName "Spouse (by ID)"
            New-PodeWebTextbox -Name 'Siblings' -DisplayName "Siblings (by ID)" 
            New-PodeWebTextbox -Name 'Children' -DisplayName "Childeren (by ID)" 
            New-PodeWebTextbox -Name 'Birthday' -DisplayName "Birthday" -Type Date
            New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags" 
            
           )

        )

    }
 
# Add Events
# =============================
 Add-PodeWebPage -Name 'Add Events' -Group 'Events' -ScriptBlock {
        New-PodeWebCard -Content @(
            
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                # 'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

           New-PodeWebForm -Name 'Events1' -ScriptBlock {
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $EventFileName = $WebEvent.Data['EventFileName']
            $EventTitle = $WebEvent.Data['EventTitle']
            $EventType = $WebEvent.Data['EventType']
            $People = $WebEvent.Data['People']
            $Location = $WebEvent.Data['Location']
            $Image = $WebEvent.Data['Image']
            $StartDate = $WebEvent.Data['StartDate']
            $EndDate = $WebEvent.Data['EndDate']
            $Tags = $WebEvent.Data['Tags']
            $Description = $multiline
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $EventFileName + ".md"
            $title = "# " + $EventTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Create a Table
                $QueryCreate = "CREATE TABLE IF NOT EXISTS Events (Id INTEGER PRIMARY KEY, EventFileName TEXT, EventTitle TEXT, EventType TEXT, 
                People Text, Location Text, Image Text, StartDate Text, EndDate Text, Tags Text, Description Text)"
                Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

                # Insert Data
                $QueryInsert = "INSERT INTO Events (EventFileName, EventTitle, EventType, People, Location, Image, StartDate, EndDate, Tags, Description) VALUES ('$EventFileName', '$EventTitle', '$EventType', '$People','$Location','$Image','$StartDate','$EndDate', '$Tags','$Description')"
                Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

                # Select Data
                $Events = Invoke-SqliteQuery -Query "SELECT * FROM Events" -DataSource $Database
                $Events | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'

           } -Content @(
            New-PodeWebTextbox -Name 'EventFileName' -DisplayName 'Event File Name'
            New-PodeWebTextbox -Name 'EventTitle' -DisplayName 'Event Title'
            New-PodeWebRadio -Name 'EventType' -DisplayName 'Event Type' -Options @('Trip', 'Sport Event', 'Concert')
            New-PodeWebTextbox -Name 'People' -DisplayName "People Attending"
            New-PodeWebTextbox -Name 'Location' -DisplayName "Location"
            New-PodeWebFileUpload -Name 'Image'
            New-PodeWebTextbox -Name 'StartDate' -DisplayName "Start Date" -Type Date
            New-PodeWebTextbox -Name 'EndDate' -DisplayName "End Date" -Type Date
            New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags" 
           )

        )

    }

# Add Tags
# =============================
 Add-PodeWebPage -Name 'Add Tags' -Group 'Tags' -ScriptBlock {
        New-PodeWebCard -Content @(
            
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                # 'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

           New-PodeWebForm -Name 'Tags1' -ScriptBlock {
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $TagFileName = $WebEvent.Data['TagFileName']
            $TagTitle = $WebEvent.Data['TagTitle']
            $TagType = $WebEvent.Data['TagType']
            $TagName = $WebEvent.Data['TagName']
            $Image = $WebEvent.Data['Image']
            $Description = $multiline
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $TagFileName + ".md"
            $title = "# " + $TagTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Create a Table
                $QueryCreate = "CREATE TABLE IF NOT EXISTS Tags (Id INTEGER PRIMARY KEY, TagFilename TEXT, TagTitle TEXT, TagType TEXT, TagName TEXT,
                Image Text, Description Text)"
                Invoke-SqliteQuery -Query $QueryCreate -DataSource $Database

                # Insert Data
                $QueryInsert = "INSERT INTO Tags (TagFilename, TagTitle, TagType, TagName, Image, Description) VALUES ('$TagFilename', '$TagTitle', '$TagType', '$TagName', '$Image', '$Description')"
                Invoke-SqliteQuery -Query $QueryInsert -DataSource $Database

                # Select Data
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM Tags" -DataSource $Database
                #$Media | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'

           } -Content @(
            New-PodeWebTextbox -Name 'TagFilename' -DisplayName 'Tag File Name'
            New-PodeWebTextbox -Name 'TagTitle' -DisplayName 'Tag Title'
            New-PodeWebRadio -Name 'TagType' -DisplayName 'Tag Type' -Options @('Events', 'People', 'Media')
            New-PodeWebTextbox -Name 'TagName' -DisplayName 'Tag Name' 
            New-PodeWebFileUpload -Name 'Image'
           )

        )

    }
#>
# Update Media
# ==================
    Add-PodeWebPage -Name 'Update_Media' -Hide -ScriptBlock {
        New-PodeWebCard -Content @(
            
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                #$global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Media = Invoke-SqliteQuery -Query "SELECT * FROM Media where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #"PPP99" + $Media + $Media.MediaType | Format-Table | Out-Default

                
        
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Value "$($Media.Description)" -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                 #'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

           New-PodeWebForm -Name 'Example1' -ScriptBlock {
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $MediaFileName = $WebEvent.Data['MediaFileName']
            $MediaTitle = $WebEvent.Data['MediaTitle']
            $MediaType = $WebEvent.Data['MediaType']
            $Creator = $WebEvent.Data['Creator']
            $Service = $WebEvent.Data['Service']
            $Image = $WebEvent.Data['Image']
            $ReleaseDate = $WebEvent.Data['ReleaseDate']
            $ViewDate = $WebEvent.Data['ViewDate']
            $Tags =  $WebEvent.Data['Tags']
            $Description = $multiline
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $MediaFileName + ".md"
            $title = "# " + $MediaTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

        

                # Insert Data
                $QueryUpdate = "UPDATE Media SET MediaFileName = '$MediaFileName', MediaTitle = '$MediaTitle', Creator = '$Creator', Service = '$Service', Image = '$Image', ReleaseDate = '$ReleaseDate', ViewDate = '$ViewDate', Tags = '$Tags',  Description = '$Description' WHERE ID = $($WebEvent.Query['ID'])"
                Invoke-SqliteQuery -Query $QueryUpdate -DataSource $Database             

                # Select Data
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM Media" -DataSource $Database
                #$Media | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'

           } -Content @(
            New-PodeWebTextbox -Name 'MediaFileName' -DisplayName 'Media File Name' -Value "$($Media.MediaFileName)"
            New-PodeWebTextbox -Name 'MediaTitle' -DisplayName 'Media Title' -Value "$($Media.MediaTitle)"
            New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @("$($Media.MediaType)",'TVshow', 'Movie', 'Book','Album','Song')
            New-PodeWebTextbox -Name 'Creator' -DisplayName "Creator/Artist/Author" -Value "$($Media.Creator)"
            New-PodeWebRadio -Name 'Service' -Options @("$($Media.Service)",'NetworkTV', 'Netflix', 'AppleTV','Hulu', 'Prime','Max', 'Libby','Kindle','Hoopla','NA')
            New-PodeWebTextbox -Name 'Image' -Value "$($Media.Image)"
            New-PodeWebTextbox -Name 'ReleaseDate' -DisplayName "Release Date" -Type Date -Value "$($Media.ReleaseDate)"
            New-PodeWebTextbox -Name 'ViewDate' -DisplayName "Viewing Date" -Type Date -Value "$($Media.ViewDate)"
             New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags"  -Value "$($Media.Tags)"
           )

        )

    }

    # Update People
# ==================
    Add-PodeWebPage -Name 'Update_People' -Hide -ScriptBlock {

         New-PodeWebCard -Content @(
               
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:People = Invoke-SqliteQuery -Query "SELECT * FROM People where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #"PPP199" + $People + $People.MediaType | Format-Table | Out-Default

                
        
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Value "$($People.Description)" -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                 #'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

        New-PodeWebForm -Name 'Example2' -ScriptBlock {
            
             #$WebEvent.Data | Out-Default
             #'UUU2' + $multiline | Out-Default

            $PeopleFileName = $WebEvent.Data['PeopleFileName']
            $PeopleTitle = $WebEvent.Data['PeopleTitle']
            $PeopleType = $WebEvent.Data['PeopleType']
            $email = $WebEvent.Data['email']
            $Facebook = $WebEvent.Data['Facebook']
            $LinkedIn = $WebEvent.Data['LinkedIn']
            $Phone = $WebEvent.Data['Phone']
            $Street = $WebEvent.Data['Street']
            $City = $WebEvent.Data['City']
            $State = $WebEvent.Data['State']
            $Zip = $WebEvent.Data['Zip']
            $Image = $WebEvent.Data['Image']
            $Parents = $WebEvent.Data['Parents']
            $Spouse = $WebEvent.Data['Spouse']
            $Siblings = $WebEvent.Data['Siblings']
            $Children = $WebEvent.Data['Children']
            $Birthday = $WebEvent.Data['Birthday']
            $Tags = $WebEvent.Data['Tags']
            $Description = $multiline


            #"UU3" + $PeopleFileName + " " + $email | Out-Default
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $PeopleFileName + ".md"
            $title = "# " + $PeopleTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Insert Data
                #$QueryUpdate = "UPDATE People SET PeopleFileName = '$PeopleFileName', PeopleTitle = '$PeopleTitle', PeopleType = '$PeopleType', email = '$email', Facebook = '$Facebook', Image = '$Image', Parents = '$Parents', Siblings = '$Siblings', Children = '$Children', Birthday = '$Birthday', Description = '$Description' WHERE ID = $($WebEvent.Query['ID'])"
                $QueryUpdate = "UPDATE People SET PeopleFileName = '$PeopleFileName', PeopleTitle = '$PeopleTitle', PeopleType = '$PeopleType', email = '$email', Facebook = '$Facebook', LinkedIn = '$LinkedIn', Image = '$Image', Phone = '$Phone', Street = '$Street', City = '$City', State = '$State', ZIP = '$ZIP', Parents = '$Parents', Spouse = '$Spouse', Siblings = '$Siblings', Children = '$Children', Birthday = '$Birthday', Tags = '$Tags', Description = '$Description'  WHERE ID = $($WebEvent.Query['ID'])"
                Invoke-SqliteQuery -Query $QueryUpdate -DataSource $Database             

                # Select Data
                $People = Invoke-SqliteQuery -Query "SELECT * FROM People" -DataSource $Database
                #$People | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'
           } -Content @(
            New-PodeWebTextbox -Name 'PeopleFileName' -DisplayName 'People File Name' -Value "$($People.PeopleFileName)"
            New-PodeWebTextbox -Name 'PeopleTitle' -DisplayName 'People Title' -Value "$($People.PeopleTitle)"
            New-PodeWebRadio -Name 'PeopleType' -DisplayName 'People Type' -Options @("$($People.PeopleType)",'Family', 'Friend', 'Athlete','Author','Actor')
            New-PodeWebTextbox -Name 'email' -DisplayName "email" -Value "$($People.email)"
            New-PodeWebTextbox -Name 'Facebook' -DisplayName "Facebook" -Value "$($People.Facebook)"
            New-PodeWebTextbox -Name 'LinkedIn' -DisplayName "LinkedIn" -Value "$($People.LinkedIn)"
            
            New-PodeWebTextbox -Name 'Phone' -DisplayName "Phone" -Value "$($People.Phone)"
            New-PodeWebTextbox -Name 'Street' -DisplayName "xxx Street" -Value "$($People.Street)"
            New-PodeWebTextbox -Name 'City' -DisplayName "City" -Value "$($People.City)"
            New-PodeWebTextbox -Name 'State' -DisplayName "State (2 letters)" -Value "$($People.State)"
            New-PodeWebTextbox -Name 'ZIP' -DisplayName "ZIP" -Value "$($People.ZIP)"
            
            New-PodeWebTextbox -Name 'Image' -Value "$($People.Image)"
        
            New-PodeWebTextbox -Name 'Parents' -DisplayName "Parents (by ID)" -Value "$($People.Parents)"
            New-PodeWebTextbox -Name 'Spouse' -DisplayName "Spouse (by ID)" -Value "$($People.Spouse)"
            New-PodeWebTextbox -Name 'Siblings' -DisplayName "Siblings (by ID)" -Value "$($People.Siblings)"
            New-PodeWebTextbox -Name 'Children' -DisplayName "Children (by ID)" -Value "$($People.Children)"
            New-PodeWebTextbox -Name 'Birthday' -DisplayName "Birthday" -Type Date -Value "$($People.Birthday)"
             New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags" -Value "$($People.Tags)"
            
           )
    
      )
    
    }

# Update Events
# ==================
    Add-PodeWebPage -Name 'Update_Events' -Hide -ScriptBlock {

         New-PodeWebCard -Content @(
               
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Events = Invoke-SqliteQuery -Query "SELECT * FROM Events where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #"PPP499" + $Events + $Events.EventType | Format-Table | Out-Default

                
        
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Value "$($Events.Description)" -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                 #'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

        New-PodeWebForm -Name 'Example2' -ScriptBlock {
            
             #$WebEvent.Data | Out-Default
             #'UUU2' + $multiline | Out-Default

            $EventFileName = $WebEvent.Data['EventFileName']
            $Eventtitle = $WebEvent.Data['Eventtitle']
            $EventType = $WebEvent.Data['EventType']
            $People = $WebEvent.Data['People']
            $Location = $WebEvent.Data['Location']
            $Image = $WebEvent.Data['Image']
            $StartDate = $WebEvent.Data['StartDate']
            $EndDate = $WebEvent.Data['EndDate']
            $Tags = $WebEvent.Data['Tags']
            $Description = $multiline

           # "UU3" + $EventFileName + " " + $email | Out-Default
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $EventFileName + ".md"
            $title = "# " + $Eventtitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Insert Data
                #$QueryUpdate = "UPDATE People SET PeopleFileName = '$PeopleFileName', PeopleTitle = '$PeopleTitle', PeopleType = '$PeopleType', email = '$email', Facebook = '$Facebook', Image = '$Image', Parents = '$Parents', Siblings = '$Siblings', Children = '$Children', Birthday = '$Birthday', Description = '$Description' WHERE ID = $($WebEvent.Query['ID'])"
                $QueryUpdate = "UPDATE Events SET EventFilename = '$EventFilename', EventTitle = '$EventTitle', EventType = '$EventType', People = '$People', Location = '$Location', Image = '$Image', StartDate = '$StartDate', EndDate = '$EndDate', Tags = '$Tags',  Description = '$Description'  WHERE ID = $($WebEvent.Query['ID'])"
                Invoke-SqliteQuery -Query $QueryUpdate -DataSource $Database             

                # Select Data
                $Events = Invoke-SqliteQuery -Query "SELECT * FROM Events" -DataSource $Database
                #$Events | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'
           } -Content @(
            New-PodeWebTextbox -Name 'EventFileName' -DisplayName 'Event File Name' -Value "$($Events.EventFileName)"
            New-PodeWebTextbox -Name 'EventTitle' -DisplayName 'Event Title' -Value "$($Events.EventTitle)"
            New-PodeWebRadio -Name 'EventType' -DisplayName 'Event Type' -Options @("$($Events.EventType)",'Trip', 'Sport Event', 'Concert')
            New-PodeWebTextbox -Name 'People' -DisplayName "People" -Value "$($Events.People)"
            New-PodeWebTextbox -Name 'Location' -DisplayName "Location" -Value "$($Events.Location)"
            New-PodeWebTextbox -Name 'Image' -DisplayName "Image" -Value "$($Events.Image)"
            
            New-PodeWebTextbox -Name 'StartDate' -DisplayName "Start Date" -Value "$($Events.StartDate)"
            New-PodeWebTextbox -Name 'EndDate' -DisplayName "End Date" -Value "$($Events.EndDate)"
            New-PodeWebTextbox -Name 'Tags' -DisplayName "Tags" -Value "$($Events.Tags)"
            

           )
    
      )
    
    }

    # Update Tags
# ==================
    Add-PodeWebPage -Name 'Update_Tags' -Hide -ScriptBlock {

         New-PodeWebCard -Content @(
               
            New-PodeWebText -Value 'Markdown Description (click button to enter description): ' 
            New-PodeWebButton -Name 'Enter Description' -ScriptBlock {
                Show-PodeWebModal -Name 'Description'
            }

            New-PodeWebModal -Name 'Description' -AsForm -Content @(   
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Tags = Invoke-SqliteQuery -Query "SELECT * FROM Tags where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #"PPP599" + $Tags + $Tags.TagType | Format-Table | Out-Default

                
        
                New-PodeWebTextbox -Name 'MultiLine' -Multiline -Value "$($Tags.Description)" -Size 20
            ) -ScriptBlock {
                
                Write-Host 'Submit button clicked!'
                 #'UUU1' + $WebEvent.Data['Multiline'] | Out-Default
                  
                  $global:multiline = $WebEvent.Data['Multiline'] 
                 
            }

        New-PodeWebParagraph -Value ' '
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

        New-PodeWebForm -Name 'Example2' -ScriptBlock {
            
            # $WebEvent.Data | Out-Default
            # 'UUU2' + $multiline | Out-Default

            $TagFileName = $WebEvent.Data['TagFileName']
            $TagTitle = $WebEvent.Data['TagTitle']
            $TagType = $WebEvent.Data['TagType']
            $TagName = $WebEvent.Data['TagName']
            $Image = $WebEvent.Data['Image']
            $Description = $multiline

            #"UU3" + $TagFileName + " " + $TagTitle | Out-Default
            
            # Create md file
            $outfile = "/home/eric/dev/pode_test1/Public/topics/" + $TagFileName + ".md"
            $title = "# " + $TagTitle
            Set-Content -Path $outfile -Value $title
            Add-Content -Path $outfile -Value $Description

             # Define database path
                $global:Database = "/home/eric/dev/pode_test1/data.db"

                # Insert Data
                #$QueryUpdate = "UPDATE People SET PeopleFileName = '$PeopleFileName', PeopleTitle = '$PeopleTitle', PeopleType = '$PeopleType', email = '$email', Facebook = '$Facebook', Image = '$Image', Parents = '$Parents', Siblings = '$Siblings', Children = '$Children', Birthday = '$Birthday', Description = '$Description' WHERE ID = $($WebEvent.Query['ID'])"
                $QueryUpdate = "UPDATE Tags SET TagFilename = '$TagFilename', TagTitle = '$TagTitle', TagType = '$TagType', TagName = '$TagName', Image = '$Image', Description = '$Description'  WHERE ID = $($WebEvent.Query['ID'])"
                Invoke-SqliteQuery -Query $QueryUpdate -DataSource $Database             

                # Select Data
                $People = Invoke-SqliteQuery -Query "SELECT * FROM People" -DataSource $Database
                #$People | Format-Table | Out-Default

                Move-PodeWebUrl -Url '/pages/thankyou'
           } -Content @(
            New-PodeWebTextbox -Name 'TagFilename' -DisplayName 'Tag File Name' -Value "$($Tags.TagFilename)"
            New-PodeWebTextbox -Name 'TagTitle' -DisplayName 'Tag Title' -Value "$($Tags.TagTitle)"
            New-PodeWebRadio -Name 'TagType' -DisplayName 'Tag Type' -Options @("$($Tags.TagType)",'Events', 'People', 'Media')
            New-PodeWebTextbox -Name 'TagName' -DisplayName "Tag Name" -Value "$($Tags.TagName)"
            New-PodeWebTextbox -Name 'Image' -DisplayName "Image" -Value "$($Tags.Image)"
           
            
           )
    
      )
    
    }

# Manage Media
# ========================
    Add-PodeWebPage -Name 'Manage Media' -Group 'Media' -ScriptBlock {
        New-PodeWebCard -Content @(

        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>MediaFileName</th><th>MediaTitle</th><th>MediaType</th><th>Creator</th><th>Service</th><th>Manage</th>"
        $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM Media" -DataSource $Database
                #$Media | Format-Table | Out-Default
        foreach ($item in $Media) {
          New-PodeWebRaw -Value "<tr>
          <td>$($item.ID)</td><td>$($item.MediaFileName)</td><td>$($item.MediaTitle)</td>
          <td>$($item.MediaType)</td><td>$($item.Creator)</td><td>$($item.Service)</td>
          <td><a href='/pages/media-view?id=$($item.ID)'>[view]</a> | <a href='/pages/Update_Media?id=$($item.ID)'>[update]</a> |
           <a href='/pages/deleteconfirm?id=$($item.ID)'>[delete]</a></td>
          </tr>" 
        }
         New-PodeWebRaw -Value "</table>" 



        )      

    }


    # Manage People
# ========================
    Add-PodeWebPage -Name 'Manage People' -Group 'People' -ScriptBlock {
        New-PodeWebCard -Content @(

        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>PeopleFileName</th><th>PeopleTitle</th><th>PeopleType</th><th>Email</th><th>Facebook</th><th>LinkedIn</th><th>Manage</th>"
        $global:Database = "/home/eric/dev/pode_test1/data.db"
                $People = Invoke-SqliteQuery -Query "SELECT * FROM People" -DataSource $Database
                #$People | Format-Table | Out-Default
        foreach ($item in $People) {
          New-PodeWebRaw -Value "<tr>
          <td>$($item.ID)</td><td>$($item.PeopleFileName)</td><td>$($item.PeopleTitle)</td>
          <td>$($item.$PeopleType)</td><td>$($item.Email)</td><td>$($item.Facebook)</td><td>$($item.LinkedIn)</td>
          <td><a href='/pages/people-view?id=$($item.ID)'>[view]</a> | <a href='/pages/Update_People?id=$($item.ID)'>[update]</a> |
           <a href='/pages/deleteconfirmPeople?id=$($item.ID)'>[delete]</a></td>
          </tr>" 
        }
         New-PodeWebRaw -Value "</table>" 


        )      

    }

# Manage Events
# ========================
Add-PodeWebPage -Name 'Manage Events' -Group 'Events' -ScriptBlock {
        New-PodeWebCard -Content @(

        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>EventFileName</th><th>EventTitle</th><th>EventType</th><th>People</th><th>Location</th><th>StartDate</th><th>Manage</th>"
        $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Events = Invoke-SqliteQuery -Query "SELECT * FROM Events" -DataSource $Database
                # $Events | Format-Table | Out-Default
        foreach ($item in $Events) {
          New-PodeWebRaw -Value "<tr>
          <td>$($item.ID)</td><td>$($item.EventFileName)</td><td>$($item.EventTitle)</td>
          <td>$($item.$EventType)</td><td>$($item.People)</td><td>$($item.Location)</td><td>$($item.StartDate)</td>
          <td><a href='/pages/event-view?id=$($item.ID)'>[view]</a> | <a href='/pages/Update_Events?id=$($item.ID)'>[update]</a> |
           <a href='/pages/deleteconfirmEvents?id=$($item.ID)'>[delete]</a></td>
          </tr>" 
        }
         New-PodeWebRaw -Value "</table>" 


        )      

    }



# Manage Tags
# ========================
Add-PodeWebPage -Name 'Manage Tags' -Group 'Tags' -ScriptBlock {
        New-PodeWebCard -Content @(

        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>TagFileName</th><th>TagTitle</th><th>TagType</th><th>TagName</th><th>Image</th><th>Manage</th>"
        $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Tags = Invoke-SqliteQuery -Query "SELECT * FROM Tags" -DataSource $Database
                #$Tags | Format-Table | Out-Default
        foreach ($item in $Tags) {
          New-PodeWebRaw -Value "<tr>
          <td>$($item.ID)</td><td>$($item.TagFileName)</td><td>$($item.TagTitle)</td>
          <td>$($item.$TagType)</td><td>$($item.TagName)</td><td>$($item.Image)</td>
          <td><a href='/pages/tag-view?id=$($item.ID)'>[view]</a> | <a href='/pages/Update_Tags?id=$($item.ID)'>[update]</a> |
           <a href='/pages/deleteconfirmTags?id=$($item.ID)'>[delete]</a></td>
          </tr>" 
        }
         New-PodeWebRaw -Value "</table>" 


        )      

    }



 # Define the destination page

 # Thankyou 
 # ==========
Add-PodeWebPage -Name 'ThankYou' -Hide -Layouts @(
    New-PodeWebCard -Content @(
     New-PodeWebHeader -Value 'Thank You for Submitting!' -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'
    )
)

# Deleted 
# ==========
Add-PodeWebPage -Name 'Deleted' -Hide -Layouts @(
    New-PodeWebCard -Content @(
     New-PodeWebHeader -Value 'Item was deleted.' -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'
    )
)

# Delete Confirmation 
# ========================
Add-PodeWebPage -Name 'DeleteConfirm' -Hide -ScriptBlock {

    #"ZZZ1" + $WebEvent.Query['ID'] | Out-Default
    New-PodeWebCard -Content @(
    
     New-PodeWebHeader -Value "Are you sure that you want to delete ID=$($WebEvent.Query['ID'])?" -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'

     New-PodeWebContainer -Content @(
            New-PodeWebTable -Name 'Services' -ScriptBlock {
                #"YYY22" | Out-Default
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM Media where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #$Media | Format-Table | Out-Default

                

                foreach ($item in $Media) {
                    $global:ID_val = $item.ID
                    [ordered]@{
                        ID      = "$($item.ID)"
                        MediaFileName    = "$($item.MediaFileName)"
                        MediaTitle = "$($item.MediaTitle)"
                        MediaType = "$($item.MediaType)"
                        Creator = "$($item.Creator)"
                        Service = "$($item.Service)"
                        
                        
                    }
                }
                
            }
<#
            New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                  New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('Yes', 'No')
            }
#>

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                     #'ZZZ1' + $WebEvent.Data['DeleteConfirm'] | Out-Default

                     if ($WebEvent.Data['DeleteConfirm'].Contains("No")) {
                        Move-PodeWebUrl -Url '/groups/Media/pages/Manage_Media'
                     }
                     if ($WebEvent.Data['DeleteConfirm'].Contains("Yes")) {
                        Invoke-SqliteQuery -Query "DELETE FROM Media where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                        Move-PodeWebUrl -Url '/pages/Deleted'
                     }

                    
                } -Content @(
                    New-PodeWebRadio -Name 'DeleteConfirm' -Options 'Yes', 'No'
                )
            )
            
        )
    )
}

# Delete Confirmation - People
# ========================
Add-PodeWebPage -Name 'DeleteConfirmPeople' -Hide -ScriptBlock {

    #"ZZZ1" + $WebEvent.Query['ID'] | Out-Default
    New-PodeWebCard -Content @(
    
     New-PodeWebHeader -Value "Are you sure that you want to delete ID=$($WebEvent.Query['ID'])?" -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'

     New-PodeWebContainer -Content @(
            New-PodeWebTable -Name 'DeleteConfirm1' -ScriptBlock {
                #"YYY22" | Out-Default
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Media = Invoke-SqliteQuery -Query "SELECT * FROM People where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #$Media | Format-Table | Out-Default

                

                foreach ($item in $Media) {
                    $global:ID_val = $item.ID
                    [ordered]@{
                        ID      = "$($item.ID)"
                        PeopleFileName    = "$($item.PeopleFileName)"
                        PeopleTitle = "$($item.PeopleTitle)"
                        PeopleType = "$($item.PeopleType)"
                        email = "$($item.email)"
                        Facebook = "$($item.Facebook)"
                        
                        
                    }
                }
                
            }
<#
            New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                  New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('Yes', 'No')
            }
#>

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                     #'ZZZ1' + $WebEvent.Data['DeleteConfirm'] | Out-Default

                     if ($WebEvent.Data['DeleteConfirm'].Contains("No")) {
                        Move-PodeWebUrl -Url '/groups/People/pages/Manage_People'
                     }
                     if ($WebEvent.Data['DeleteConfirm'].Contains("Yes")) {
                        Invoke-SqliteQuery -Query "DELETE FROM People where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                        Move-PodeWebUrl -Url '/pages/Deleted'
                     }

                    
                } -Content @(
                    New-PodeWebRadio -Name 'DeleteConfirm' -Options 'Yes', 'No'
                )
            )
            
        )
    )
}

# Delete Confirmation - Events
# ========================
Add-PodeWebPage -Name 'DeleteConfirmEvents' -Hide -ScriptBlock {

    #"ZZZ1" + $WebEvent.Query['ID'] | Out-Default
    New-PodeWebCard -Content @(
    
     New-PodeWebHeader -Value "Are you sure that you want to delete ID=$($WebEvent.Query['ID'])?" -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'

     New-PodeWebContainer -Content @(
            New-PodeWebTable -Name 'DeleteConfirm1' -ScriptBlock {
                #"YYY22" | Out-Default
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Events = Invoke-SqliteQuery -Query "SELECT * FROM Events where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #$Events | Format-Table | Out-Default

                

                foreach ($item in $Events) {
                    $global:ID_val = $item.ID
                    [ordered]@{
                        ID      = "$($item.ID)"
                        EventFileName    = "$($item.EventFileName)"
                        EventTitle = "$($item.EventTitle)"
                        EventType = "$($item.EventType)"
                        People = "$($item.People)"
                        Location = "$($item.Location)"
                        
                        
                    }
                }
                
            }
<#
            New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                  New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('Yes', 'No')
            }
#>

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                    # 'ZZZ1' + $WebEvent.Data['DeleteConfirm'] | Out-Default

                     if ($WebEvent.Data['DeleteConfirm'].Contains("No")) {
                        Move-PodeWebUrl -Url '/groups/Events/pages/Manage_Events'
                     }
                     if ($WebEvent.Data['DeleteConfirm'].Contains("Yes")) {
                        Invoke-SqliteQuery -Query "DELETE FROM Events where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                        Move-PodeWebUrl -Url '/pages/Deleted'
                     }

                    
                } -Content @(
                    New-PodeWebRadio -Name 'DeleteConfirm' -Options 'Yes', 'No'
                )
            )
            
        )
    )
}

# Delete Confirmation - Tags
# ========================
Add-PodeWebPage -Name 'DeleteConfirmTags' -Hide -ScriptBlock {

    #"ZZZ1" + $WebEvent.Query['ID'] | Out-Default
    New-PodeWebCard -Content @(
    
     New-PodeWebHeader -Value "Are you sure that you want to delete ID=$($WebEvent.Query['ID'])?" -Size 1 
     New-PodeWebParagraph -Value 'Your submissions have been reveived.'

     New-PodeWebContainer -Content @(
            New-PodeWebTable -Name 'DeleteConfirm1' -ScriptBlock {
                #"YYY22" | Out-Default
                $global:Database = "/home/eric/dev/pode_test1/data.db"
                $Tags = Invoke-SqliteQuery -Query "SELECT * FROM Tags where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                #$Events | Format-Table | Out-Default

                

                foreach ($item in $Tags) {
                    $global:ID_val = $item.ID
                    [ordered]@{
                        ID      = "$($item.ID)"
                        TagFileName    = "$($item.TagFileName)"
                        TagTitle = "$($item.TagTitle)"
                        TagType = "$($item.TagType)"
                        TagName = "$($item.TagName)"  
                    }
                }
                
            }
<#
            New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                  New-PodeWebRadio -Name 'MediaType' -DisplayName 'Media Type' -Options @('Yes', 'No')
            }
#>

            New-PodeWebCard -Content @(
                New-PodeWebForm -Name 'DeleteConfirm' -ScriptBlock {
                    # 'ZZZ1' + $WebEvent.Data['DeleteConfirm'] | Out-Default

                     if ($WebEvent.Data['DeleteConfirm'].Contains("No")) {
                        Move-PodeWebUrl -Url '/groups/Tags/pages/Manage_Tags'
                     }
                     if ($WebEvent.Data['DeleteConfirm'].Contains("Yes")) {
                        Invoke-SqliteQuery -Query "DELETE FROM Tags where ID = $($WebEvent.Query['ID'])" -DataSource $Database
                        Move-PodeWebUrl -Url '/pages/Deleted'
                     }

                    
                } -Content @(
                    New-PodeWebRadio -Name 'DeleteConfirm' -Options 'Yes', 'No'
                )
            )
            
        )
    )
}

<#
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
#>

Add-PodeWebPage -Name Media-View -Hide  -ScriptBlock {
     #"ZZZ98" + $WebEvent.Query['ID'] | Out-Default
     $global:ID_value = $WebEvent.Query['ID']
    New-PodeWebCard -Content @(

    $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Media = Invoke-SqliteQuery -Query "SELECT * FROM Media where ID=$ID_value" -DataSource $Database
               
                "ZZZ99" + $Media.MediaFilename | Out-Default
        New-PodeWebIFrame -Url "/html/$($Media.MediaFileName).html"
      #New-PodeWebText -Value "Media Filename:	$($Media.MediaFileName)"


    #++++++++++++++++    
        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>MediaFileName</th><th>MediaTitle</th><th>MediaType</th><th>Creator</th>
<th>Service</th><th>Image</th><th>Release Date</th><th>View Date</th>"
       
          New-PodeWebRaw -Value "<tr>
          <td>$($Media.ID)</td><td>$($Media.MediaFileName)</td><td>$($Media.MediaTitle)</td>
          <td>$($Media.MediaType)</td><td>$($Media.Creator)</td><td>$($Media.Service)</td>
          <td>$($Media.Image)</td><td>$($Media.ReleaseDate)</td><td>$($Media.ViewDate)</td>
          
          </tr>" 
        
         New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   
New-PodeWebRaw -Value "<p><b>Creators:</b></p>
<table>
<th>ID</th><th>Creator</th>"

$creator1 = $Media.Creator.split(",")
    foreach ($person in $creator1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        #"ZZZ77 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

    )
    }

Add-PodeWebPage -Name People-View -Hide  -ScriptBlock {
     #"ZZZ100 " + $WebEvent.Query['ID'] | Out-Default
     $global:ID_value = $WebEvent.Query['ID']
    New-PodeWebCard -Content @(

    $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:People = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$ID_value" -DataSource $Database
               
               # "ZZZ99 " + $People.PeopleFilename | Out-Default
               # "ZZZ98 " + $People.Parents | Out-Default
    

        New-PodeWebIFrame -Url "/html/$($People.PeopleFileName).html"
      #New-PodeWebText -Value "Media Filename:	$($Media.MediaFileName)"


    #++++++++++++++++    
        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>PeopleFileName</th><th>PeopleTitle</th><th>PeopleType</th><th>email</th>
<th>Facebook</th><th>LinkedIn</th><th>Birthday</th><th>Phone</th><th>Tags</th>"
       
          New-PodeWebRaw -Value "<tr>
          <td>$($People.ID)</td><td>$($People.PeopleFileName)</td><td>$($People.PeopleTitle)</td>
          <td>$($People.PeopleType)</td><td>$($People.email)</td><td>$($People.Facebook)</td>
          <td>$($People.LinkedIn)</td><td>$($People.Birthday)</td><td>$($People.Phone)</td>
          <td>$($People.Tags)</td>
          </tr>" 
        
          
         New-PodeWebRaw -Value "</table>" 

    New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<p><b>Parents:</b></p>
<table>
<th>ID</th><th>Parent</th>"

$parents1 = $People.Parents.split(",")
    foreach ($person in $parents1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
       # "ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   



    New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>

<p><b>Spouse:</b></p>
<table>
<th>ID</th><th>Spouse</th>"

$spouse1 = $People.Spouse.split(",")
    foreach ($person in $spouse1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
       # "ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

New-PodeWebRaw -Value "<p><b>Children:</b></p>
<table>
<th>ID</th><th>Children</th>"

$children1 = $People.Children.split(",")
    foreach ($person in $children1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        #"ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

    New-PodeWebRaw -Value "<p><b>Siblings:</b></p>
<table>
<th>ID</th><th>Siblings</th>"

$siblings1 = $People.siblings.split(",")
    foreach ($person in $siblings1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        #"ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   



    )
    }

Add-PodeWebPage -Name Event-View -Hide  -ScriptBlock {
     #"ZZZ100 " + $WebEvent.Query['ID'] | Out-Default
     $global:ID_value = $WebEvent.Query['ID']
    New-PodeWebCard -Content @(

    $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Events = Invoke-SqliteQuery -Query "SELECT * FROM Events where ID=$ID_value" -DataSource $Database
               
                #"ZZZ99 " + $Events.EventFileName | Out-Default
                #"ZZZ98 " + $Events.EventTitle | Out-Default
    

        New-PodeWebIFrame -Url "/html/$($Events.EventFileName).html"
      #New-PodeWebText -Value "Media Filename:	$($Media.MediaFileName)"


    #++++++++++++++++    
        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>EventFileName</th><th>EventTitle</th><th>EventType</th><th>People</th>
<th>Location</th><th>Image</th><th>Start Date</th><th>End Date</th>"
       
          New-PodeWebRaw -Value "<tr>
          <td>$($Events.ID)</td><td>$($Events.EventFileName)</td><td>$($Events.EventTitle)</td>
          <td>$($Events.EventType)</td><td>$($Events.People)</td><td>$($Events.Location)</td>
          <td>$($Events.Image)</td><td>$($Events.StartDate)</td><td>$($Events.EndDate)</td>
          
          </tr>" 
        
          
         New-PodeWebRaw -Value "</table>" 


    New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<p><b>People Attending:</b></p>
<table>
<th>ID</th><th>People</th>"


$people_e = $Events.People.split(",")
    foreach ($person in $people_e) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        #"ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

<#

    New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>

<p><b>Spouse:</b></p>
<table>
<th>ID</th><th>Spouse</th>"

$spouse1 = $People.Spouse.split(",")
    foreach ($person in $spouse1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        "ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

New-PodeWebRaw -Value "<p><b>Children:</b></p>
<table>
<th>ID</th><th>Children</th>"

$children1 = $People.Children.split(",")
    foreach ($person in $children1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        "ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   

    New-PodeWebRaw -Value "<p><b>Siblings:</b></p>
<table>
<th>ID</th><th>Siblings</th>"

$siblings1 = $People.siblings.split(",")
    foreach ($person in $siblings1) {
        $People1 = Invoke-SqliteQuery -Query "SELECT * FROM People where ID=$($person)" -DataSource $Database
        "ZZZ96 " + $People1.PeopleTitle | Out-Default
        New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($People1.ID)'>$($People1.ID)</a></td><td>$($People1.PeopleTitle)</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   
#>


    )
    }
Add-PodeWebPage -Name Tag-View -Hide  -ScriptBlock {
     #"ZZZ101 " + $WebEvent.Query['ID'] | Out-Default
     $global:ID_value = $WebEvent.Query['ID']
    New-PodeWebCard -Content @(

    $global:Database = "/home/eric/dev/pode_test1/data.db"
                $global:Tags = Invoke-SqliteQuery -Query "SELECT * FROM Tags where ID=$ID_value" -DataSource $Database
               
                #"ZZZ99 " + $Tags.TagFileName | Out-Default
                #"ZZZ98 " + $Tags.TagName | Out-Default

                
    

        New-PodeWebIFrame -Url "/html/$($Tags.TagFileName).html"
      #New-PodeWebText -Value "Media Filename:	$($Media.MediaFileName)"


    #++++++++++++++++    
        New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<table>
<th>ID</th><th>TagFilename</th><th>TagTitle</th><th>TagType</th><th>TagName</th>
<th>Image</th>"
       
          New-PodeWebRaw -Value "<tr>
          <td>$($Tags.ID)</td><td>$($Tags.TagFilename )</td><td>$($Tags.TagTitle)</td>
          <td>$($Tags.TagType)</td><td>$($Tags.TagName)</td><td>$($Tags.Image)</td>
         
          
          </tr>" 
        
          
         New-PodeWebRaw -Value "</table>" 

    New-PodeWebRaw -Value "<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
<p><b>$($Tags.TagType):</b></p>
<table>
<th>ID</th><th>$($Tags.TagType)</th>"

 $global:Items = Invoke-SqliteQuery -Query "SELECT * FROM $($Tags.TagType) where Tags='$($Tags.TagName)'" -DataSource $Database



    foreach ($item in $Items) {

        if ($Tags.TagType -eq 'People') {
            $Tag_id = "<a href='/pages/people-view?id=$($item.ID)'>$($item.ID)</a>"
            $Tag_Title = $item.PeopleTitle
        }
        if ($Tags.TagType -eq 'Media') {
            $Tag_id = "<a href='/pages/media-view?id=$($item.ID)'>$($item.ID)</a>"
            $Tag_Title = $item.MediaTitle
        }
        if ($Tags.TagType -eq 'Events') {
            $Tag_id = "<a href='/pages/event-view?id=$($item.ID)'>$($item.ID)</a>"
            $Tag_Title = $item.EventTitle
        }
        
        #New-PodeWebRaw -Value "<tr><td><a href='/pages/people-view?id=$($person.ID)'>$($person.ID)</a></td><td>$($person.PeopleTitle)$($person.MediaTitle)$($person.EventTitle)</td></tr>"
        New-PodeWebRaw -Value "<tr><td>$Tag_id</td><td>$Tag_Title</td></tr>"
    }

    New-PodeWebRaw -Value "</table>" 
    #++++++++++++++++   



   

    )
    }


}
