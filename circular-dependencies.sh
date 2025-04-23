#!/bin/bash

# Initialize an associative array for dependencies
declare -A dependencies

# Load project dependencies from .csproj files
for proj in $(find . -name 'CSharp xUnit starter/*.csproj'); do
    project_name=$(basename "$proj" .csproj)
    # Extract project references using xmllint
    refs=$(xmllint --xpath '//ProjectReference/@Include' "$proj" 2>/dev/null | sed 's/[^\/]*\///; s/\.csproj//g')
    
    # Check if refs variable is not empty
    if [[ -n "$refs" ]]; then
        dependencies["$project_name"]="${refs// / }"
    else
        dependencies["$project_name"]=""
    fi

    echo "Project: $project_name -> Dependencies: ${dependencies[$project_name]}"
done

# Function to detect cycles
detect_cycle() {
    local project=$1
    local visited=()
    local stack=()

    visited+=("$project")
    stack+=("$project")

    for dep in ${dependencies["$project"]}; do
        if [[ " ${stack[*]} " == *" $dep "* ]]; then
            echo "Circular dependency detected involving $project and $dep"
            return 1
        fi
        
        if [[ ! " ${visited[*]} " == *" $dep "* ]]; then
            if ! detect_cycle "$dep"; then
                return 1
            fi
        fi
    done

    stack=("${stack[@]:0:${#stack[@]}-1}") # Pop project from stack
    return 0
}

# Check for circular dependencies for each project
for project in "${!dependencies[@]}"; do
    if [[ -z "${dependencies[$project]}" ]]; then
        echo "No dependencies for project: $project"
    else
        detect_cycle "$project" || exit 1
    fi
done

echo "No circular dependencies detected."
