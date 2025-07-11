# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Set the name of the application.
ENV APP_NAME="StardewValley"

# replace mirrors
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list.d/tsinghua.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list.d/tsinghua.list

RUN apt-get update
RUN apt-get install -y wget unzip tar strace mono-complete xterm gettext-base jq netcat procps 
#RUN APP_ICON_URL=https://stardewcommunitywiki.com/mediawiki/images/4/48/Fiddlehead_Fern.png && \
#    install_app_icon.sh "$APP_ICON_URL"


RUN mkdir -p /data/Stardew && \
    mkdir -p /data/nexus && \
    mkdir -p /data/default-mods

COPY ["data/", "/data/"]
# Game + ModLoader 1.6.15 3.18.2
RUN if [ ! -f "/data/Stardew_1.6.15.tar.gz" ]; then \
        wget https://eris.cc/Stardew_1.6.15.tar.gz -qO /data/Stardew_1.6.15.tar.gz; \
    fi && \
    tar xf /data/Stardew_1.6.15.tar.gz -C /data/Stardew && \
    rm /data/Stardew_1.6.15.tar.gz

# check if dotnet is installed, if not, install it
RUN if [ ! -f "/data/dotnet.tar.gz" ]; then \
        wget -qO /data/dotnet.tar.gz https://download.visualstudio.microsoft.com/download/pr/6788a5a5-1879-4095-948d-72c7fbdf350f/c996151548ec9f24d553817db64c3577/dotnet-sdk-5.0.402-linux-x64.tar.gz; \
    fi && \
    tar -zxf /data/dotnet.tar.gz -C /usr/share/dotnet && \
    rm /data/dotnet.tar.gz && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install SMAPI (Stardew Modding API)
RUN if [ ! -f "/data/nexus.zip" ]; then \
        wget https://github.com/Pathoschild/SMAPI/releases/download/4.1.10/SMAPI-4.1.10-installer.zip -qO /data/nexus.zip; \
    fi && \
    unzip /data/nexus.zip -d /data/nexus/ && \
    /bin/bash -c "SMAPI_NO_TERMINAL=true SMAPI_USE_CURRENT_SHELL=true echo -e \"2\n\n\" | /data/nexus/SMAPI\ 4.1.10\ installer/internal/linux/SMAPI.Installer --install --game-path \"/data/Stardew/Stardew Valley\"" || :
        # Add Mods & Scripts
COPY ["mods/", "/data/default-mods/"]
COPY scripts/ /opt/

RUN chmod +x /data/Stardew/Stardew\ Valley/StardewValley && \
    chmod -R 777 /data/Stardew/ && \
    chown -R 1000:1000 /data/Stardew && \
    chmod +x /opt/*.sh

# 新增：添加 root 权限的初始化脚本
RUN mkdir -p /etc/cont-init.d
RUN cp /opt/fixed-mod-permission.sh /etc/cont-init.d/ && \
    chmod +x /etc/cont-init.d/fixed-mod-permission.sh

# RUN mkdir /etc/services.d/utils && touch /etc/services.d/app/utils.dep
# COPY run /etc/services.d/utils/run 
# RUN chmod +x /etc/services.d/utils/run 

COPY docker-entrypoint.sh /startapp.sh
