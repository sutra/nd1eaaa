#! /bin/bash
PATH=${PATH}:./bin
urls=("http://free.ssh2proxy.com/" "http://blog.paying.org.ru/")
users=("ssh2proxy.com" "paying.org.ru")
hosts=("173.0.51.222" "196.46.191.163")
lport=7070

echo y | plink -v -C -N -ssh -2 -P 22 -l waimao -pw waimao -D 7069 178.33.86.197 &
echo "Sleeping 10 seconds..."
sleep 10

echo 'Try to get an SSH account...'
for (( t = 1; t <= 10; t++ )); do
	echo "Try ${t} time(s)..."
	for (( i = 0; i < ${#urls[@]}; i++ )); do
		url=${urls[$i]}
		user=${users[$i]}
		host=${hosts[$i]}

		echo "Obtaing SSH password from ${url} ..."

		pw=$( curl --socks5-hostname localhost:7069 --connect-timeout 10 -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//' )

		if [ -z "$pw" ]; then
			echo "Obtain SSH password from ${url} failed."
			continue
		elif echo "$pw" | grep '服务器人数过多，请稍候再来'; then
			continue
		else
			echo "Got the SSH account: ${host}, ${user}, ${pw}"
			break 2
		fi
	done

	sleep 60
	[ $t -gt 9 ] && {
		echo "Tried 10 times, please try again later." ;
		exit 5
	}
done

echo "Tunneling to${host} ..."
echo y | plink -v -C -N -ssh -2 -P 22 -l "$user" -pw "$pw" -D $lport "$host"
