#!/bin/bash

set -eu

echo -e "\e[1;32m> unzip\e[m"
echo -e "\e[90m[1/1]\e[m インストール中..."
sudo -E apt-get -y install unzip -qq
echo

cd /tmp

echo -e "\e[1;32m> stlink for Windows\e[m"
echo -e "\e[90m[1/2]\e[m アーカイブ取得中..."
wget "https://github.com/stlink-org/stlink/releases/download/v1.7.0/stlink-1.7.0-x86_64-w64-mingw32.zip" -O "stlink-1.7.0-x86_64-w64-mingw32.zip" -q --show-progress
echo -e "\e[90m[2/3]\e[m アーカイブ展開中..."
if [ -e /tmp/stlink-1.7.0-x86_64-w64-mingw32 ]; then
    sudo rm -rf /tmp/stlink-1.7.0-x86_64-w64-mingw32
fi
unzip "stlink-1.7.0-x86_64-w64-mingw32.zip" -d "stlink-1.7.0-x86_64-w64-mingw32"

WINHOME=$(wslpath "$(wslvar USERPROFILE)")

if [ -e "$WINHOME"/stlink-1.7.0-x86_64-w64-mingw32 ]; then
    sudo rm -rf "$WINHOME"/stlink-1.7.0-x86_64-w64-mingw32
fi

# WSLからWindows上のファイルのパーミッションを変更出来ず、
# Operation not permittedとなることを避けるために、事前に
# パーミッションを合わせておく
chmod -R 777 stlink-1.7.0-x86_64-w64-mingw32
sudo chown -R root:root stlink-1.7.0-x86_64-w64-mingw32
sudo mv "stlink-1.7.0-x86_64-w64-mingw32/stlink-1.7.0-x86_64-w64-mingw32" "$WINHOME"/
echo -e "\e[90m[3/3]\e[m シンボリックリンク作成中..."
mkdir -p ~/.local/bin
ls "$WINHOME"/stlink-1.7.0-x86_64-w64-mingw32/bin | while read -r EXE_FILE; do
   LINKNAME=$(basename $EXE_FILE .exe)
   ln -fs "$WINHOME"/stlink-1.7.0-x86_64-w64-mingw32/bin/"$EXE_FILE" ~/.local/bin/"$LINKNAME"
done
