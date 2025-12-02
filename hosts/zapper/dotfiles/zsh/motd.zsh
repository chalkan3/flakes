# motd.zsh - Message of the Day (v2 - Safer Version)

# Using printf for better portability and reliability.
CYAN=$(printf '\e[36m')
RESET=$(printf '\e[0m')

printf "\n%s" "$CYAN"
cat << "EOF"
  ____ _  _ ____ _  _ _    _      ____ ____ _ _  _ 
 [__  |__| |___ |  | |    |      | __ |__/ | |\| |
 ___] |  | |___ |__| |___ |___   |__] |  \ | | \| 

EOF
printf "%s" "$RESET"
printf "\n%s\n\n" "                      🦥 ... slow and steady ... 🦥"