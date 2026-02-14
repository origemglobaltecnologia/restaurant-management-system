#!/data/data/com.termux/files/usr/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/services.conf"

case "$1" in
    up)
        echo "🚀 Iniciando Infraestrutura..."
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name dir port <<< "$item"
            # Checagem dupla: Porta ou Processo Java ativo
            pid=$(lsof -t -i:$port 2>/dev/null || pgrep -f "$dir")
            if [ -n "$pid" ]; then
                echo "✅ $name já está online."
            else
                echo "🌱 Subindo $name..."
                cd "$INFRA_DIR/$dir" || continue
                nohup mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xmx256m -Xms128m" > "$LOG_DIR/${name,,}.log" 2>&1 &
                [ "$port" == "8761" ] && sleep 20 || sleep 15
            fi
        done
        ;;
    status)
        echo -e "\n📊 Monitor de Recursos (Termux Optimized):"
        echo "----------------------------------------------------"
        printf "%-18s | %-8s | %-8s\n" "Serviço" "Status" "RAM"
        echo "----------------------------------------------------"
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name dir port <<< "$item"
            # Tenta achar o PID pelo nome da pasta do projeto no comando Java
            pid=$(pgrep -f "$dir" | head -n 1)
            if [ -n "$pid" ]; then
                mem=$(ps -o rss= -p "$pid" | awk '{print int($1/1024) "MB"}' 2>/dev/null || echo "N/A")
                printf "%-18s | \e[32mON\e[0m     | %-8s\n" "$name" "$mem"
            else
                printf "%-18s | \e[31mOFF\e[0m    | -\n" "$name"
            fi
        done
        echo "----------------------------------------------------"
        ;;
    down)
        echo "🛑 Desligando serviços..."
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name dir port <<< "$item"
            pid=$(pgrep -f "$dir")
            [ -n "$pid" ] && kill $pid && echo "✅ $name parado."
        done
        ;;
    *)
        echo "Uso: ./sys.sh {up|status|down}"
        ;;
esac
