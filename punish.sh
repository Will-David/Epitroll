#!/bin/bash

# EpiTroll - The Student Punishment Tool
# Target: Students who leave their PC unlocked.

CONFIG_BLOCK_START="# BEGIN EPITROLL"
CONFIG_BLOCK_END="# END EPITROLL"

# Function to display help
show_help() {
    echo "Usage: sudo punish [FLAGS]"
    echo ""
    echo "Flags:"
    echo "  -s, --sl          Alias ls to sl (Requires sl installed)"
    echo "  -c, --cd-exit     Alias cd to exit"
    echo "  -v, --no-vim      Alias vim to nano"
    echo "  -g, --gcc-error   Mock GCC compilation errors"
    echo "  -l, --lock        Alias ls to 'sl' and clear to 'exit'"
    echo "  -a, --all         Enable all active trolls"
    echo "  --disable         Remove all active trolls"
    echo "  -h, --help        Show this help message"
}

# Function to remove existing EpiTroll block
cleanup() {
    for file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$file" ]; then
            sed -i "/$CONFIG_BLOCK_START/,/$CONFIG_BLOCK_END/d" "$file"
        fi
    done
}

if [ "$1" == "--disable" ]; then
    cleanup
    echo "EpiTroll disabled. Student is safe... for now."
    exit 0
fi

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Initialize troll list
TROLLS=""

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--sl)
            TROLLS+="alias ls='sl' ; "
            shift
            ;;
        -c|--cd-exit)
            TROLLS+="alias cd='exit' ; "
            shift
            ;;
        -v|--no-vim)
            TROLLS+="alias vim='nano' ; "
            shift
            ;;
        -g|--gcc-error)
            TROLLS+="alias gcc='echo \"Compilation error: missing brain.h\"' ; "
            shift
            ;;
        -l|--lock)
            TROLLS+="alias ls='sl' ; alias clear='exit' ; "
            shift
            ;;
        -a|--all)
            TROLLS+="alias ls='sl' ; alias cd='exit' ; alias vim='nano' ; alias gcc='echo \"Compilation error: missing brain.h\"' ; alias clear='exit' ; "
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown flag: $1"
            show_help
            exit 1
            ;;
    esac
done

# Inject trolls into configs
if [ -n "$TROLLS" ]; then
    cleanup
    for file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$file" ]; then
            echo "$CONFIG_BLOCK_START" >> "$file"
            echo "$TROLLS" >> "$file"
            echo "$CONFIG_BLOCK_END" >> "$file"
            echo "EpiTroll injected into $file"
        fi
    done
    echo "Punishment applied! Make sure to run 'source ~/.bashrc' or restart the terminal."
fi
