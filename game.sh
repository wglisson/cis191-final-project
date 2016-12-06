#!/bin/bash

########################   Check System Requirements  ##########################

# Checks if the game window reachers requirements. game needs at least 50
# column terminal display. Note: Adapted from ShellTris
LL=`stty -a | grep rows | sed 's/^.*;\(.*\)rows\(.*\);.*$/\1\2/' | sed 's/;.*$//' | sed 's/[^0-9]//g'` # ROWS
LC=`stty -a | grep columns | sed 's/^.*;\(.*\)columns\(.*\);.*$/\1\2/' | sed 's/;.*$//' | sed 's/[^0-9]//g'` # COLUMNS
if [ $LC -lt 50 ] ; then
	echo "This game requires at least a 50-column terminal display. Please make your terminal bigger"
	exit 0;
fi

if [ $LL -lt 35 ] ; then
    echo "This game requires at least a 35 row terminal display. Please make your terminal bigger"
    exit 0;
fi

# Terminal setting to suppress echo (hide all key press output)
#TTYSETTING="-echo"


#############        data structures to store blocks      ######################
# Note that there is a maximum of 15 rows of blocks
# Each row has 10 blocks
initializeBlocks() {
    export row1=(0 0 0 0 0 0 0 0 0 0)
    export row2=(0 0 0 0 0 0 0 0 0 0)
    export row3=(0 0 0 0 0 0 0 0 0 0)
    export row4=(0 0 0 0 0 0 0 0 0 0)
    export row5=(0 0 0 0 0 0 0 0 0 0)
    export row6=(0 0 0 0 0 0 0 0 0 0)
    export row7=(0 0 0 0 0 0 0 0 0 0)
    export row8=(0 0 0 0 0 0 0 0 0 0)
    export row9=(0 0 0 0 0 0 0 0 0 0)
    export row10=(0 0 0 0 0 0 0 0 0 0)
    export row11=(0 0 0 0 0 0 0 0 0 0)
    export row12=(0 0 0 0 0 0 0 0 0 0)
    export row13=(0 0 0 0 0 0 0 0 0 0)
    export row14=(0 0 0 0 0 0 0 0 0 0)
    export row15=(0 0 0 0 0 0 0 0 0 0)
}


# #############################################################################
# Helper function draws the score in the instance of the game
# Expects 2 input elements, as follows
# @Inputs:
# var 1 is starting x coordinate
# var 2 is starting y coordinate
# score is the current score, initially 0, but changes throughout the game
# #############################################################################
score=0
scoreX=40
scoreY=10

