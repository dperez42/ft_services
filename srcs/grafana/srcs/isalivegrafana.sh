#!/bin/ash
ps > live.tmp
cat live.tmp | grep "grafana-server" > live2.tmp
return=$(cat live2.tmp | wc -l)
if [ $return = 1 ]
then
    exit 0
else
    exit 1
fi
