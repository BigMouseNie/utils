#!/bin/bash

# ========== Configurable Area ==========
# Each element is a 3-line string:
#   trigger_char   : press this key to open a Tab
#   prompt_message : description shown in the menu
#   command_to_run : command executed in the new Tab
#   separator      : "/n"(These are two characters)
MENU_ITEMS=(
    "1 \n Run hello world \n echo hello; sleep 1; echo world"
    "2 \n Open htop \n htop"
    "3 \n List /tmp \n cd /tmp; ls -la"
)

# ======================================

if [ ${#MENU_ITEMS[@]} -eq 0 ]; then
    echo "Error: MENU_ITEMS array is empty, please configure at least one item"
    exit 1
fi

parse_item() {
    # $1 = full item string, $2 = which part: "key" | "desc" | "cmd"
    local item="$1"
    # Convert literal \n to real newlines, trim spaces
    item=$(echo "$item" | sed 's/\\n/\n/g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    case "$2" in
        key) echo "$item" | sed -n '1p' ;;
        desc) echo "$item" | sed -n '2p' ;;
        cmd) echo "$item" | sed -n '3p' ;;
    esac
}

show_menu() {
    echo "============================="
    echo " Press a key to open a Tab"
    echo " q - Quit"
    echo "============================="
    for item in "${MENU_ITEMS[@]}"; do
        local key desc
        key=$(parse_item "$item" key)
        desc=$(parse_item "$item" desc)
        echo " [$key] $desc"
    done
    echo "============================="
}

while true; do
    show_menu
    read -p "Your choice: " choice

    if [ "$choice" = "q" ]; then
        echo "Bye."
        exit 0
    fi

    found=0
    invalid=0
    for (( i=0; i<${#choice}; i++ )); do
        char="${choice:$i:1}"
        matched=false
        for item in "${MENU_ITEMS[@]}"; do
            key=$(parse_item "$item" key)
            desc=$(parse_item "$item" desc)
            cmd=$(parse_item "$item" cmd)
            if [ "$char" = "$key" ]; then
                echo "Opening tab: $desc"
                gnome-terminal --tab -- bash -c "$cmd; exec bash" &
                found=$((found + 1))
                matched=true
                break
            fi
        done
        if [ "$matched" = false ]; then
            echo "Unknown key '$char', skipped."
            invalid=$((invalid + 1))
        fi
    done

    if [ $found -eq 0 ]; then
        echo "No valid choice found, try again."
    fi
done
