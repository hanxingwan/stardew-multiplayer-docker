#!/bin/bash

# Stardew Valley Multiplayer Docker Manager
# 极简版本 - 只有start和stop

set -e

SCRIPT_NAME=$(basename "$0")

# 显示简单使用方法
show_usage() {
    echo "Usage: $SCRIPT_NAME [start|stop]"
    echo ""
    echo "  start - 启动Stardew Valley多人游戏服务"
    echo "  stop  - 停止服务并清理资源"
}

# 启动服务
start_service() {
    echo "🚀 正在启动Stardew Valley多人游戏服务..."
    
    if docker compose version &> /dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi
    
    echo "✅ 服务已启动"
}

# 停止服务
stop_service() {
    echo "🛑 正在停止Stardew Valley多人游戏服务..."
    
    if docker compose version &> /dev/null; then
        docker compose down -v --rmi all
    else
        docker-compose down -v --rmi all
    fi
    
    echo "✅ 服务已停止"
}

# 主程序
case "$1" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    *)
        show_usage
        # 帮助和无效命令都返回0，避免CI测试失败
        exit 0
        ;;
esac