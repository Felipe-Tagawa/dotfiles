#!/bin/bash
# Configure automatic dotfiles backup via cron

SCRIPT_PATH="$HOME/dotfiles-backup.sh"
CRON_FILE="$HOME/.config/crontab/dotfiles-backup"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ Error: dotfiles-backup.sh not found at $SCRIPT_PATH"
    exit 1
fi

mkdir -p "$(dirname "$CRON_FILE")"

echo "📅 Configure automatic dotfiles backup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Choose backup frequency:"
echo "1) Every hour"
echo "2) Every 6 hours"
echo "3) Daily (at midnight)"
echo "4) Every 12 hours"
echo "5) Custom"
echo "6) Remove cron job"
echo ""

read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        cron_expr="0 * * * *"
        ;;
    2)
        cron_expr="0 */6 * * *"
        ;;
    3)
        cron_expr="0 0 * * *"
        ;;
    4)
        cron_expr="0 */12 * * *"
        ;;
    5)
        read -p "Enter cron expression (e.g., '0 9 * * *' for daily at 9am): " cron_expr
        ;;
    6)
        if [ -f "$CRON_FILE" ]; then
            rm "$CRON_FILE"
            echo "✅ Cron job removed"
        else
            echo "ℹ️  No cron job found"
        fi
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "$cron_expr $SCRIPT_PATH" > "$CRON_FILE"
crontab "$CRON_FILE" 2>/dev/null || (crontab -l 2>/dev/null; cat "$CRON_FILE") | crontab -

echo "✅ Cron job configured:"
echo "   Expression: $cron_expr"
echo "   Script: $SCRIPT_PATH"
echo ""
echo "To view cron jobs: crontab -l"
echo "To edit cron jobs: crontab -e"
