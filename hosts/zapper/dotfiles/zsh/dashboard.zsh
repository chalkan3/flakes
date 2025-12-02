# ═══════════════════════════════════════════════════════════════════════
# 📊 Terminal Dashboard - Sistema Imponente
# ═══════════════════════════════════════════════════════════════════════

# Remove any existing alias to avoid conflicts
unalias dashboard 2>/dev/null

# Show system dashboard
dashboard() {
    local cols=$(tput cols)
    local blue='\033[34m'
    local cyan='\033[36m'
    local green='\033[32m'
    local yellow='\033[33m'
    local red='\033[31m'
    local magenta='\033[35m'
    local bold='\033[1m'
    local reset='\033[0m'
    local gray='\033[90m'

    # Header
    printf "\n${bold}${blue}"
    printf "╔════════════════════════════════════════════════════════════════════════════╗\n"
    printf "║                           🚀 SYSTEM DASHBOARD                              ║\n"
    printf "╚════════════════════════════════════════════════════════════════════════════╝${reset}\n\n"

    # System Info Section
    printf "${bold}${cyan}📡 Sistema${reset}\n"
    printf "${gray}├──${reset} ${green}Host:${reset}      $(hostname)\n"
    printf "${gray}├──${reset} ${green}User:${reset}      $USER\n"
    printf "${gray}├──${reset} ${green}Shell:${reset}     $SHELL (Zsh $ZSH_VERSION)\n"
    printf "${gray}├──${reset} ${green}OS:${reset}        $(uname -s) $(uname -r)\n"
    printf "${gray}└──${reset} ${green}Uptime:${reset}    $(uptime | awk '{print $3,$4}' | sed 's/,//')\n"
    printf "\n"

    # Git Info (if in git repo)
    if git rev-parse --git-dir > /dev/null 2>&1; then
        printf "${bold}${cyan}🔱 Git Repository${reset}\n"
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        local repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        local status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
        local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")

        printf "${gray}├──${reset} ${green}Repo:${reset}      $repo\n"
        printf "${gray}├──${reset} ${green}Branch:${reset}    $branch\n"
        printf "${gray}├──${reset} ${green}Changes:${reset}   "
        if [[ $status -gt 0 ]]; then
            printf "${yellow}$status modified${reset}\n"
        else
            printf "${green}clean${reset}\n"
        fi

        if [[ $ahead -gt 0 ]] || [[ $behind -gt 0 ]]; then
            printf "${gray}└──${reset} ${green}Sync:${reset}      "
            [[ $ahead -gt 0 ]] && printf "${green}↑$ahead${reset} "
            [[ $behind -gt 0 ]] && printf "${red}↓$behind${reset}"
            printf "\n"
        else
            printf "${gray}└──${reset} ${green}Sync:${reset}      ${green}✓ in sync${reset}\n"
        fi
        printf "\n"
    fi

    # Disk Usage
    printf "${bold}${cyan}💾 Disk Usage${reset}\n"
    if command -v df &> /dev/null; then
        df -h / | awk 'NR==2 {
            used=$3; total=$2; percent=$5;
            printf "'${gray}'├──'${reset}' '${green}'Used:'${reset}'      %s / %s (%s)\n", used, total, percent
        }'

        # Home directory size
        local home_size=$(du -sh ~ 2>/dev/null | awk '{print $1}')
        printf "${gray}└──${reset} ${green}Home:${reset}      $home_size\n"
    fi
    printf "\n"

    # Memory Info (cross-platform)
    printf "${bold}${cyan}🧠 Memory${reset}\n"
    if command -v free &> /dev/null; then
        # Linux (Ubuntu, Arch, etc)
        free -h | awk '/^Mem:/ {printf "'${gray}'└──'${reset}' '${green}'RAM:'${reset}'       %s / %s\n", $3, $2}'
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        local total_mem=$(sysctl -n hw.memsize 2>/dev/null | awk '{printf "%.1fGB", $0/1073741824}')
        local used_mem=$(vm_stat 2>/dev/null | awk '/Pages active/ {print $3}' | sed 's/\.//' | awk '{printf "%.1fGB", ($1*4096)/1073741824}')
        printf "${gray}└──${reset} ${green}RAM:${reset}       ${used_mem:-N/A} / ${total_mem:-N/A}\n"
    else
        printf "${gray}└──${reset} ${green}RAM:${reset}       N/A\n"
    fi
    printf "\n"

    # Running Processes
    printf "${bold}${cyan}⚡ Processos${reset}\n"
    local total_procs=$(ps aux | wc -l | tr -d ' ')
    printf "${gray}└──${reset} ${green}Total:${reset}     $total_procs processos\n"
    printf "\n"

    # Network Info (cross-platform)
    printf "${bold}${cyan}🌐 Network${reset}\n"
    local ip=""
    if command -v ip &> /dev/null; then
        # Linux modern (ip command)
        ip=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)
    elif command -v ifconfig &> /dev/null; then
        # macOS or Linux with ifconfig
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
        else
            ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d: -f2 | head -1)
        fi
    fi
    printf "${gray}└──${reset} ${green}IP:${reset}        ${ip:-N/A}\n"
    printf "\n"

    # Recent Commands
    printf "${bold}${cyan}📜 Últimos Comandos${reset}\n"
    fc -ln -5 | sed 's/^[ \t]*//' | awk '{printf "'${gray}'├──'${reset}' %s\n", $0}'
    printf "${gray}└──${reset} ${yellow}Comandos totais no histórico: $(fc -l | wc -l | tr -d ' ')${reset}\n"
    printf "\n"

    # Quick Commands
    printf "${bold}${cyan}⚡ Comandos Rápidos${reset}\n"
    printf "${gray}├──${reset} ${magenta}keys${reset}       Ver atalhos de teclado\n"
    printf "${gray}├──${reset} ${magenta}explore${reset}    Explorar comandos disponíveis\n"
    printf "${gray}├──${reset} ${magenta}gs${reset}         Git status\n"
    printf "${gray}└──${reset} ${magenta}reload${reset}     Recarregar configuração\n"
    printf "\n"

    # Footer
    printf "${gray}$(printf '─%.0s' {1..$cols})${reset}\n"
    printf "${bold}${blue}💡 Dica:${reset} Use ${yellow}dashboard${reset} para ver este painel novamente\n\n"
}

