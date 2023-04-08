#!/bin/bash

siteTitle="Old MacDonalds Egg Expository" #Name of the site
url="https://example.com"
license="© Old MacDonald 2022-$(date +%y)" #License Information
email="example@example.com"

baseDir=$(pwd) #The directory the script operates in.
fileDir="$baseDir/files" #The directory for static files.
outputDir="$baseDir/output" #Where the site is generated.
articleDir="articles" #Where blog posts are stored.

function extractData {
	#This function extracts keyvalue-pairs from the top of posts
	#$1 is for the file
	#$2 is for the key
    lowdown -X $1 $2
}

echo "🥚Generating Site"
rm -r "${outputDir:?}"/* #Clean the output

cp -r "$baseDir/$articleDir" "$outputDir/$articleDir" #Copy posts to output
cp -r $fileDir/* $outputDir #Copy files to output

source templates.sh # Get the templates

# This is for indexing the posts for the templates
posts=($( for post in $outputDir/$articleDir/**/index.md ; do
        date=$(extractData date "$post") ;
        echo "$date:$post" ;
        done | sort -rg ))

for file in $outputDir/$articleDir/**/index.md ; do
	# These variables will be inserted into the template
	title=$(extractData "title" $file)
	date=$(extractData "date" $file)
        article=$(lowdown $file;)
	author=$(extractData "author" $file)
	# Write the template with the new variables to the right place
        blogTemplateHtml > ${file%.*}.html;
done

# Write the index to output.
pageTemplateHtml indexTemplateHtml > $outputDir/index.html
# Write the rss feed to output.
rssTemplateHtml > $outputDir/index.xml
# Write the articles index to output/
pageTemplateHtml articleIndexTemplateHtml > $outputDir/articles/index.html
echo "🐣 Site Generation Complete"
