#!/bin/bash
# 设置变量
STEAMCMD_DIR="/data/steamcmd"
GAME_DIR="/data/Stardew/Stardew Valley"

# 检查是否设置了Steam用户和密码
if [ -n "$STEAM_USER" ] && [ -n "$STEAM_PWD" ]; then
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
        mkdir -p $STEAMCMD_DIR && \
        tar -xzvf steamcmd_linux.tar.gz -C /data/steamcmd && \
        rm steamcmd_linux.tar.gz
    echo "using Steam to update game, \n your may need confirm on your steam phone app for login..."
    $STEAMCMD_DIR/steamcmd.sh +force_install_dir $GAME_DIR +login "$STEAM_USER" "$STEAM_PWD" +app_update 413150 validate +quit
# else
#     echo "未设置Steam账户，使用匿名更新游戏..."
#     $STEAMCMD_DIR/steamcmd.sh +force_install_dir $GAME_DIR +login anonymous +app_update 413150 validate +quit
fi