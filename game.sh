#!/bin/bash

# #############################################################################
# Helper function to draw the borders of draw the borders of game
#
# Expects 4 input elements, as follows
# @Input:
# var 1 is starting x coordinate
# var 2 is starting y coordinate
# var 3 is x length
# var 4 is y length
#
# @return: none
# #############################################################################
drawBorders() {

    xprog=0
    yprog=0

    #print the top and bottom borders with "X"
    while [[ $xprog -le $3 ]]
    do
        xloc=$(( $xprog + $1 ))

        # Move cursor to screen location X, Y (top left is 0,0)
        tput cup $2 $xloc
        echo "X"
        #prints bottom border as well
        yloc=$(( $2 + $4 ))
        tput cup $yloc $xloc
        echo "X"
        xprog=$(( $xprog + 1 ))
    done

    #print the left and right borders with "X"
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


# #############################################################################
# Helper function to get the value at (x,y).
#
# Expects 4 input elements, as follows
# @Input:
# var1 is y coordinate (row)
# var2 is x coordinate (col)
#
# @return: none
# #############################################################################
getVal() {

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

# #############################################################################
# Helper function to put a value at (x,y).
#
# Expects 3 input elements, as follows
# @Input:
# var1 is y coordinate (row)
# var2 is x coordinate (col)
# var3 is new value
#
# @return: none
# #############################################################################
putVal() {

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

# #############################################################################
# Helper function to draw bricks
#
# #############################################################################

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

# Board variable recommendations, can be moved around to a more appropriate position later
# boardX represents the x coord of the center cell of the board, board movement is calculated through this
# boardY represents the y coord of the center cell of the board, this will not change
# boardWidth represents the width on either side of the board ignoring the center cell
# that is, a boardWidth of 2 corresponds to an actual board size of 2 + 1 + 2 = 5
boardWidth=2
boardX=16
boardY=30

#Draw the board's position on the screen
drawBoard() {
    counter=0
    boardLeftX=$(( boardX - $boardWidth ))

    #
    while [[ $counter -lt 5 ]]
    do
        case $counter in
            0) char="<" ;;
            1) char="=" ;;
            2) char="=" ;;
            3) char="=" ;;
            4) char=">"
        esac
        tput cup $boardY $(( $boardLeftX + $counter ))
        echo "$char"
        counter=$(( $counter + 1 ))
    done
}

#Moves the board one character to the left
updateBoardL() {
    boardLeftX=$(( boardX - $boardWidth ))

    tput cup $boardY $(( $boardLeftX ))
    echo "<"

    tput cup $boardY $(( $boardLeftX + 1 ))
    echo "="

    tput cup $boardY $(( $boardLeftX + 4 ))
    echo ">"

    tput cup $boardY $(( $boardLeftX + 5 ))
    echo " "
}

#Moves the board one character to the right
updateBoardR() {
    boardRightX=$(( boardX + $boardWidth ))

    tput cup $boardY $(( $boardRightX))
    echo ">"

    tput cup $boardY $(( $boardRightX - 1 ))
    echo "="

    tput cup $boardY $(( $boardRightX - 4 ))
    echo "<"

    tput cup $boardY $(( $boardRightX - 5 ))
    echo " "
}

#Method stub for ball launchBall
#launchBall() {
#    TODO
#}

#gotta love those magic numbers on the drawBorders function
#the first two are starting coordinates (top left), next two numbers indicate size of border
demoPopulate
drawBorders 1 1 31 31
drawBricks
drawBoard

#put the command prompt below the board (visual cleanup)
tput cup 33 1

#suppress echo (hide all key press output)
stty -echo

#basic control flow
while read -s -n 1 inst
do
    case $inst in
        #Not implemented yet
        #w) launchBall ;;
        a) if [[ ! "$(( $boardX - $boardWidth ))" == 2 ]]
           then
               boardX=$(( boardX - 1 ))
               updateBoardL
           fi ;;
        d) if [[ ! "$(( $boardX + $boardWidth ))" == 31 ]]
           then
               boardX=$(( boardX + 1 ))
               updateBoardR
           fi ;;
       #activatable powerups can be used with s if we add them
       #s) usePowerup
        q) stty echo
           exit 0 ;;
    esac
done
