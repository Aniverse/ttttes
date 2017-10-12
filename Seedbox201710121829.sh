#!/bin/sh

# 作者：弱鸡
# 基本上都是从各处抄来的，感谢原作者（参考资料在下边）
# 有很多地方我想做得更好不过就我这三脚猫功夫……笑笑就好

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
sub_title=${bold}${yellow}; repo_title=${white}${on_blue}; message_title=${white}${on_green};
zidingyi1=${white}${on_cyan}
# --------------------------------------------------------------------------------
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------




clear




# 介绍 (1)
function _intro() {
  echo
  echo
  echo "[${repo_title}Seedbox${normal}] ${title} BitTorrent Client Installation ${normal}  "
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




# 询问是否创建 log (3)
function _logcheck() {
  echo -ne "${bold}${yellow}Do you wish to write to a log file?${normal} (Default: ${green}${bold}Y${normal}) "; read input
    case $input in
      [yY] | [yY][Ee][Ss] | "" ) OUTTO="/root/seedboxscript.$PPID.log";echo "${bold}Output is being sent to /root/seedboxscript.${magenta}$PPID${normal}${bold}.log${normal}" ;;
      [nN] | [nN][Oo] ) OUTTO="/dev/null 2>&1";echo "${cyan}NO output will be logged${normal}" ;;
    *) OUTTO="/root/seedboxscript.$PPID.log";echo "${bold}Output is being sent to /root/seedboxscript.${magenta}$PPID${normal}${bold}.log${normal}" ;;
    esac
  if [[ ! -d /root/tmp ]]; then
    sed -i 's/noexec,//g' /etc/fstab
    mount -o remount /tmp >>"${OUTTO}" 2>&1
  fi
}




# 询问需要安装的 qBittorrent 的版本 (4)
function _askqbt() {
  clear
  echo -e "01) qBittorrent ${cyan}3.3.7${normal}  (MTeam Supported)"
  echo -e "02) qBittorrent ${cyan}3.3.8${normal}"
  echo -e "03) qBittorrent ${cyan}3.3.9${normal}"
  echo -e "04) qBittorrent ${cyan}3.3.10${normal}"
  echo -e "05) qBittorrent ${cyan}3.3.11${normal} (HDSky Supported)"
  echo -e "06) qBittorrent ${cyan}3.3.12${normal}"
  echo -e "07) qBittorrent ${cyan}3.3.13${normal} (Skip hash check)"
  echo -e "08) qBittorrent ${cyan}3.3.14${normal} (HDChina Supported)"
  echo -e "09) qBittorrent ${cyan}3.3.15${normal}"
  echo -e "10) qBittorrent ${cyan}3.3.16${normal} (Latest Stable)"
  echo -e "11) qBittorrent ${cyan}dev${normal}    (GitHub master branch)"
  echo -e "12) Do not install qBittorrent"
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
    11) QBVERSION=dev ;;
    12) QBVERSION=NO ;;
    1) QBVERSION=3.3.7 ;;
    2) QBVERSION=3.3.8 ;;
    3) QBVERSION=3.3.9 ;;
    4) QBVERSION=3.3.10 ;;
    5) QBVERSION=3.3.11 ;;
    6) QBVERSION=3.3.12 ;;
    7) QBVERSION=3.3.13 ;;
    8) QBVERSION=3.3.14 ;;
    9) QBVERSION=3.3.15 ;;
    *) QBVERSION=3.3.11 ;;
  esac
  if [ $QBVERSION == "NO" ]; then
    echo "${zidingyi1}qBittorrent will ${repo_title}not${zidingyi1} be installed${normal}"
    echo  
  else 
    echo "${zidingyi1}qBittorrent-$QBVERSION${normal} will be installed"
    echo  
  fi
}




