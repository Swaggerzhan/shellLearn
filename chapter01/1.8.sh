#!/bin/bash

array[1]=test1
array[2]=test2

echo ${array[0]}
echo ${array[1]}
echo ${array[2]}

echo "---------"
echo "len: " ${#array[*]}
echo ${array[*]}