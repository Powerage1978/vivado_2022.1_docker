FROM ubuntu:22.04 as base-setup

ARG VIVADO_RUN_FILE=Xilinx_Unified_2022.1_0420_0327
ARG USER=skytemdev
ARG HOME=/home/$USER
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-256color

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    locales \
    libtinfo5 \
    build-essential \
    sudo \
    libncurses5-dev \
    libgtk2.0-0 \
    xterm \
    openssh-client \
    libxtst6 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*


ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales


from base-setup as setup-user

RUN adduser --disabled-password --gecos '' $USER \
    && usermod -aG sudo $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /app \
    && chown $USER:$USER /app \
    && echo "PS1='\e[32;1m\u: \e[34m\W\e[0m\$ '" >> $HOME/.bashrc \
    && mkdir -p $HOME/.Xilinx \
    && chown $USER:$USER $HOME/.Xilinx \
    && mkdir -p /opt/Xilinx

from setup-user as setup-vivado

USER $USER

RUN --mount=type=bind,target=/data sudo /data/tmp/$VIVADO_RUN_FILE/xsetup --batch Install --agree XilinxEULA,3rdPartyEULA --config /data/install_config.txt \
    && sudo rm -rf /opt/Xilinx/Vivado/2022.1/data/parts/xilinx/devint/vault/versal \
    && echo "source /opt/Xilinx/Vivado/2022.1/settings64.sh" >> $HOME/.bashrc \
    && sed -i.bak '6,9d' $HOME/.bashrc

USER root
