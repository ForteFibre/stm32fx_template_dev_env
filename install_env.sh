#!/bin/bash
#================================
# stm32fx_template setup script
#================================

# このスクリプトはcloneしてから実行すること
set -eu

# 表示のついでにsudoのパスワードを予め入力しておいてもらう
sudo echo -e "\n\e[1;96mstm32fx_template ツールチェインインストーラー\e[m\n"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo -e "\e[1;32m> udev\e[m"
echo -e "\e[90m[1/1]\e[m ルールファイル設置中..."
sudo cp "$SCRIPT_DIR"/50-udev.rules /etc/udev/rules.d/
echo

echo -e "\e[1;32m> APT\e[m"
echo -e "\e[90m[1/1]\e[m パッケージリスト更新中..."
sudo -E apt-get update -qq
echo

echo -e "\e[1;32m> CMake\e[m"
echo -e "\e[90m[1/1]\e[m インストール中..."
sudo -E apt-get -y install cmake -qq
echo

echo -e "\e[1;32m> GNU Make\e[m"
echo -e "\e[90m[1/1]\e[m インストール中..."
sudo -E apt-get -y install cmake -qq
echo

cd /tmp

echo -e "\e[1;32m> stlink\e[m"
echo -e "\e[90m[1/2]\e[m debパッケージ取得中..."
wget "https://github.com/stlink-org/stlink/releases/download/v1.6.1/stlink-1.6.1-1_amd64.deb" -O "stlink-1.6.1-1_amd64.deb" -q --show-progress
echo -e "\e[90m[2/2]\e[m インストール中..."
sudo -E apt-get -y install ./stlink-1.6.1-1_amd64.deb -qq
echo

echo -e "\e[1;32m> GNU Arm Embedded Toolchain\e[m"
mkdir -p ~/.local/bin
mkdir -p ~/.local/lib
echo -e "\e[90m[1/3]\e[m アーカイブ取得中..."
wget "https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2" -O "gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2" -q --show-progress
echo -e "\e[90m[2/3]\e[m アーカイブ展開中..."
if [ -e ~/.local/lib/gcc-arm-none-eabi-9-2020-q2-update ]; then
    rm ~/.local/lib/gcc-arm-none-eabi-9-2020-q2-update -rf
fi
tar -xf "gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2" -C ~/.local/lib
echo -e "\e[90m[3/3]\e[m シンボリックリンク作成中..."
ls ~/.local/lib/gcc-arm-none-eabi-9-2020-q2-update/bin | xargs -I{} ln -fs ../lib/gcc-arm-none-eabi-9-2020-q2-update/bin/{} ~/.local/bin/
echo

echo -e "\e[1;96mインストール完了！\e[m\n"
