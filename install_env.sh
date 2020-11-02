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

# Install cmake
sudo apt-get -y install cmake 1> /dev/null  &&  echo 'cmakeのインストール完了しました'
# Install git
sudo apt-get -y install git 1> /dev/null  &&  echo 'gitのインストール完了しました'

#--------------------------
# コンパイラのインストール
# -------------------------

sudo apt-get -y install gcc-arm-none-eabi 1> /dev/null  &&  echo 'armコンパイラのインストール完了しました'

#----------------------
# stlinkのインストール
#----------------------

sudo apt-get -y install stlink-tools 1> /dev/null && echo 'stlink-toolsのインストールが完了しました'
