# ═══════════════════════════════════════════════════════════════════════
# ⚡ Advanced Zsh Features - Sistema Imponente
# ═══════════════════════════════════════════════════════════════════════

# Remove any existing aliases to avoid conflicts
unalias gstatus 2>/dev/null

# ───────────────────────────────────────────────────────────────────────
# ⏱️  Command Timing - Mostra tempo de execução de comandos
# ───────────────────────────────────────────────────────────────────────
typeset -g CMD_START_TIME
typeset -g CMD_END_TIME
typeset -g LAST_CMD_DURATION

# Hook antes do comando
preexec() {
    CMD_START_TIME=$SECONDS
}

# Hook depois do comando
precmd() {
    local exit_status=$?

    if [[ -n $CMD_START_TIME ]]; then
        CMD_END_TIME=$SECONDS
        LAST_CMD_DURATION=$((CMD_END_TIME - CMD_START_TIME))

        # Notificar se comando demorou mais de 10 segundos
        if [[ $LAST_CMD_DURATION -gt 10 ]]; then
            printf "\n⏱️  \033[33mComando levou ${LAST_CMD_DURATION}s\033[0m "
            if [[ $exit_status -eq 0 ]]; then
                printf "\033[32m✓\033[0m\n"
            else
                printf "\033[31m✗ (exit $exit_status)\033[0m\n"
            fi
        fi

        unset CMD_START_TIME
    fi
}

# ───────────────────────────────────────────────────────────────────────
# 📊 Last Command Info - Informações do último comando
# ───────────────────────────────────────────────────────────────────────
lastcmd() {
    local last_cmd=$(fc -ln -1 | sed 's/^[ \t]*//')
    local exit_code=$?

    printf "\n\033[1;36m📊 Último Comando\033[0m\n"
    printf "\033[90m├──\033[0m \033[32mComando:\033[0m   $last_cmd\n"

    if [[ -n $LAST_CMD_DURATION ]]; then
        printf "\033[90m├──\033[0m \033[32mDuração:\033[0m   ${LAST_CMD_DURATION}s\n"
    fi

    printf "\033[90m└──\033[0m \033[32mStatus:\033[0m    "
    if [[ $exit_code -eq 0 ]]; then
        printf "\033[32m✓ sucesso\033[0m\n"
    else
        printf "\033[31m✗ erro (exit $exit_code)\033[0m\n"
    fi
    printf "\n"
}

# ───────────────────────────────────────────────────────────────────────
# 🔍 Enhanced History Search
# ───────────────────────────────────────────────────────────────────────
# Search history with context
hsearch() {
    if [[ -z "$1" ]]; then
        echo "Uso: hsearch <termo>"
        return 1
    fi

    printf "\n\033[1;36m🔍 Buscando '$1' no histórico:\033[0m\n\n"

    # Search with line numbers and timestamps
    fc -l 1 | grep -i "$1" | tail -20 | while read -r line; do
        printf "\033[90m%s\033[0m\n" "$line"
    done

    printf "\n"
}

# ───────────────────────────────────────────────────────────────────────
# 🎨 Directory Info - Info avançada do diretório atual
# ───────────────────────────────────────────────────────────────────────
dirinfo() {
    local dir=${1:-.}

    printf "\n\033[1;36m📁 Informações do Diretório\033[0m\n"
    printf "\033[90m├──\033[0m \033[32mPath:\033[0m       $(realpath "$dir")\n"

    # Count files and directories
    local files=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    local dirs=$(find "$dir" -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    dirs=$((dirs - 1)) # Remove o próprio diretório da contagem

    printf "\033[90m├──\033[0m \033[32mArquivos:\033[0m   $files\n"
    printf "\033[90m├──\033[0m \033[32mPastas:\033[0m     $dirs\n"

    # Size
    local size=$(du -sh "$dir" 2>/dev/null | awk '{print $1}')
    printf "\033[90m├──\033[0m \033[32mTamanho:\033[0m    $size\n"

    # Permissions (cross-platform)
    local perms=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (BSD stat)
        perms=$(stat -f "%Sp" "$dir" 2>/dev/null)
    else
        # Linux (GNU stat)
        perms=$(stat -c "%A" "$dir" 2>/dev/null)
    fi
    printf "\033[90m├──\033[0m \033[32mPermissões:\033[0m ${perms:-N/A}\n"

    # Git info if in repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        printf "\033[90m└──\033[0m \033[32mGit:\033[0m        $branch\n"
    else
        printf "\033[90m└──\033[0m \033[32mGit:\033[0m        não é repositório\n"
    fi

    printf "\n"
}

# ───────────────────────────────────────────────────────────────────────
# 🚀 Quick CD - Navegação rápida para projetos
# ───────────────────────────────────────────────────────────────────────
# Define common project directories
typeset -A PROJECT_DIRS
PROJECT_DIRS=(
    home "$HOME"
    config "$HOME/.config"
    projects "$HOME/projects"
    work "$HOME/work"
    downloads "$HOME/Downloads"
    docs "$HOME/Documents"
)

# Quick jump to project dirs
jump() {
    if [[ -z "$1" ]]; then
        printf "\n\033[1;36m🚀 Quick Jump\033[0m\n\n"
        printf "Atalhos disponíveis:\n"
        for key val in ${(kv)PROJECT_DIRS}; do
            printf "  \033[33m%-12s\033[0m → %s\n" "$key" "$val"
        done
        printf "\nUso: jump <atalho>\n\n"
        return 0
    fi

    local target=${PROJECT_DIRS[$1]}
    if [[ -n "$target" ]]; then
        cd "$target" && printf "📂 %s\n" "$(pwd)"
    else
        echo "❌ Atalho '$1' não encontrado. Use 'jump' para ver atalhos disponíveis."
        return 1
    fi
}

# Add alias for jump
alias j='jump'

# ───────────────────────────────────────────────────────────────────────
# 🎯 Smart Extract - Extrai qualquer arquivo comprimido
# ───────────────────────────────────────────────────────────────────────
extract() {
    if [[ -z "$1" ]]; then
        echo "Uso: extract <arquivo>"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        echo "❌ Arquivo '$1' não encontrado"
        return 1
    fi

    printf "📦 Extraindo: %s\n" "$1"

    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)           echo "❌ Formato não suportado: '$1'" ;;
    esac

    [[ $? -eq 0 ]] && printf "\033[32m✓\033[0m Extração concluída\n" || printf "\033[31m✗\033[0m Erro na extração\n"
}

