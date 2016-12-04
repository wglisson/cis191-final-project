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
    while [[ $xprog -le $3 ]]
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
        yloc=$(( $2 + $4 ))
        tput cup $yloc $xloc
        echo "X"
        xprog=$(( $xprog + 1 ))
    done
}

#data structures!
#can be created more efficiently but I don't feel like doing that now
row1=(0 0 0 0 0 0 0 0 0 0)
row2=(0 0 0 0 0 0 0 0 0 0)
row3=(0 0 0 0 0 0 0 0 0 0)
row4=(0 0 0 0 0 0 0 0 0 0)
row5=(0 0 0 0 0 0 0 0 0 0)
row6=(0 0 0 0 0 0 0 0 0 0)
row7=(0 0 0 0 0 0 0 0 0 0)
row8=(0 0 0 0 0 0 0 0 0 0)
row9=(0 0 0 0 0 0 0 0 0 0)
row10=(0 0 0 0 0 0 0 0 0 0)
row11=(0 0 0 0 0 0 0 0 0 0)
row12=(0 0 0 0 0 0 0 0 0 0)
row13=(0 0 0 0 0 0 0 0 0 0)
row14=(0 0 0 0 0 0 0 0 0 0)
row15=(0 0 0 0 0 0 0 0 0 0)

getVal() {
    #var1 is y coordinate (row)
    #var2 is x coordinate (col)
    case $1 in
        1) echo "${row1[$2]}" ;;
        2) echo "${row2[$2]}" ;;
        3) echo "${row3[$2]}" ;;
        4) echo "${row4[$2]}" ;;
        5) echo "${row5[$2]}" ;;
        6) echo "${row6[$2]}" ;;
        7) echo "${row7[$2]}" ;;
        8) echo "${row8[$2]}" ;;
        9) echo "${row9[$2]}" ;;
        10) echo "${row10[$2]}" ;;
        11) echo "${row11[$2]}" ;;
        12) echo "${row12[$2]}" ;;
        13) echo "${row13[$2]}" ;;
        14) echo "${row14[$2]}" ;;
        15) echo "${row15[$2]}" ;;
    esac
}

putVal() {
    #var1 is y coordinate (row)
    #var2 is x coordinate (col)
    #var3 is new value
    case $1 in
        1) row1[$2]=$3 ;;
        2) row2[$2]=$3 ;;
        3) row3[$2]=$3 ;;
        4) row4[$2]=$3 ;;
        5) row5[$2]=$3 ;;
        6) row6[$2]=$3 ;;
        7) row7[$2]=$3 ;;
        8) row8[$2]=$3 ;;
        9) row9[$2]=$3 ;;
        10) row10[$2]=$3 ;;
        11) row11[$2]=$3 ;;
        12) row12[$2]=$3 ;;
        13) row13[$2]=$3 ;;
        14) row14[$2]=$3 ;;
        15) row15[$2]=$3 ;;
    esac
}

#fuck comments, it works
drawBricks() {
    row=1
    rowOffset=2
    while [[ $row -le 15 ]]
    do
        col=0
        colOffset=2
        while [[ $col -lt 10 ]]
        do
            brick="[$(getVal $row $col)]"
            if [[ ! "$brick" == "[0]" ]]
            then
                tput cup $rowOffset $colOffset
                echo "$brick"
            fi
            col=$(( $col + 1 ))
            colOffset=$(( $colOffset + 3 ))
        done
        row=$(( $row + 1))
        rowOffset=$(( $rowOffset + 1 ))
    done 
}

# adds a diagonal line of [5] bricks - just POC that if we can load 
# level data into arrays, it will get drawn correctly
demoPopulate() {
    val=0
    while [[ $val -lt 10 ]]
    do
        valOffset=$(( $val + 1 ))
        putVal "$valOffset" "$val" 5
        echo "$(getVal valOffset val)"
        val=$(( $val + 1))
    done
}

#gotta love those magic numbers on the drawBorders function
demoPopulate
drawBorders 1 1 31 31
drawBricks