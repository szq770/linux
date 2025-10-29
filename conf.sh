#!/bin/bash
apt update
apt install -y open-vm-tools open-vm-tools-desktop    #下载vm-tools
#下面两行可能出现配置重复添加问题
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config    #修改ssh可以远程连接
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config #   开启密码验证
#下载tab命令补全工具,ubuntu自带
#apt install bash-completion -y
systemctl restart sshd
systemctl disable --now ufw
#ubuntu换源
cat > /etc/apt/sources.list << eof
# Ubuntu sources have moved to /etc/apt/sources.list.d/ubuntu.sources
deb https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
eof
echo "PS1='\[\e[1;33m\][\u@\h \w] \$\[\e[0m\]'" >> /root/.bashrc
apt install -y man-pages    #下载man手册
apt install -y language-pack-zh-hans manpages-zh   #下载中文语言包
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
