# ═══════════════════════════════════════════════════════════════════════
# 🛠️  Custom Functions
# ═══════════════════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────────────────
# 📚 Help & Documentation
# ───────────────────────────────────────────────────────────────────────

ssh-nixos() {
  ssh -X chalkan3@192.168.1.54
}
# Show keyboard shortcuts guide
keys() {
    local keybindings_file

    # Try to find KEYBINDINGS.md in common locations
    if [[ -f "$HOME/KEYBINDINGS.md" ]]; then
        keybindings_file="$HOME/KEYBINDINGS.md"
    elif [[ -f "$HOME/.config/KEYBINDINGS.md" ]]; then
        keybindings_file="$HOME/.config/KEYBINDINGS.md"
    elif [[ -f "/tmp/dotfiles_clone/KEYBINDINGS.md" ]]; then
        keybindings_file="/tmp/dotfiles_clone/KEYBINDINGS.md"
    else
        echo "❌ KEYBINDINGS.md não encontrado!"
        echo ""
        echo "Para criar o arquivo, copie do repositório:"
        echo "  cp /tmp/dotfiles_clone/KEYBINDINGS.md ~/KEYBINDINGS.md"
        return 1
    fi

    # Show with bat if available (syntax highlighting), otherwise use less
    if command -v bat &> /dev/null; then
        bat --style=full --paging=always "$keybindings_file"
    elif command -v batcat &> /dev/null; then
        batcat --style=full --paging=always "$keybindings_file"
    else
        less "$keybindings_file"
    fi
}

# Show quick cheat sheet of most used shortcuts
keycheat() {
    printf "\n\e[1;34m⌨️  Atalhos mais Usados do Terminal\e[0m\n\n"

    printf "\e[1;36m🏃 Navegação entre Palavras\e[0m\n"
    printf "  \e[33mOption + →/←\e[0m     Pular palavras\n"
    printf "  \e[33mCtrl + a/e\e[0m       Início/Fim da linha\n\n"

    printf "\e[1;36m✂️  Deletar\e[0m\n"
    printf "  \e[33mCtrl + w\e[0m         Deleta palavra anterior\n"
    printf "  \e[33mOption + d\e[0m       Deleta próxima palavra\n"
    printf "  \e[33mCtrl + k\e[0m         Deleta até fim da linha\n"
    printf "  \e[33mCtrl + u\e[0m         Deleta até início da linha\n\n"

    printf "\e[1;36m📋 Clipboard\e[0m\n"
    printf "  \e[33mCtrl + w\e[0m         Deleta e guarda\n"
    printf "  \e[33mCtrl + y\e[0m         Cola de volta\n\n"

    printf "\e[1;36m🔍 Busca\e[0m\n"
    printf "  \e[33mCtrl + r\e[0m         Busca no histórico (fzf)\n\n"

    printf "\e[1;36m🔙 Outros\e[0m\n"
    printf "  \e[33mCtrl + _\e[0m         Desfaz última edição\n"
    printf "  \e[33mCtrl + x, Ctrl + e\e[0m Abre no editor\n\n"

    printf "\e[90mPara ver guia completo: \e[32mkeys\e[0m\n\n"
}

# ───────────────────────────────────────────────────────────────────────
# 📂 Directory Operations
# ───────────────────────────────────────────────────────────────────────

# Create a directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go up N directories (usage: up 3)
up() {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# ───────────────────────────────────────────────────────────────────────
# 🔍 Search & Find
# ───────────────────────────────────────────────────────────────────────

# Find file by name (usage: ff filename)
ff() {
  fd -H -I "$1"
}

# Find in files (usage: fif "search term")
fif() {
  if [ $# -eq 0 ]; then
    echo "Usage: fif <search term>"
    return 1
  fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Search and open with nvim using fzf
flvim() {
  if [ -z "$1" ]; then
    echo "Usage: flvim <search_term>"
    return 1
  fi

  local selected
  selected=$(
    rg --line-number --no-heading --color=always "$1" |
    fzf --ansi \
        --delimiter ':' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
        --preview-window=right:60%:wrap
  )

  if [[ -n "$selected" ]]; then
    local file_path=$(echo "$selected" | cut -d: -f1)
    local line_number=$(echo "$selected" | cut -d: -f2)

    nvim +$line_number "$file_path"
  fi
}

# Interactive cd with fzf
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=1 --color=always {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# ───────────────────────────────────────────────────────────────────────
# 🗜️  Archive Operations
# ───────────────────────────────────────────────────────────────────────

# Extract common archive formats
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1"  ;;
      *.tar)     tar xf "$1"  ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1"   ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1"    ;;
      *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create an archive (usage: compress <file> <type>)
compress() {
  if [ $# -lt 2 ]; then
    echo "Usage: compress <file/directory> <type>"
    echo "Types: tar.gz, tar.bz2, zip"
    return 1
  fi

  case "$2" in
    tar.gz)  tar czf "$1.tar.gz" "$1" ;;
    tar.bz2) tar cjf "$1.tar.bz2" "$1" ;;
    zip)     zip -r "$1.zip" "$1" ;;
    *)       echo "Unknown archive type: $2" ;;
  esac
}

# ───────────────────────────────────────────────────────────────────────
# 🌐 Git Functions
# ───────────────────────────────────────────────────────────────────────

# Clone and cd into directory
gcl() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Git commit with auto-generated message based on changes
gac() {
  git add -A
  if [ -z "$1" ]; then
    git commit -v
  else
    git commit -m "$1"
  fi
}

