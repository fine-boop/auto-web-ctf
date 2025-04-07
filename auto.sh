#!/bin/bash
fortune | cowsay -f tux | lolcat
echo .................................................................... | lolcat

echo EzSolve | toilet| lolcat 
echo automatic ctf enumerator uses multiple tools i did not write | lolcat
echo -e "\e[1;34mautomatic ctf enumerator uses multiple tools i did not write\e[0m"

echo ....................................................................  | lolcat
echo -n -e "\e[1;33mEnter your target url =>\e[0m "
read url
echo targeting $url
pwd=pwd
echo -e "\e[1;97mFinding basic info...\e[0m"

timeout 10s ping $url | tee -a ~/tools/auto/output.txt
dig $url | tee ~/tools/auto/output.txt
whois $url |  tee -a ~/tools/auto/output.txt
curl -i $url | tee -a ~/tools/auto/output.txt
echo scanning for ports..
nmap -sV -Pn url | tee  -a ~/tools/auto/output.txt

echo -e "\e[1;33mgrabbing cookies... \e[0m"
curl -c cookies.txt http://$url >> cookies.txt

grep flag cookies.txt
grep  cookies.txt
grep admin cookies.txt

echo -e "\e[1;33mchecking for robots.txt... \e[0m"
response=$(curl -I -s $url/robots.txt | grep "HTTP/")
if echo "$response" | grep -q "200"; then
    echo -e "\e[1;32mFound robots.txt at $url/robots.txt\e[0m"   
    echo "Robots.txt found at $url" >> ~/tools/auto/output.txt
else
    echo -e "\e[1;31mNo robots.txt found at $url/robots.txt\e[0m" 
    echo "No Robots.txt found at $url" >> ~/tools/auto/output.txt
fi

echo -e "\e[1;97mSearching for terms in source \e[0m"
timeout 20s curl -v $url | grep -e "Zero" -e "pass" -e "zero" -e "flag" -e "clue" -e "secret" -e "challenge" -e "message" -e "hint" -e "admin" | tee -a output.txt

echo -e "\e[1;97mscanning for sql vulnerabilites...\e[0m"

sqlmap -u $url --batch  |  tee  -a ~/tools/auto/output.txt


echo -e "\e[1;97mscanning for admin panels...\e[0m"
gobuster fuzz -u http://$url/ -w /usr/share/wordlists/wfuzz/general/admin-panels.txt | tee -a ~/tools/auto/output.txt
 

echo -e "\e[1;97mscanning for hidden directories...\e[0m"
gobuster dir -u http://$url/FUZZ/ -w ~/lists/list.txt -t 50  | tee -a ~/tools/auto/output.txt

echo -e "\e[1;97mscanning for subdomains \e[0m"
python3 ~/tools/Sublist3r/sublist3r.py -d $url | tee -a ~/tools/auto/output.txt


echo -e "\e[1;97mscanning for xss\e[0m"
python3 ~/tools/XSStrike-master/xsstrike.py -u  $url  | tee -a ~/tools/auto/output.txt

echo -e "\n \n \n \n \n"
echo -e "\e[1;32mScan complete!\e[0m"
echo -e "\e[1;32mOutput saved to: $pwd/output.txt \e[0m"
