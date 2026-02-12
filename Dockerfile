FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# ---- system dependencies required by Cursor (Electron) ----
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    fuse \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgbm1 \
    libdrm2 \
    libglib2.0-0 \
    libdbus-1-3 \
#    dbus \
    libxkbcommon0 \
    xauth \
    xdg-utils \
    libpci3 \
    libegl1 \
    libgl1 \
    libgles2 \
    # sudo needed in case the user wants to sue --sudouser flag: \
    sudo \
    # xkb-data needed to make Alt+Gr key work.
    xkb-data \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    # to make remote ssh plugin work: \
    openssh-client \
    # to make Alt Gr work: \
    x11-xkb-utils \
    # so that cursor window can maximize if Xephyr window increases beyond initial size: \
    x11-xserver-utils
#RUN apt-get update && apt-get install -y libfuse3-4 libfuse2t64

# ---- download Cursor AppImage ----
WORKDIR /opt/cursor

RUN cd /opt/cursor && \
    curl -L https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/ \
    -o cursor.AppImage \
    && chmod +x cursor.AppImage

#COPY ./cursor.AppImage /opt/cursor/
#RUN chmod +x /opt/cursor/cursor.AppImage

# ---- Electron / AppImage container quirks ----
ENV ELECTRON_DISABLE_SANDBOX=1
ENV NO_AT_BRIDGE=1

# cursor run script. Without this it crashes because /tmp/ doesn't have exec permissions.
COPY run-cursor.sh /usr/local/bin/run-cursor.sh
RUN chmod +x /usr/local/bin/run-cursor.sh

CMD ["/usr/local/bin/run-cursor.sh"]
