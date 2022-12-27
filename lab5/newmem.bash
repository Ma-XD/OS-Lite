#!/bin/bash

if [ $# != 1 ]
then
exit 1
fi

N=$1
cnt=0
arr=()

while true
do
  if [[ ${#arr[*]} -gt $N ]] 
  then
    echo STOP
    exit 0
  fi

  size=${#arr[*]}
  for (( i = 0; i < 10; i++ ))
  do
    arr[$(($size + $i))]=$(($i + 1))
  done
  cnt=$((cnt + 1))
done
