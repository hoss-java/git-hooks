#!/bin/bash

my_function() {
    local array_name="${FUNCNAME[0]}_subcommands"
    
    # Declare an associative array
    declare -A "$array_name"
    
    # Use indirect referencing to assign values
    eval "${array_name}[key1]='value1'"
    eval "${array_name}[key2]='value2'"
    eval "${array_name}[key3]='value3'"
    
    # Create usage string listing keys
    local usage="Usage: git deck ${FUNCNAME[0]} {$(IFS='|'; echo "${!array_name[@]}")}"
    
    echo "$usage"
}

my_function
