#!/bin/bash

# homeディレクトリに.pyenvがなければDEFAULTの設定をコピーしてくる
if [ ! -d /root/.pyenv ]; then
    cp -a /cp_root/. /root
fi
rm -rf /cp_root

# mount:/root するときにmount/.ssh/authorized_keysを正しいパーミッションでおくか
# /authorized_keysをマウントするか
if [ ! -f ~/.ssh/authorized_keys ]; then
    if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi
fi
if [ -f /authorized_keys ]; then
    cp /authorized_keys ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# sshd起動！
/usr/sbin/sshd

if [ $# -eq 0 ]; then
    # jupyter起動!
    python /monitoring.py
else
    $@
fi