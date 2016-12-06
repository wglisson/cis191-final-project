#!/bin/bash

generateLevel() {
    if [[ $# -lt 3 ]]; then echo "usage: generateLevel maxNumRows numRowsToFill numCols"; exit 1; fi
    # renaming input variables
    maxNumRows=$1
    numRowsToFill=$2
    numCols=$3

    # create new randomLevel file. Overwrite if exists
    > randomLevel

    for row in $(seq 1 $numRowsToFill)
    do
        for column in $(seq 1 $numCols)
        do
            echo -n $(( (RANDOM % 6) )) >> randomLevel
        done
        echo "" >> randomLevel
    done

    # fill the remaining rows with blank blocks
    for row in $(seq $((numRowsToFill + 1)) $maxNumRows)
    do
        for column in $(seq 1 $numCols)
        do
            echo -n "0" >> randomLevel
        done
        echo "" >> randomLevel
    done
}

generateLevel $1 $2 $3
