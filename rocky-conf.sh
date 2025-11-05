#!/bin/bash
#rocky版本
#Rocky换源
cat > /etc/yum.repos.d/rocky.repo << eof
[baseos]
name=Rocky Linux $releasever - BaseOS
#mirrorlist=https://mirrors.rockylinux.org/mirrorlist?
arch=$basearch&repo=BaseOS-$releasever$rltype
baseurl=https://mirrors.aliyun.com/rockylinux/10/BaseOS/x86_64/os/
gpgcheck=1
enabled=1
gpgkey=https://mirrors.aliyun.com/rockylinux/RPM-GPG-KEY-Rocky-10
[AppStream]
name=Rocky Linux $releasever - AppStream - Debug
#mirrorlist=https://mirrors.rockylinux.org/mirrorlist?
arch=$basearch&repo=BaseOS-$releasever-debug$rltype
baseurl=https://mirrors.aliyun.com/rockylinux/10/AppStream/x86_64/os/
gpgcheck=1
enabled=1
gpgkey=https://mirrors.aliyun.com/rockylinux/RPM-GPG-KEY-Rocky-10
[extras]
name=Rocky Linux $releasever - Extras - Source
#mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releaseversource$rltype
baseurl=https://mirrors.aliyun.com/rockylinux/10/extras/x86_64/os/
gpgcheck=1
enabled=1
gpgkey=https://mirrors.aliyun.com/rockylinux/RPM-GPG-KEY-Rocky-10
[epel]
name=Rocky Linux $releasever - EPEL - Source
#mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releaseversource$rltype
baseurl=https://mirrors.aliyun.com/epel/10/Everything/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-10
eof
yum makecache
yum install -y open-vm-tools open-vm-tools-desktop    #下载vm-tools
#下面两行可能出现配置重复添加问题
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config    #修改ssh可以远程连接
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config #   开启密码验证
#下载tab命令补全工具,ubuntu自带
#apt install bash-completion -y
systemctl restart sshd
#关闭selinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -i 's/^SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config
setenforce 0
#关闭防火墙
systemctl disable firewalld.service 
#修改命令提示符
echo "PS1='\[\e[1;33m\][\u@\h \w] \$\[\e[0m\]'" >> /root/.bashrc
yum install -y langpacks-zh_CN glibc-langpack-zh   #下载中文语言包
yum install -y man-pages-zh-CN.noarch   #下载man手册
#配置中文环境
cat > /etc/locale.conf << eof
LANG=zh_CN.UTF-8
LC_ALL=zh_CN.UTF-8
eof
#配置自定义vim环境
cat >> /root/.vimrc << eof
colorscheme murphy
runtime! ftplugin/man.vim
if exists('*minpac#init')
" Minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " Other plugins
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('yegappan/mru')
  call minpac#add('bujnlc8/vim-translator')
endif
if has('eval')
  " Minpac commands
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
endif
if !has('gui_running')
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>     :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif
endif
let g:translator_cache=1
let g:translator_cache_path='~/.cache'
let g:translator_channel='baidu'
let g:translator_target_lang = 'zh'
let g:translator_source_lang = 'auto'
let g:translator_outputype='popup'
noremap <leader>tc :<C-u>Tc<CR>
vnoremap <leader>tv :<C-u>Tv<CR>
autocmd FileType man setlocal readonly

set expandtab       " Tab 转换为空格
set tabstop=2       " 显示 Tab 为 2 空格
set shiftwidth=2    " 缩进用 2 空格
set smarttab        " 行首按 Tab 时用 shiftwidth 缩进，其他位置按 tabstop
eof
