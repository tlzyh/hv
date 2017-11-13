" vim configuration
" Last Change: 2017/11/03
" Author: YangHui <tlz.yh@outlook.com>
" Maintainer: YangHui <tlz.yh@outlook.com>
" License: his file is placed in the public domain.

silent function! IsOSX()
    return has('macunix')
endfunction
silent function! IsLinux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! IsWindows()
    return  (has('win32') || has('win64'))
endfunction

set nocompatible
set background=dark

if !IsWindows()
    set shell=/bin/sh
endif

silent function! SwitchMenu()
    if IsWindows()
        if &guioptions =~# 'T'
            set guioptions-=T
            set guioptions-=m
        else
            set guioptions+=T
            set guioptions+=m
        endif
    endif
endfunction

if IsWindows()
    "set runtimepath+=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after,$HOME/.vim/vimfiles
    set noerrorbells visualbell t_vb=
    " 关闭响铃
    autocmd GUIEnter * set visualbell t_vb=

    " 隐藏菜单工具栏。开关为F3
    set guioptions-=m
    set guioptions-=T
    map <silent> <F3> :call SwitchMenu() <CR>

    if has("multi_byte")
		" 全局编码
        set encoding=utf-8
		" 无BOM头
        set nobomb
		" 可用编码列表
        set fileencodings=utf-8,cp936,latin-1
		" 设置新建，打开，保存时候的编码
        set fileencoding=utf-8
		" 终端编码
        let &termencoding=&encoding
		" 设置消息编码格式
        language messages zh_CN.utf-8
    endif
endif

" -------------------------------- 设置 vim-plug ----------------------
call plug#begin('~/.vim/plugin')
" color scheme
Plug 'tlzyh/vim-colors'

" 在线翻译
Plug 'tlzyh/vim-youdao-translater'

" Lua
Plug 'xolox/vim-misc'
Plug 'xolox/vim-lua-ftplugin'

Plug 'xolox/vim-shell'

" 高亮行
Plug 'vim-scripts/Visual-Mark'

" 搜索
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" 内容查找
Plug 'tlzyh/grep'

" 状态栏
Plug 'tlzyh/vim-powerline'

call plug#end()

" -------------------------------- End vim-plug ----------------------
filetype plugin indent on
syntax on
set mouse=a
set mousehide
scriptencoding utf-8

if has('clipboard')
    if has('unnamedplus')
        set clipboard=unnamed,unnamedplus
    else
        set clipboard=unnamed
    endif
endif

set shortmess+=filmnrxoOtT
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore
set history=1000
set nospell
set hidden
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-

" 切换buffer的时候，光标回到之前的位置
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction
augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

set tabpagemax=15
set showmode
set cursorline

highlight clear SignColumn
highlight clear LineNr

if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
endif

set backspace=indent,eol,start
set linespace=0
set relativenumber
set number
set showmatch
set incsearch
set hlsearch
set winminheight=0
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set scrolljump=5
set scrolloff=3
set foldenable
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. 
set nowrap
set autoindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set nojoinspaces
set splitright
set splitbelow
set pastetoggle=<F12>

map <S-H> gT
map <S-L> gt

let mapleader = ','

nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

if has('gui_running')
    set guioptions-=T
    set lines=40
    if IsLinux()
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif IsOSX()
        set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
    elseif IsWindows()
        " set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        set guifont=Courier_New:h11
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256
    endif
endif

" 映射vimrc编辑
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" 第一次打开的目录作为工程目录
silent function! InitProjectDir()
    let g:hv_project_directory = getcwd()
endfunction
augroup project_dir_init
    autocmd!
    autocmd GUIEnter * call InitProjectDir()
augroup END

" 目录切换设置
" 打开Buff，当前目录切换到当前文件所在目录
" autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
silent function! SwitchProjectDir()
    if bufname("") !~ "^\[A-Za-z0-9\]*://"
        if toupper(getcwd()) == toupper(g:hv_project_directory)
            " 设置为当前路径, 可以拼接路径，也可以像下面一样
            lcd %:p:h
            echo 'change to current directory:' . getcwd()
        else
            execute "lcd " . g:hv_project_directory
            echo 'change to project directory:' . g:hv_project_directory
        endif
    endif
endfunction

vnoremap <silent> <C-D> :call SwitchProjectDir() <CR>
nnoremap <silent> <C-D> :call SwitchProjectDir() <CR>

" quickfix 配置
silent function! OpenOrCloseQuickfix()
    " 垂直打开，去掉前缀 vert为水平打开
    " TODO
    vert copen 30
endfunction
vnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
nnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
" set switchbuf+=usetab,newtab


" 文件折叠
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" 文件搜索 -----------------------------------------------------------
" 获取选中的文字
function! GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction

" 获取光标位置字符
function! GetCursorWord()
    return expand("<cword>")
endfunction

" 文件中删除
silent function! SearchInFiles()
    let str = GetVisualSelection()
    if strlen(str) <= 0
        let str = GetCursorWord()
    end
    if strlen(str) > 0
        execute "Grep -rna \"" . str . "\" " . getcwd()
    end
endfunction
if isdirectory(expand("~/.vim/plugin/grep"))
    vnoremap <silent> <C-S> :call SearchInFiles() <CR>
    nnoremap <silent> <C-S> :call SearchInFiles() <CR>
endif
"----------------------------------- end --------------------------

" 状态栏，如果没有powerline 使用自己的配置
if !isdirectory(expand("~/.vim/plugin/vim-powerline"))
    if has('statusline')
        set laststatus=2
        set statusline=%<%f\
        set statusline+=%w%h%m%r
        set statusline+=\ [%{&ff}/%Y]
        set statusline+=\ [%{getcwd()}]
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%
    endif
endif

" 翻译快捷键映射为Ctrl-T
if isdirectory(expand("~/.vim/plugin/vim-youdao-translater"))
    vnoremap <silent> <C-T> <Esc>:Ydv<CR> 
    nnoremap <silent> <C-T> <Esc>:Ydc<CR> 
    noremap <leader>yd :Yde<CR>
end

if isdirectory(expand("~/.vim/plugin/fzf.vim"))
    " An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " Default fzf layout
    " - down / up / left / right
    let g:fzf_layout = { 'down': '~40%' }

    " You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
    " let g:fzf_layout = { 'window': 'enew' }
    " let g:fzf_layout = { 'window': '-tabnew' }
    " let g:fzf_layout = { 'window': '10split enew' }

    " Customize fzf colors to match your color scheme
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = '~/.local/share/fzf-history'

    vnoremap <silent> <C-P> <Esc>:FZF<CR>
    nnoremap <silent> <C-P> <Esc>:FZF<CR>
end

function! InitializeDirectories()
    let parent = $HOME . '/.vimtmpdir/'

    " create parent dir
    if !isdirectory(parent)
        call mkdir(parent)
    endif

    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            execute "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

if filereadable(expand("~/.vim/plugin/vim-colors/colors/molokai.vim"))
    colorscheme molokai
endif

