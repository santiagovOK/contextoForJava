#!/bin/bash
# bin/contexto-init.sh
# AI Agents Context Generator for Java/Spring Boot projects

set -e

# Resolve the directory where the script is installed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Assuming the repo structure is standard: templates/ is sibling to bin/
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/templates"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "❌ Error: Templates directory not found at $TEMPLATE_DIR"
    exit 1
fi

echo "🤖 Initializing Agents Rules for Java..."

# 1. Detect or Ask for the Base Package
DEFAULT_DIR="src/main/java/com/example/app"
if [ -d "src/main/java" ]; then
    # Try to find the first sub-package as a suggestion
    DETECTED=$(find src/main/java -mindepth 2 -maxdepth 4 -type d 2>/dev/null | head -n 1)
    if [ ! -z "$DETECTED" ]; then
        DEFAULT_DIR="$DETECTED"
    fi
fi

echo -e "\n📍 We need to know where to place the code rules (your base package)."
read -r -p "   Enter the package path (Press Enter for '$DEFAULT_DIR'): " USER_PKG_PATH
BASE_PKG="${USER_PKG_PATH:-$DEFAULT_DIR}"

echo "📂 Setting up rules in: $BASE_PKG"

# 2. File creation/copy helper
install_rule() {
    local source_file=$1
    local dest_path=$2
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest_path")"
    
    if [ ! -f "$dest_path" ]; then
        if [ -f "$source_file" ]; then
            cp "$source_file" "$dest_path"
            echo "   ✅ Installed: $dest_path"
        else
            echo "   ⚠️  Template missing: $source_file"
        fi
    else
        echo "   ⚠️  Skipped (already exists): $dest_path"
    fi
}

# 3. Generate Directory and File Structure

echo -e "\n📝 Installing rule files..."

# Common directories
mkdir -p "$BASE_PKG"
mkdir -p "src/main/resources"
mkdir -p "src/test"
mkdir -p "skills"

# Layer Rules
install_rule "$TEMPLATE_DIR/java/web.md"         "$BASE_PKG/web/AGENTS-API.md"
install_rule "$TEMPLATE_DIR/java/business.md"    "$BASE_PKG/service/AGENTS-BUSINESS.md"
install_rule "$TEMPLATE_DIR/java/persistence.md" "$BASE_PKG/persistence/AGENTS-DATA.md"
install_rule "$TEMPLATE_DIR/java/domain.md"      "$BASE_PKG/domain/AGENTS-DOMAIN.md"
install_rule "$TEMPLATE_DIR/java/utils.md"       "$BASE_PKG/util/AGENTS-UTILS.md"
install_rule "$TEMPLATE_DIR/java/config.md"      "src/main/resources/AGENTS-CONFIG.md"
install_rule "$TEMPLATE_DIR/java/testing.md"     "src/test/AGENTS-TESTING.md"

# Documentation & Guidelines
DOCS_DIR="$(dirname "$SCRIPT_DIR")/docs"
if [ -d "$DOCS_DIR" ]; then
    mkdir -p "docs"
    install_rule "$DOCS_DIR/dependency-management-best-practices.md" "docs/AGENTS-OOP-BEST-PRACTICES.md"
    install_rule "$DOCS_DIR/umlet-diagram-guidelines.md" "docs/AGENTS-UML-GUIDELINES.md"
fi

# Generate Skills (Expert Roles)
install_rule "$TEMPLATE_DIR/roles/architect.md"         "skills/SPRING-ARCHITECT.md"
install_rule "$TEMPLATE_DIR/roles/performance-tuner.md" "skills/JAVA-PERFORMANCE.md"

# Git Guidelines
install_rule "$TEMPLATE_DIR/common/git.md" "AGENTS-GIT.md"

# Generate main AGENTS.md (Orchestrator)
JAVA_VER=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
# Default to "Unknown" if java command fails or returns unexpected format
JAVA_VER=${JAVA_VER:-Unknown}

if [ -f pom.xml ]; then
    BUILD_SYS="Maven"
elif [ -f build.gradle ] || [ -f build.gradle.kts ]; then
    BUILD_SYS="Gradle"
else
    BUILD_SYS="Unknown"
fi

# We construct AGENTS.md dynamically because it depends on BASE_PKG
cat <<EOF > AGENTS.md
# Java Project Context Map

## Detected Tech Stack
- **Java**: $JAVA_VER
- **Build System**: $BUILD_SYS

## Directory Guidance (Local Context)
- **API Layer**: [Controllers](./$BASE_PKG/web/AGENTS-API.md)
- **Logic Layer**: [Services](./$BASE_PKG/service/AGENTS-BUSINESS.md)
- **Data Layer**: [Repositories](./$BASE_PKG/persistence/AGENTS-DATA.md)
- **Domain Layer**: [Entities/DTOs](./$BASE_PKG/domain/AGENTS-DOMAIN.md)
- **Testing**: [Standards](./src/test/AGENTS-TESTING.md)

## Best Practices & Guidelines
- **[OOP Best Practices](./docs/AGENTS-OOP-BEST-PRACTICES.md)**: Dependency management, Tell Don't Ask, encapsulation, getters/setters criteria, 1-to-1 relationships
- **[UML Guidelines](./docs/AGENTS-UML-GUIDELINES.md)**: UMLet diagram construction with XML syntax rules

## Git Guidelines
- [Conventional Commits](./AGENTS-GIT.md)

## Active Skills (Roles)
- [Spring Architect](./skills/SPRING-ARCHITECT.md)
- [Performance Tuning](./skills/JAVA-PERFORMANCE.md)
EOF
echo "   ✅ Created: AGENTS.md (Master File)"

# 4. Git Configuration (.gitignore)
echo -e "\n🛡️  Git Configuration"
read -r -p "❓ Do you want to add these files (AGENTS.md, skills/, etc.) to .gitignore? [y/N] " ADD_TO_GIT

if [[ "$ADD_TO_GIT" =~ ^[Yy]$ ]]; then
    if [ ! -f .gitignore ]; then
        echo "   Creating .gitignore..."
        touch .gitignore
    fi
    
    # Add a header if it doesn't exist
    if ! grep -q "Agents Rules" .gitignore; then
        echo -e "\n# --- Agents Rules & Context ---" >> .gitignore
    fi

    # Helper function to append if not present
    add_ignore() {
        local pattern=$1
        if ! grep -qxF "$pattern" .gitignore; then
            echo "$pattern" >> .gitignore
            echo "   ➕ Ignored: $pattern"
        fi
    }

    add_ignore "AGENTS.md"
    add_ignore "AGENTS-*.md"
    add_ignore "skills/"
    add_ignore "docs/AGENTS-*.md"
    add_ignore "**/*AGENTS-*.md"
    
    echo "✅ .gitignore updated successfully."
else
    echo "ℹ️  Skipped. (Note: It is recommended to commit 'AGENTS.md' if you want to share rules with your team)."
fi

echo -e "\n🚀 Done! Your Java project is ready for AI Agents."
