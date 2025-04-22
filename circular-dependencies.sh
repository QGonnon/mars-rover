#!/bin/bash

# Fonction pour détecter les dépendances circulaires
detect_cycle() {
    local project=$1
    local visited=()
    local stack=()
    
    visited+=("$project")
    stack+=("$project")

    for dep in "${dependencies[$project]}"; do
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

# Dictionnaire pour stocker les dépendances
declare -A dependencies

# Charger les projets et leurs dépendances
for proj in $(find . -name '*.csproj'); do
    project_name=$(basename "$proj" .csproj)
    # Extraire les références de projet
    refs=$(xmllint --xpath '//ProjectReference/@Include' "$proj" 2>/dev/null | sed 's/[^\/]*\///; s/\.csproj//g')
    dependencies["$project_name"]="${refs// / }"
done

# Vérifier les dépendances circulaires
for project in "${!dependencies[@]}"; do
    detect_cycle "$project" || exit 1
done

echo "No circular dependencies detected."
