#!/bin/sh
#
# 作者：弱鸡
# 基本上都是从各处抄来的，感谢原作者（参考资料在下边）
# 有很多地方我想做得更好不过就我这三脚猫功夫……笑笑就好
#
# https://github.com/qbittorrent/qBittorrent/wiki/Compiling-qBittorrent-on-Debian-and-Ubuntu
# https://github.com/qbittorrent/qBittorrent/wiki/Setting-up-qBittorrent-on-Ubuntu-server-as-daemon-with-Web-interface-(15.04-and-newer)
# https://github.com/QuickBox/QB
# https://github.com/arakasi72/rtinst
# https://flexget.com/InstallWizard/Linux
# https://rclone.org/install
#
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
#####& spinner $!;echo
#####>>"${OUTTO}" 2>&1



clear




# 介绍 (1)
function _intro() {
  echo
  echo
  echo "[${repo_title}Seedbox${normal}] ${title} BitTorrent Client Installation ${normal}  "
  echo
  echo "   ${title}                         Warning!                        ${normal} "
  echo "   ${message_title}  This script is a BETA and have many unresolved issues  ${normal} "
  echo "   ${message_title}          May work with Ubuntu 16.04 | Debian 9          ${normal} "
  echo "   ${message_title}                                                         ${normal} "
  echo "   ${message_title}          Press Ctrl+Z to stop this shit script          ${normal} "
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
  echo "${green}You're running as root. Let's continue${normal} ... "
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
}




# 询问需要安装的 qBittorrent 的版本 (4)
function _askqbt() {
  clear
  echo -e "01) qBittorrent ${cyan}3.3.7${normal}"
  echo -e "02) qBittorrent ${cyan}3.3.8${normal}"
  echo -e "03) qBittorrent ${cyan}3.3.9${normal}"
  echo -e "04) qBittorrent ${cyan}3.3.10${normal}"
  echo -e "05) qBittorrent ${cyan}3.3.11${normal}"
  echo -e "06) qBittorrent ${cyan}3.3.12${normal}"
  echo -e "07) qBittorrent ${cyan}3.3.13${normal}"
  echo -e "08) qBittorrent ${cyan}3.3.14${normal}"
  echo -e "09) qBittorrent ${cyan}3.3.15${normal}"
  echo -e "10) qBittorrent ${cyan}3.3.16${normal} (latest stable)"
  echo -e "11) qBittorrent ${cyan}dev${normal}"
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
    11) QBVERSION=master ;;
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
  elif [ $QBVERSION == "master" ]; then
    echo "${zidingyi1}qBittorrent dev${normal} will be installed"
    echo  
  else 
    echo "${zidingyi1}qBittorrent $QBVERSION${normal} will be installed"
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
  echo -e "09) Deluge ${cyan}1.3.13${normal}"
  echo -e "10) Deluge ${cyan}1.3.14${normal}"
  echo -e "11) Deluge ${cyan}1.3.15${normal} (latest stable)"
  echo -e "12) Do not install Deluge"
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
    12) DEVERSION=NO ;;
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
    echo "${zidingyi1}Deluge $DEVERSION${normal} will be installed"
  fi
}




# 询问需要安装的 Deluge libtorrent 版本 (6)
function _askdelt() {
  if [ $DEVERSION == "NO" ]; then
    echo  
  else
    echo  
    echo -e "01) libtorrent ${cyan}RC_0_16${normal}"
    echo -e "02) libtorrent ${cyan}RC_1_0${normal}"
    echo -e "03) libtorrent ${cyan}RC_1_1${normal}"
    echo -e "04) libtorrent ${cyan}repo${normal}"
    echo -e "05) libtorrent ${cyan}dev${normal}"
    echo -ne "${bold}${yellow}What version of libtorrent do you want to be used for Deluge?${normal} (Default ${cyan}04${normal}): "; read version
    case $version in
      1) DELTVERSION=RC_0_16 ;;
      2) DELTVERSION=RC_1_0 ;;
      3) DELTVERSION=RC_1_1 ;;
      4 | "") DELTVERSION=NO ;;
      5) DELTVERSION=master ;;
      01) DELTVERSION=RC_0_16 ;;
      02) DELTVERSION=RC_1_0 ;;
      03) DELTVERSION=RC_1_1 ;;
      04) DELTVERSION=NO ;;
      05) DELTVERSION=master ;;
      *) DELTVERSION=RC_1_0 ;;
    esac
    if [ $DELTVERSION == "NO" ]; then
      echo "libtorrent will be installed from repo"
    elif [ $DELTVERSION == "master" ]; then
      echo "${zidingyi1}libtorrent-dev${normal} will be installed"
      echo  
    else 
      echo "${zidingyi1}libtorrent-$DELTVERSION${normal} will be installed"
    fi
    echo  
  fi
}




