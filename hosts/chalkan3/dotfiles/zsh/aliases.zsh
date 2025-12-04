# ═══════════════════════════════════════════════════════════════════════
# 🎯 Custom Aliases
# ═══════════════════════════════════════════════════════────────════════

# ───────────────────────────────────────────────────────────────────────
# 🚀 Super Commands - Sistema Imponente
# ───────────────────────────────────────────────────────────────────────
# Note: As funções dashboard, dirinfo, lastcmd, etc estão definidas em
# ~/.zsh/dashboard.zsh e ~/.zsh/advanced.zsh
alias dash='dashboard'
alias info='dirinfo'
alias last='lastcmd'
alias gst='gstatus'
alias h='hsearch'
alias top10='toph 10'
alias mem10='topm 10'

# ───────────────────────────────────────────────────────────────────────
# 🔧 Cross-platform Command Compatibility
# ───────────────────────────────────────────────────────────────────────
# Handle different command names across distros

# bat (Ubuntu uses 'batcat', others use 'bat')
# Only create alias if batcat exists (Ubuntu compatibility)
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    alias bat='batcat'
fi

# fd (Ubuntu uses 'fdfind', others use 'fd')
# Only create alias if fdfind exists (Ubuntu compatibility)
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    alias fd='fdfind'
fi

# ───────────────────────────────────────────────────────────────────────
# 📁 Navigation
# ───────────────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"  # Go back to previous directory

# Use zoxide for smart cd (learns your habits) - only if installed
if command -v zoxide &> /dev/null; then
    alias cd="z"
    alias cdi="zi"  # Interactive zoxide
fi

# ───────────────────────────────────────────────────────────────────────
# 📂 File Listing (using eza/lsd)
# ───────────────────────────────────────────────────────────────────────
# Use eza if available, fallback to lsd
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias l='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias lla='eza -la --icons --group-directories-first --git'
else
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -la'
    alias lt='lsd --tree'
    alias ll='lsd -l'
    alias lla='lsd -la'
fi

# ───────────────────────────────────────────────────────────────────────
# 🔍 Search & Find
# ───────────────────────────────────────────────────────────────────────
# Only create aliases if the commands exist
command -v fd &> /dev/null && alias find='fd'
command -v fdfind &> /dev/null && alias find='fdfind'
command -v rg &> /dev/null && alias grep='rg'

# ───────────────────────────────────────────────────────────────────────
# 📝 File Operations
# ───────────────────────────────────────────────────────────────────────
if command -v bat &> /dev/null; then
    alias cat='bat'
    alias less='bat'
elif command -v batcat &> /dev/null; then
    alias cat='batcat'
    alias less='batcat'
fi

alias cp='cp -iv'      # Interactive and verbose
alias mv='mv -iv'      # Interactive and verbose
alias rm='rm -i'       # Interactive
alias mkdir='mkdir -pv' # Create parent dirs and verbose

# ───────────────────────────────────────────────────────────────────────
# 🌐 Git
# ───────────────────────────────────────────────────────────────────────
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'  # Interactive add
alias gc='git commit -m'
alias gca='git commit -am'
alias gcf='git commit --fixup'
alias gs='git status -sb'  # Short and branch
alias gst='git status'
alias gp='git push'
alias gpf='git push --force-with-lease'  # Safer force push
alias gpull='git pull --rebase'  # Rebase instead of merge
alias gf='git fetch'
alias gfa='git fetch --all'

# Branches
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main || git checkout master'
alias gcd='git checkout develop'

# Logs
alias gl='git log --oneline --decorate --graph'
alias gla='git log --oneline --decorate --graph --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --graph'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Diff
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --stat'

# Stash
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstap='git stash pop'
alias gstl='git stash list'
alias gstd='git stash drop'
alias gstc='git stash clear'

# Reset & Rebase
alias gundo='git reset --soft HEAD~1'  # Undo last commit
alias greset='git reset --hard HEAD'
alias gclean='git clean -fd'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# Misc
alias gm='git merge'
alias gma='git merge --abort'
alias gt='git tag'
alias gshow='git show'
alias gbl='git blame'
alias gwip='git add -A && git commit -m "WIP"'  # Work in progress commit
alias gunwip='git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'  # Undo WIP

# ───────────────────────────────────────────────────────────────────────
# 🐳 Docker
# ───────────────────────────────────────────────────────────────────────
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -af --volumes'  # Clean everything
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
alias dcr='docker-compose restart'

