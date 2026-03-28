#!/bin/bash

# 每个 Tab 执行的命令（数组，每个元素对应一个 Tab）
# 自定义你要在各个 Tab 中执行的命令
COMMANDS=(
    "echo hello; sleep 1; echo world"           # Tab 1                                                                                                        
    "htop"                                       # Tab 2                                                                                                       
    "cd /tmp; ls -la"                            # Tab 3   
)

if [ ${#COMMANDS[@]} -eq 0 ]; then
    echo "Error: COMMANDS array is empty, please configure at least one command"
    exit 1
fi

TAB_COUNT=${#COMMANDS[@]}
echo "Opening ${TAB_COUNT} tabs..."

for i in $(seq 0 $((TAB_COUNT - 1))); do
    gnome-terminal --tab -- bash -c "${COMMANDS[$i]}; exec bash"
done
