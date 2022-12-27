#!/bin/bash

cnt=0
arr=()
echo > $PWD/report2.log

while true
do
  shift=$(($cnt % 100000))
  if [[ $shift -eq 0 ]]
  then
    echo ${#arr[*]} >> $PWD/report2.log
  fi

  size=${#arr[*]}
  for (( i = 0; i < 10; i++ ))
  do
    arr[$(($size + $i))]=$(($i + 1))
  done
  cnt=$((cnt + 1))
done

