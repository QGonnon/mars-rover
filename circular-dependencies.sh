#!/bin/bash

# Function to detect circular dependencies
detect_circular_dependencies() {
    local dir=$1
    local dependencies=()
    declare -A dependency_graph

    # Find all .cs files and extract dependencies
    while IFS= read -r file; do
        filename=$(basename "$file" .cs)
        using_statements=$(grep "^using " "$file" | sed -E 's/using ([^;]+);/\1/g')

        for dep in $using_statements; do
            dep=$(echo "$dep" | tr -d ' ')
            if [[ -n "$dep" ]]; then
                dependency_graph["$filename"]+="$dep "
            fi
        done
    done < <(find "$dir" -name "*.cs")

    # Function to perform DFS for cycle detection
    local visited=()
    local stack=()

    function has_cycle() {
        local node=$1
        if [[ " ${stack[@]} " =~ " ${node} " ]]; then
            return 0  # Cycle found
        fi
        if [[ " ${visited[@]} " =~ " ${node} " ]]; then
            return 1  # Node has already been checked.
        fi

        visited+=("$node")
        stack+=("$node")

        for neighbor in ${dependency_graph[$node]}; do
            if has_cycle "$neighbor"; then
                return 0
            fi
        done

        stack=("${stack[@]/$node}")
        return 1
    }

    # Check each file for circular dependencies
    for node in "${!dependency_graph[@]}"; do
        visited=()
        stack=()
        if has_cycle "$node"; then
            echo "Circular dependency detected involving $node"
            return 1  # Exit with failure
        fi
    done

    echo "No circular dependencies found."
    return 0  # Exit with success
}

# Main script execution
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

detect_circular_dependencies "$1"