# ───────────────────────────────────────────────────────────────────────
# 🔥 Process Management - Gerenciamento avançado de processos
# ───────────────────────────────────────────────────────────────────────
# Find and kill process by name
killp() {
    if [[ -z "$1" ]]; then
        echo "Uso: killp <nome_do_processo>"
        return 1
    fi

    local pids=$(pgrep -f "$1")

    if [[ -z "$pids" ]]; then
        echo "❌ Nenhum processo encontrado com '$1'"
        return 1
    fi

    printf "\n\033[1;36m🎯 Processos encontrados:\033[0m\n\n"
    ps -p $pids -o pid,user,%cpu,%mem,command

    printf "\n\033[33m⚠️  Deseja matar estes processos? [y/N]:\033[0m "
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill $pids && printf "\033[32m✓\033[0m Processos terminados\n" || printf "\033[31m✗\033[0m Erro ao terminar processos\n"
    else
        echo "Operação cancelada"
    fi
}

# Show top processes
toph() {
    local limit=${1:-10}
    printf "\n\033[1;36m🔥 Top $limit Processos (CPU)\033[0m\n\n"
    ps aux | sort -rk 3,3 | head -n $((limit + 1)) | awk 'NR==1 || NR>1 {printf "%-8s %-8s %5s %5s %s\n", $2, $1, $3"%", $4"%", $11}'
    printf "\n"
}

# Show top memory processes
topm() {
    local limit=${1:-10}
    printf "\n\033[1;36m🧠 Top $limit Processos (Memória)\033[0m\n\n"
    ps aux | sort -rk 4,4 | head -n $((limit + 1)) | awk 'NR==1 || NR>1 {printf "%-8s %-8s %5s %5s %s\n", $2, $1, $3"%", $4"%", $11}'
    printf "\n"
}

# ───────────────────────────────────────────────────────────────────────
# 📝 Note Taking - Sistema simples de notas
# ───────────────────────────────────────────────────────────────────────
NOTES_DIR="$HOME/.notes"
mkdir -p "$NOTES_DIR"

# Quick note
note() {
    local note_file="$NOTES_DIR/$(date +%Y-%m-%d).md"

    if [[ -z "$1" ]]; then
        # Open today's note in editor
        ${EDITOR:-vim} "$note_file"
    else
        # Append note with timestamp
        echo "## $(date +%H:%M:%S)" >> "$note_file"
        echo "$*" >> "$note_file"
        echo "" >> "$note_file"
        printf "\033[32m✓\033[0m Nota adicionada em %s\n" "$(basename $note_file)"
    fi
}

# List notes
notes() {
    printf "\n\033[1;36m📝 Notas Recentes\033[0m\n\n"
    ls -t "$NOTES_DIR"/*.md 2>/dev/null | head -10 | while read -r file; do
        local date=$(basename "$file" .md)
        local lines=$(wc -l < "$file")
        printf "  \033[33m%s\033[0m (%d linhas)\n" "$date" "$lines"
    done
    printf "\n\033[90mUso: note [mensagem]  - Adicionar nota\033[0m\n"
    printf "\033[90m     notes           - Listar notas\033[0m\n\n"
}
