#!/bin/bash
clear
echo -e "Instagram Check Email Exist\nAuthor : Muhamad Faiz Azhar"
echo -e "============================="
read -p "Your List : " lst
if [[ ! -f $(eval find $lst) ]]; then
	exit 1
fi
checker(){
	em=$1
	csrf=$(curl -sI https://www.instagram.com/accounts/emailsignup/ | ggrep -Po '(?<=\mid=)(.*?)(?=\;)')
	check=$(curl -s "https://www.instagram.com/accounts/web_create_ajax/attempt/" -d "email=$em&username=&first_name=&opt_into_one_tap=false" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36" -H "X-Csrftoken: $csrf" | jq -r '.errors.email[].message' 2>/dev/null)
	if [[ -z $check ]]; then
		echo -e "$em => Not Exist!"
	else
		echo -e "$em => $check"
		echo "$em" >> email-exist.txt
	fi
}
echo -e "============================="
export -f checker
eval cat $lst | xargs -P 2 -n1 bash -c 'checker "$@"' _
echo -e "============================="
echo -e "Saved to : email-exist.txt"
echo -e "============================="