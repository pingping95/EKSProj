#!/bin/bash

## Description
## Amazon Linux2 전용 스크립트입니다.
## 기타 OS에서는 정상 작동되지 않습니다.
## id와 pw를 기입해주어야 합니다.
## Amazon Linux2에서는 Time Sync Service가 기본으로 적용되어 있습니다.


# update Package Manager
sudo yum -y update

# 생성할 user의 id와 pw 기입
id='admin_user'
pw='passw0rd1!'

# User 생성
# User 없을 시 아래 if문을 실행하지 않음
if [ -n "$id" ] && [ -n "$pw" ]; then
  sudo useradd $id
  sudo bash -c "echo '$id:$pw' | chpasswd"
  sudo usermod -aG wheel $id
fi

# Timezone 변경
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime


# password 접속 허용
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart