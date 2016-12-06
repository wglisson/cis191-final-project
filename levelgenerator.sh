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


generateLevel 15 10


# #############################################################################
# Generates a random level (creates a new file)
# Essentially sgenerates a file of
#
# var 1: numRows
# var 2: numCols
# #############################################################################
loadBlocksFromFile() {
    # check if there is at least 1 input
    if [[ $# -lt 1 ]]; then echo "usage: loadBlocksFromFile <filename>"; exit 1; fi

    currRow=1
    while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "Text read from file: $line"
        # declare row$currRow=$line
        # varname=row$currRow
        # export ${!varname}=$line
        # echo $row1

        # foo=${!varname}
        rowEncoding="$line"
        for (( i=0; i<${#rowEncoding}; i++ )); do
          echo "${rowEncoding:$i:1}"

          # puts the value in the appropriate row and colum
          putVal $currRow $((i+1)) "${rowEncoding:$i:1}"
        done

        # once a line is read, update the current Row.
        currRow= $((currRow + 1))
    done < "$1"
}

loadBlocksFromFile randomLevel