# 询问需要安装的 rTorrent 版本 (7)
function _askrt() {
  echo -e "01) rTorrent ${cyan}0.9.6${normal} (with ipv6 support)"
  echo -e "02) rTorrent ${cyan}0.9.4${normal}"
  echo -e "03) rTorrent ${cyan}0.9.3${normal}"
  echo -e "04) Do not install rTorrent"
  echo -ne "${bold}${yellow}What version of rTorrent do you want?${normal} (Default ${cyan}04${normal}): "; read version
  case $version in
    01) RTVERSION=0.9.6 ;;
    02) RTVERSION=0.9.4 ;;
    03) RTVERSION=0.9.3 ;;
    04) RTVERSION=NO ;;
    *) RTVERSION=NO ;;
    1) RTVERSION=0.9.6 ;;
    2) RTVERSION=0.9.4 ;;
    3) RTVERSION=0.9.3 ;;
    4 | "") RTVERSION=NO ;;
  esac
  if [ $RTVERSION == "NO" ]; then
    echo "${zidingyi1}rTorrent will ${repo_title}not${zidingyi1} be installed${normal}"
  else 
    echo "${zidingyi1}rTorrent $RTVERSION${normal} will be installed"
  fi
  echo
}




# 询问是否需要安装 Flexget (8)
function _askflex() {
  echo -ne "${bold}${yellow}Would you like to install Flexget? (Used for RSS)${normal} [Y]es or [${cyan}N${normal}]o: "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss]) flexget=YES ;;
    [nN] | [nN][Oo] | "" ) flexget=NO ;;
    *) flexget=NO ;;
  esac
  if [ $flexget == "YES" ]; then
    echo "${zidingyi1}Flexget${normal} will be installed"
  else 
    echo "${zidingyi1}Flexget will ${repo_title}not${zidingyi1} be installed${normal}"
  fi
  echo
}




# 询问是否需要安装 rclone (9)
function _askrclone() {
  echo -ne "${bold}${yellow}Would you like to install rclone? (Used for sync files to cloud drive)${normal} [Y]es or [${cyan}N${normal}]o: "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss]) rclone=YES ;;
    [nN] | [nN][Oo] | "" ) rclone=NO ;;
    *) rclone=NO ;;
  esac
  if [ $rclone == "YES" ]; then
    echo "${zidingyi1}rclone${normal} will be installed"
  else 
    echo "${zidingyi1}rclone will ${repo_title}not${zidingyi1} be installed${normal}"
  fi
  echo
}




# 询问是否继续 (10)
function _askcontinue() {
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin or ${standout}${red}Ctrl+Z${normal} to cancel" ;read input
  echo
}




# 编译安装 qBittorrent (11)
function _installqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd
  elif [ $QBVERSION == "dev" ]; then
    apt-get update >>"${OUTTO}" 2>&1
    apt-get install -y libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git >>"${OUTTO}" 2>&1
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
    echo;echo;echo >>"${OUTTO}" 2>&1
    echo "  QB-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
    echo;echo;echo >>"${OUTTO}" 2>&1
  else 
    apt-get update >>"${OUTTO}" 2>&1
    apt-get install -y libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git >>"${OUTTO}" 2>&1
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
    echo;echo;echo >>"${OUTTO}" 2>&1
    echo "  QB-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
    echo;echo;echo >>"${OUTTO}" 2>&1
  fi
}




