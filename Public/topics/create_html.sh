files=`find . -maxdepth 1 -type f -name "*.md"`
for entry in $files
 do
	 echo "converting $entry"
	  ~/dita-ot-4.4/bin/dita --input=$entry --format=html5 --output=html
 done
