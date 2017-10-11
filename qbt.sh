#!/bin/bash

# 作者：某弱鸡
# 基本上都是从 QuickBox 和 qBittorrent GutHub WiKi 那抄来的，感谢原作者
# 有很多地方我想做得更好不过就我这三脚猫功夫……所以笑笑就好

# https://github.com/qbittorrent/qBittorrent/wiki/Compiling-qBittorrent-on-Debian-and-Ubuntu
# https://github.com/qbittorrent/qBittorrent/wiki/Setting-up-qBittorrent-on-Ubuntu-server-as-daemon-with-Web-interface-(15.04-and-newer)
# https://github.com/QuickBox/QB

# --------------------------------------------------------------------------------
#Script Console Colors
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
sub_title=${bold}${yellow}; repo_title=${black}${on_blue}; message_title=${white}${on_green}
# --------------------------------------------------------------------------------
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------

clear

# 介绍 (1)
function _intro() {
  echo
  echo
  echo "[${repo_title}Seedbox${normal}] ${title} qBittorrent-nox Installation ${normal}  "
  echo
  echo "   ${title}              Heads Up!              ${normal} "
  echo "   ${message_title}  This script works with             ${normal} "
  echo "   ${message_title}  Ubuntu 15.10 | 16.04 | 16.10       ${normal} "
  echo "   ${message_title}  Debian 8 | 9                       ${normal} "
  echo
  echo
}

# 检查是否以root运行 (2)
function _checkroot() {
  if [[ $EUID != 0 ]]; then
    echo 'This script must be run with root privileges.'
    echo 'Exiting...'
    exit 1
  fi
  echo "${green}Congrats! You're running as root. Let's continue${normal} ... "
  echo
}

clear

# 询问需要安装的 qBittorrent 的版本 (3)
function _askqbt() {
  echo -e "01) qBittorrent ${cyan}3.3.7${normal}"
  echo -e "02) qBittorrent ${cyan}3.3.8${normal}"
  echo -e "03) qBittorrent ${cyan}3.3.9${normal}"
  echo -e "04) qBittorrent ${cyan}3.3.10${normal}"
  echo -e "05) qBittorrent ${cyan}3.3.11${normal}"
  echo -e "06) qBittorrent ${cyan}3.3.12${normal}"
  echo -e "07) qBittorrent ${cyan}3.3.13${normal}"
  echo -e "08) qBittorrent ${cyan}3.3.14${normal}"
  echo -e "09) qBittorrent ${cyan}3.3.15${normal}"
  echo -e "10) qBittorrent ${cyan}3.3.16${normal}"
  echo -ne "${bold}${yellow}What version of qBittorrent do you want?${normal} (Default ${cyan}05${normal}): "; read version
  case $version in
    01) QBVERSION=3.3.7 ;;
    02) QBVERSION=3.3.8 ;;
    03) QBVERSION=3.3.9 ;;
    04) QBVERSION=3.3.10 ;;
    05 | "") QBVERSION=3.3.11 ;;
    06) QBVERSION=3.3.12 ;;
    07) QBVERSION=3.3.13 ;;
    08) QBVERSION=3.3.14 ;;
    09) QBVERSION=3.3.15 ;;
    10) QBVERSION=3.3.16 ;;
    *) QBVERSION=3.3.11 ;;
  esac
  echo "We will be using qBittorrent-${cyan}$QBVERSION${normal}"
  echo
}

# 询问是否继续 (4)
function _askcontinue() {
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin or ${standout}${red}Ctrl+Z${normal} to cancel" ;read input
  echo
}

# 安装 qBittorrent (5)
function _installqbt() {
  apt-get update \
  && apt-get -yqq install libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev git pkg-config automake libtool zlib1g-dev \
  && cd \
  && git clone -b RC_1_0 https://github.com/arvidn/libtorrent.git \
  && cd libtorrent \
  && ./autotool.sh \
  && ./configure --disable-debug --enable-encryption --prefix=/usr --with-libgeoip=system \
  && make clean \
  && make -j$(nproc) \
  && make install \
  && cd \
  && git clone -b release-$QBVERSION$ https://github.com/qbittorrent/qBittorrent.git \
  && cd qBittorrent \
  && ./configure --prefix=/usr --disable-gui \
  && make -j$(nproc) \
  && make install \
  && cd
  rm -rf libtorrent qBittorrent
}


# 设置 qBittorrent (6)
function _setqbt() {
  mkdir -p /root/.config/qBittorrent
  touch /etc/systemd/system/qbittorrent.service
cat >/etc/systemd/system/qbittorrent.service<<EOF
[Unit]
Description=qBittorrent Daemon Service
After=network.target

[Service]
User=root
ExecStart=/usr/bin/qbittorrent-nox --webui-port=2017

[Install]
WantedBy=multi-user.target
EOF

touch /root/.config/qBittorrent/qBittorrent.conf

cat >/root/.config/qBittorrent/qBittorrent.conf<<EOF
[LegalNotice]
Accepted=true

[Preferences]
Connection\GlobalDLLimitAlt=0
Connection\GlobalUPLimitAlt=0
Bittorrent\MaxConnecs=-1
Bittorrent\MaxConnecsPerTorrent=-1
Bittorrent\MaxRatioAction=0
General\Locale=zh
Queueing\QueueingEnabled=false
WebUI\Port=2017
EOF

systemctl daemon-reload
}

clear

# 结束 (7)
function _end() {
  echo
  echo -e "${yellow}${bold}This is the choice of Steins;Gate!${normal}"
  echo
}

# Script STRUCTURE
_intro
_checkroot
_askqbt
_askcontinue
_installqbt
_setqbt
_end