# 设置 qBittorrent (12)
function _setqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd
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




# 编译安装 Deluge (13)
function _installde() {
  if [ $DEVERSION == "NO" ]; then
    cd >>"${OUTTO}" 2>&1
  else
    if [ $DELTVERSION == "NO" ]; then
      cd >>"${OUTTO}" 2>&1
      apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako slimit >>"${OUTTO}" 2>&1
      wget -q http://download.deluge-torrent.org/source/deluge-$DEVERSION.tar.gz >>"${OUTTO}" 2>&1
      tar zxf deluge*.tar.gz >>"${OUTTO}" 2>&1
      cd deluge* >>"${OUTTO}" 2>&1
      python setup.py build >>"${OUTTO}" 2>&1
      python setup.py install --install-layout=deb >>"${OUTTO}" 2>&1
      cd >>"${OUTTO}" 2>&1
      rm -rf deluge* >>"${OUTTO}" 2>&1
      echo;echo;echo >>"${OUTTO}" 2>&1
      echo "  DE-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
      echo;echo;echo >>"${OUTTO}" 2>&1
    else
      cd >>"${OUTTO}" 2>&1
      apt-get install -y git build-essential checkinstall libboost-system-dev libboost-python-dev libboost-chrono-dev libboost-random-dev libssl-dev git libtool automake autoconf >>"${OUTTO}" 2>&1
      git clone -b ${DELTVERSION} https://github.com/arvidn/libtorrent.git >>"${OUTTO}" 2>&1
      cd libtorrent >>"${OUTTO}" 2>&1
      ./autotool.sh >>"${OUTTO}" 2>&1
      ./configure --enable-python-binding --with-libiconv >>"${OUTTO}" 2>&1
      make -j$(nproc) >>"${OUTTO}" 2>&1
      checkinstall -y >>"${OUTTO}" 2>&1
      ldconfig >>"${OUTTO}" 2>&1
      cd >>"${OUTTO}" 2>&1
      apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako slimit >>"${OUTTO}" 2>&1
      wget -q http://download.deluge-torrent.org/source/deluge-$DEVERSION.tar.gz >>"${OUTTO}" 2>&1
      tar zxf deluge*.tar.gz >>"${OUTTO}" 2>&1
      cd deluge* >/dev/null 2>&1
      python setup.py build >>"${OUTTO}" 2>&1
      python setup.py install --install-layout=deb >>"${OUTTO}" 2>&1
      cd >/dev/null 2>&1
      rm -rf deluge libtorrent
      echo;echo;echo >>"${OUTTO}" 2>&1
      echo "  DE-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
      echo;echo;echo >>"${OUTTO}" 2>&1
    fi
  fi
}




# 使用 rtinst 脚本安装 rTorrent+ruTorrent (14)
function _installrt() {
  wget https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup >>"${OUTTO}" 2>&1
  bash rtsetup master >>"${OUTTO}" 2>&1
  sed -i '18s/.*/rtorrentrel='${RTVERSION}'/' /usr/local/bin/rtinst
  rtinst -t -d -y -u ${MINGZI} -p ${MIMA} --webpass ${WMIMA} >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
  echo "  RT-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
}




# 安装 Flexget (15)
function _installflex() {
  apt-get -y install python-pip >>"${OUTTO}" 2>&1
  pip install --upgrade setuptools >>"${OUTTO}" 2>&1
  pip install flexget >>"${OUTTO}" 2>&1
  cd  >>"${OUTTO}" 2>&1
  mkdir .flexget >/dev/null 2>&1
  cd .flexget >>"${OUTTO}" 2>&1
  touch config.yml >>"${OUTTO}" 2>&1
  cd >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
  echo "  FLEXGET-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
}



