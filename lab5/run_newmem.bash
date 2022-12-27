#!/bin/bash7
N=2700000

for (( K = 0; K < 30; K++ ))
do
  bash newmem.bash $N &
  echo k=$K, pid=$!
  sleep 1
done
