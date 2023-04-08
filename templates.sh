#!/bin/bash

function blogTemplateHtml {
cat << EOF
<!DOCTYPE html>
<html lang="en-us">
<head>
<title>$title</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<meta name="author" content="$siteTitle">
<link rel="icon" href="/favicon.ico" type="image/x-icon">
<link rel="alternate" type="application/rss+xml" title="$siteTitle RSS" href="/index.xml">
<style>
$(cat "$outputDir/style.css")
</style>
</head>
<body>
<header><h1>$title</h1></header>
<p>By <a href="/">$author</a> on $(date -d $date "+%b %d, %Y").</p>
<article>
$article
<div id="left">
<a id="left" href="mailto:$email?subject=RE:$title">📬 Reply to this Post via e-mail.</a> 
</div>
<div id="right">
<a id="right" href="/$articleDir">📄 Find More Articles</a>
</div>
<br> 
</article>
<footer>
<hr>
© $siteTitle $(date -d $date +%Y)
</footer>
</body>
EOF
}
function indexTemplateHtml {
home="true"
title="$siteTitle"
content="$(cat << EOF
<div>
Welcome to my site. You will find essays about eggs and poultry. Eggs are a wonderful food item which is what inspired me to write this blog. I would love for you to send me comments about eggs to this <a href="mailto:$email?subject=RE:Comment for $siteTitle">email.</a> Thank you, end enjoy reading!
</p>
</div>
<ul>
EOF

post="${posts[0]}"
file="${post#*:}"
    title="$(extractData title "$file")"
    file="${file##*/output/}"
    file="${file%index.md}"
cat << EOF
<li><a href="$file"><strong style="color:red;">Featured: </strong>$title</a></li>

<li><a href="/articles">Find More Articles</a></li>

</ul>
EOF
)"
}

function articleIndexTemplateHtml {
content="$(
cat << EOF
<ul>
EOF
for post in "${posts[@]}" ; do
    date="$(date -d ${post%%:*} "+%b %d, %Y")"
    file="${post#*:}"
    summary="$(head $file)"
    title="$(extractData title "$file")"
    file="${file##*/$articleDir/}"
    file="${file%index.md}"

cat << EOF
<li><a href="$file">$title</a></li>
EOF
done
cat << EOF
</ul>
EOF
)"
title='Articles'
home="false"
}

function pageTemplateHtml {
# Variable that will be passed that contains the specific page data to fill
# the template.
$1
cat << EOF
<!DOCTYPE html>
<head>
<title>$title</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="/favicon.ico" type="image/x-icon">
<html lang="en">
<style>
$(cat "$outputDir/style.css")
</style>
</head>
<body>
<header><h1>$title</h1></header>
EOF

if [ $home = 'false' ]; then
	homelink="<p><a href="/">🏠 Go Home</a></p>"
fi

cat << EOF
$homelink
<main>
<article>
$content
</article>
</section>
</body>
</main>

<footer>
<hr>
$license
&emsp;<a href="/index.xml"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-rss-fill" viewBox="0 0 16 16"><path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm1.5 2.5c5.523 0 10 4.477 10 10a1 1 0 1 1-2 0 8 8 0 0 0-8-8 1 1 0 0 1 0-2zm0 4a6 6 0 0 1 6 6 1 1 0 1 1-2 0 4 4 0 0 0-4-4 1 1 0 0 1 0-2zm.5 7a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z"></path>
	  </svg> RSS Feed</a>
	  	 	
<div>
		<a href="https://heaventree.xyz/prev">⟵</a>
		<a href="https://heaventree.xyz">Christian Webring</a>
		<a href="https://heaventree.xyz/next">⟶</a><br>
		</span>
</div>
		
</footer>
</body>
</html>
EOF
}
function rssTemplateHtml {

buildDate="$(date -R)"

cat << EOF
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
<title>$siteTitle</title>
<link>$url</link>
<description>
Updates for $siteTitle.
</description>
<generator>CUSTOM BASH SCRIPT 3000 by yours truly.</generator>
<language>en-us</language>
<lastBuildDate>$buildDate</lastBuildDate>
<atom:link href="$url/index.xml" rel="self" type="application/rss+xml"/>
EOF

# removed posts variable, now found in main file

for post in "${posts[@]}" ; do
    
    file="${post#*:}"
    rssDate=$(date -Rd ${post%%:*})
    title="$(extractData title "$file")"
    date="$(extractData date "$file")"
    article="$(lowdown "$file")"
    file="${file##*/output/}"
    file="${file%index.md}"
    link="$url/articles/$file"
cat << EOF
<item>
<title>$title</title>
<link>$link</link>
<pubDate>$rssDate</pubDate>
<guid>$link</guid>
<description>
$article
</description>
</item>
EOF
done
cat << EOF
</channel>
</rss>
EOF
}
