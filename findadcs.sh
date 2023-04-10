#!/bin/bash
echo "";
echo "";
echo " █████╗ ██████╗  ██████╗███████╗                                                                                           ";
echo "██╔══██╗██╔══██╗██╔════╝██╔════╝                                                                                           ";
echo "███████║██║  ██║██║     ███████╗                                                                                           ";
echo "██╔══██║██║  ██║██║     ╚════██║                                                                                           ";
echo "██║  ██║██████╔╝╚██████╗███████║                                                                                           ";
echo "╚═╝  ╚═╝╚═════╝  ╚═════╝╚══════╝                                                                                           ";
echo "██╗    ██╗███████╗██████╗     ███████╗███╗   ██╗██████╗  ██████╗ ██╗     ██╗     ███╗   ███╗███████╗███╗   ██╗████████╗    ";
echo "██║    ██║██╔════╝██╔══██╗    ██╔════╝████╗  ██║██╔══██╗██╔═══██╗██║     ██║     ████╗ ████║██╔════╝████╗  ██║╚══██╔══╝    ";
echo "██║ █╗ ██║█████╗  ██████╔╝    █████╗  ██╔██╗ ██║██████╔╝██║   ██║██║     ██║     ██╔████╔██║█████╗  ██╔██╗ ██║   ██║       ";
echo "██║███╗██║██╔══╝  ██╔══██╗    ██╔══╝  ██║╚██╗██║██╔══██╗██║   ██║██║     ██║     ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║       ";
echo "╚███╔███╔╝███████╗██████╔╝    ███████╗██║ ╚████║██║  ██║╚██████╔╝███████╗███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║       ";
echo " ╚══╝╚══╝ ╚══════╝╚═════╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝       ";
echo "███████╗██╗███╗   ██╗██████╗ ███████╗██████╗                                                                               ";
echo "██╔════╝██║████╗  ██║██╔══██╗██╔════╝██╔══██╗                                                                              ";
echo "█████╗  ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝                                                                              ";
echo "██╔══╝  ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗                                                                              ";
echo "██║     ██║██║ ╚████║██████╔╝███████╗██║  ██║                                                                              ";
echo "╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝                                                                              ";
echo "                                                                                                                           ";
echo "";

VALID_ONLY=false

while getopts "i:r:f:d:v" opt; do
    case $opt in
        i)
            ip=$OPTARG
            ;;
        r)
            range=$OPTARG
            ;;
        f)
            file=$OPTARG
            ;;
        d)
            domain=$OPTARG
            ;;
        v)
            VALID_ONLY=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [[ -z $domain ]]; then
    echo "Please specify the domain with -d option." >&2
    exit 1
fi

while read ip; do
    if curl -sSLkI -u "${domain}\\'':''" --ntlm --max-time 2 "http://$ip/certsrv/certfnsh.asp" 2>/dev/null | grep -q -e 401 -e 200 ; then
        if $VALID_ONLY; then
            echo -e "\e[36m[+] $ip - http://$ip/certsrv/certfnsh.asp\e[0m"

        else
            echo -e "\e[36m[+] $ip - http://$ip/certsrv/certfnsh.asp\e[0m"

        fi
    elif ! $VALID_ONLY; then 
        echo "[-] $ip" 
    fi
done < <(if [[ -n $ip ]]; then echo "$ip"; elif [[ -n $range ]]; then nmap -n -sn "$range" -oG - | awk '/Up$/{print $2}'; elif [[ -n $file ]]; then cat "$file" | xargs -I {} sh -c "nmap -n -sn {} -oG - | awk '/Up$/{print \$2}' | uniq"; fi)
