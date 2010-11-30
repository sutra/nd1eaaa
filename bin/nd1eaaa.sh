#! /bin/bash
PATH=./bin
urls=("http://www.ssh2proxy.com/" "http://blog.paying.org.ru/")
users=("ssh2proxy.com" "paying.org.ru")
hosts=("173.0.51.222" "196.46.191.163")

connect() {
	url=$1
	user=$2
	host=$3
	lport=7070
	pw=$( curl -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//' )

	for (( i=1 ; i<=10 ; i++ )); do
		if echo "$pw" | grep '服务器人数过多，请稍候再来'; then
			sleep 60
			pw=$(curl -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//')
			[ $i -gt 9 ] && {
				echo "已經嘗試連接十次.請稍後再試." ;
				exit 5
			}
		else
			break
		fi
	done

	plink "$host" -N -ssh -2 -P 22 -l "$user" -pw "$pw" -D $lport -v
}

for (( i = 0; i < ${#urls[@]}; i++ )); do
	connect ${urls[$i]} ${users[$i]} ${hosts[$i]}
done