# Show git status with rich formatting
gstatus() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Não é um repositório git"
        return 1
    fi

    local blue='\033[34m'
    local cyan='\033[36m'
    local green='\033[32m'
    local yellow='\033[33m'
    local red='\033[31m'
    local bold='\033[1m'
    local reset='\033[0m'
    local gray='\033[90m'

    printf "\n${bold}${blue}╔════════════════════════════════════════════════════════════════════════════╗${reset}\n"
    printf "${bold}${blue}║                           🔱 GIT STATUS                                   ║${reset}\n"
    printf "${bold}${blue}╚════════════════════════════════════════════════════════════════════════════╝${reset}\n\n"

    # Repository info
    local repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
    local branch=$(git branch --show-current 2>/dev/null || echo "detached")
    local commit=$(git rev-parse --short HEAD 2>/dev/null)
    local remote=$(git remote get-url origin 2>/dev/null || echo "none")

    printf "${bold}${cyan}📦 Repository:${reset} $repo\n"
    printf "${bold}${cyan}🌿 Branch:${reset}     $branch\n"
    printf "${bold}${cyan}📍 Commit:${reset}     $commit\n"
    printf "${bold}${cyan}🔗 Remote:${reset}     $remote\n"
    printf "\n"

    # Status
    git status -sb --porcelain | head -20
    printf "\n"

    # Recent commits
    printf "${bold}${cyan}📜 Recent Commits:${reset}\n"
    git log --oneline --decorate --graph -5
    printf "\n"
}
