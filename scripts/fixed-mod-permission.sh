#!/bin/bash
set -e

# 修复 mods 目录权限 - 简化版本
MODS_DIR="/data/Stardew/Stardew Valley/Mods"
[[ -d "$MODS_DIR" ]] && { chown -R 1000:1000 "$MODS_DIR"; chmod -R 755 "$MODS_DIR"; echo "✅ Mods权限已修复"; } || echo "❌ Mods目录不存在"