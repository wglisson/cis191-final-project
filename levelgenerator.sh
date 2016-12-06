#!/bin/bash

# #############################################################################
# Generates a random level (creates a new file)
# Essentially generates a file of
#
# var 1: numRows
# var 2: numCols
# #############################################################################
generateLevel() {
    numRows=$1
    numCols=$2

    # create new randomLevel file. Overwrite if exists
    > randomLevel

    for row in $(seq 1 $numRows)
    do
        for column in $(seq 1 $numCols)
        do
            echo -n $(( (RANDOM % 6) )) >> randomLevel
        done
        echo "" >> randomLevel
    done
}


generateLevel 15 33