# Delete merged branches (keeps main/master/develop)
git-clean-branches() {
  git branch --merged | egrep -v "(^\*|main|master|develop)" | xargs git branch -d
}

# Git undo - goes back N commits (usage: gundo 3)
git-undo() {
  local commits=${1:-1}
  git reset --soft HEAD~$commits
}

# Show git branch with fzf
git-branch-fzf() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# ───────────────────────────────────────────────────────────────────────
# 🐳 Docker Functions
# ───────────────────────────────────────────────────────────────────────

# Docker cleanup - remove stopped containers, unused images, networks
docker-cleanup() {
  echo "🧹 Cleaning Docker..."
  docker container prune -f
  docker image prune -f
  docker network prune -f
  docker volume prune -f
  echo "✅ Docker cleanup complete!"
}

# Docker shell into container
dsh() {
  if [ -z "$1" ]; then
    echo "Usage: dsh <container_name_or_id>"
    return 1
  fi
  docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Docker stats with formatting
dstats() {
  docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# ───────────────────────────────────────────────────────────────────────
# 🌐 Network Functions
# ───────────────────────────────────────────────────────────────────────

# Kill process running on port
port-kill() {
  if [ -z "$1" ]; then
    echo "Usage: port-kill <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9
  echo "✅ Killed process on port $1"
}

# Show what's using a port
port-check() {
  if [ -z "$1" ]; then
    echo "Usage: port-check <port>"
    return 1
  fi
  lsof -i :$1
}

# Get external IP
myip() {
  echo "Local IP:  $(ipconfig getifaddr en0)"
  echo "Public IP: $(curl -s ifconfig.me)"
}

# ───────────────────────────────────────────────────────────────────────
# 📊 System Info
# ───────────────────────────────────────────────────────────────────────

# System information
sysinfo() {
  echo "═══════════════════════════════════════════════"
  echo "🖥️  System Information"
  echo "═══════════════════════════════════════════════"
  echo "Hostname:    $(hostname)"
  echo "macOS:       $(sw_vers -productVersion)"
  echo "Kernel:      $(uname -r)"
  echo "Uptime:      $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  echo "Shell:       $SHELL"
  echo "Terminal:    $TERM"
  echo "CPU:         $(sysctl -n machdep.cpu.brand_string)"
  echo "Memory:      $(sysctl hw.memsize | awk '{print $2/1024/1024/1024 " GB"}')"
  echo "Disk Usage:  $(df -h / | awk 'NR==2{print $3"/"$2" ("$5" used)"}')"
  echo "═══════════════════════════════════════════════"
}

# ───────────────────────────────────────────────────────────────────────
# 🔧 Utilities
# ───────────────────────────────────────────────────────────────────────

# Generate QR code in terminal
qr() {
  if [ -z "$1" ]; then
    echo "Usage: qr <text or url>"
    return 1
  fi
  curl qrenco.de/"$1"
}

# URL shortener
shorten() {
  if [ -z "$1" ]; then
    echo "Usage: shorten <url>"
    return 1
  fi
  curl -s "http://tinyurl.com/api-create.php?url=$1"
}

# Generate random password
genpass() {
  local length=${1:-20}
  openssl rand -base64 48 | cut -c1-$length
}

# Create backup of file
backup() {
  if [ -z "$1" ]; then
    echo "Usage: backup <file>"
    return 1
  fi
  cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
  echo "✅ Backup created: $1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Show directory size
dirsize() {
  du -sh ${1:-.} 2>/dev/null | awk '{print $1}'
}

# Calculator (usage: calc "2+2")
calc() {
  echo "$*" | bc -l
}

# ───────────────────────────────────────────────────────────────────────
# 📡 SSH Functions
# ───────────────────────────────────────────────────────────────────────

# Connect to specific hosts
ssh-lady() {
  ssh -p 62222 chalkan3@45.55.39.104
}

ssh-keite() {
  ssh -p 62223 chalkan3@45.55.39.104
}

ssh-do-vault-01() {
  ssh chalkan3@159.65.189.46 -i ~/.ssh/id_ed25519
}

ssh-do-workload-01() {
  ssh chalkan3@138.197.88.209 -i ~/.ssh/id_ed25519
}

# Kubernetes cluster SSH shortcuts
ssh-k8s-master-1() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.10
}

ssh-k8s-master-2() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.11
}

ssh-k8s-master-3() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.12
}

ssh-k8s-worker-1() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.13
}

ssh-k8s-worker-2() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.14
}

ssh-k8s-worker-3() {
  ssh -i ~/.ssh/kubernetes-clusters/production.pem root@10.8.0.15
}

# Execute commands on remote host
ssh-exec() {
  CMD=$1
  ssh chalkan3@192.168.1.16 "${CMD}"
}

# Copy SSH key to remote server
ssh-copy-key() {
  if [ -z "$1" ]; then
    echo "Usage: ssh-copy-key <user@host>"
    return 1
  fi
  cat ~/.ssh/id_ed25519.pub | ssh "$1" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
}

# ───────────────────────────────────────────────────────────────────────
# 🦥 Raspberry Pi NTFY Listener Manager
# ───────────────────────────────────────────────────────────────────────

SCRIPT_PATH="$HOME/.local/bin/raspberry-listner.rb"
PROCESS_NAME="raspberry-listner.rb"

