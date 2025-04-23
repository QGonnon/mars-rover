#!/bin/bash

# Fonction de détection des dépendances circulaires
detect_circular_dependencies() {
    local project_dir=$1
    declare -A dependency_graph
    declare -A known_names

    # Collecter tous les noms de fichiers sans se limiter à .cs
    while IFS= read -r file; do
        name=$(basename "$file")
        name_without_ext="${name%.*}"
        known_names["$name_without_ext"]=1
    done < <(find "$project_dir" -type f)

    # Extraire les dépendances à partir des fichiers .cs uniquement
    while IFS= read -r file; do
        filename=$(basename "$file" .cs)
        using_statements=$(grep "^using " "$file" | sed -E 's/using ([^;]+);/\1/g')

        for dep in $using_statements; do
            dep=$(echo "$dep" | tr -d ' ')
            if [[ "$dep" == System.* ]]; then
                continue
            fi
            dep_short=$(basename "$dep")
            if [[ -n "$dep_short" && "${known_names[$dep_short]}" == "1" ]]; then
                dependency_graph["$filename"]+="$dep_short "
            fi
        done
    done < <(find "$project_dir" -name "*.cs")

    # DFS pour détecter les cycles
    declare -A visited
    declare -A in_stack

    has_cycle() {
        local node=$1

        if [[ "${in_stack[$node]}" == "1" ]]; then
            return 0
        fi
        if [[ "${visited[$node]}" == "1" ]]; then
            return 1
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

# Exécution principale
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <project-subdirectory>"
    exit 1
fi

project_dir="$1"

if [[ ! -d "$project_dir" ]]; then
    echo "Error: Directory '$project_dir' not found."
    exit 1
fi

detect_circular_dependencies "$project_dir"
