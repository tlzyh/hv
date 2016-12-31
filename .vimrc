" vim config
" Last Change: 2016 Dec 30
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


" Windows平台配置
if IsWindows()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set noerrorbells visualbell t_vb=
    if has('autocmd')
        " 关闭响铃
        autocmd GUIEnter * set visualbell t_vb=
    endif

    " 隐藏菜单工具栏。开关为F3
    set guioptions-=m
    set guioptions-=T
    map <silent> <F3> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>

    if has("multi_byte")
        set encoding=utf-8
        set nobomb
        set fileencodings=utf-8,chinese,latin-1
        set fileencoding=chinese
        let &termencoding=&encoding
        language messages zh_CN.utf-8
    endif
endif



" 设置 bundle
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

function! UnBundle(arg, ...)
    let bundle = vundle#config#init_bundle(a:arg, a:000)
    call filter(g:vundle#bundles, 'v:val["name_spec"] != "' . a:arg . '"')
endfunction

com! -nargs=+         UnBundle
\ call UnBundle(<args>)

" -----------------------------------------------------------------------------
Bundle 'gmarik/vundle'
Bundle 'spf13/vim-colors'
Bundle 'tlzyh/vim-youdao-translater'

Bundle 'kien/ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky'

Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-shell'
Bundle 'xolox/vim-lua-ftplugin'

Bundle 'godlygeek/tabular'
Bundle 'scrooloose/nerdtree'

Bundle 'vim-scripts/Visual-Mark'

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

" 打开Buff，当前目录切换到当前文件所在目录
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

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

if has('statusline')
    set laststatus=2
    set statusline=%<%f\
    set statusline+=%w%h%m%r
    set statusline+=\ [%{&ff}/%Y]
    set statusline+=\ [%{getcwd()}]
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%
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


if isdirectory(expand("~/.vim/bundle/vim-youdao-translater"))
    vnoremap <silent> <C-T> <Esc>:Ydv<CR> 
    nnoremap <silent> <C-T> <Esc>:Ydc<CR> 
    noremap <leader>yd :Yde<CR>
end

if isdirectory(expand("~/.vim/bundle/nerdtree"))
    map <C-e> <plug>NERDTreeTabsToggle<CR>
    map <leader>e :NERDTreeFind<CR>
    nmap <leader>nt :NERDTreeFind<CR>

    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
endif

if isdirectory(expand("~/.vim/bundle/tabular"))
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
    nmap <Leader>a=> :Tabularize /=><CR>
    vmap <Leader>a=> :Tabularize /=><CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif

if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
    let g:ctrlp_working_path_mode = 'ra'
    nnoremap <silent> <D-t> :CtrlP<CR>
    nnoremap <silent> <D-r> :CtrlPMRU<CR>
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
    if IsWindows()
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif
    if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
    endif
    let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }

    if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
        let g:ctrlp_extensions = ['funky']
        nnoremap <Leader>fu :CtrlPFunky<Cr>
    endif
endif


if isdirectory(expand("~/.vim/bundle/tagbar/"))
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif

if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif

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

function! InitializeDirectories()
    let parent = $HOME
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
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

"colorscheme molokai