rpi_listener_start() {
  if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "✅ Raspberry Pi Listener is already running."
  else
    echo "🚀 Starting Raspberry Pi Listener in the background..."
    nohup "$SCRIPT_PATH" > "$HOME/.local/bin/raspberry-listner.log" 2>&1 & disown
    sleep 1
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
       echo "✅ Raspberry Pi Listener started successfully."
    else
       echo "❌ Failed to start the Raspberry Pi Listener."
    fi
  fi
}

rpi_listener_stop() {
  if pgrep -f "$PROCESS_NAME" > /dev/null; then
    echo "🛑 Stopping Raspberry Pi Listener..."
    pkill -f "$PROCESS_NAME"
    echo "✅ Raspberry Pi Listener stopped."
  else
    echo "✅ Raspberry Pi Listener was not running."
  fi
}

rpi_listener_status() {
  if pgrep -af "$PROCESS_NAME" > /dev/null; then
    echo "✅ Raspberry Pi Listener is running."
    pgrep -af "$PROCESS_NAME"
  else
    echo "❌ Raspberry Pi Listener is not running."
  fi
}

# ───────────────────────────────────────────────────────────────────────
# 📚 Help & Documentation
# ───────────────────────────────────────────────────────────────────────

# Display available custom aliases and functions
zsh-help() {
  echo "💡 \e[1mAvailable Custom Commands\e[0m
"

  echo "\e[1;34mALIASES\e[0m"
  echo "--------------------------"
  grep '^alias' ~/.zsh/aliases.zsh | cut -d'=' -f1 | sed 's/alias //' | sort | awk '{printf "  - %s\n", $1}'
  echo ""

  echo "\e[1;32mFUNCTIONS\e[0m"
  echo "--------------------------"
  grep -o '^[a-zA-Z0-9_-]\+\s*()' ~/.zsh/functions.zsh | sed 's/()//' | sort | awk '{printf "  - %s\n", $1}'
  echo ""

  echo "\e[1;33mUSAGE\e[0m"
  echo "--------------------------"
  echo "  - explore     : Interactive command explorer"
  echo "  - show <cmd>  : Show what a command does"
  echo ""
}

# Show what a command does (alias or function)
show() {
  if [ -z "$1" ]; then
    echo "Usage: show <command_name>"
    echo "Example: show gp"
    return 1
  fi

  local cmd="$1"
  local found=0

  # Check if it's an alias
  if alias "$cmd" &>/dev/null; then
    echo "\e[1;34m📌 ALIAS:\e[0m $cmd"
    echo "\e[1;37mDefinition:\e[0m"
    alias "$cmd" | sed 's/^[^=]*=/  /'
    found=1
  fi

  # Check if it's a function
  if type "$cmd" 2>/dev/null | grep -q "function"; then
    echo "\e[1;32m🔧 FUNCTION:\e[0m $cmd"
    echo "\e[1;37mDefinition:\e[0m"
    type "$cmd" | sed '1d' | sed 's/^/  /'
    found=1
  fi

  # Check if it's a binary/executable
  if command -v "$cmd" &>/dev/null && [ $found -eq 0 ]; then
    echo "\e[1;35m⚙️  EXECUTABLE:\e[0m $cmd"
    echo "\e[1;37mLocation:\e[0m $(which "$cmd")"

    # Try to show version or help
    if "$cmd" --version &>/dev/null; then
      echo "\e[1;37mVersion:\e[0m"
      "$cmd" --version 2>&1 | head -1 | sed 's/^/  /'
    fi
    found=1
  fi

  if [ $found -eq 0 ]; then
    echo "\e[1;31m❌ Command not found:\e[0m $cmd"
    return 1
  fi
}

