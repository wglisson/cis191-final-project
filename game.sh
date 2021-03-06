#!/bin/bash

################################################################################
# Brick Breaker Game for CIS191 Final Project. See README.md
#
# University of Pennsylvania
# CIS191 - Unix, fall 2016
#
# @author: alextzhao
# @author: wglisson
# @author: wangandr
# ##############################################################################

# Intial state of the game. Throughout the game tput + echo is used to draw the
# game appropriately:


 # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 # X[4][3][3][4][5][4][4][4][3][1]X
 # X[3][1][4][3]   [2][2][5][2][1]X
 # X[1][4][4]   [1][1][1][2]   [1]X
 # X[1][1][3][2][5][5][1]   [4]   X
 # X[4]         [4][1][3]   [1][5]X
 # X                              X
 # X                              X
 # X                              X
 # X                              X       Score:  0
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X                              X
 # X              0               X
 # X            <===>             X
 # X                              X
 # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


########################   Check System Requirements  ##########################

# Checks if the game window reachers requirements. game needs at least 50
# column terminal display. Note: code is adapted from ShellTris, reference:
# http://www.shellscriptgames.com/shelltris/
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


#############        data structures to store blocks      ######################
# Note that there is a maximum of 15 rows of blocks. The game can potentially
# have fewer rows of block, in which case the rows will be populated from row1,
# ...rowk. The rest of the rows will contains 0's
#
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

BLOCKS_MAX_NUMROWS=15           # Maximum allowed num rows of blocks is 15.
BLOCKS_ROWSTOFILL_DEFAULT=5     # Rows to actually fill. Suggested default: 5
BLOCKS_NUMCOLS_DEFAULT=10       # Cols to actually fill. Suggested default: 10

# #############################################################################
# Helper function draws the score in the instance of the game
# Expects 2 input elements, as follows
# @Inputs:
# var 1 is starting x coordinate
# var 2 is starting y coordinate
# score is the current score, initially 0, but changes throughout the game
# #############################################################################
scoreX=40       # x-position of score
scoreY=10       # y-position of score

