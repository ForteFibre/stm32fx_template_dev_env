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
yes | sudo -E apt update 1> /dev/null && echo 'APTのキャッシュの更新が完了しました'

# Install cmake
sudo -E apt -y install cmake 1> /dev/null  &&  echo 'cmakeのインストール完了しました'
# Install git
sudo -E apt -y install git 1> /dev/null  &&  echo 'gitのインストール完了しました'

#--------------------------
# コンパイラのインストール
# -------------------------

cd /tmp
mkdir -p ~/.local/bin
mkdir -p ~/.local/lib
wget 'https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2' \
        && echo -e '\barmコンパイラのアーカイブのダウンロードが完了しました'
tar xvf 'gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2' -C ~/.local/lib 1> /dev/null \
        && echo 'アーカイブの展開が完了しました'
ls ~/.local/lib/gcc-arm-none-eabi-9-2020-q2-update/bin | xargs -I{} ln -s ../lib/gcc-arm-none-eabi-9-2020-q2-update/bin/{} ~/.local/bin/ \
        && echo 'armコンパイラへのシンボリックリンクを作成しました'

#----------------------
# stlinkのインストール
#----------------------

sudo -E apt -y install stlink-tools 1> /dev/null && echo 'stlink-toolsのインストールが完了しました'