# Interactive command explorer with fzf
explore() {
  # Create temporary file with all commands and descriptions
  local tmpfile=$(mktemp)

  echo "# ════════════════════════════════════════════════════════════" > "$tmpfile"
  echo "# 🎯 NAVIGATION & FILES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "cd (z)          │ Smart cd with zoxide (learns your habits)" >> "$tmpfile"
  echo "..              │ Go up one directory" >> "$tmpfile"
  echo "...             │ Go up two directories" >> "$tmpfile"
  echo "-               │ Go to previous directory" >> "$tmpfile"
  echo "ls              │ List files with icons (eza)" >> "$tmpfile"
  echo "ll              │ List files with git status" >> "$tmpfile"
  echo "lt              │ Tree view of files" >> "$tmpfile"
  echo "fcd             │ Interactive cd with fzf preview" >> "$tmpfile"
  echo "mkcd            │ Create directory and cd into it" >> "$tmpfile"
  echo "up <n>          │ Go up N directories (e.g., up 3)" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🔍 SEARCH & FIND" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "ff <name>       │ Find file by name" >> "$tmpfile"
  echo "fif <text>      │ Find text in files (interactive)" >> "$tmpfile"
  echo "flvim <text>    │ Search and open in nvim" >> "$tmpfile"
  echo "grep            │ Search with ripgrep (rg)" >> "$tmpfile"
  echo "find            │ Find files with fd" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🌐 GIT COMMANDS" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "gs              │ Git status (short format)" >> "$tmpfile"
  echo "ga <file>       │ Git add file" >> "$tmpfile"
  echo "gaa             │ Git add all" >> "$tmpfile"
  echo "gc <msg>        │ Git commit with message" >> "$tmpfile"
  echo "gp              │ Git push" >> "$tmpfile"
  echo "gpull           │ Git pull with rebase" >> "$tmpfile"
  echo "gco <branch>    │ Git checkout branch" >> "$tmpfile"
  echo "gcb <branch>    │ Create and checkout new branch" >> "$tmpfile"
  echo "gl              │ Git log (one line, graph)" >> "$tmpfile"
  echo "gd              │ Git diff" >> "$tmpfile"
  echo "gsta            │ Git stash" >> "$tmpfile"
  echo "gstap           │ Git stash pop" >> "$tmpfile"
  echo "gundo           │ Undo last commit (keep changes)" >> "$tmpfile"
  echo "gwip            │ Quick WIP commit" >> "$tmpfile"
  echo "gcl <url>       │ Clone repo and cd into it" >> "$tmpfile"
  echo "git-clean-branches │ Delete merged branches" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🐳 DOCKER" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "dps             │ Docker ps (list containers)" >> "$tmpfile"
  echo "dex <name>      │ Docker exec into container" >> "$tmpfile"
  echo "dsh <name>      │ Shell into container" >> "$tmpfile"
  echo "dlog <name>     │ Follow container logs" >> "$tmpfile"
  echo "dprune          │ Clean all Docker resources" >> "$tmpfile"
  echo "docker-cleanup  │ Full Docker cleanup with messages" >> "$tmpfile"
  echo "dcu             │ Docker compose up -d" >> "$tmpfile"
  echo "dcd             │ Docker compose down" >> "$tmpfile"
  echo "dcl             │ Docker compose logs -f" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# ☸️  KUBERNETES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "k               │ kubectl" >> "$tmpfile"
  echo "kgp             │ Get pods" >> "$tmpfile"
  echo "kgs             │ Get services" >> "$tmpfile"
  echo "kex <pod>       │ Exec into pod" >> "$tmpfile"
  echo "kl <pod>        │ Follow pod logs" >> "$tmpfile"
  echo "kctx <context>  │ Switch context" >> "$tmpfile"
  echo "kns <namespace> │ Switch namespace" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🌐 NETWORK & SYSTEM" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "port-kill <port> │ Kill process on port" >> "$tmpfile"
  echo "port-check <port> │ Show what's using port" >> "$tmpfile"
  echo "ports           │ Show all listening ports" >> "$tmpfile"
  echo "myip            │ Show local and public IP" >> "$tmpfile"
  echo "ip              │ Local IP address" >> "$tmpfile"
  echo "publicip        │ Public IP address" >> "$tmpfile"
  echo "speedtest       │ Run internet speed test" >> "$tmpfile"
  echo "sysinfo         │ Complete system information" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🐍 PYTHON" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "py              │ Python3" >> "$tmpfile"
  echo "venv            │ Create and activate venv" >> "$tmpfile"
  echo "venv-activate   │ Activate existing venv" >> "$tmpfile"
  echo "pipup           │ Upgrade pip, setuptools, wheel" >> "$tmpfile"
  echo "pipreq          │ Generate requirements.txt" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🔧 UTILITIES" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "cat             │ Show file with syntax (bat)" >> "$tmpfile"
  echo "extract <file>  │ Extract any archive format" >> "$tmpfile"
  echo "compress <file> <type> │ Create archive (tar.gz, zip)" >> "$tmpfile"
  echo "backup <file>   │ Create timestamped backup" >> "$tmpfile"
  echo "genpass [len]   │ Generate secure password" >> "$tmpfile"
  echo "qr <text>       │ Generate QR code in terminal" >> "$tmpfile"
  echo "weather         │ Show weather forecast" >> "$tmpfile"
  echo "json            │ Format JSON from stdin" >> "$tmpfile"
  echo "calc <expr>     │ Calculator (e.g., calc 2+2)" >> "$tmpfile"
  echo "dirsize [dir]   │ Show directory size" >> "$tmpfile"
  echo "please          │ Rerun last command with sudo" >> "$tmpfile"
  echo "reload          │ Reload zsh configuration" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# 🪟 ZELLIJ (Terminal Multiplexer)" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "zj              │ Start Zellij" >> "$tmpfile"
  echo "zjs [name]      │ Smart session (create/attach)" >> "$tmpfile"
  echo "zjp [layout]    │ Project session (named by dir)" >> "$tmpfile"
  echo "zjls            │ List sessions (pretty)" >> "$tmpfile"
  echo "zjrm            │ Delete sessions (interactive)" >> "$tmpfile"
  echo "zjdev           │ Start with dev layout" >> "$tmpfile"
  echo "zjfs            │ Start with fullstack layout" >> "$tmpfile"
  echo "zjops           │ Start with ops layout" >> "$tmpfile"
  echo "" >> "$tmpfile"

  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "# ⚙️  CONFIGURATION" >> "$tmpfile"
  echo "# ════════════════════════════════════════════════════════════" >> "$tmpfile"
  echo "edit-zshrc      │ Edit .zshrc" >> "$tmpfile"
  echo "edit-alias      │ Edit aliases" >> "$tmpfile"
  echo "edit-functions  │ Edit functions" >> "$tmpfile"
  echo "edit-plugins    │ Edit plugins" >> "$tmpfile"
  echo "edit-options    │ Edit zsh options" >> "$tmpfile"
  echo "zsh-help        │ List all commands" >> "$tmpfile"
  echo "show <cmd>      │ Show what command does" >> "$tmpfile"
  echo "explore         │ This interactive explorer" >> "$tmpfile"

  # Use fzf to select and show command
  local selection
  selection=$(cat "$tmpfile" | \
    grep -v '^#' | \
    grep -v '^$' | \
    fzf --ansi \
        --header="📚 Command Explorer - Press ENTER to see details, ESC to quit" \
        --header-first \
        --prompt="Search: " \
        --preview='echo {} | cut -d" " -f1 | xargs -I CMD zsh -ic "show CMD"' \
        --preview-window=right:60%:wrap \
        --border=rounded \
        --height=90%)

  rm "$tmpfile"

  if [[ -n "$selection" ]]; then
    local cmd=$(echo "$selection" | awk '{print $1}')
    echo "\n\e[1;36m═══════════════════════════════════════════════\e[0m"
    echo "\e[1;36m📖 Detailed view of:\e[0m $cmd"
    echo "\e[1;36m═══════════════════════════════════════════════\e[0m\n"
    show "$cmd"

    # Ask if user wants to try it
    echo "\n\e[1;33m💡 Try it now? (y/N):\e[0m \c"
    read -q response
    if [[ "$response" == "y" ]]; then
      echo "\n\e[1;32m▶ Running:\e[0m $cmd"
      print -z "$cmd "  # Pre-fill command line
    fi
  fi
}

