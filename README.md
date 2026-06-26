# Pode Web Application

The application created with the Pode.Web module allows you to add media (TV shows, movies, books, and albums), people (friends, family, authors, directors, actors, artists, etc.), and events (concerts, sporting events, vacations, etc.) by using web forms. The data from the web forms will be stored to a sqlite database. It includes connections between the three entities.

*Prerequisites:* Powershell and DITA Open Tool Kit.

The application will also require the following Powershell modules:

 * Pode
 * Pode.Web
 * PSSqlite

Please refer to [PowerShell and Pode.Web on Ubuntu](https://hypot2noose.blogspot.com/2026/03/powershell-and-podeweb-on-ubuntu.html) for setting up PowerShell and installing the modules.

## Quick Start

### Install Application

1. Download zip file (Code > Download Zip).
2. Unzip file into a folder.
3. Open in cms.ps1 with text editor.
4. Replace */home/eric/dev/pode_webapp* with *<your_path>/pode_webapp*

### Run Application

1. Open terminal window.
2. Type *cd <your_path>/web>*
3. Type *pwsh*.
4. Tyoe *./cms.ps1*

Web application starts up running on localhost:8081.

### Populate Web Forms

#### Events

**Add/Update Events:** A web form to input details of past or upcoming events.
*Event Types:* Trip, Sport Event, Concert.
*Inputs:* Title, file name, event type, location, start date, end date, image path, description, attendee associations (People.Id), and tags (Tags.TagName).

**Manage Events:** A summary table displaying event logs with View, Update, and Delete options.

To enter form data:

1. Navigate to *Events > Add Events* to enter form data.
2. Navigate to *Events > Manage Events* to view, update, and delete Events.

Note: Remember to *Enter Description*, which is a separate popup window.

#### Media

**Add/Update Media:** Users must be able to input and edit media items through web forms.
*Media Types:* TVshow, Movie, Book, Album, Song.
*Services/Platforms:* NetworkTV, Netflix, AppleTV, Hulu, Prime, Max, Libby, Kindle, Hoopla, NA.
*Inputs:* Title, file name, release date, view date, image path, description, creator link (People.Id), and tags (Tags.TagName).

**Manage Media:** A dashboard displaying a structured table of all media entries, providing quick action buttons to View, Update, or Delete records.

To enter form data:

1. Navigate to *Media > Add Media* to enter form data.
2. Navigate to *Media > Manage Media* to view, update, and delete Media.

Note: Remember to *Enter Description*, which is a separate popup window.

#### People

**Add/Update People:** A web form to input and edit personal contacts or public figures.
*People Types:* Family, Friend, Athlete, Author, Actor.
*Inputs:* Name, contact details (Email, Phone, Street, City, State, ZIP), social links (Facebook, LinkedIn), image path, birthday, description, and tags (Tags.TagName).
*Relationships:* Self-referencing fields to map family trees (Parents, Siblings, Children, Spouse linking directly to People.Id).

**Manage People:** A tabular view of all registered people with action items for View, Update, and Delete.

To enter form data:

1. Navigate to *People > Add People* to enter form data.
2. Navigate to *People > Manage People* to view, update, and delete People.

Note: Remember to *Enter Description*, which is a separate popup window.

#### Tags

**Add/Update Tags:** A form to create custom categorization tags.
*Tag Types:* Events, People, Media.
*Inputs:* Tag name, filename, title, image, and description.

**Manage Tags:** A view enabling the organization and deletion of existing tags.

To enter form data:

1. Navigate to *Tags > Add Tags* to enter form data.
2. Navigate to *Tags > Manage Tags* to view, update, and delete Tags.

Note: Remember to *Enter Description*, which is a separate popup window.

#### Convert Markdown Files to HTML

Each time you submit a web form a markdown file is created in the following folder *<your_path>/pode_webapp/Public/topics*. You need to periodically convert these markdown files into HTML files. The view function uses the HTML format to display a visually appealing format.



Follow the steps below to convert them:

1. Type *cd <your_path>/pode_webapp/Public/topics*
2. Type *./create_html.sh*

This shell script will convert all of the markdown files to HTML using DITA Open Toolkit.

Below is the contents of the *create_html.sh* file. If necessary, edit *create_html.sh* with your path to the DITA OT executable. 

```
files=`find . -maxdepth 1 -type f -name "*.md"`
for entry in $files
 do
         echo "converting $entry"
          ~/dita-ot-4.4/bin/dita --input=$entry --format=html5 --output=html
 done
```
## References

[Pode Webapp Software Requirements](https://hypot2noose.blogspot.com/2026/06/software-requirements-document-for.html)

[Pode.Web Application](https://hypot2noose.blogspot.com/2026/03/podeweb-application.html)

[PowerShell and Pode.Web on Ubuntu](https://hypot2noose.blogspot.com/2026/03/powershell-and-podeweb-on-ubuntu.html)

[PowerShell and Pode.Web on Ubuntu](https://hypot2noose.blogspot.com/2026/03/powershell-and-podeweb-on-ubuntu.html)

[Pode.Web Tutorial](https://badgerati.github.io/Pode.Web/0.8.3/)

[Pode Tutorial](https://pode.readthedocs.io/en/latest/)