# ───────────────────────────────────────────────────────────────────────
# ☸️  Kubernetes
# ───────────────────────────────────────────────────────────────────────
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# ───────────────────────────────────────────────────────────────────────
# 💻 System
# ───────────────────────────────────────────────────────────────────────
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup'
alias brewup='brew update && brew upgrade && brew cleanup && brew doctor'
alias ip="ipconfig getifaddr en0"
alias localip="ipconfig getifaddr en0"
alias publicip="curl -s ifconfig.me"
alias reload="source ~/.zshrc"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'  # Process search
alias ports='lsof -i -P -n | grep LISTEN'  # Show listening ports

# Disk usage
alias du='du -h'
alias df='df -h'
alias ducks='du -cks * | sort -rn | head'  # Show biggest folders

# ───────────────────────────────────────────────────────────────────────
# 🐍 Python
# ───────────────────────────────────────────────────────────────────────
alias py='python3'
alias python='python3'
alias pip='pip3'
alias venv-create='python3 -m venv venv'
alias venv-activate='. venv/bin/activate'
alias venv='python3 -m venv venv && . venv/bin/activate'
alias pipup='pip install --upgrade pip setuptools wheel'
alias pipreq='pip freeze > requirements.txt'

# ───────────────────────────────────────────────────────────────────────
# 📦 Package Managers
# ───────────────────────────────────────────────────────────────────────
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nup='npm update'

alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias yup='yarn upgrade'

# ───────────────────────────────────────────────────────────────────────
# 🔧 Utilities
# ───────────────────────────────────────────────────────────────────────
alias watch='watch -n 1'  # Execute every second
alias please='sudo !!'  # Rerun last command with sudo
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'  # Print each PATH entry on a separate line
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Clipboard (macOS)
alias copy='pbcopy'
alias paste='pbpaste'

# JSON formatting
alias json='python3 -m json.tool'

# URL encode/decode
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# ───────────────────────────────────────────────────────────────────────
# 🧰 Salt Stack
# ───────────────────────────────────────────────────────────────────────
alias salt='sudo salt'
alias salt-key='sudo salt-key'
alias salt-run='sudo salt-run'
alias sls='sudo salt-key --list-all'
alias reload-salt-master='sudo launchctl unload /Library/LaunchDaemons/com.saltstack.salt.master.plist && launchctl load /Library/LaunchDaemons/com.saltstack.salt.master.plist'
alias salt-master-start='sudo launchctl start com.saltstack.salt.master'
alias salt-master-stop='sudo launchctl stop com.saltstack.salt.master'

# ───────────────────────────────────────────────────────────────────────
# 🔐 Slothctl
# ───────────────────────────────────────────────────────────────────────
alias slothctl='sudo slothctl'

# ───────────────────────────────────────────────────────────────────────
# ⚙️  Configuration Edit Shortcuts
# ───────────────────────────────────────────────────────────────────────
alias edit-alias='nvim ~/.zsh/aliases.zsh'
alias edit-functions='nvim ~/.zsh/functions.zsh'
alias edit-exports='nvim ~/.zsh/env.zsh'
alias edit-plugins='nvim ~/.zsh/plugins.zsh'
alias edit-options='nvim ~/.zsh/options.zsh'
alias edit-zshrc='nvim ~/.zshrc'

# ───────────────────────────────────────────────────────────────────────
# 🪟 Zellij (Terminal Multiplexer)
# ───────────────────────────────────────────────────────────────────────
alias zj='zellij'
alias zja='zellij attach'
alias zjl='zellij list-sessions'
alias zjk='zellij kill-session'
alias zjka='zellij kill-all-sessions'

# Layout shortcuts
alias zjdev='zellij --layout dev'
alias zjfs='zellij --layout fullstack'
alias zjops='zellij --layout ops'
alias zjmin='zellij --layout compact'

# ───────────────────────────────────────────────────────────────────────
# 🎨 Fun
# ───────────────────────────────────────────────────────────────────────
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'
alias starwars='telnet towel.blinkenlights.nl'

alias aws-pulumi="$HOME/.projects/aws/pulumi-aws-vault.sh"
alias vpn-up="sudo wg-quick up wg-client"
alias vpn-down="sudo wg-quick down wg-client"

alias gmail='himalaya'
alias gmail-list='himalaya envelope list'
alias gmail-read='himalaya message read'
alias gmail-send='himalaya message read'
alias gmail-unread='himalaya envelope list --query "unseen"'