drawScore() {
    tput cup $2 $1
    echo "Score: " $score
}


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

    # helper variables to store the progress in x and y direction when drawing
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
# Helper function to get the value of a block at (x,y).
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
# Helper function to put a value of a block at (x,y).
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
# @Inputs:
# var 1: filename       the file from which to load the blocks.
# #############################################################################
loadBlocksFromFile() {
    # check if there is at least 1 input
    if [[ $# -lt 1 ]]; then echo "usage: loadBlocksFromFile <filename>"; exit 1; fi

    # We process each row at a time. Initialize currRow to 1
    currRow=1
    while IFS='' read -r line || [[ -n "$line" ]]; do

        # Loop over each character in each line and update the data structures
        # representing the blocks using putVal
        rowEncoding="$line"
        for (( i=0; i<${#rowEncoding}; i++ )); do
          # puts the value in the appropriate row and colum
          putVal $currRow "$((i))" "${rowEncoding:$i:1}"
        done

        # once a line is read, update the current Row.
        currRow=$((currRow + 1))
    done < "$1"
}



# #############################################################################
# Helper function to render the bricks based on the underlying bricks data
# structure
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
            brick="[$(getVal $row $col)]"
            if [[ ! "$brick" == "[0]" ]]
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
# @inputs
# var 1 row
# var 2 col
# #############################################################################
updateBrick() {
    rowOffset=$(( $1 + 1 ))
    colOffset=$(( $2 * 3 ))
    colOffset=$(( $colOffset + 2 ))
    brick="[$(getVal $1 $2)]"
    if [[ ! "$brick" == "[0]" ]]
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
# demoPopulate() {
#     val=0
#     while [[ $val -lt 10 ]]
#     do
#         valOffset=$(( $val + 1 ))
#         putVal "$valOffset" "$val" 2
#         echo -n "$(getVal valOffset val)"
#         val=$(( $val + 1))
#     done
# }

# Board variable recommendations, can be moved around to a more appropriate position later
# boardX represents the x coord of the center cell of the board, board movement is calculated through this
# boardY represents the y coord of the center cell of the board, this will not change
# boardWidth represents the width on either side of the board ignoring the center cell
# that is, a boardWidth of 2 corresponds to an actual board size of 2 + 1 + 2 = 5
boardWidth=2
boardX=16
boardY=30

################################################################################
# Draw the board's position on the screen
#
# @inputs: none
# ##############################################################################
drawBoard() {
    counter=0
    boardLeftX=$(( boardX - $boardWidth ))

    # use a case statement to draw the board. Set up like this to make re-rendering
    # easier
    while [[ $counter -lt 5 ]]
    do
        case $counter in
            0) char="<" ;;
            1) char="=" ;;
            2) char="=" ;;
            3) char="=" ;;
            4) char=">"
        esac

        # actual rendering of the board
        tput cup $boardY $(( $boardLeftX + $counter ))
        echo -n "$char"
        counter=$(( $counter + 1 ))
    done
}

################################################################################
# Moves the board one character to the left
################################################################################
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

################################################################################
# Moves the board one character to the right
################################################################################
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



################################################################################
# gives details for game board
################################################################################
export topLeftX=1
export topLeftY=1
export gameWidth=31
export gameHeight=31
export gameRight=$(( topLeftX + gameWidth -1 ))
export gameTop=$(( topLeftY + 1 ))
export gameLeft=$(( topLeftX + 1 ))
export gameBottom=$(( topLeftY + gameHeight -1 ))

################################################################################
# Method stub for ball launchBall
#
# FIXME: Currently ball only launches when a key is pressed.
################################################################################
launchBall() {
    ballX=$boardX
	tput cup $ballY $ballX
	echo -n "O"
	ballSpeedX=1
	ballSpeedY=1
}

################################################################################
# updates the ball's position
################################################################################
moveBall() {
    oldBallX=$ballX
    oldBallY=$ballY
    oldBallSpeedX=$ballSpeedX
    oldBallSpeedY=$ballSpeedY
	ballNextX=$(( ballX + ballSpeedX ))
	ballNextY=$(( ballY - ballSpeedY ))
    checkBoundaryCollision                  # check if collided with a boundary
    checkBoardCollision                     # check if collided with the board
    checkBlockCollision                     # check if collided with a block
    ballX=$(( ballX + ballSpeedX ))
	ballY=$(( ballY - ballSpeedY ))
    handleCollisionError
    tput cup $oldBallY $oldBallX
	echo -n " "
	tput cup $ballY $ballX
	echo -n "O"
}

# #############################################################################
# Helper function to check whether the ball has collided with any boundaries.
# Update velocity of ball approriately
# #############################################################################
checkBoundaryCollision() {
	#check for collisions with the game's boundaries
	if [[ $ballNextX -ge $(( $gameRight )) ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballNextY -le $(( $gameTop )) ]]
	then
		ballSpeedY=$(( -1 * ballSpeedY ))
	fi
	if [[ $ballNextX -le $(( $gameLeft )) ]]
	then
		ballSpeedX=$(( -1 * ballSpeedX ))
	fi
	if [[ $ballY -ge $(( $gameBottom  )) ]]
	then
        gameover
	fi
}

gameover() {
    #gameover
    ballSpeedY=0
    ballSpeedX=0
    tput cup $(( $scoreY + 5)) $scoreX
    echo "Game Over"
    #compares current score to high score (if it exists), and update if needed
    #check if the high scores list exists
    if [[ -f ".highScore" ]]
    then
        read -r curHighScore < .highScore
        #curHighScore=10
        if [[ score -le curHighScore ]]
        then
            tput cup $(( $scoreY + 10 )) $scoreX
            echo "current high score is " $curHighScore
        else
            echo $score > .highScore
            tput cup $(( $scoreY + 10 )) $scoreX
            echo $score "is a new high score!"
        fi
    else
        #if no high score file, print "new high score" and create high score file
        touch .highScore
        echo $score > .highScore
        tput cup $(( $scoreY + 10 )) $scoreX
        echo $score "is a new high score!"
    fi

    # TODO: Implement  Allow user to press a key to play again.
    playagain
}
## resets terminal after game state ends.
resetTerminal() {
    tput reset
    stty echo
}

exitgame() {
    # if the user loses, then exit out of the game after 3 seconds and
    # reset the terminal settings.
    resetTerminal
    exit 0
}

## Helper function to check whether the user wants to play again
playagain() {
    playagainX=40       # x-position of play again?
    playagainY=20       # y-position of play again?

    tput cup $(( $playagainY + 5 )) $playagainX
    echo "Press R to play again, X to exit"
    sleep 2     # sleep for 2 seconds to properly catch user input.
    # catch user input, X to exit game, R to reload game
    read -n 1 selection
    case $selection in
        x ) exitgame        # if x selected, then exit game
        ;;
        r ) startGame       # if r pressed, then replay game.
        ;;
        * ) sleep 1         # sleep for 1 second and exit
    esac
    exitgame
}

# #############################################################################
# Helper function to check whether the ball has collided with any blocks
# Update velocity of ball approriately and decrease the value of collided
# blocks
# #############################################################################
checkBlockCollision() {
    blockYIndex=$(( $ballNextY - 1 ))
    if [[ "$blockYIndex" -le 15 ]]
    then
        blockXIndex=$(( $ballNextX + 1 ))
        blockXIndex=$(( $blockXIndex / 3 ))
        blockXIndex=$(( $blockXIndex - 1 ))
        blockVal="$(getVal $blockYIndex $blockXIndex)"
        if [[ $blockVal -ne 0 ]]
        then
            blockVal=$(( $blockVal - 1 ))
            ballYSide=$(( ballY - 1 ))
            blockValSide="$(getVal $ballYSide $blockXIndex)"
            if [[ $blockValSide -ne 0 ]]
            then
                ballSpeedX=$(( -1 * ballSpeedX ))
            else
                ballSpeedY=$(( -1 * ballSpeedY ))
            fi
            score=$(( $score + 1 ))
            drawScore $scoreX $scoreY
            putVal "$blockYIndex" "$blockXIndex" "$blockVal"
            updateBrick "$blockYIndex" "$blockXIndex"
        fi
    fi
}