# Show function definition (kept for backwards compatibility)
show-func() {
  show "$1"
}

# ───────────────────────────────────────────────────────────────────────
# 🪟 Zellij Session Management
# ───────────────────────────────────────────────────────────────────────

# Smart Zellij session creator/attacher
zjs() {
  if [ -z "$1" ]; then
    # No argument - show sessions and let user pick
    local sessions=$(zellij list-sessions 2>/dev/null | grep -v "^$")

    if [ -z "$sessions" ]; then
      echo "No active sessions. Creating new session..."
      zellij
    else
      # Use fzf to select session
      local selected=$(echo "$sessions" | fzf --header="Select a session to attach (Ctrl-C to create new)")

      if [ -n "$selected" ]; then
        local session_name=$(echo "$selected" | awk '{print $1}')
        zellij attach "$session_name"
      else
        # User cancelled - create new session
        zellij
      fi
    fi
  else
    # Argument provided - use it as session name
    local session_name="$1"
    local layout="$2"

    # Check if session exists
    if zellij list-sessions 2>/dev/null | grep -q "^$session_name"; then
      echo "📎 Attaching to existing session: $session_name"
      zellij attach "$session_name"
    else
      echo "🆕 Creating new session: $session_name"
      if [ -n "$layout" ]; then
        zellij --session "$session_name" --layout "$layout"
      else
        zellij --session "$session_name"
      fi
    fi
  fi
}

# Quick project session - creates/attaches to session named after current directory
zjp() {
  local project_name=$(basename "$PWD")
  local layout="${1:-dev}"

  echo "🚀 Starting Zellij session for project: $project_name"
  zjs "$project_name" "$layout"
}

# Zellij session fuzzy finder - delete session
zjrm() {
  local sessions=$(zellij list-sessions 2>/dev/null | grep -v "^$")

  if [ -z "$sessions" ]; then
    echo "No active sessions to delete."
    return
  fi

  local selected=$(echo "$sessions" | fzf --multi --header="Select sessions to delete (Tab to select multiple)")

  if [ -n "$selected" ]; then
    echo "$selected" | while read session; do
      local session_name=$(echo "$session" | awk '{print $1}')
      echo "🗑️  Deleting session: $session_name"
      zellij kill-session "$session_name"
    done
  fi
}

# List Zellij sessions with details
zjls() {
  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"
  echo "\e[1;36m📋 Active Zellij Sessions\e[0m"
  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"

  local sessions=$(zellij list-sessions 2>/dev/null)

  if [ -z "$sessions" ]; then
    echo "\e[1;33m⚠️  No active sessions\e[0m"
  else
    echo "$sessions" | while read -r line; do
      if [ -n "$line" ]; then
        echo "\e[1;32m  ▪\e[0m $line"
      fi
    done
  fi

  echo "\e[1;36m═══════════════════════════════════════════════\e[0m"
  echo "\e[1;90mTip: Use 'zjs <name>' to create/attach to a session\e[0m"
}

# Async callback (for zsh-async)
async-callback() {
    local job_name=$1
    local return_code=$2
    local output=$3
    echo "\n[Callback] The '$job_name' finished with code ($return_code) output -> $output"
    zle reset-prompt
}

# ───────────────────────────────────────────────────────────────────────
# 🌐 VPN Management
# ───────────────────────────────────────────────────────────────────────

