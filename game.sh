#!/bin/bash


#Helper function draws the score in the instance of the game
#Expects 2 input elements, as follows
#@Inputs:
#var 1 is starting x coordinate
#var 2 is starting y coordinate
#score is the current score, initially 0, but changes throughout the game
score=0
scoreX=40
scoreY=10

drawScore() {
tput cup $2 $1
echo "score: " $score
}
#an example usage, to show it works, use scoreX and scoreY for later calls
drawScore $scoreX $scoreY


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
        echo -n "X"
        #prints bottom border as well
        yloc=$(( $2 + $4 ))
        tput cup $yloc $xloc
        echo -n "X"
        xprog=$(( $xprog + 1 ))
    done

    #print the left and right borders with "X"
    while [[ $yprog -lt $4 ]]
    do
        yloc=$(( $yprog + $2 ))
        tput cup $yloc $1
        echo -n "X"
        xloc=$(( $1 + $3 ))
        tput cup $yloc $xloc
        echo -n "X"
        yprog=$(( $yprog + 1 ))
    done

    xprog=0
    while [[ $xprog -lt $3 ]]
    do
        xloc=$(( $xprog + $1 ))
        yloc=$(( $2 + $4 ))
        tput cup $yloc $xloc
        echo -n "X"
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
        1) echo -n "${row1[$2]}" ;;
        2) echo -n "${row2[$2]}" ;;
        3) echo -n "${row3[$2]}" ;;
        4) echo -n "${row4[$2]}" ;;
        5) echo -n "${row5[$2]}" ;;
        6) echo -n "${row6[$2]}" ;;
        7) echo -n "${row7[$2]}" ;;
        8) echo -n "${row8[$2]}" ;;
        9) echo -n "${row9[$2]}" ;;
        10) echo -n "${row10[$2]}" ;;
        11) echo -n "${row11[$2]}" ;;
        12) echo -n "${row12[$2]}" ;;
        13) echo -n "${row13[$2]}" ;;
        14) echo -n "${row14[$2]}" ;;
        15) echo -n "${row15[$2]}" ;;
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
            brick=" $(getVal $row $col) "
            if [[ ! "$brick" == " 0 " ]]
            then
                tput cup $rowOffset $colOffset
                echo -n "$brick"
            fi
            col=$(( $col + 1 ))
            colOffset=$(( $colOffset + 3 ))
        done
        row=$(( $row + 1))
        rowOffset=$(( $rowOffset + 1 ))
    done
}

#1 row
#2 col
updateBrick() {
    rowOffset=$(( $1 + 1 ))
    colOffset=$(( $2 * 3 ))
    colOffset=$(( $colOffset + 2 ))
    brick=" $(getVal $1 $2) "
    if [[ ! "$brick" == " 0 " ]]
    then
        tput cup $rowOffset $colOffset
        echo -n "$brick"
    else
        tput cup $rowOffset $colOffset
        echo -n "   "   
    fi
}

# loads data into arrays that will then be drawn to
# add a diagonal line of [5] bricks - just POC that if we can load
# level data into arrays, it will get drawn correctly
demoPopulate() {
    val=0
    while [[ $val -lt 10 ]]
    do
        valOffset=$(( $val + 1 ))
        putVal "$valOffset" "$val" 2
        echo -n "$(getVal valOffset val)"
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
        echo -n "$char"
        counter=$(( $counter + 1 ))
    done
}

#Moves the board one character to the left
updateBoardL() {
    boardLeftX=$(( boardX - $boardWidth ))

    tput cup $boardY $(( $boardLeftX ))
    echo -n "<"

    tput cup $boardY $(( $boardLeftX + 1 ))
    echo -n "="

    tput cup $boardY $(( $boardLeftX + 4 ))
    echo -n ">"

    tput cup $boardY $(( $boardLeftX + 5 ))
    echo -n " "
}