drawScore() {
tput cup $2 $1
echo "score: " $score
}
#an example usage, to show it works, use scoreX and scoreY for later calls
drawScore $scoreX $scoreY
drawScore 50 50


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
# Loads blocks based on description from a file.
#
# FIXME: Currently does not does error checking to ensure that the file has
# at most 10 columns and 15 rows. This should be enforced by any argument passed
# into generateLevel
#
# @Inputs:
# var 1: filename       the file from which to load the blocks.
# #############################################################################
loadBlocksFromFile() {
    # check if there is at least 1 input
    if [[ $# -lt 1 ]]; then echo "usage: loadBlocksFromFile <filename>"; exit 1; fi

    # We process each row at a time. Initialize currRow to 1
    currRow=1
    while IFS='' read -r line || [[ -n "$line" ]]; do
        # echo "Text read from file: $line"     # test that line read is correct

        # Playing with variable assignments
        # declare row$currRow=$line
        # varname=row$currRow
        # echo ${!varname}

        # Loop over each character in each line and update the data structures
        # representing the blocks using putVal
        rowEncoding="$line"
        for (( i=0; i<${#rowEncoding}; i++ )); do
          # echo "${rowEncoding:$i:1}"      # test that we can loop over each character

          # puts the value in the appropriate row and colum
          putVal $currRow "$((i + 1))" "${rowEncoding:$i:1}"
        done

        # once a line is read, update the current Row.
        currRow=$((currRow + 1))
    done < "$1"
}



# #############################################################################
# Helper function to render the bricks based on the underlying bricks data
# structure
#
# #############################################################################
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

# #############################################################################
# Helper function to update the bricks
#
# 1 row
# 2 col
# #############################################################################
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
export topLeftX=1
export topLeftY=1
export gameWidth=31
export gameHeight=31
export gameRight=$(( topLeftX + gameWidth -1 ))
export gameTop=$(( topLeftY + 1 ))
export gameLeft=$(( topLeftX + 1 ))
export gameBottom=$(( topLeftY + gameHeight -1 ))

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
    checkBoardCollision                     # check if collided with the board
	ballNextX=$(( ballX + ballSpeedX ))
	ballNextY=$(( ballY - ballSpeedY ))
    checkBlockCollision                     # check if collided with a block
    ballX=$(( ballX + ballSpeedX ))
	ballY=$(( ballY - ballSpeedY ))
    tput cup $oldBallY $oldBallX
	echo -n " "
	tput cup $ballY $ballX
	echo -n "O"
}

checkBoundaryCollision() {
	#check for collisions with the game's boundaries
	if [[ $ballX -ge $(( $gameRight - 1 )) ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballY -le $(( $gameTop + 1 )) ]]
	then
		ballSpeedY=$(( -1 * ballSpeedY ))
	fi
	if [[ $ballX -le $(( $gameLeft + 1 )) ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballY -ge $(( $gameBottom  )) ]]
	then
		#gameover
		ballSpeedY=0
		ballSpeedX=0
		tput cup $(( $scoreY + 5)) $scoreX
		echo "Game Over"
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

# TODO: Implement
ballIsWithinBoard() {
    # check if board is on same y coordinate
    if [[ $ballY -eq $boardY ]]; then
        # check if ball is within x cofines of the board.
        if [[ $ballX -ge $(( $boardX - $boardWidth)) ]]; then
            if [[ $ballX -le $(( $boardX + $boardWidth)) ]]; then
                return 0
            fi
        fi
    fi
    return 1
}

checkBoardCollision() {
    # when ball collides with ball reverse the y direction
    if ballIsWithinBoard; then
        ballSpeedY=$(( -1 * ballSpeedY ))
    else
        return
    fi

    # update the x speed of ball depending on where ball collides on boardX
    boardLeftX=$(( $boardX-$boardWidth ))
    boardTotalWidth=$(( 2*$boardWidth + 1 ))    #compute the total board width
    # FIXME: Note that this is a brute force solution. Completely not extensible
    # if the board width changes in any way.
    # FIXME: This introduces compatibility issues with check boundary collision
    ballSpeedX_change=0
    if [[ ballX -le $(( boardLeftX + 1 )) ]]; then
        ballSpeedX_change=-2
    elif [[ ballX -le $(( boardLeftX + 2 )) ]]; then
        ballSpeedX_change=-1
    elif [[ ballX -le $(( boardLeftX + 3 )) ]]; then
        ballSpeedX_change=0
    elif [[ ballX -le $(( boardLeftX + 4 )) ]]; then
        ballSpeedX_change=1
    else
        ballSpeedX_change=2
    fi

    ballSpeedX=$(( ballSpeedX + ballSpeedX_change ))
}

# Starting a new game
startGame() {
    clear               #clear the terminal on starting
    stty -echo          #suppress echo (hide all key press output)
    tput civis          #hide the cursor

    initializeBlocks    # sets all blocks to emtpy
    ballLaunched=0      # ball has not launched

    drawBorders $topLeftX $topLeftY $gameWidth $gameHeight

    #NOTE: Here, we generate a new level based on the file <randomLevel
    #demoPopulate
    loadBlocksFromFile randomLevel

    # Draw the bricks and board
    drawBricks
    drawBoard

    #basic control flow
    while read -s -n 1 inst
    do
	    moveBall
        case $inst in
        w)  if [[ "$ballLaunched" == "0" ]]
            then
                launchBall
                ballLaunched=1
            fi ;;
        a)  if [[ ! "$(( $boardX - $boardWidth ))" == 2 ]]
            then
                boardX=$(( boardX - 1 ))
                updateBoardL
            fi ;;
        d)  if [[ ! "$(( $boardX + $boardWidth ))" == 31 ]]
            then
                boardX=$(( boardX + 1 ))
                updateBoardR
            fi ;;
        q)  stty echo
            tput cnorm
            clear
            exit 0 ;;
        esac
    done
}

# start the game
startGame
export
