FROM ruby:3.2.2-slim

ENV ANDROID_COMMAND_LINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip" \
    ANDROID_HOME="/opt/android/sdk" \
    ANDROID_ACCEPT_LICENSE="yes" \
    ANDROID_PLATFORM_VERSION="31" \
    DEBIAN_FRONTEND="noninteractive" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    PATH=$PATH:/opt/android/sdk/platform-tools:/opt/android/tools/bin

# 基础依赖
RUN mkdir -p /usr/share/man/man1 \
 && apt-get update --fix-missing \
 && apt-get -y upgrade \
 && apt-get install -y \
      apt-transport-https \
      build-essential \
      default-jdk-headless \
      curl \
      git \
      python3 \
      unzip \
      usbutils \
      vim

# 安装 Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs

# 全局安装 react-native-cli
RUN npm install -g react-native-cli

# 创建挂载目录并开放权限
RUN mkdir -p /conf /data \
 && chmod 777 /conf /data \
 && mkdir -p /opt/android

# 安装 Android SDK command‑line tools
RUN curl -o /tmp/android-tools.zip "$ANDROID_COMMAND_LINE_TOOLS_URL" \
 && unzip -d /opt/android /tmp/android-tools.zip \
 && rm /tmp/android-tools.zip \
 # 接受许可并安装平台工具
 && yes | /opt/android/tools/bin/sdkmanager --sdk_root="$ANDROID_HOME" \
      "platform-tools" "platforms;android-${ANDROID_PLATFORM_VERSION}"

# 安装 fastlane
RUN gem install fastlane

# 复制配置和脚本
COPY build-sample.conf /home/build-sample.conf
COPY entrypoint.sh /entrypoint.sh
COPY google-services.json /conf/google-services.json

# 确保 entrypoint.sh 可执行
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
