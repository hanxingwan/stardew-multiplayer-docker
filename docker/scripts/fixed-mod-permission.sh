#!/bin/sh
set -e

# 修复 mods 挂载目录的权限（以 root 执行）
MODS_DIR="/data/Stardew/Stardew Valley/Mods"
if [ -d "/data/Stardew/Stardew Valley/Mods" ]; then
    chown -R 1000:1000 "$MODS_DIR"  # 改为容器内运行用户（UID 1000）
    chmod -R 755 "$MODS_DIR"        # 确保可读写
    echo "Setting Mods permissions to ALL"
else
    echo "Mods Dir Not Exist: /data/Stardew/Stardew Valley/Mods"
fi