# List all VPN hosts in the WireGuard mesh
vpn-hosts() {
  # Cores
  local GREEN='\033[0;32m'
  local BLUE='\033[0;34m'
  local YELLOW='\033[1;33m'
  local CYAN='\033[0;36m'
  local MAGENTA='\033[0;35m'
  local RED='\033[0;31m'
  local NC='\033[0m' # No Color

  echo -e "${YELLOW}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${YELLOW}║           WireGuard VPN Mesh - Available Hosts                 ║${NC}"
  echo -e "${YELLOW}╚════════════════════════════════════════════════════════════════╝${NC}\n"

  # Verificar se está conectado
  local vpn_connected=false
  if sudo wg show &>/dev/null; then
    vpn_connected=true
    echo -e "${GREEN}✓ VPN Status: CONNECTED${NC}\n"
  else
    echo -e "${YELLOW}⚠ VPN Status: DISCONNECTED${NC}"
    echo -e "  Connect with: ${BLUE}sudo wg-quick up wg-client${NC}\n"
  fi

  # Buscar peers dinamicamente do servidor VPN
  echo -e "${CYAN}📡 Fetching active peers from VPN server...${NC}\n"

  local vpn_server="172.236.112.208"
  local ssh_key="$HOME/.ssh/aws-sloth-runner-01"

  if [[ ! -f "$ssh_key" ]]; then
    echo -e "${RED}❌ SSH key not found: $ssh_key${NC}"
    echo -e "${YELLOW}Showing static host list instead...${NC}\n"
    _vpn_hosts_static
    return 1
  fi

  # Obter informações dos peers do servidor
  local peers_data=$(ssh -i "$ssh_key" -o ConnectTimeout=5 -o StrictHostKeyChecking=no root@$vpn_server "wg show wg0 dump" 2>/dev/null)

  if [[ -z "$peers_data" ]]; then
    echo -e "${RED}❌ Failed to connect to VPN server${NC}"
    echo -e "${YELLOW}Showing static host list instead...${NC}\n"
    _vpn_hosts_static
    return 1
  fi

  # Mapeamento de IPs para nomes/descrições (pode ser atualizado conforme necessário)
  typeset -A host_info
  host_info=(
    "10.8.0.1"  "AWS Hub (us-east-1)|ec2-user"
    "10.8.0.2"  "MacBook (chalkan3)|chalkan3"
    "10.8.0.3"  "DigitalOcean (nyc3)|root"
    "10.8.0.4"  "Linode Hub (us-ord)|root"
    "10.8.0.5"  "lady-guica (NixOS RPi3)|chalkan3"
    "10.8.0.6"  "keite-guica (Ubuntu RPi5)|chalkan3"
    "10.8.0.10" "master-1 (K8s Control)|root"
    "10.8.0.11" "master-2 (K8s Control)|root"
    "10.8.0.12" "master-3 (K8s Control)|root"
    "10.8.0.13" "worker-1 (K8s Worker)|root"
    "10.8.0.14" "worker-2 (K8s Worker)|root"
    "10.8.0.15" "worker-3 (K8s Worker)|root"
    "10.20.0.10" "frps-rpi-ladyguica (Slackware)|root"
    "10.20.0.11" "frps-rpi-keiteguica (Slackware)|root"
  )

  # Processar dados dos peers
  local temp_file=$(mktemp)
  local line_num=0

  while IFS=$'\t' read -r col1 col2 col3 col4 col5 col6 col7 col8; do
    ((line_num++))
    # Pular primeira linha (servidor)
    [[ $line_num -eq 1 ]] && continue

    # Parse: pubkey psk endpoint allowed_ips latest_handshake rx tx keepalive
    local pubkey="$col1"
    local psk="$col2"
    local endpoint="$col3"
    local allowed_ips="$col4"
    local latest_handshake="$col5"
    local rx="$col6"
    local tx="$col7"
    local keepalive="$col8"

    # Extrair IP do allowed_ips (formato: 10.8.0.X/32)
    local peer_ip=$(echo "$allowed_ips" | /usr/bin/grep -oE '10\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)

    if [[ -n "$peer_ip" ]]; then
      local info="${host_info[$peer_ip]}"
      local hostname="Unknown Host"
      local username="root"

      if [[ -n "$info" ]]; then
        hostname=$(echo "$info" | cut -d'|' -f1)
        username=$(echo "$info" | cut -d'|' -f2)
      fi

      # Verificar se o peer está ativo (handshake recente)
      local status_icon="🔴"
      local handshake_info="never"

      if [[ -n "$latest_handshake" && "$latest_handshake" != "0" ]]; then
        local current_time=$(date +%s)
        local handshake_age=$((current_time - latest_handshake))

        if [[ $handshake_age -lt 300 ]]; then  # Menos de 5 minutos
          status_icon="🟢"

          if [[ $handshake_age -lt 60 ]]; then
            handshake_info="${handshake_age}s ago"
          else
            handshake_info="$((handshake_age / 60))m ago"
          fi
        else
          status_icon="🟡"
          handshake_info="$((handshake_age / 60))m ago"
        fi
      fi

      # Formatação de tráfego
      local rx_mb=$((rx / 1024 / 1024))
      local tx_mb=$((tx / 1024 / 1024))
      local traffic_info="↓${rx_mb}MB ↑${tx_mb}MB"

      # Criar string de ordenação baseada no IP
      local sort_key=$(printf "%03d.%03d.%03d.%03d" $(echo "$peer_ip" | tr '.' ' '))

      echo "${sort_key}|${status_icon}|${peer_ip}|${hostname}|${handshake_info}|${traffic_info}" >> "$temp_file"
    fi
  done <<< "$peers_data"

  # Ordenar e exibir
  sort "$temp_file" | while IFS='|' read -r sort_key status_icon peer_ip hostname handshake_info traffic_info; do
    printf "${status_icon} ${GREEN}%-15s${NC} → ${BLUE}%-35s${NC} ${MAGENTA}%-15s${NC} ${CYAN}%s${NC}\n" \
      "$peer_ip" "$hostname" "$handshake_info" "$traffic_info"
  done

  rm -f "$temp_file"

  echo ""
  echo -e "${CYAN}Legend:${NC}"
  echo -e "  🟢 Online (active within 5 min)  🟡 Stale (inactive > 5 min)  🔴 Offline"
  echo ""
}

# Função auxiliar com lista estática (fallback)
_vpn_hosts_static() {
  local GREEN='\033[0;32m'
  local BLUE='\033[0;34m'
  local CYAN='\033[0;36m'
  local MAGENTA='\033[0;35m'
  local NC='\033[0m'

  echo -e "${CYAN}Cloud Servers:${NC}"
  echo -e "  ${GREEN}10.8.0.1${NC}  →  ${BLUE}AWS Hub${NC} (us-east-1) - ec2-user@10.8.0.1"
  echo -e "  ${GREEN}10.8.0.3${NC}  →  ${BLUE}DigitalOcean${NC} (nyc3) - root@10.8.0.3"
  echo -e "  ${GREEN}10.8.0.4${NC}  →  ${BLUE}Linode Hub${NC} (us-ord) - root@10.8.0.4"
  echo ""

  echo -e "${CYAN}Raspberry Pi:${NC}"
  echo -e "  ${GREEN}10.8.0.5${NC}  →  ${BLUE}lady-guica${NC} (NixOS RPi3) - chalkan3@10.8.0.5"
  echo -e "  ${GREEN}10.8.0.6${NC}  →  ${BLUE}keite-guica${NC} (Ubuntu RPi5) - chalkan3@10.8.0.6"
  echo ""

  echo -e "${MAGENTA}☸️  Kubernetes Cluster (Production):${NC}"
  echo -e "  ${GREEN}10.8.0.10${NC}  →  ${BLUE}master-1${NC} (K8s Control Plane) - root@10.8.0.10"
  echo -e "  ${GREEN}10.8.0.11${NC}  →  ${BLUE}master-2${NC} (K8s Control Plane) - root@10.8.0.11"
  echo -e "  ${GREEN}10.8.0.12${NC}  →  ${BLUE}master-3${NC} (K8s Control Plane) - root@10.8.0.12"
  echo -e "  ${GREEN}10.8.0.13${NC}  →  ${BLUE}worker-1${NC} (K8s Worker Node) - root@10.8.0.13"
  echo -e "  ${GREEN}10.8.0.14${NC}  →  ${BLUE}worker-2${NC} (K8s Worker Node) - root@10.8.0.14"
  echo -e "  ${GREEN}10.8.0.15${NC}  →  ${BLUE}worker-3${NC} (K8s Worker Node) - root@10.8.0.15"
  echo ""

  echo -e "${CYAN}Linode Private Instances (via 10.8.0.4):${NC}"
  echo -e "  ${GREEN}10.20.0.10${NC}  →  ${BLUE}frps-rpi-ladyguica${NC} (Slackware) - root@10.20.0.10"
  echo -e "  ${GREEN}10.20.0.11${NC}  →  ${BLUE}frps-rpi-keiteguica${NC} (Slackware) - root@10.20.0.11"
  echo ""
}

s3() {
  aws --profile minio --endpoint-url http://192.168.1.15:9000 s3 "$@"
}

# ===============================================
# Himalaya - Funções de Filtro Personalizadas
# ===============================================

# Buscar emails com filtro interativo
gmail-search() {
    if [[ -z "$1" ]]; then
        echo "Uso: gmail-search <termo>"
        echo "Exemplos:"
        echo "  gmail-search 'from slack'"
        echo "  gmail-search 'subject importante'"
        echo "  gmail-search 'from google and flag unseen'"
        return 1
    fi
    himalaya envelope list "$@" 2>&1 | grep -v WARN
}

# Ver emails dos últimos N dias
gmail-last-days() {
    local days=${1:-7}
    local date=$(date -v-${days}d +%Y-%m-%d)
    himalaya envelope list "after $date order by date desc" 2>&1 | grep -v WARN
}

# Ver emails importantes (Gmail Important)
gmail-important() {
    himalaya envelope list --folder "[Gmail]/Importante" 2>&1 | grep -v WARN
}

# Ver emails enviados
gmail-sent() {
    himalaya envelope list --folder "[Gmail]/E-mails enviados" 2>&1 | grep -v WARN
}

# Ver rascunhos
gmail-drafts() {
    himalaya envelope list --folder "[Gmail]/Rascunhos" 2>&1 | grep -v WARN
}

# Ver spam
gmail-spam() {
    himalaya envelope list --folder "[Gmail]/Spam" 2>&1 | grep -v WARN
}

# Ver lixeira
gmail-trash() {
    himalaya envelope list --folder "[Gmail]/Lixeira" 2>&1 | grep -v WARN
}

# Ver emails com anexos (busca por padrões comuns)
gmail-attachments() {
    himalaya envelope list "body attachment or body anexo or body attached" 2>&1 | grep -v WARN
}

# Dashboard do Gmail - Resumo geral
gmail-dashboard() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📧 GMAIL DASHBOARD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📬 Não lidos:"
    himalaya envelope list --page-size 5 "flag unseen" 2>&1 | grep -v WARN
    echo ""
    echo "⭐ Com estrela:"
    himalaya envelope list --page-size 5 "flag flagged" 2>&1 | grep -v WARN
    echo ""
    echo "📅 Hoje:"
    himalaya envelope list --page-size 5 "date $(date +%Y-%m-%d)" 2>&1 | grep -v WARN
}