#Moves the board one character to the right
updateBoardR() {
    boardRightX=$(( boardX + $boardWidth ))

    tput cup $boardY $(( $boardRightX))
    echo -n ">"

    tput cup $boardY $(( $boardRightX - 1 ))
    echo -n "="

    tput cup $boardY $(( $boardRightX - 4 ))
    echo -n "<"

    tput cup $boardY $(( $boardRightX - 5 ))
    echo -n " "
}

#ballX is x coordinate of ball
#ballY is y coordinate of ball
#ballSpeedX is movement of ball in x direction
#ballSpeedY is movement of ball in y direction
ballX=17
ballY=28
ballNextX=0
ballNextY=0
ballSpeedX=0
ballSpeedY=0


#gives details for game board
topLeftX=1
topLeftY=1
gameWidth=31
gameHeight=31
gameRight=$(( topLeftX + gameWidth -1 ))
gameTop=$(( topLeftY + 1 ))
gameLeft=$(( topLeftX + 1 ))
gameBottom=$(( topLeftY + gameHeight -1 ))

#Method stub for ball launchBall
launchBall() {
	tput cup $ballY $ballX
	echo -n "O"
	ballSpeedX=1
	ballSpeedY=1
}

#updates the ball's position
moveBall() {
    oldBallX=$ballX
    oldBallY=$ballY
    checkBoundaryCollision
	ballNextX=$(( ballX + ballSpeedX ))
	ballNextY=$(( ballY - ballSpeedY ))
    checkBlockCollision
    ballX=$(( ballX + ballSpeedX ))
	ballY=$(( ballY - ballSpeedY ))
    tput cup $oldBallY $oldBallX
	echo -n " "
	tput cup $ballY $ballX
	echo -n "O"
}

checkBoundaryCollision() {
	#check for collisions with the game's boundaries
	if [[ $ballX -eq $gameRight ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballY -eq $gameTop ]]
	then
		ballSpeedY=$(( -1 * ballSpeedY ))
	fi
	if [[ $ballX -eq $gameLeft ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballY -eq $gameBottom ]]
	then
		ballSpeedY=$(( -1 * ballSpeedY ))
	fi
}

checkBlockCollision() {
    blockYIndex=$(( $ballNextY - 1 ))
    if [[ "$blockYIndex" -le 15 ]]
    then
        blockCheckX=$(( $ballNextX + 1 ))
        blockCheckL=$ballNextX
        blockCheckR=$(( $ballNextX + 2 ))
        blockCheckX=$(( $blockCheckX / 3 ))
        blockCheckL=$(( $blockCheckL / 3 ))
        blockCheckR=$(( $blockCheckR / 3 ))
        blockXIndex=$(( $blockCheckX - 1 ))
        if [[ $blockCheckL -eq $blockCheckX ]]
        then
            if [[ $blockCheckR -eq $blockCheckX ]]
            then
                blockVal="$(getVal $blockYIndex $blockXIndex)"
                if [[ $blockVal -ne 0 ]]
                then
                    blockVal=$(( $blockVal - 1 ))
                    putVal "$blockYIndex" "$blockXIndex" "$blockVal"
                    updateBrick "$blockYIndex" "$blockXIndex"
                    #ballX=$(( ballX - 2 ))
                    #ballY=$(( ballY - 1 ))
                    ballSpeedY=$(( -1 * ballSpeedY ))
                fi
            fi
        fi
    fi
}

ballLaunched=0

#clear the terminal on starting
clear

#suppress echo (hide all key press output)
stty -echo

#hide the cursor
tput civis

demoPopulate
drawBorders $topLeftX $topLeftY $gameWidth $gameHeight
drawBricks
drawBoard

#basic control flow
while read -s -n 1 inst
do
	moveBall
    case $inst in
        w) if [[ "$ballLaunched" == "0" ]]
           then
               launchBall
               ballLaunched=1
           fi ;;
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
        q) stty echo
           tput cnorm
           clear
           exit 0 ;;
    esac
done
