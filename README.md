# ezsolve
Automate the beginning checks of any web ctf challenge 

Now this isnt an overly complicated tool, it is intended purley for timesaving purposes. Currently for it to work you must have these tools installed
- Sublist3r
- gobuster
- nmap
- xsstrike
- sqlmap

As well as some wordlists I will put up later. 

Currently, what this shell script does it, scan the target with nmap, ping, dig and whois for intel. 

Next it saves cookies to a file and checks for strings (these can be changed). It checks for a robots.txt file, and downloads and parses the source code for strings of intrest. 

It uses sqlmap to check for sql vulnerabilites, gobuster for hidden directories and admin files, sublist3r to check for hidden subdomains, xsstrike for xss attacks and finally saves the output of them all in the file output.txt in the current directory.

# New update - Added automatic setup

Now the tool will create a new directory, copy itslef into the new directory and download all the extra tools it needs to run. 

