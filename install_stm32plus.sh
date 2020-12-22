#!/bin/bash

set -eu

# 表示のついでにsudoのパスワードを予め入力しておいてもらう
sudo echo -e "\n\e[1;96mstm32fx_template ライブラリインストーラー\e[m\n"

if ! which arm-none-eabi-gcc 1> /dev/null; then
  echo "stm32plusをインストールするにはarm-none-eabi-gccが必要です"
  exit 1
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo -e "\e[1;32m> SCons\e[m"
echo -e "\e[90m[1/1]\e[m インストール中..."
sudo -E apt-get -y install scons -qq
echo

cp "$SCRIPT_DIR"/stm32plus_use_standard_stl.patch /tmp
cp "$SCRIPT_DIR"/stm32plus_compiler_option.patch /tmp
cd /tmp

if [ -e stm32plus ]; then
  rm -rf stm32plus
fi

echo -e "\e[1;32m> stm32plus\e[m"
echo -e "\e[90m[1/4]\e[m リポジトリクローン中..."
git clone https://github.com/andysworkshop/stm32plus.git -q

echo -e "\e[90m[2/4]\e[m パッチ適用中..."
cd stm32plus
rm ./lib/include/stl -rf
git apply ../stm32plus_use_standard_stl.patch
git apply ../stm32plus_compiler_option.patch

echo -ne "\e[90m[3/4]\e[m ビルド中... 1/8"
scons mode=small mcu=f1md hse=12000000 -j4 examples=no 1> /dev/null && echo -ne "\e[3D2/8"
scons mode=small mcu=f1hd hse=12000000 -j4 examples=no 1> /dev/null && echo -ne "\e[3D3/8"
scons mode=small mcu=f1md hse=8000000 -j4 examples=no 1> /dev/null && echo -ne "\e[3D4/8"
scons mode=small mcu=f1hd hse=8000000 -j4 examples=no 1> /dev/null && echo -ne "\e[3D5/8"

scons mode=small mcu=f4 hse=25000000 -j4 float=hard examples=no 1> /dev/null && echo -ne "\e[3D6/8"
scons mode=small mcu=f4 hse=8000000 -j4 float=hard examples=no 1> /dev/null && echo -ne "\e[3D7/8"
scons mode=small mcu=f4 hse=12000000 -j4 float=hard examples=no 1> /dev/null && echo -ne "\e[3D8/8"

scons mode=small mcu=f429 hse=8000000 -j4 float=hard examples=no 1> /dev/null && echo -e "\e[3D   "

if [ -e ~/workspace/stm32plus ]; then
  rm -rf ~/workspace/stm32plus
fi

echo -e "\e[90m[4/4]\e[m ビルド成果物コピー中..."
mkdir -p ~/workspace
mv ./lib ~/workspace/stm32plus

cd ~/workspace/stm32plus/build

#To be compatible with old stm32plus

cp -r small-f1hd-8000000e small-f1hd-8000000
cp -r small-f1hd-12000000e small-f1hd-12000000
cp -r small-f1md-8000000e small-f1md-8000000
cp -r small-f1md-12000000e small-f1md-12000000
cp -r small-f4-8000000e-hard small-f4-8000000-hard
cp -r small-f4-25000000e-hard small-f4-25000000-hard
cp -r small-f429-8000000e-hard small-f429-8000000-hard

cd small-f1hd-8000000
cp libstm32plus-small-f1hd-8000000e.a libstm32plus-small-f1hd-8000000.a
cd ../small-f1hd-12000000
cp libstm32plus-small-f1hd-12000000e.a libstm32plus-small-f1hd-12000000.a
cd ../small-f1md-8000000
cp libstm32plus-small-f1md-8000000e.a libstm32plus-small-f1md-8000000.a
cd ../small-f1md-12000000
cp libstm32plus-small-f1md-12000000e.a libstm32plus-small-f1md-12000000.a
cd ../small-f4-8000000-hard
cp libstm32plus-small-f4-8000000e-hard.a libstm32plus-small-f4-8000000-hard.a
cd ../small-f4-25000000-hard
cp libstm32plus-small-f4-25000000e-hard.a libstm32plus-small-f4-25000000-hard.a
cd ../small-f429-8000000-hard
cp libstm32plus-small-f429-8000000e-hard.a libstm32plus-small-f429-8000000-hard.a
echo

echo -e "\e[1;96mインストール完了！\e[m\n"