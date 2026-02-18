#!/data/data/com.termux/files/usr/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/services.conf"

get_path() {
    if [ "$1" == "infra" ]; then echo "$INFRA_DIR/$2"
    elif [ "$1" == "core" ]; then echo "$CORE_DIR/$2"
    else echo "$ROOT_DIR/$2"; fi
}

start_service() {
    local name=$1 base=$2 sub=$3 port=$4 key=$5
    
    # Pula o Employer-Service para poupar RAM
    if [ "$name" == "Employer-Service" ]; then
        echo "⏭️  $name ignorado por questões de performance."
        return
    fi

    local TARGET_PATH=$(get_path "$base" "$sub")
    
    # Flags de Memória de Sobrevivência (Mínimo absoluto)
    # -Xmx80m: Teto muito baixo
    # -Xshare:off: Economiza memória nativa de classes compartilhadas
    # -XX:-UseBiasedLocking: Reduz overhead de threads
    local JVM_OPTS="-Xms32m -Xmx80m -XX:+UseSerialGC -XX:TieredStopAtLevel=1 -Xss256k -Xshare:off"
    
    echo "🌱 Subindo $name (Modo Econômico)..."
    if [ "$name" == "Database" ]; then
        pg_ctl -D $PREFIX/var/lib/postgresql start > /dev/null 2>&1
        sleep 5
    else
        local JAR_FILE=$(find "$TARGET_PATH/target" -name "*.jar" ! -name "*-sources.jar" | head -n 1)
        
        if [ -z "$JAR_FILE" ]; then
            echo "❌ Erro: JAR não encontrado em $sub. Rode 'mvn install' primeiro."
            return
        fi

        local ARGS=""
        if [[ "$name" =~ ^(Gateway|Auth-Service|User-Service)$ ]]; then
            ARGS="--spring.config.import=optional:configserver:http://localhost:8888"
        fi

        nohup java $JVM_OPTS -jar "$JAR_FILE" $ARGS > "$LOG_DIR/${key}.log" 2>&1 &
    fi
}

case "$1" in
    up)
        echo "🚀 Iniciando Sistema (MODO PERFORMANCE - Employer OFF)..."
        mkdir -p "$LOG_DIR"
        pkill -9 java
        
        for item in "${SERVICES[@]}"; do
            IFS=':' read -r name base sub port key <<< "$item"
            start_service "$name" "$base" "$sub" "$port" "$key"
            
            # Pausas maiores para não saturar a CPU do celular
            if [[ "$port" =~ ^(8761|8888)$ ]]; then
                echo "⏳ Estabilizando Infra..."
                sleep 45
            else
                sleep 25
            fi
        done
        echo "✨ Infraestrutura básica e User-Service ativos."
        ;;

    status)
        echo -e "\n📊 Monitor de Recursos (Limite: 80MB Heap):"
        echo "----------------------------------------------------"
        printf "%-18s | %-8s | %-8s\n" "Serviço" "Status" "RAM (RSS)"
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
        ;;

    down)
        pkill -9 java
        pg_ctl -D $PREFIX/var/lib/postgresql stop > /dev/null 2>&1
        echo "✅ Cleanup completo."
        ;;
esac
