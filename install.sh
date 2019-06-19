#===============================================================================
#                                  install.sh
#===============================================================================
# 対象OS: Ubuntu16 ~ Ubuntu18
# 著者: nishi
# 作成日: 2019/06/19
# 説明:
#   このスクリプトは, wget, curl などを使用して実行されることを目的としています
#   次のコマンドで実行できます
#      TODO: 書く
#   stm32fx_template_dev_env リポジトリをクローンし, 次のスクリプトを実行します
#     - install_env.sh
#     - install_stm32plus.sh

yes | sudo apt-get update 1> /dev/null && echo 'APTのキャッシュの更新が完了しました'

if !(type git); then
    sudo apt-get install -y git 1> /dev/null && echo 'gitのインストールが完了'
fi

cd /tmp
if [ -e /tmp/stm32fx_template_dev_env ]; then
    echo '古いstm32fx_template_dev_envディレクトリを削除しています'
    rm -rf /tmp/stm32fx_template_dev_env
fi
git clone https://github.com/nishi-yuki/stm32fx_template_dev_env.git stm32fx_template_dev_env
cd /tmp/stm32fx_template_dev_env
# pwd
# git status
bash install_env.sh
bash install_stm32plus.sh

# End
echo "-----------------"
echo "Install finished!"
echo "-----------------"
#!/bin/bash