# 询问需要安装的 Deluge 版本 (5)
function _askdeluge() {
  echo -e "01) Deluge ${cyan}1.3.5${normal}"
  echo -e "02) Deluge ${cyan}1.3.6${normal}"
  echo -e "03) Deluge ${cyan}1.3.7${normal}"
  echo -e "04) Deluge ${cyan}1.3.8${normal}"
  echo -e "05) Deluge ${cyan}1.3.9${normal}"
  echo -e "06) Deluge ${cyan}1.3.10${normal}"
  echo -e "07) Deluge ${cyan}1.3.11${normal}"
  echo -e "08) Deluge ${cyan}1.3.12${normal}"
  echo -e "09) Deluge ${cyan}1.3.13${normal} (OurBits & HDHome Supported)"
  echo -e "10) Deluge ${cyan}1.3.14${normal}"
  echo -e "11) Deluge ${cyan}1.3.15${normal} (Latest Stable)"
  echo -e "12) Deluge ${cyan}dev${normal}    (GitHub develop branch)"
  echo -e "13) Do not install Deluge"
  echo -ne "${bold}${yellow}What version of Deluge do you want?${normal} (Default ${cyan}11${normal}): "; read version
  case $version in
    01) DEVERSION=1.3.5 ;;
    02) DEVERSION=1.3.6 ;;
    03) DEVERSION=1.3.7 ;;
    04) DEVERSION=1.3.8 ;;
    05) DEVERSION=1.3.9 ;;
    06) DEVERSION=1.3.10 ;;
    07) DEVERSION=1.3.11 ;;
    08) DEVERSION=1.3.12 ;;
    09) DEVERSION=1.3.13 ;;
    10) DEVERSION=1.3.14 ;;
    11 | "") DEVERSION=1.3.15 ;;
    12) DEVERSION=dev ;;
    13) DEVERSION=NO ;;
    1) DEVERSION=1.3.5 ;;
    2) DEVERSION=1.3.6 ;;
    3) DEVERSION=1.3.7 ;;
    4) DEVERSION=1.3.8 ;;
    5) DEVERSION=1.3.9 ;;
    6) DEVERSION=1.3.10 ;;
    7) DEVERSION=1.3.11 ;;
    8) DEVERSION=1.3.12 ;;
    9) DEVERSION=1.3.13 ;;
    *) DEVERSION=1.3.15 ;;
  esac
  if [ $DEVERSION == "NO" ]; then
    echo "${zidingyi1}Deluge will ${repo_title}not${zidingyi1} be installed${normal}"
  else 
    echo "${zidingyi1}Deluge-$DEVERSION${normal} will be installed"
  fi
}




# 询问需要安装的 Deluge-libtorrent 版本 (6)
function _askdelt() {
  if [ $DEVERSION == "NO" ]; then
    echo  
  else
    echo  
    echo -e "01) libtorrent ${cyan}RC_0_16${normal}"
    echo -e "02) libtorrent ${cyan}RC_1_0${normal}"
    echo -e "03) libtorrent ${cyan}RC_1_1${normal}"
    echo -ne "${bold}${yellow}What version of libtorrent do you want to be used for Deluge?${normal} (Default ${cyan}02${normal}): "; read version
    case $version in
      1) DELTVERSION=RC_0_16 ;;
      2 | "") DELTVERSION=RC_1_0 ;;
      3) DELTVERSION=RC_1_1 ;;
      01) DELTVERSION=RC_0_16 ;;
      02) DELTVERSION=RC_1_0 ;;
      03) DELTVERSION=1.1.x ;;
      *) DELTVERSION=RC_1_1 ;;
    esac
    echo "${zidingyi1}libtorrent $DELTVERSION${normal} will be installed"
    echo  
  fi
}




# 询问是否继续 (7)
function _askcontinue() {
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin or ${standout}${red}Ctrl+Z${normal} to cancel" ;read input
  echo
}




# 编译安装 qBittorrent (8)
function _installqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd >/dev/null 2>&1
  elif [ $QBVERSION == "dev" ]; then
    apt-get update >>"${OUTTO}" 2>&1
    apt-get -y install libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev git pkg-config automake libtool zlib1g-dev >>"${OUTTO}" 2>&1
    cd
    git clone -b RC_1_0 https://github.com/arvidn/libtorrent.git >>"${OUTTO}" 2>&1
    cd libtorrent
    ./autotool.sh >>"${OUTTO}" 2>&1
    ./configure --disable-debug --enable-encryption --prefix=/usr --with-libgeoip=system >>"${OUTTO}" 2>&1
    make clean >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    make install >>"${OUTTO}" 2>&1
    cd
    git clone -b master https://github.com/qbittorrent/qBittorrent.git >>"${OUTTO}" 2>&1
    cd qBittorrent
    ./configure --prefix=/usr --disable-gui >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    make install >>"${OUTTO}" 2>&1
    cd
    rm -rf libtorrent qBittorrent
  else 
    apt-get update >>"${OUTTO}" 2>&1
    apt-get -y install libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev git pkg-config automake libtool zlib1g-dev >>"${OUTTO}" 2>&1
    cd
    git clone -b RC_1_0 https://github.com/arvidn/libtorrent.git >>"${OUTTO}" 2>&1
    cd libtorrent
    ./autotool.sh >>"${OUTTO}" 2>&1
    ./configure --disable-debug --enable-encryption --prefix=/usr --with-libgeoip=system >>"${OUTTO}" 2>&1
    make clean >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    make install >>"${OUTTO}" 2>&1
    cd
    git clone -b release-${QBVERSION} https://github.com/qbittorrent/qBittorrent.git >>"${OUTTO}" 2>&1
    cd qBittorrent
    ./configure --prefix=/usr --disable-gui >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    make install >>"${OUTTO}" 2>&1
    cd
    rm -rf libtorrent qBittorrent
  fi
}




