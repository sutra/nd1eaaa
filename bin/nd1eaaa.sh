#! /bin/bash
PATH=${PATH}:./bin
urls=("http://free.ssh2proxy.com/" "http://blog.paying.org.ru/")
users=("ssh2proxy.com" "paying.org.ru")
hosts=("173.0.51.222" "196.46.191.163")
lport=7070

echo '尝试获得登录帐号……'
for (( t = 1; t <= 10; t++ )); do
	echo "第${t}次尝试……"
	for (( i = 0; i < ${#urls[@]}; i++ )); do
		url=${urls[$i]}
		user=${users[$i]}
		host=${hosts[$i]}

		echo "正在从 ${url} 获取密码信息……"

		pw=$( curl -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//' )

		if [ -z "$pw" ]; then
			echo "从 ${url} 获取密码页面失败"
			continue
		elif echo "$pw" | grep '服务器人数过多，请稍候再来'; then
			continue
		else
			echo "获得帐号成功：${host}, ${user}, ${pw}"
			break 2
		fi
	done

	sleep 60
	[ $t -gt 9 ] && {
		echo "已經嘗試連接十次.請稍後再試." ;
		exit 5
	}
done

echo "建立隧道到：${host}……"
plink "$host" -N -ssh -2 -P 22 -l "$user" -pw "$pw" -D $lport -v
