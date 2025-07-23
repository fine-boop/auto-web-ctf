#!/bin/bash

fortune | cowsay -f tux | lolcat



setup(){
    cd ~
    mkdir ezsolve
    cd ezsolve
    echo creating python3 venv to run tools without disrupting existing venvs
    python -m venv ezsolveenv
    source ~/ezsolve/ezsolveenv/bin/activate
    echo installing tools with apt
    sudo apt install sqlmap nmap whois curl gobuster -y
    mkdir tools
    cd tools
    echo installing sublist3r, xsstrike and ffuf
    wget https://github.com/aboul3la/Sublist3r/archive/refs/heads/master.zip
    unzip master.zip
    rm master.zip
    cd Sublist3r-master
    pip install -r requirements.txt
    cd ..
    wget https://github.com/s0md3v/XSStrike/archive/refs/heads/master.zip
    unzip master.zip
    rm master.zip
    cd XSStrike-master
    pip install -r requirements.txt
    echo installing styling tools
    sudo apt install cowsay toilet lolcat -y


}


attack(){
    

    echo .................................................................... | lolcat

    echo EzSolve | toilet| lolcat 
    echo automatic ctf enumerator uses multiple tools i did not write | lolcat
    echo -e "\e[1;34mautomatic ctf enumerator uses multiple tools i did not write\e[0m"

    echo ....................................................................  | lolcat

    echo -n -e "\e[1;33mEnter your target url =>\e[0m "
    read url
    read format
    echo targeting $url
    echo confirment format is $format
    pwd = pwd=$(pwd)

    echo -e "\e[1;97mFinding basic info...\e[0m"

    timeout 10s ping $url | tee -a ~/ezsolve/output.txt
    dig $url | tee ~/ezsolve/output.txt
    whois $url |  tee -a ~/ezsolve/output.txt
    curl -i $url | tee -a ~/ezsolve/output.txt
    echo scanning for ports..
    nmap -sV -Pn url | tee  -a ~/ezsolve/output.txt

    echo -e "\e[1;33mgrabbing cookies... \e[0m"
    curl -c cookies.txt http://$url >> cookies.txt

    grep flag cookies.txt
    grep secret cookies.txt
    grep admin cookies.txt
    grep $format cookies.txt

    echo -e "\e[1;33mchecking for robots.txt... \e[0m"
    response=$(curl -I -s $url/robots.txt | grep "HTTP/")
    if echo "$response" | grep -q "200"; then
        echo -e "\e[1;32mFound robots.txt at $url/robots.txt\e[0m"   
        echo "Robots.txt found at $url" >> ~/ezsolve/output.txt
    else
        echo -e "\e[1;31mNo robots.txt found at $url/robots.txt\e[0m" 
        echo "No Robots.txt found at $url" >> ~/ezsolve/output.txt
    fi

    echo -e "\e[1;97mSearching for terms in source \e[0m"
    timeout 20s curl -v $url | grep -e "pass"  -e "flag" -e "clue" -e "secret" -e "challenge" -e "message" -e "hint" -e "admin" -e $format | tee -a output.txt

    echo -e "\e[1;97mscanning for sql vulnerabilites...\e[0m"

    sqlmap -u $url --batch  |  tee  -a ~/ezsolve/output.txt


    echo -e "\e[1;97mscanning for admin panels...\e[0m"
    gobuster fuzz -u http://$url/ -w /usr/share/wordlists/wfuzz/general/admin-panels.txt | tee -a ~/ezsolve/output.txt
    

    echo -e "\e[1;97mscanning for hidden directories...\e[0m"
    gobuster dir -u http://$url/FUZZ/ -w ~/ezsolve/lists/list.txt -t 50  | tee -a ~/ezsolve/output.txt

    echo -e "\e[1;97mscanning for subdomains \e[0m"
    python3 ~/ezsolve/tools/Sublist3r/sublist3r.py -d $url | tee -a ~/ezsolve/output.txt


    echo -e "\e[1;97mscanning for xss\e[0m"
    python3 ~/ezsolve/tools/XSStrike-master/xsstrike.py -u  $url  | tee -a ~/ezsolve/output.txt

    echo -e "\n \n \n \n \n"
    echo -e "\e[1;32mScan complete!\e[0m"
    echo -e "\e[1;32mOutput saved to: $pwd/output.txt \e[0m"
}





read -p "enter setup? [y/n] " choice

if [ "$choice" == "y" ]; then
    setup
elif [ "$choice" == "n" ]; then
    attack
else
    echo "Invalid input."
fi