# Buscar emails por remetente
gmail-from() {
    if [[ -z "$1" ]]; then
        echo "Uso: gmail-from <remetente>"
        return 1
    fi
    himalaya envelope list "from $1" 2>&1 | grep -v WARN
}

# Buscar emails por destinatário
gmail-to() {
    if [[ -z "$1" ]]; then
        echo "Uso: gmail-to <destinatario>"
        return 1
    fi
    himalaya envelope list "to $1" 2>&1 | grep -v WARN
}

# Ver emails de um período específico
gmail-between() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Uso: gmail-between <data-inicio> <data-fim>"
        echo "Exemplo: gmail-between 2025-11-01 2025-11-03"
        return 1
    fi
    himalaya envelope list "after $1 and before $2 order by date desc" 2>&1 | grep -v WARN
}


# Lista todos os comandos disponíveis do Gmail
gmail-list-commands() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📧 HIMALAYA/GMAIL - COMANDOS DISPONÍVEIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔷 COMANDOS BÁSICOS:"
    echo "  him                     - Himalaya"
    echo "  himl                    - Listar emails"
    echo "  himr <id>               - Ler email"
    echo "  hims                    - Enviar email"
    echo "  himw                    - Escrever email (editor)"
    echo ""
    echo "🔷 VISUALIZAÇÕES RÁPIDAS:"
    echo "  gmail-unread            - Emails não lidos"
    echo "  gmail-starred           - Emails com estrela"
    echo "  gmail-today             - Emails de hoje"
    echo "  gmail-week              - Emails dos últimos 7 dias"
    echo "  gmail-dashboard         - Dashboard completo"
    echo ""
    echo "🔷 FILTROS POR REMETENTE:"
    echo "  gmail-google            - Emails do Google"
    echo "  gmail-slack             - Emails do Slack"
    echo "  gmail-from <remetente>  - Emails de um remetente"
    echo "  gmail-to <destinatario> - Emails para um destinatário"
    echo ""
    echo "🔷 PASTAS ESPECIAIS:"
    echo "  gmail-important         - Pasta Importante"
    echo "  gmail-sent              - Emails enviados"
    echo "  gmail-drafts            - Rascunhos"
    echo "  gmail-spam              - Spam"
    echo "  gmail-trash             - Lixeira"
    echo ""
    echo "🔷 BUSCA AVANÇADA:"
    echo "  gmail-search 'query'    - Busca personalizada"
    echo "  gmail-last-days <n>     - Emails dos últimos N dias"
    echo "  gmail-between <d1> <d2> - Emails entre datas"
    echo "  gmail-attachments       - Emails com anexos"
    echo ""
    echo "🔷 AÇÕES:"
    echo "  gmail-mark-read <id> seen    - Marcar como lido"
    echo "  gmail-star <id> flagged      - Adicionar estrela"
    echo "  gmail-delete <id>            - Deletar email"
    echo ""
    echo "🔷 EXEMPLOS DE BUSCA:"
    echo "  gmail-search 'from slack and flag unseen'"
    echo "  gmail-search 'subject importante'"
    echo "  gmail-search 'after 2025-11-01 order by date desc'"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Use 'gmail-help' para ver esta lista novamente"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}


