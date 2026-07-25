#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
BRANCH="${1:-main}"

echo "🔄 Dotfiles Backup Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Time: $TIMESTAMP"
echo "Branch: $BRANCH"
echo ""

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "❌ Error: dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR"

if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Initialize with: cd $DOTFILES_DIR && git init"
    exit 1
fi

echo "📝 Checking for changes..."
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ No changes to commit"
    exit 0
fi

echo "📦 Staging changes..."
git add -A

echo "📋 Changes to be committed:"
git diff --cached --stat

echo ""
echo "💾 Creating commit..."
git commit -m "Auto-backup: $TIMESTAMP"

echo ""
echo "🚀 Pushing to remote..."
if ! git remote get-url origin &>/dev/null; then
    echo "⚠️  Warning: No remote 'origin' configured"
    echo "   To add remote: git remote add origin <repository-url>"
    exit 1
fi

if git push origin "$BRANCH"; then
    echo ""
    echo "✅ Backup successful!"
    echo "   Branch: $BRANCH"
    echo "   Time: $TIMESTAMP"
else
    echo ""
    echo "❌ Push failed. Check your internet connection and git configuration."
    exit 1
fi
