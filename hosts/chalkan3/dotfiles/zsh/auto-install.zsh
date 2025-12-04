# ═══════════════════════════════════════════════════════════════════════
# 🔧 Auto-install Missing Tools
# ═══════════════════════════════════════════════════════════════════════
# Automatically installs essential CLI tools if they're missing
#
# ✅ Supported Systems:
#   - macOS (Homebrew)
#   - Ubuntu/Debian (apt)
#   - Arch Linux (pacman)
#   - Fedora/RHEL (dnf)
#
# 📝 Notes:
#   - Ubuntu: eza requires adding third-party repo
#   - Ubuntu: fd-find installs as 'fdfind' command (alias handled automatically)
#   - Ubuntu: bat installs as 'batcat' command (alias handled automatically)
#   - Arch: All tools available in official repos
#   - Checks only once per day to avoid slowing down shell startup

# List of essential tools
ESSENTIAL_TOOLS=(
    "zoxide:smarter cd"
    "eza:modern ls"
    "bat:better cat"
    "fd:faster find"
    "ripgrep:better grep"
    "fzf:fuzzy finder"
    "git-delta:better git diff"
    "direnv:auto load env"
)

# Detect package manager
detect_package_manager() {
    if command -v brew &> /dev/null; then
        echo "brew"
    elif command -v apt &> /dev/null; then
        echo "apt"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

# Get install command for tool based on package manager
get_install_cmd() {
    local tool=$1
    local pm=$2

    case $pm in
        brew)
            # Special cases for brew
            case $tool in
                ripgrep) echo "brew install ripgrep" ;;
                *) echo "brew install $tool" ;;
            esac
            ;;
        apt)
            # Special cases for apt
            case $tool in
                fd) echo "sudo apt install -y fd-find" ;;
                bat) echo "sudo apt install -y bat" ;;
                eza)
                    # eza requires adding a repository on Ubuntu/Debian
                    echo "sudo mkdir -p /etc/apt/keyrings && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && echo 'deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main' | sudo tee /etc/apt/sources.list.d/gierens.list && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && sudo apt update && sudo apt install -y eza"
                    ;;
                ripgrep) echo "sudo apt install -y ripgrep" ;;
                git-delta)
                    # git-delta may not be in older Ubuntu versions, install from GitHub releases
                    echo "wget -q https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb -O /tmp/git-delta.deb && sudo dpkg -i /tmp/git-delta.deb && rm /tmp/git-delta.deb"
                    ;;
                *) echo "sudo apt install -y $tool" ;;
            esac
            ;;
        pacman)
            # Arch Linux - most tools are in official repos
            case $tool in
                ripgrep) echo "sudo pacman -S --noconfirm ripgrep" ;;
                git-delta) echo "sudo pacman -S --noconfirm git-delta" ;;
                *) echo "sudo pacman -S --noconfirm $tool" ;;
            esac
            ;;
        dnf)
            case $tool in
                fd) echo "sudo dnf install -y fd-find" ;;
                bat) echo "sudo dnf install -y bat" ;;
                ripgrep) echo "sudo dnf install -y ripgrep" ;;
                git-delta) echo "sudo dnf install -y git-delta" ;;
                *) echo "sudo dnf install -y $tool" ;;
            esac
            ;;
    esac
}

# Check and install missing tools
auto_install_tools() {
    local pm=$(detect_package_manager)
    local missing_tools=()

    if [[ "$pm" == "unknown" ]]; then
        return
    fi

    # Check which tools are missing
    for tool_info in "${ESSENTIAL_TOOLS[@]}"; do
        local tool="${tool_info%%:*}"
        local desc="${tool_info##*:}"

        # Special check for bat/batcat
        if [[ "$tool" == "bat" ]]; then
            if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
                missing_tools+=("$tool_info")
            fi
        # Special check for fd/fdfind
        elif [[ "$tool" == "fd" ]]; then
            if ! command -v fd &> /dev/null && ! command -v fdfind &> /dev/null; then
                missing_tools+=("$tool_info")
            fi
        # Special check for ripgrep (rg command)
        elif [[ "$tool" == "ripgrep" ]]; then
            if ! command -v rg &> /dev/null; then
                missing_tools+=("$tool_info")
            fi
        else
            if ! command -v "$tool" &> /dev/null; then
                missing_tools+=("$tool_info")
            fi
        fi
    done

    # If no missing tools, return early
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        return
    fi

    # Show missing tools
    printf "\n\e[33m⚠️  Missing tools detected:\e[0m\n"
    for tool_info in "${missing_tools[@]}"; do
        local tool="${tool_info%%:*}"
        local desc="${tool_info##*:}"
        printf "  • \e[36m%-12s\e[0m %s\n" "$tool" "$desc"
    done

    printf "\n\e[34m🔧 Auto-installing missing tools...\e[0m\n\n"

    # Install each missing tool
    for tool_info in "${missing_tools[@]}"; do
        local tool="${tool_info%%:*}"
        local cmd=$(get_install_cmd "$tool" "$pm")

        if [[ -n "$cmd" ]]; then
            printf "\e[32m→\e[0m Installing \e[36m%s\e[0m...\n" "$tool"
            eval "$cmd" &> /dev/null

            if [[ $? -eq 0 ]]; then
                printf "  \e[32m✓\e[0m %s installed successfully\n" "$tool"
            else
                printf "  \e[31m✗\e[0m Failed to install %s\n" "$tool"
            fi
        fi
    done

    printf "\n\e[32m✓ Installation complete!\e[0m\n"
    printf "\e[33m→ Restart your terminal or run 'source ~/.zshrc'\e[0m\n\n"
}

# Only run auto-install once per day to avoid slowing down shell startup
INSTALL_CHECK_FILE="$HOME/.cache/zsh_auto_install_check"
INSTALL_CHECK_INTERVAL=86400  # 24 hours in seconds

should_check_install() {
    if [[ ! -f "$INSTALL_CHECK_FILE" ]]; then
        return 0
    fi

    local last_check=$(cat "$INSTALL_CHECK_FILE" 2>/dev/null || echo 0)
    local current_time=$(date +%s)
    local time_diff=$((current_time - last_check))

    if [[ $time_diff -gt $INSTALL_CHECK_INTERVAL ]]; then
        return 0
    fi

    return 1
}

update_install_check() {
    mkdir -p "$(dirname "$INSTALL_CHECK_FILE")"
    date +%s > "$INSTALL_CHECK_FILE"
}

# Run auto-install check
if should_check_install; then
    auto_install_tools
    update_install_check
fi
