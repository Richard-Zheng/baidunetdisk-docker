FROM jlesage/baseimage-gui:debian-12-v4

ENV VERSION=4.17.7
ENV URI=https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/$VERSION/baidunetdisk_${VERSION}_amd64.deb

ENV ENABLE_CJK_FONT=1
ENV TZ=Asia/Shanghai
ENV SERVICES_GRACETIME=8000

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl  \
    ca-certificates \
    desktop-file-utils    \
    libasound2-dev        \
    locales               \
    fonts-wqy-zenhei      \
    libgtk-3-0            \
    libnotify4            \
    libnss3               \
    libxss1               \
    libxtst6              \
    xdg-utils             \
    libatspi2.0-0         \
    libuuid1              \
    libappindicator3-1    \
    libsecret-1-0 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L ${URI} -o /defaults/baidunetdisk.deb     \
    && apt-get install -y /defaults/baidunetdisk.deb \
    && rm /defaults/baidunetdisk.deb 

RUN \
    APP_ICON_URL='https://raw.githubusercontent.com/KevinLADLee/baidunetdisk-docker/master/logo.png' && \
    install_app_icon.sh "$APP_ICON_URL"

COPY rootfs/etc/cont-init.d/baidunetdisk.sh /etc/cont-init.d/baidunetdisk.sh
COPY rootfs/startapp.sh /startapp.sh

RUN chmod +x /startapp.sh /etc/cont-init.d/baidunetdisk.sh

ENV APP_NAME="BaiduNetdisk"

WORKDIR /config

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/downloads"]
