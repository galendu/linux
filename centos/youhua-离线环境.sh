#!/bin/bash
set -e
echo "---------------字符集设置 en_US.utf8-------------------"
localectl set-locale LANG=en_US.utf8
echo "---------------配置shell,便于定位当前目录--------------"
echo 'export PS1="[ \033[01;33m\u\033[0;36m@\033[01;34m\h \033[01;31m\w\033[0m ]\033[0m \n#"' >> /etc/profile
#vm.swappiness=10 #内存使用到100-10=90%的时候,开始出现有交换分区的使用
echo "----------------开始优化内核--------------"
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_fin_timeout = 30
vm.swappiness=10
vm.max_map_count = 262144
EOF
echo "----------------设置打开文件描述符的数量-----------------"
cat >> /etc/security/limits.conf << EOF
*           soft   nofile       65535
*           hard   nofile       65535
EOF

echo "-----------------vim基础配置------------------------------"
cat >> /root/.vimrc << EOF
syntax enable
syntax on
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set ignorecase
set nocompatible
set wildmenu
set paste
set nowrap
set expandtab
set tabstop=2
set shiftwidth=4
set softtabstop=4
set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
EOF
echo "--------------------关闭selinux-------------------------"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
echo "--------------------关闭firewalld-------------------------"
systemctl stop firewalld && systemctl disable firewalld
echo "--------------------关闭ctrl+alt+del快捷键---------------"
mv /usr/lib/systemd/system/ctrl-alt-del.target /usr/lib/systemd/system/ctrl-alt-del.target.bak
echo "--------------------优化sshd,根据需求修改-----------------------"
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's%#PermitRootLogin yes%PermitRootLogin yes%g' /etc/ssh/sshd_config
sed -i 's%#PermitEmptyPasswords no%PermitEmptyPasswords no%g' /etc/ssh/sshd_config
#sed -i 's%#Port 22%Port 52020%g' /etc/ssh/sshd_config
