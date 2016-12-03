#!/bin/bash

#draw the borders
drawBorders() {
#var 1 is starting x coordinate
#var 2 is starting y coordinate
#var 3 is x length
#var 4 is y length
xprog=0
yprog=0

#print the top and bottom borders
while [[ $xprog -lt $3 ]]
do 
xloc=$(( $xprog + $1 ))
tput cup $2 $xloc
echo "X"
#prints bottom border as well
yloc=$(( $2 + $4 ))
tput cup $yloc $xloc
echo "X"
xprog=$(( $xprog + 1 ))
done

#print the left and right borders
while [[ $yprog -lt $4 ]]
do
yloc=$(( $yprog + $2 ))
tput cup $yloc $1
echo "X"
xloc=$(( $1 + $3 ))
tput cup $yloc $xloc
echo "X"
yprog=$(( $yprog + 1 ))
done

xprog=0
while [[ $xprog -lt $3 ]]
do
xloc=$(( $xprog + $1 ))
yloc = $(( $2 + $4 ))
tput cup $yloc $xloc
echo "X"
xprog=$(( $xprog + 1 ))
done
}

drawBorders 1 1 30 30 