# #############################################################################
# Helper function to handle whether the ball's final position is a conflict
# with any blocks. Resets the ball's position to its last position and negates
# velocities to "back up" the ball out of the error causing situation.
# #############################################################################
handleCollisionError() {
    blockYIndex=$(( $ballY - 1 ))
    if [[ "$blockYIndex" -le 15 ]]
        then
        blockXIndex=$(( $ballX + 1 ))
        blockXIndex=$(( $blockXIndex / 3 ))
        blockXIndex=$(( $blockXIndex - 1 ))
        blockVal="$(getVal $blockYIndex $blockXIndex)"
        if [[ $blockVal -ne 0 ]]
        then
            ballX=$oldBallX
            ballY=$oldBallY
            ballSpeedX=$(( -1 * $oldBallSpeedX ))
            ballSpeedY=$(( -1 * $oldBallSpeedY ))
        fi
    fi
}

# #############################################################################
# Helper function to check whether the ball is within the bounds of the board
# This is useful for checking whether the ball has collided with the board
# #############################################################################
ballIsWithinBoard() {
    # check if board is on same y coordinate
    if [[ $ballY -ge $(( $boardY - 1)) ]]; then
        # check if ball is within x confines of the board.
        if [[ $ballX -ge $(( $boardX - $boardWidth)) ]]; then
            if [[ $ballX -le $(( $boardX + $boardWidth)) ]]; then
                return 0
            fi
        fi
    fi
    return 1
}

# #############################################################################
# Helper function to check whether the ball has collided with the board. This
# function also changes the ball's x-velocity appropriately to take note of
# where the ball hit the paddle.
# #############################################################################
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
    # NOTE: Note that this is a brute force solution. Completely not extensible
    # if the board width changes in any way.
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

resetparameters() {
    export ballX=0             # current x coordinate of ball
    export ballY=28            # current y coordinate of ball
    export oldBallX=0          # old x coordinate of ball
    export oldBallY=0          # old y coordinate of ball
    export ballNextX=0         # Next X position of the ball
    export ballNextY=0         # Next Y position of the ball
    export oldBallSpeedX=0     # old ballSpeedX used for reset purposes
    export oldBallSpeedY=0     # old ballSpeedY used for reset purposes
    export ballSpeedX=0        # ballSpeedX is movement of ball in x direction
    export ballSpeedY=0        # ballSpeedY is movement of ball in y direction
    export score=0             # score for the current game
}
# Starting a new game
startGame() {
    clear               #clear the terminal on starting
    stty -echo          #suppress echo (hide all key press output)
    tput civis          #hide the cursor

    initializeBlocks    # sets all blocks to emtpy
    ballLaunched=0      # ball has not launched

    resetparameters     # reset the parameters

    drawBorders $topLeftX $topLeftY $gameWidth $gameHeight
    drawScore $scoreX $scoreY

		# var1 decides what level to play. if no var1 or var1 doesn't exist, then we
		# create a random level
		if [[ -f $1 ]]
		then
			case $1 in
				level1) loadBlocksFromFile level1 ;;
				level2) loadBlocksFromFile level2 ;;
				level3) loadBlocksFromFile level3 ;;
				level4) loadBlocksFromFile level4 ;;
				level5) loadBlocksFromFile level5 ;;
				*) clear
						echo "file is not a level"
						exit 0 ;;
			esac
		else

    # First generate a level with $BLOCKS_ROWSTOFILL_DEFAULT number of rows of block,
    # but which allows up to BLOCKS_MAX_NUMROWS of blocks. Essentially the file
    # used to encode a is BLOCKS_MAX_NUMROWS lines, where the First
    # BLOCKS_ROWSTOFILL_DEFAULT number of lines are lines of random integers,
    # and the rest of the lines are filled with 0's to indicate blank blocks.
    # This design choice allows for more extensibility down the line should we
    # decide to implement different levels of varying difficulty and number of
    # blocks
    ./generateLevel.sh $BLOCKS_MAX_NUMROWS $BLOCKS_ROWSTOFILL_DEFAULT $BLOCKS_NUMCOLS_DEFAULT

    # Once the level is generate from ./generateLevel, we load the level (insantiating)
    # the data structures based on the contents of the file <randomLevel>
    loadBlocksFromFile randomLevel
		fi


    # Draw the bricks and board
    drawBricks
    drawBoard

    #basic control flow
    while read -s -n 1 inst
    do
        if [[ "$ballLaunched" == "1" ]]
        then
            moveBall
        fi
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
        q)  resetTerminal
            exit 0 ;;
        esac
    done
}

# start the game
startGame $1
export