# 编译安装 Deluge (9)
function _installde() {
  if [ $DEVERSION == "NO" ]; then
    cd >/dev/null 2>&1
  elif [ $DEVERSION == "dev" ]; then
    cd
    apt-get install -y build-essential checkinstall libboost-system-dev libboost-python-dev libboost-chrono-dev libboost-random-dev libssl-dev python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako >>"${OUTTO}" 2>&1
    git clone -b ${DELTVERSION} https://github.com/arvidn/libtorrent.git >>"${OUTTO}" 2>&1
    cd libtorrent
    ./autotool.sh >>"${OUTTO}" 2>&1
    ./configure --enable-python-binding --with-libiconv >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    checkinstall -y >>"${OUTTO}" 2>&1
    ldconfig >>"${OUTTO}" 2>&1
    cd
    git clone -b develop https://github.com/deluge-torrent/deluge.git >>"${OUTTO}" 2>&1
    cd deluge
    python setup.py build >>"${OUTTO}" 2>&1
    python setup.py install --install-layout=deb >>"${OUTTO}" 2>&1
    cd
    rm -rf deluge libtorrent
  else
    cd
    apt-get install -y build-essential checkinstall libboost-system-dev libboost-python-dev libboost-chrono-dev libboost-random-dev libssl-dev python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako >>"${OUTTO}" 2>&1
    git clone -b ${DELTVERSION} https://github.com/arvidn/libtorrent.git >>"${OUTTO}" 2>&1
    cd libtorrent
    ./autotool.sh >>"${OUTTO}" 2>&1
    ./configure --enable-python-binding --with-libiconv >>"${OUTTO}" 2>&1
    make -j$(nproc) >>"${OUTTO}" 2>&1
    checkinstall -y >>"${OUTTO}" 2>&1
    ldconfig >>"${OUTTO}" 2>&1
    cd
    git clone -b ${DEVERSION} https://github.com/deluge-torrent/deluge.git >>"${OUTTO}" 2>&1
    cd deluge
    python setup.py build >>"${OUTTO}" 2>&1
    python setup.py install --install-layout=deb >>"${OUTTO}" 2>&1
    cd
    rm -rf deluge libtorrent
  fi
}




# 设置 qBittorrent (10)
function _setqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd >/dev/null 2>&1
  else
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

  mkdir -p /root/.config/qBittorrent
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

  systemctl daemon-reload >/dev/null 2>&1
  systemctl enable qbittorrent >/dev/null 2>&1
  systemctl start qbittorrent >/dev/null 2>&1
  fi
}




# 设置快捷命令 (11)
function _setcommand() {
  cat >~/.bashrc<<EOF
echo alias dea="deluged"
echo alias deb="killall deluge"
echo alias dewa="deluge-web -f"
echo alias dewb="killall deluge-web"
echo alias qba="systemctl start qbittorrent"
echo alias qbb="systemctl stop qbittorrent"
echo alias qbzhuangtai="systemctl status qbittorrent"
EOF
  source ~/.bashrc >/dev/null 2>&1
}




# 结束 (12)
function _end() {
  echo
  echo -e " ${black}${on_green}    BitTorrent Clients Installation Completed    ${normal} "
  echo;echo
  echo "可用命令:  "
  echo '  -------------------'
  echo
  echo -e " ${green}dea${normal}         - 运行 Deluge"
  echo -e " ${green}deb${normal}         - 关闭 Deluge"
  echo -e " ${green}dewa${normal}        - 启用 Deluge WebUI"
  echo -e " ${green}dewb${normal}        - 停用 Deluge WebUI"
  echo -e " ${green}qba${normal}         - 运行 qBittorrent-nox"
  echo -e " ${green}qbb${normal}         - 关闭 qBittorrent-nox"
  echo -e " ${green}qbzhuangtai${normal} - 查询 qBittorrent-nox 当前运行状态"
  echo;echo;echo
  echo '####################################################################
  echo "#   "
  echo "#   "
  echo "#   ${yellow}${bold}This is the choice of Steins;Gate.${normal}"
  echo "#   "
  echo "#   "
  echo '####################################################################
  echo
}




# 进度 (14)
spinner() {
    local pid=$1
    local delay=0.25
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [${bold}${yellow}%c${normal}]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
    echo -ne "${OK}"
}




# 脚本结构 (15)
_intro
_checkroot
_logcheck
_askqbt
_askdeluge
_askdelt
_askcontinue




echo
echo ""
echo "${bold}${magenta}The selected clients will be installed, this may take between${normal}"
echo "${bold}${magenta}10 and 35 minutes depending on your systems specs${normal}"
echo ""
echo -n "Installing qBittorrent ... ";_installqbt & spinner $!;echo
echo -n "Installing Deluge ... ";_installde & spinner $!;echo
echo -n "Configuring qBittorrent ... ";_setqbt & spinner $!;echo
_setcommand
clear
_end





