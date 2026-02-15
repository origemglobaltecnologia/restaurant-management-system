#!/data/data/com.termux/files/usr/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/services.conf"

get_path() {
    if [ "$1" == "infra" ]; then echo "$INFRA_DIR/$2"
    elif [ "$1" == "core" ]; then echo "$CORE_DIR/$2"
    else echo "$ROOT_DIR/$2"; fi
}

case "$1" in
    up)
        echo "🚀 Iniciando Sistema (Modo Otimizado)..."
        mkdir -p "$LOG_DIR"
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name base sub port key <<< "$item"
            pid=$(pgrep -f "$key" | head -n 1)
            
            if [ -n "$pid" ]; then
                echo "✅ $name já está online."
            else
                TARGET_PATH=$(get_path "$base" "$sub")
                echo "🌱 Subindo $name..."
                
                if [ "$name" == "Database" ]; then
                    pg_ctl -D $PREFIX/var/lib/postgresql start > /dev/null 2>&1
                    sleep 4
                else
                    cd "$TARGET_PATH"
                    
                    # Argumentos de importação do Config Server para serviços dependentes
                    if [[ "$name" =~ ^(Gateway|Auth-Service|User-Service)$ ]]; then
                        CMD_ARGS="-Dspring-boot.run.arguments='--spring.config.import=optional:configserver:http://localhost:8888'"
                    else
                        CMD_ARGS=""
                    fi

                    # Rodando com limites de memória para estabilidade no Termux
                    nohup mvn spring-boot:run $CMD_ARGS -Dspring-boot.run.jvmArguments="-Xmx180m -Xms128m" > "$LOG_DIR/${key}.log" 2>&1 &
                    
                    [[ "$port" =~ ^(8761|8888)$ ]] && sleep 25 || sleep 15
                fi
            fi
        done
        echo "✨ Sistema pronto. Employer-Service mantido em OFF para poupar RAM."
        ;;

    status)
        echo -e "\n📊 Monitor de Recursos:"
        echo "----------------------------------------------------"
        printf "%-18s | %-8s | %-8s\n" "Serviço" "Status" "RAM"
        echo "----------------------------------------------------"
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name base sub port key <<< "$item"
            pid=$(pgrep -f "$key" | head -n 1)
            if [ -n "$pid" ]; then
                mem=$(ps -o rss= -p "$pid" | awk '{print int($1/1024) "MB"}' 2>/dev/null || echo "??")
                printf "%-18s | \e[32mON\e[0m     | %-8s\n" "$name" "$mem"
            else
                printf "%-18s | \e[31mOFF\e[0m    | -\n" "$name"
            fi
        done
        # Verificação extra manual do Employer para você não perder o controle
        emp_pid=$(pgrep -f "employer-service" | head -n 1)
        if [ -n "$emp_pid" ]; then
            mem_emp=$(ps -o rss= -p "$emp_pid" | awk '{print int($1/1024) "MB"}' 2>/dev/null)
            printf "%-18s | \e[33mMANUAL\e[0m | %-8s\n" "Employer-Service" "$mem_emp"
        fi
        echo "----------------------------------------------------"
        ;;

    down)
        echo "🛑 Desligando..."
        # Mata os serviços da lista e também o employer caso ele tenha sido subido manualmente
        for key in "postgres" "discovery-server" "config-server" "auth-service" "api-gateway" "user-service" "employer-service"; do
            pid=$(pgrep -f "$key")
            if [ -n "$pid" ]; then
                [ "$key" == "postgres" ] && pg_ctl -D $PREFIX/var/lib/postgresql stop > /dev/null 2>&1 || kill -9 $pid
            fi
        done
        echo "✅ Todos os serviços (incluindo manuais) foram parados."
        ;;
esac
