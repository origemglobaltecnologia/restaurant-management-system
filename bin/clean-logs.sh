#!/data/data/com.termux/files/usr/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$(cd "$DIR/.." && pwd)/logs"

echo "🧹 Esvaziando logs para liberar RAM e Disco..."
for log in "$LOG_DIR"/*.log; do
    [ -f "$log" ] && truncate -s 0 "$log" && echo "✅ $(basename "$log") zerado."
done
echo "✨ Sistema limpo."
