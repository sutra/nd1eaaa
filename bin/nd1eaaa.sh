#! /bin/bash
PATH=./bin
url="http://www.ssh2proxy.com/"
user="ssh2proxy.com"
host=173.0.51.222
lport=7070
pw=$( curl -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//' )

  for (( i=1 ; i<=10 ; i++ ))
      do
          if echo "$pw" | grep '服务器人数过多，请稍候再来'
              then
                 sleep 60
                 pw=$(curl -s "$url" | sed '/服务器密码/!d;s/^.*value="//;s/".*$//')
                 [ $i -gt 9 ] && { echo "已經嘗試連接十次.請稍後再試." ;
                                  exit 5
                 }
              else
                  break
          fi
      done

plink "$host" -N -ssh -2 -P 22 -l "$user" -pw "$pw" -D $lport -v