# 安装 rclone (16)
function _installrclone() {
  cd >>"${OUTTO}" 2>&1
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip >>"${OUTTO}" 2>&1
  unzip rclone-current-linux-amd64.zip >>"${OUTTO}" 2>&1
  cd rclone-*-linux-amd64 >>"${OUTTO}" 2>&1
  cp rclone /usr/bin/ >>"${OUTTO}" 2>&1
  chown root:root /usr/bin/rclone >>"${OUTTO}" 2>&1
  chmod 755 /usr/bin/rclone >>"${OUTTO}" 2>&1
  mkdir -p /usr/local/share/man/man1 >>"${OUTTO}" 2>&1
  cp rclone.1 /usr/local/share/man/man1 >>"${OUTTO}" 2>&1
  mandb >>"${OUTTO}" 2>&1
  cd >>"${OUTTO}" 2>&1
  rm -rf rclone* >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
  echo "  RCLONE-INSTALLATION-COMPLETED  " >>"${OUTTO}" 2>&1
  echo;echo;echo >>"${OUTTO}" 2>&1
}




# 设置快捷命令 (17)
function _setcommand() {
  cat >/etc/bashrc<<EOF
alias dekai="deluged"
alias deguan="killall deluge"
alias dewkai="deluge-web -f"
alias dewguan="killall deluge-web"
alias qbkai="systemctl start qbittorrent"
alias qbguan="systemctl stop qbittorrent"
alias qbzhuangtai="systemctl status qbittorrent"
alias rsskai="flexget daemon start --daemonize"
alias rssguan="flexget daemon stop"

EOF
  source /etc/bashrc >>"${OUTTO}" 2>&1
}




# 结束 (18)
function _end() {
  echo
  echo -e " ${black}${on_green}    BitTorrent Clients Installation Completed    ${normal} "
  echo;echo
  echo 
  echo '  -------------------'
  echo
  echo -e " ${green}dekai${normal}         - 运行 Deluge"
  echo -e " ${green}deguan${normal}        - 关闭 Deluge"
  echo -e " ${green}dewkai${normal}        - 启用 Deluge WebUI"
  echo -e " ${green}dewguan${normal}       - 停用 Deluge WebUI"
  echo -e " ${green}qbkai${normal}         - 运行 qBittorrent-nox"
  echo -e " ${green}qbguan${normal}        - 关闭 qBittorrent-nox"
  echo -e " ${green}qbzhuangtai${normal}   - 查询 qBittorrent-nox 当前运行状态"
  echo -e " ${green}rsskai${normal}        - 运行 Flexget Daemon"
  echo -e " ${green}rssguan${normal}       - 关闭 Flexget Daemon"
  echo
  echo
  echo '####################################################################'
  echo "#   "
  echo "#   "
  echo "#   ${yellow}${bold}This is the choice of Steins;Gate.${normal}"
  echo "#   "
  echo "#   "
  echo '####################################################################'
  echo
  echo
}




# 进度功能 (19)
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




# 脚本结构 (20)
_intro
_checkroot
_logcheck
_askqbt
_askdeluge
_askdelt
_askrt
_askflex
_askrclone
_askcontinue


echo
echo ""
echo "${bold}${magenta}The selected clients will be installed, this may take between${normal}"
echo "${bold}${magenta}10 and 35 minutes depending on your systems specs${normal}"
echo ""


if [ $QBVERSION == "NO" ]; then
  echo "Skip qBittorrent installation"
else
  echo -n "Installing qBittorrent ... ";_installqbt & spinner $!;echo
  echo -n "Configuring qBittorrent ... ";_setqbt & spinner $!;echo
fi


if [ $DEVERSION == "NO" ]; then
  echo "Skip Deluge installation"
else
  echo -n "Installing Deluge ... ";_installde & spinner $!;echo
fi


if [ $RTVERSION == "NO" ]; then
  echo "Skip rTorrent installation"
else
  echo -n "Installing rTorrent ... ";_installrt & spinner $!;echo
fi


if [ $flexget == "NO" ]; then
  echo "Skip Flexget installation"
else
  echo -n "Installing Flexget ... ";_installflex & spinner $!;echo
fi


if [ $rclone == "NO" ]; then
  echo "Skip rclone installation"
else
  echo -n "Installing rclone ... ";_installrclone & spinner $!;echo
fi


echo -n "Configuring QuickCommands ... ";_setcommand & spinner $!;echo

clear
_end
  