# ===============================================
# Google Calendar (gcalcli) - Funções Úteis
# ===============================================

# Dashboard do calendário
gcal-dashboard() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📅 GOOGLE CALENDAR DASHBOARD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📆 Hoje:"
    ~/gcalcli-wrapper.sh agenda
    echo ""
    echo "📅 Esta Semana:"
    ~/gcalcli-wrapper.sh calw
}

# Próximos N eventos
gcal-next() {
    local count=${1:-5}
    ~/gcalcli-wrapper.sh agenda --detail-length 50 --limit "$count"
}

# Adicionar evento rápido (linguagem natural)
# Exemplo: gcal-add-quick "Reunião amanhã às 15h"
gcal-add-quick() {
    if [[ -z "$1" ]]; then
        echo "Uso: gcal-add-quick 'descrição do evento'"
        echo "Exemplo: gcal-add-quick 'Reunião amanhã às 15h'"
        return 1
    fi
    ~/gcalcli-wrapper.sh quick "$1"
}

# Ver eventos de amanhã
gcal-tomorrow() {
    ~/gcalcli-wrapper.sh agenda tomorrow
}

# Ver eventos de uma data específica
gcal-date() {
    if [[ -z "$1" ]]; then
        echo "Uso: gcal-date <data>"
        echo "Exemplo: gcal-date 2025-11-05"
        return 1
    fi
    ~/gcalcli-wrapper.sh agenda "$1"
}

# Ajuda do gcalcli
gcal-help() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📅 GCALCLI - COMANDOS DISPONÍVEIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔷 VISUALIZAÇÕES:"
    echo "  gcal-today         - Agenda de hoje"
    echo "  gcal-tomorrow      - Agenda de amanhã"
    echo "  gcal-week          - Calendário da semana"
    echo "  gcal-month         - Calendário do mês"
    echo "  gcal-next <n>      - Próximos N eventos"
    echo "  gcal-dashboard     - Dashboard completo"
    echo ""
    echo "🔷 ADICIONAR EVENTOS:"
    echo "  gcal-add-quick 'texto'  - Adicionar com linguagem natural"
    echo "  gcal-add                - Adicionar interativo"
    echo ""
    echo "🔷 BUSCAR:"
    echo "  gcal-search <termo>     - Buscar eventos"
    echo "  gcal-date <data>        - Ver eventos de uma data"
    echo ""
    echo "🔷 GERENCIAR:"
    echo "  gcal-list               - Listar calendários"
    echo "  gcal                    - Comando principal"
    echo ""
    echo "🔷 EXEMPLOS:"
    echo "  gcal-add-quick 'Dentista sexta às 14h'"
    echo "  gcal-search 'reunião'"
    echo "  gcal-date 2025-11-10"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

