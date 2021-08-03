#!/bin/bash

function f1()
{
    echo "this is f1"
    echo "arg1: " $1
    echo "arg2: " $2
    echo $@
}

f1 "first" "second"