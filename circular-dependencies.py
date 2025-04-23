import os
import re
from collections import defaultdict

def extract_namespace(content):
    """Extrait le namespace déclaré dans un fichier .cs"""
    match = re.search(r'namespace\s+([\w\.]+)', content)
    return match.group(1) if match else None

def find_cs_dependencies(root_dir):
    namespace_to_file = {}
    file_to_namespace = {}
    dependencies = defaultdict(set)

    # Étape 1 : Collecte des namespaces par fichier
    for dirpath, _, files in os.walk(root_dir):
        for filename in files:
            if filename.endswith('.cs'):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                    ns = extract_namespace(content)
                    if ns:
                        namespace_to_file[ns] = filename
                        file_to_namespace[filename] = ns

    # Étape 2 : Recherche de dépendances via usages de namespace
    for dirpath, _, files in os.walk(root_dir):
        for filename in files:
            if filename.endswith('.cs'):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                    for ns, other_file in namespace_to_file.items():
                        if ns in content and other_file != filename:
                            dependencies[filename].add(other_file)

    return dependencies

def detect_circular_dependencies(dependencies):
    visited = set()
    stack = set()

    def visit(node):
        if node in stack:
            return True
        if node in visited:
            return False

        visited.add(node)
        stack.add(node)

        for neighbor in dependencies.get(node, []):
            if visit(neighbor):
                return True

        stack.remove(node)
        return False

    for node in dependencies:
        if visit(node):
            return True

    return False

if __name__ == "__main__":
    import sys
    root_directory = sys.argv[1]
    deps = find_cs_dependencies(root_directory)

    if detect_circular_dependencies(deps):
        print("🚨 Dépendances circulaires détectées !")
        sys.exit(1)
    else:
        print("✅ Aucune dépendance circulaire trouvée.")
        sys.exit(0)
