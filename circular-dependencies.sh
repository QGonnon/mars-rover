#!/bin/bash

# Function to detect circular dependencies
detect_circular_dependencies() {
    local dir=$1
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
    declare -A visited
    declare -A in_stack

    has_cycle() {
        local node=$1

        if [[ "${in_stack[$node]}" == "1" ]]; then
            return 0  # Cycle found
        fi
        if [[ "${visited[$node]}" == "1" ]]; then
            return 1  # Already checked
        fi

        visited["$node"]=1
        in_stack["$node"]=1

        for neighbor in ${dependency_graph[$node]}; do
            if has_cycle "$neighbor"; then
                return 0
            fi
        done

        in_stack["$node"]=0
        return 1
    }

    # Check each file for circular dependencies
    for node in "${!dependency_graph[@]}"; do
        visited=()
        in_stack=()
        if has_cycle "$node"; then
            echo "Circular dependency detected involving $node"
            return 1
        fi
    done

    echo "No circular dependencies found."
    return 0
}

# Main script execution
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

detect_circular_dependencies "$1"
