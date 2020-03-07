#!/bin/bash
#================================
# stm32fx_template setup script
#================================

# このスクリプトはcloneしてから実行すること
set -eu
SCRIPT_DIR=$(cd $(dirname $0); pwd)

#Add udev-rules file
sudo cp "$SCRIPT_DIR"/50-udev.rules /etc/udev/rules.d/ && echo 'udevルールファイルの設置が完了しました'

#Update cache
yes | sudo apt-get update 1> /dev/null && echo 'APTのキャッシュの更新が完了しました'

#GNU Tools for ARM Embedded Processors is 32bit application.
sudo apt-get -y install lib32z1 1> /dev/null && echo 'lib32z1パッケージのインストール完了しました'
# Install cmake
sudo apt-get -y install cmake 1> /dev/null  &&  echo 'cmakeのインストール完了しました'
# Install git
sudo apt-get -y install git 1> /dev/null  &&  echo 'gitのインストール完了しました'

#--------------------------
# コンパイラのインストール
# -------------------------

# aptでインストールしたコンパイラを使用するとコンパイルエラーがでた．
# TODO: 原因を解明
#sudo apt-get -y install gcc-arm-none-eabi 1> /dev/null  &&  echo 'armコンパイラのインストール完了しました'

# armコンパイラをダウンロードして配置
cd /tmp
wget 'https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2'\
        -nc \
        && echo -e '\barmコンパイラのアーカイブのダウンロードが完了しました'
sudo tar xvf 'gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2' -C '/usr/local' 1> /dev/null \
        && echo 'アーカイブの展開が完了しました'
sudo ln -snf '/usr/local/gcc-arm-none-eabi-7-2018-q2-update' '/usr/local/arm-cs-tools' \
        && echo 'armコンパイラへのシンボリックリンクを作成しました'

sudo apt-get -y install dh-autoreconf     1> /dev/null  &&  echo 'dh_autoreconfパッケージのインストール完了しました'
sudo apt-get -y install libusb-1.0-0-dev  1> /dev/null  &&  echo 'libusb-1.0-0-devパッケージのインストール完了しました'


#----------------------
# stlinkのインストール
#----------------------

# Download stlink
cd /tmp
if [ -e stlink ]; then
    echo '古いstlinkファイルを削除しました'
    rm -rf stlink
fi
git clone 'https://github.com/texane/stlink.git' stlink && echo 'stlinkのソースの取得が完了しました'
cd /tmp/stlink
git fetch --tags
git checkout v1.2.0

mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Debug .. 2> /dev/null
make 2> /dev/null

sudo make install && echo 'stlinkのインストールが完了しました'

#Setup dfu-util
sudo apt-get -y install dfu-util 1> /dev/null  &&  echo 'dfu-utilパッケージのインストールが完了しました'
