#!/bin/bash

#draw the borders
drawBorders() {
#var 1 is starting x coordinate
#var 2 is starting y coordinate
#var 3 is x length
#var 4 is y length
xprog=0
yprog=0
#while [ $xprog -lt 10 ]
#do 
tput cup $xprog $2
echo "X"
xprog='expr $xprog+1'
#done

}

drawBorders 10 10 10
