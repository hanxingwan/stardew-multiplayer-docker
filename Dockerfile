# Pull base image.
FROM jlesage/baseimage-gui:debian-10

ARG STEAM_USER
ARG STEAM_PWD
# Set the name of the application.
ENV APP_NAME="StardewValley"

# Define download URLs and filenames
ENV STARDEW_GAME_URL="https://eris.cc/Stardew_1.6.15.tar.gz"
ENV DOTNET_SDK_URL="https://download.visualstudio.microsoft.com/download/pr/6788a5a5-1879-4095-948d-72c7fbdf350f/c996151548ec9f24d553817db64c3577/dotnet-sdk-5.0.402-linux-x64.tar.gz"
ENV SMAPI_URL="https://github.com/Pathoschild/SMAPI/releases/download/4.1.10/SMAPI-4.1.10-installer.zip"

# 设置默认的debian archive源（确保基础构建成功）
RUN echo "deb http://archive.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

# 阿里云镜像源（可选，用于加速 - 注释掉默认使用archive.debian.org）
#RUN echo "deb http://mirrors.aliyun.com/debian-archive/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/debian-archive/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y wget unzip tar strace mono-complete xterm gettext-base jq netcat procps lib32stdc++6 lib32gcc1
#RUN APP_ICON_URL=https://stardewcommunitywiki.com/mediawiki/images/4/48/Fiddlehead_Fern.png && \
#    install_app_icon.sh "$APP_ICON_URL"


RUN mkdir -p /data/Stardew /data/nexus /data/default-mods

COPY data/ /data

# Download and install game files, dotnet SDK and SMAPI
RUN STARDEW_GAME_FILE=$(basename "$STARDEW_GAME_URL") && \
    DOTNET_FILE=$(basename "$DOTNET_SDK_URL") && \
    SMAPI_FILE=$(basename "$SMAPI_URL") && \
    # Download all files first
    wget -c -q "$STARDEW_GAME_URL" -O "/data/$STARDEW_GAME_FILE" && \
    wget -c -q "$DOTNET_SDK_URL" -O "/data/$DOTNET_FILE" && \
    wget -c -q "$SMAPI_URL" -O "/data/$SMAPI_FILE" && \
    # Extract and install Stardew game
    tar xf "/data/$STARDEW_GAME_FILE" -C /data/Stardew && \
    rm "/data/$STARDEW_GAME_FILE" && \
    # Install dotnet SDK
    tar -zxf "/data/$DOTNET_FILE" -C /usr/share/dotnet && \
    rm "/data/$DOTNET_FILE" && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    # Install SMAPI
    unzip "/data/$SMAPI_FILE" -d /data/nexus/ && \
    rm "/data/$SMAPI_FILE" && \
    /bin/bash -c "SMAPI_NO_TERMINAL=true SMAPI_USE_CURRENT_SHELL=true echo -e \"2\\n\\n\" | /data/nexus/SMAPI\ 4.1.10\ installer/internal/linux/SMAPI.Installer --install --game-path \"/data/Stardew/Stardew Valley\"" || :
        # Add Mods & Scripts

COPY scripts/ /opt

RUN chmod +x /data/Stardew/Stardew\ Valley/StardewValley && \
    chmod -R 777 /data/Stardew/ && \
    chown -R 1000:1000 /data/Stardew && \
    chmod +x /opt/*.sh

# 新增：添加 root 权限的初始化脚本
RUN mkdir -p /etc/cont-init.d && \
    cp /opt/fixed-mod-permission.sh /etc/cont-init.d/ && \
    chmod +x /etc/cont-init.d/fixed-mod-permission.sh && \
    cp /opt/steam_download.sh /etc/cont-init.d/ && \
    chmod +x /etc/cont-init.d/steam_download.sh

# RUN mkdir /etc/services.d/utils && touch /etc/services.d/app/utils.dep
# COPY run /etc/services.d/utils/run 
# RUN chmod +x /etc/services.d/utils/run 

COPY docker-entrypoint.sh /startapp.sh