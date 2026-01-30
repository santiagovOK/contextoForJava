#!/bin/bash
# install.sh
# Installs ContextoForJava to ~/.contextoForJava

set -e

# Configuration
REPO_URL="${REPO_URL:-https://github.com/YOUR_USERNAME/ContextoForJava.git}"
INSTALL_DIR="$HOME/.contextoForJava"
BRANCH="main"

echo -e "\033[0;34m⬇️  Installing ContextoForJava...\033[0m"

# 1. Check for Git
if ! command -v git &> /dev/null; then
    echo "❌ Error: Git is not installed."
    exit 1
fi

# 2. Clone or Update
if [ -d "$INSTALL_DIR" ]; then
    echo "   🔄 Updating existing installation in $INSTALL_DIR..."
    cd "$INSTALL_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
else
    echo "   📥 Cloning to $INSTALL_DIR..."
    git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

# 3. Setup Permissions
chmod +x "$INSTALL_DIR/bin/contexto-init.sh"

# 4. Success Message & Instructions
echo -e "\n\033[0;32m✅ Installation complete!\033[0m"
echo "   Location: $INSTALL_DIR"

echo -e "\n\033[1;33m👉 Next Steps:\033[0m"
echo "   Add the following line to your shell configuration file (.bashrc, .zshrc, etc.):"
echo -e "   \033[0;36mexport PATH=\"$PATH:$INSTALL_DIR/bin\"
\033[0m"
echo ""
echo "   Then restart your terminal and run:"
echo -e "   \033[1;32mcontexto-init.sh\033[0m"
