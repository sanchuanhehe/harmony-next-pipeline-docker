# 使用 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置环境变量以避免交互式安装提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        openjdk-17-jdk \
        git \
        && rm -rf /var/lib/apt/lists/*

# 设置 JDK 17 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# 下载并安装 HarmonyOS CLI 工具
RUN mkdir -p /opt/harmonyos-tools && \
    wget -q --show-progress -O /tmp/commandline-tools-linux.zip https://harmonytools.sanchuanhehe.com/commandline-tools-linux-x64-5.0.7.100.zip && \
    unzip -q /tmp/commandline-tools-linux.zip -d /opt/harmonyos-tools/ && \
    chmod -R +x /opt/harmonyos-tools/command-line-tools/bin && \
    rm /tmp/commandline-tools-linux.zip

# 下载 openharmony SDK 12
RUN wget -q --show-progress -O /tmp/ohos-sdk-public-5.0.0-release.tar.gz https://cidownload.openharmony.cn/version/Master_Version/OpenHarmony_5.0.0.71/20250315_060615/version-Master_Version-OpenHarmony_5.0.0.71-20250315_060615-ohos-sdk-public-5.0.0-release.tar.gz && \
    tar -xvf /tmp/ohos-sdk-public-5.0.0-release.tar.gz -C /opt/harmonyos-tools/command-line-tools/sdk/12/ && \
    rm /tmp/ohos-sdk-public-5.0.0-release.tar.gz

# 设置 HarmonyOS CLI 工具的环境变量
ENV COMMANDLINE_TOOL_DIR=/opt/harmonyos-tools
ENV PATH=$COMMANDLINE_TOOL_DIR/command-line-tools/bin:$PATH
ENV HDC_HOME=$COMMANDLINE_TOOL_DIR/command-line-tools/sdk/default/openharmony/toolchains
ENV PATH=$HDC_HOME:$PATH
ENV OHOS_BASE_SDK_HOME=$COMMANDLINE_TOOL_DIR/command-line-tools/sdk/default/openharmony

# 设置工作目录
WORKDIR /workspace

# 设置默认命令
CMD ["bash"]
