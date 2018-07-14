" vim configuration
" Last Change: 2018/04/05
" Author: YangHui <tlz.yh@outlook.com>
" Maintainer: YangHui <tlz.yh@outlook.com>
" License: This file is placed in the public domain.

" 公共函数定义 {{{
" 是否是macOs
function! IsOSX()
    return has('macunix')
endfunction

" 是否是Linux平台
function! IsLinux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" 是否是windows平台
function! IsWindows()
    return has('win32') || has('win64')
endfunction

" 是否是GUI版本
function! IsGui()
    return has('gui_running')
endfunction

" 获取Visual模式下选中的文本
function! GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction

" 获取光标处的文本
function! GetCursorWord()
    return expand("<cword>")
endfunction

" 获取vim 命令执行之后的返回值
function! GetVimCmdOutput(cmd)
  let old_lang = v:lang
  exec ":lan mes en_US"
  let v:errmsg = ''
  let output = ''
  let _z = @z
  try
    redir @z
    silent execute a:cmd
  catch /.*/
    let v:errmsg = substitute(v:exception, '^[^:]\+:', '', '')
  finally
    redir END
    if v:errmsg == ''
      let output = @z
    endif
    let @z = _z
  endtry
  execute ":lan mes " . old_lang
  return output
endfunction

function! WarnMsg(msg)
    echohl WarningMsg | echomsg a:msg | echohl None
endfunction

function! ErrorMsg(msg)
    echoerr a:msg
endfunction
" }}}

" {{{ 运行环境检查
if !has("signs")
    call ErrorMsg("Vim 不支持 sign")
    finish
endif

if !has("python") && !has("python3")
    call ErrorMsg("Vim 不支持 python")
    finish
endif

" 版本判断
if v:version < 800
    call ErrorMsg("请使用8.0以上版本")
else
    if !has('patch-8.0.1023')
        call ErrorMsg("版本过低：patch-8.0.1023")
    endif
endif

" }}}

" 通用设置 {{{
let mapleader = ','
set nocompatible

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

" windows 平台设置
if IsWindows()
    " 隐藏菜单工具栏
    set guioptions-=m
    set guioptions-=T
    noremap <leader>m :call SwitchMenu()<CR>
    " 禁用菜单的alt快捷键, Windows中一般都是 alt访问菜单
    set winaltkeys=no

    function! GetHvLibName()
        let cpu_arch = has('win64') ? 'x64' : 'x86'
        return 'hv-' . cpu_arch . '.dll'
    endfunction
endif
" }}}

" 编码设置 {{{
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
"}}}

" 设置 vim-plug {{{
call plug#begin('~/.vim/plugins')
" color scheme
Plug 'tlzyh/vim-colors'

" 搜索
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'skywind3000/asyncrun.vim'

Plug 'w0rp/ale'
"Plug 'python-mode/python-mode'

Plug 'davidhalter/jedi-vim'

call plug#end()
" End vim-plug }}}

" 通用配置 {{{
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
function! ResetCursor()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction
augroup reset_cursor
    autocmd!
    autocmd BufWinEnter * call ResetCursor()
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

" 关闭响铃
if IsGui()
    autocmd GUIEnter * set visualbell t_vb=
endif
set noerrorbells visualbell t_vb=
" }}}

" 字体字号{{{
if IsGui()
    set guioptions-=T
    set lines=40
    if IsLinux()
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif IsOSX()
        " set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        set guifont=Courier\ New\ Regular:h14
    elseif IsWindows()
        " set guifont=,Courier_New:h10
        set guifont=Courier_New:h11,Andale_Mono:h11,Menlo:h10,Consolas:h10
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256
    endif
endif
"}}}

" vimrc编辑 {{{
nnoremap <leader>ev :tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" 目录切换设置 {{{
" 第一次打开的目录作为工程目录
silent function! GuiEnterInit()
    let g:hv_project_directory = getcwd()
endfunction
augroup project_dir_init
    autocmd!
    autocmd GUIEnter * call GuiEnterInit()
augroup END
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
" }}}

" quickfix 配置 {{{
" silent function! OpenOrCloseQuickfix()
"     " 垂直打开，去掉前缀 vert为水平打开
"     " TODO
"     vert copen 30
" endfunction
" vnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
" nnoremap <silent> <C-Q> <Esc>:call OpenOrCloseQuickfix() <CR>
" 设置quickfix 打开文件到新的tab
set switchbuf+=useopen,usetab,newtab
" }}}

" 文件折叠 {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" 文件内容搜索 {{{
let s:grep_tempfile = ''
let s:grep_job_id = 0
function! DelGrepCmdTmpFile()
    if IsWindows()
        if exists('s:grep_tempfile') && s:grep_tempfile != ''
            call delete(s:grep_tempfile)
            let s:grep_tempfile = ''
        endif
    endif
endfunction

function! OnGrepOutputCallback(qf_id, channel, msg)
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
        call WarnMsg('对应的Channel没有对应的Job')
        return
    endif
    if has('patch-8.0.1023')
        let l = getqflist({'id' : a:qf_id})
        if !has_key(l, 'id') || l.id == 0
            call job_stop(job)
            return
        endif
        call setqflist([], 'a', {'id' : a:qf_id,
                    \ 'efm' : '%f:%\\s%#%l:%c:%m,%f:%\s%#%l:%m',
                    \ 'lines' : [a:msg]})
    else
        let old_efm = &efm
        set efm=%f:%\\s%#%l:%c:%m,%f:%\\s%#%l:%m
        caddexpr a:msg . "\n"
        let &efm = old_efm
    endif
endfunction

function! OnGrepCloseCallback(qf_id, channel)
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
        call WarnMsg('对应的Channel没有对应的Job, Close callback')
        return
    endif
    let emsg = '[Search command exited with status ' . job_info(job).exitval . ']'
    if has('patch-8.0.1023')
        let l = getqflist({'id' : a:qf_id})
        if has_key(l, 'id') && l.id == a:qf_id
            call setqflist([], 'a', {'id' : a:qf_id,
                        \ 'efm' : '%f:%\s%#%l:%m',
                        \ 'lines' : [emsg]})
        endif
    else
        caddexpr emsg
    endif
endfunction

function! RunGrepAsync(cmd, pattern, dir)
    if s:grep_job_id != 0
        " 先停止运行的job
        call job_stop(s:grep_job_id)
    endif

    let title = '[Search results for (' . a:pattern . ') in ' . a:dir . ']'
    cexpr title . "\n"

    call setqflist([], 'a', {'title' : title})
    let l = getqflist({'id' : 0})
    if has_key(l, 'id')
        let qf_id = l.id
    else
        let qf_id = -1
    endif

    if IsWindows()
        let cmd_list = [a:cmd]
    else
        let cmd_list = ['/bin/sh', '-c', a:cmd]
    endif

    " 开启job
    let s:grep_job_id = job_start(cmd_list,
                \ {'callback' : function('OnGrepOutputCallback', [qf_id]),
                \ 'close_cb' : function('OnGrepCloseCallback', [qf_id]),
                \ 'exit_cb' : function('OnGrepExitCallback', [qf_id])})

    " 判断是否成功
    if job_status(s:grep_job_id) == 'fail'
        call WarnMsg('创建Job失败')
        let s:grep_job_id = 0
        call DelGrepCmdTmpFile()
        return
    endif
    botright copen
endfunction

function! OnGrepExitCallback(qf_id, job, exit_status)
    if s:grep_job_id == a:job
        let s:grep_job_id = 0
        call DelGrepCmdTmpFile()
    endif
endfunction

function! RunGrep(pattern, option, dir)
    let cmd = 'grep ' . a:option . ' ' . a:pattern . ' ' . a:dir
    if IsWindows()
        " windows下面处理多个引号的命令有坑。所以，先把命令保存到bat
        " 文件中，再执行bat文件
        let s:grep_tempfile = fnamemodify(tempname(), ':h') . '\hvgrep.cmd'
        " 关闭回显
        call writefile(['@echo off', cmd], s:grep_tempfile)
        call RunGrepAsync(s:grep_tempfile, a:pattern, a:dir)
        call DelGrepCmdTmpFile()
    else
        call RunGrepAsync(cmd, a:pattern, a:dir)
    endif
endfunction

function! ExecuteGrep(str)
    if strlen(a:str) > 0
        call RunGrep(a:str, '-ran', getcwd())
    endif
endfunction

" 文件中删除
function! SearchInFiles()
    let str = GetVisualSelection()
    if strlen(str) <= 0
        let str = GetCursorWord()
    endif
    call ExecuteGrep(str)
endfunction

" 搜索输入的内容
function! SearchInputWord()
    let word = input("Please enter the word: ")
    exe "norm! \<Esc><CR>"
    call ExecuteGrep(word)
endfunction

if executable('grep')
    vnoremap <silent><C-S> :call SearchInFiles() <CR>
    nnoremap <silent><C-S> :call SearchInFiles() <CR>

    noremap <silent><M-1> :call SearchInputWord()<CR>
    inoremap <silent><M-1> <ESC>:call SearchInputWord()<CR>
else
    throw 'grep executable not found'
endif
" }}}

" tab 设置 {{{
" 左右切换tab
noremap <C-H> gT
noremap <C-L> gt

silent function! TabLeaveInit()
    let g:hv_pre_tab_nr = tabpagenr()
endfunction
augroup tab_leave
    autocmd!
    autocmd TabLeave * call TabLeaveInit()
augroup END

" 切换到上一页
silent function! SwitchToPreTab()
    if exists("g:hv_pre_tab_nr") && g:hv_pre_tab_nr > 0
        let l:pn = tabpagenr('$')
        if g:hv_pre_tab_nr <= l:pn
            execute "tabn " . g:hv_pre_tab_nr
        endif
    endif
endfunction

if IsGui()
    if IsOSX()
        " set macmeta
        noremap <silent><C-TAB> :call SwitchToPreTab()<CR>
        inoremap <silent><C-TAB> <ESC>:call SwitchToPreTab()<CR>
        noremap <silent><D-1> :tabn 1<CR>
        noremap <silent><D-2> :tabn 2<CR>
        noremap <silent><D-3> :tabn 3<CR>
        noremap <silent><D-4> :tabn 4<CR>
        noremap <silent><D-5> :tabn 5<CR>
        noremap <silent><D-6> :tabn 6<CR>
        noremap <silent><D-7> :tabn 7<CR>
        noremap <silent><D-8> :tabn 8<CR>
        noremap <silent><D-9> :tabn 9<CR>
        noremap <silent><D-0> :tabn 10<CR>
        inoremap <silent><D-1> <ESC>:tabn 1<CR>
        inoremap <silent><D-2> <ESC>:tabn 2<CR>
        inoremap <silent><D-3> <ESC>:tabn 3<CR>
        inoremap <silent><D-4> <ESC>:tabn 4<CR>
        inoremap <silent><D-5> <ESC>:tabn 5<CR>
        inoremap <silent><D-6> <ESC>:tabn 6<CR>
        inoremap <silent><D-7> <ESC>:tabn 7<CR>
        inoremap <silent><D-8> <ESC>:tabn 8<CR>
        inoremap <silent><D-9> <ESC>:tabn 9<CR>
        inoremap <silent><D-0> <ESC>:tabn 10<CR>
        noremap <silent><D-O> :browse tabnew<CR>
        inoremap <silent><D-O> <ESC>:browse tabnew<CR>
    else
        " set macmeta
        noremap <silent><C-TAB> :call SwitchToPreTab()<CR>
        inoremap <silent><C-TAB> <ESC>:call SwitchToPreTab()<CR>
        " noremap <silent><M-1> :tabn 1<CR>
        noremap <silent><M-2> :tabn 2<CR>
        noremap <silent><M-3> :tabn 3<CR>
        noremap <silent><M-4> :tabn 4<CR>
        noremap <silent><M-5> :tabn 5<CR>
        noremap <silent><M-6> :tabn 6<CR>
        noremap <silent><M-7> :tabn 7<CR>
        noremap <silent><M-8> :tabn 8<CR>
        noremap <silent><M-9> :tabn 9<CR>
        noremap <silent><M-0> :tabn 10<CR>
        inoremap <silent><M-1> <ESC>:tabn 1<CR>
        inoremap <silent><M-2> <ESC>:tabn 2<CR>
        inoremap <silent><M-3> <ESC>:tabn 3<CR>
        inoremap <silent><M-4> <ESC>:tabn 4<CR>
        inoremap <silent><M-5> <ESC>:tabn 5<CR>
        inoremap <silent><M-6> <ESC>:tabn 6<CR>
        inoremap <silent><M-7> <ESC>:tabn 7<CR>
        inoremap <silent><M-8> <ESC>:tabn 8<CR>
        inoremap <silent><M-9> <ESC>:tabn 9<CR>
        inoremap <silent><M-0> <ESC>:tabn 10<CR>
    end
else
    " 使用终端自定义按键序列，把alt-n 或者alt-shift-n 设置为
    " 发送 "<ESC>]{0}n~" 按键序列
    noremap <silent><ESC>]{0}1~ :tabn 1<CR>
    noremap <silent><ESC>]{0}2~ :tabn 2<CR>
    noremap <silent><ESC>]{0}3~ :tabn 3<CR>
    noremap <silent><ESC>]{0}4~ :tabn 4<CR>
    noremap <silent><ESC>]{0}5~ :tabn 5<CR>
    noremap <silent><ESC>]{0}6~ :tabn 6<CR>
    noremap <silent><ESC>]{0}7~ :tabn 7<CR>
    noremap <silent><ESC>]{0}8~ :tabn 8<CR>
    noremap <silent><ESC>]{0}9~ :tabn 9<CR>
    noremap <silent><ESC>]{0}0~ :tabn 10<CR>
    inoremap <silent><ESC>]{0}1~ <ESC>:tabn 1<CR>
    inoremap <silent><ESC>]{0}2~ <ESC>:tabn 2<CR>
    inoremap <silent><ESC>]{0}3~ <ESC>:tabn 3<CR>
    inoremap <silent><ESC>]{0}4~ <ESC>:tabn 4<CR>

    inoremap <silent><ESC>]{0}5~ <ESC>:tabn 5<CR>
    inoremap <silent><ESC>]{0}6~ <ESC>:tabn 6<CR>
    inoremap <silent><ESC>]{0}7~ <ESC>:tabn 7<CR>
    inoremap <silent><ESC>]{0}8~ <ESC>:tabn 8<CR>
    inoremap <silent><ESC>]{0}9~ <ESC>:tabn 9<CR>
    inoremap <silent><ESC>]{0}0~ <ESC>:tabn 10<CR>
endif

" 终端模式下的TabLine， 参见官方文档示例
function! CreateTerminalTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        let s .= '%' . (i + 1) . 'T'
        let s .= ' %{GetTerminalTabLineString(' . (i + 1) . ')} '
    endfor
    let s .= '%#TabLineFill#%T'
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif
    return s
endfunc

" 获取名字
function! GetBuffOrTabString(bufnr, fullname, tabnr)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname
                return fnamemodify(l:name, ':p')
            else
                if a:tabnr
                    return '[' . a:tabnr . ']' . fnamemodify(l:name, ':t')
                else
                    return fnamemodify(l:name, ':t')
                endif
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname
                return '-'.fnamemodify(l:name, ':p')
            else
                if a:tabnr
                    return '-' . '[' . a:tabnr . ']' . fnamemodify(l:name, ':t')
                else
                    return '-' . fnamemodify(l:name, ':t')
                end
            endif
        else
        endif
        return '[No Name]'
    endif
endfunc

function! GetTerminalTabLineString(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    return GetBuffOrTabString(l:bufnr, 0, a:n)
endfunc

function! GetGuiTabLineString()
    let l:num = v:lnum
    let l:buflist = tabpagebuflist(l:num)
    let l:winnr = tabpagewinnr(l:num)
    let l:bufnr = l:buflist[l:winnr - 1]
    let l:tab = GetBuffOrTabString(l:bufnr, 0, l:num)
    if getbufvar(l:bufnr, "&modified")
        let l:tab = l:tab . ' +'
    endif
    return l:tab
endfunc

set tabline=%!CreateTerminalTabLine()
set guitablabel=%{GetGuiTabLineString()}

function! GetGuiTabTip()
    let tip = ''
    let bufnrlist = tabpagebuflist(v:lnum)
    for bufnr in bufnrlist
        if tip != ''
            let tip .= " \n"
        endif
        let name = GetBuffOrTabString(bufnr, 1, 0)
        let tip .= name
        if getbufvar(bufnr, "&modified")
            let tip .= ' [+]'
        endif
        if getbufvar(bufnr, "&modifiable")==0
            let tip .= ' [-]'
        endif
    endfor
    return tip
endfunc
set guitabtooltip=%{GetGuiTabTip()}
" }}}

" 状态栏 {{{
" 如果没有powerline 使用自己的配置
if isdirectory(expand("~/.vim/plugins/vim-airline"))
    if isdirectory(expand("~/.vim/plugins/vim-airline-themes"))
        if !exists('g:airline_theme')
            let g:airline_theme = 'solarized'
        endif
        if !exists('g:airline_powerline_fonts')
            let g:airline_left_sep='›'
            let g:airline_right_sep='‹'
        endif
    endif
else
    if has('statusline')
        set laststatus=2
        set statusline=%<%f\
        set statusline+=%w%h%m%r
        set statusline+=\ [%{&ff}/%Y]
        set statusline+=\ [%{getcwd()}]
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%
    endif
endif
" }}}

" 在线翻译 {{{
python << EOF
import vim,requests,collections,xml.etree.ElementTree as ET
import socket
# -*- coding: utf-8 -*-
WARN_NOT_FIND = " 找不到该单词的释义"
ERROR_QUERY = " 有道翻译查询出错!"
REMOTE_SERVER = "www.baidu.com"
INVALID_NETWORKING = "网络不可用"
def is_connected():
    try:
        host = socket.gethostbyname(REMOTE_SERVER)
        socket.create_connection((host, 80), 2)
        return True
    except:
        pass
    return False

def get_word_info(word):
    if not is_connected():
        return INVALID_NETWORKING.decode('utf-8');
    if not word:
        return ''
    r = requests.get("http://dict.youdao.com" + "/fsearch?q=" + word)
    if r.status_code == 200:
        doc = ET.fromstring(r.content)
        info = collections.defaultdict(list)
        if not len(doc.findall(".//content")):
            return WARN_NOT_FIND.decode('utf-8')

        for el in doc.findall(".//"):
            if el.tag in ('return-phrase','phonetic-symbol'):
                if el.text:
                    info[el.tag].append(el.text.encode("utf-8"))
            elif el.tag in ('content','value'):
                if el.text:
                    info[el.tag].append(el.text.encode("utf-8"))

        for k,v in info.items():
            info[k] = ' | '.join(v) if k == "content" else ' '.join(v)

        tpl = ' %(return-phrase)s'
        if info["phonetic-symbol"]:
            tpl = tpl + ' [%(phonetic-symbol)s]'
        tpl = tpl +' %(content)s'

        return tpl % info

    else:
        return  ERROR_QUERY.decode('utf-8')

def translate_visual_selection(word):
    word = word.decode('utf-8')
    info = get_word_info( word )
    vim.command('echo "'+ info +'"')
EOF

function! YoudaoVisualTranslate()
    python translate_visual_selection(vim.eval("GetVisualSelection()"))
endfunction

function! YoudaoCursorTranslate()
    python translate_visual_selection(vim.eval("GetCursorWord()"))
endfunction

function! YoudaoEnterTranslate()
    let word = input("Please enter the word: ")
    exe "norm! \<Esc><CR>"
    python translate_visual_selection(vim.eval("word"))
endfunction

command! Ydv :call YoudaoVisualTranslate()
command! Ydc :call YoudaoCursorTranslate()
command! Yde :call YoudaoEnterTranslate()

vnoremap <silent> <C-T> <Esc>:Ydv<CR>
nnoremap <silent> <C-T> <Esc>:Ydc<CR>
noremap <leader>yd :Yde<CR>
" }}}

" FZF 插件配置 {{{
if isdirectory(expand("~/.vim/plugins/fzf.vim"))
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

    let g:fzf_layout = { 'down': '~40%' }

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

    let g:fzf_history_dir = '~/.local/share/fzf-history'
    vnoremap <silent> <C-P> <Esc>:FZF<CR>
    nnoremap <silent> <C-P> <Esc>:FZF<CR>
end
" }}}

" python-mode 配置 {{{
"if isdirectory(expand("~/.vim/plugins/python-mode"))
"  let g:pymode_lint_checkers = ['pyflakes']
"  let g:pymode_trim_whitespaces = 0
"  let g:pymode_options = 0
"  let g:pymode_rope = 0
"  let g:pymode_indent = 1
"  let g:pymode_folding = 0
"  let g:pymode_options_colorcolumn = 1
"  let g:pymode_breakpoint_bind = '<leader>br'
"end
" }}}

" Python 格式化 {{{
augroup python_format
    autocmd!
    autocmd FileType python nnoremap <leader>= :0,$!yapf<CR>
augroup END
" }}}

" 快速运行 {{{
if isdirectory(expand("~/.vim/plugins/asyncrun.vim"))
    augroup quick_async_run
        autocmd!
        autocmd User AsyncRunStart call asyncrun#quickfix_toggle(15, 1)
    augroup END
    function! QuickAsyncRun()
        exec 'w'
        if &filetype == 'c'
            exec "AsyncRun! gcc % -o %<; time ./%<"
        elseif &filetype == 'cpp'
            exec "AsyncRun! g++ -std=c++11 % -o %<; time ./%<"
        elseif &filetype == 'java'
            exec "AsyncRun! javac %; time java %<"
        elseif &filetype == 'sh'
            exec "AsyncRun! time bash %"
        elseif &filetype == 'python'
            exec "AsyncRun! time python %"
        endif
    endfunction
    nnoremap <leader>r :call <SID>QuickAsyncRun()<CR>
endif
" }}}

" 初始化目录 {{{
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
" }}}

" 主题设置 {{{
if filereadable(expand("~/.vim/plugins/vim-colors/colors/molokai.vim"))
    colorscheme molokai
endif
" }}}

" Lua 语法检测 {{{
function! CheckLuaSyntax()
    if !executable('luac')
        echo "ERROR: Can not find luac executable file"
        return
    endif
    " let l:name = expand("%:p")
    let l:name = expand("%")
    if IsWindows()
        let l:error_str = call('system', ['luac -p ' . l:name])
    else
        echo 'not support on this platform'
    endif

    if l:error_str != ""
        echo l:error_str
    endif
endfunction
command! -bar LuaCheck call CheckLuaSyntax()
" }}}

" {{{ BufWritePost 主函数
function! OnBufWritePost()
    if &filetype == 'lua'
        call CheckLuaSyntax()
    endif
endfunction
augroup buf_write_post
  autocmd!
  autocmd BufWritePost * call OnBufWritePost()
augroup END
" }}}

" {{{ 高亮URL
function! HighlightURL()
    let command = 'syntax match %s /%s/ contained containedin=.*Comment.*,.*String.*'
    let urlgroup = 'CommentURL'
    let regx = '\<\w\{3,}://\(\(\S\&[^"]\)*\w\)\+[/?#]\?'
    execute printf(command, urlgroup, escape(regx, '/'))
    execute 'highlight def link' urlgroup 'Underlined'
endfunction
" }}}

" {{{ 高亮Email
function! HighlightEmail()
    let command = 'syntax match %s /%s/ contained containedin=.*Comment.*,.*String.*'
    let emailgroup = 'CommentEmail'
    let regx = '\<\w[^@ \t\r<>]*\w@\w[^@ \t\r<>]\+\w\>'
    execute printf(command, emailgroup, escape(regx, '/'))
    execute 'highlight def link' emailgroup 'Underlined'
endfunction
" }}}

" {{{ BufNew BufRead Syntax 回调主函数
function! OnBufNewBufReadSyntax()
    call HighlightURL()
    call HighlightEmail()
endfunction
augroup bufnew_bufread_syntax
  autocmd! BufNew,BufRead,Syntax * call OnBufNewBufReadSyntax()
augroup END
" }}}

" {{{ 高亮标记行
" 颜色配置
if &bg == "dark"
    highlight SignColor ctermfg=white ctermbg=blue guifg=white guibg=RoyalBlue3
else
    highlight SignColor ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
endif

" 在当前行添加标记
function! PlaceSignOnCurrentLine()
    if !exists("b:Vm_sign_number")
        let b:Vm_sign_number = 1
    endif
    let ln = line(".")
    exe 'sign define SignSymbol linehl=SignColor texthl=SignColor'
    exe 'sign place ' . b:Vm_sign_number . ' line=' . ln . ' name=SignSymbol buffer=' . winbufnr(0)
    let b:Vm_sign_number = b:Vm_sign_number + 1
endfunction

" 移除指定id的标记
function! RemoveSign(sign_id)
    silent! exe 'sign unplace ' . a:sign_id . ' buffer=' . winbufnr(0)
endfunction

" 移除所有标记
function! RemoveAllSigns()
    silent! exe 'sign unplace *'
endfunction

" 获取指定行号的标记id
" 如果该行有标记那么返回标记id，如果没有标记则返回-1
function! GetSignIdFromLine(line_number)
    let sign_list = GetVimCmdOutput('sign place buffer=' . winbufnr(0))
    let line_str_index = match(sign_list, "line=" . a:line_number, 0)
    if line_str_index < 0
        return -1
    endif

    let id_str_index = matchend(sign_list, "id=", line_str_index)
    if id_str_index < 0
        return -1
    endif

    let space_index = match(sign_list, " ", id_str_index)
    let id = strpart(sign_list, id_str_index, space_index - id_str_index)
    return id
endfunction

" 当前行添加或者移除标记
function! ToggleSign()
    let curr_line_number = line(".")
    let sign_id = GetSignIdFromLine(curr_line_number)

    if sign_id < 0
        let is_on = 0
    else
        let is_on = 1
    endif

    if is_on != 0
        call RemoveSign(sign_id)
    else
        call PlaceSignOnCurrentLine()
    endif
endfunction

" 从 sign place命令中返回的字符串中截取行号
function! GetLineNumberFromSignInfoString(string)
    let line_str_index = match(a:string, "line=", b:Vm_start_from)
    if line_str_index <= 0
        return -1
    endif

    let equal_sign_index = match(a:string, "=", line_str_index)
    let space_index      = match(a:string, " ", equal_sign_index)
    let line_number      = strpart(a:string, equal_sign_index + 1, space_index - equal_sign_index - 1)
    let b:Vm_start_from  = space_index
    return line_number + 0
endfunction

" 获取相对当前行的下一个有标记的行的行号
function! GetNextSignLine(curr_line_number)
    let b:Vm_start_from = 1
    let sign_list = GetVimCmdOutput('sign place buffer=' . winbufnr(0))

    let curr_line_number = a:curr_line_number
    let line_number = 1
    let is_no_sign  = 1
    let min_line_number = -1
    let min_line_number_diff = 0

    while 1
        let line_number = GetLineNumberFromSignInfoString(sign_list)
        if line_number < 0
            break
        endif

        if is_no_sign != 0
            let min_line_number = line_number
        elseif line_number < min_line_number
            let min_line_number = line_number
        endif
        let is_no_sign = 0

        let tmp_diff = line_number - curr_line_number
        if tmp_diff > 0
            if min_line_number_diff > 0
                if tmp_diff < min_line_number_diff
                    let min_line_number_diff = tmp_diff
                endif
            else
                let min_line_number_diff = tmp_diff
            endif
        endif
    endwhile

    let line_number = curr_line_number + min_line_number_diff
    if is_no_sign != 0 || min_line_number_diff <= 0
        let line_number = min_line_number
    endif

    return line_number
endfunction

" 获取相对当前行的上一个有标记的行的行号
function! GetPrevSignLine(curr_line_number)
    let b:Vm_start_from = 1
    let sign_list = GetVimCmdOutput('sign place buffer=' . winbufnr(0))
    let curr_line_number = a:curr_line_number
    let line_number = 1
    let is_no_sign  = 1
    let max_line_number = -1
    let max_line_number_diff = 0

    while 1
        let line_number = GetLineNumberFromSignInfoString(sign_list)
        if line_number < 0
            break
        endif

        if is_no_sign != 0
            let max_line_number = line_number
        elseif line_number > max_line_number
            let max_line_number = line_number
        endif
        let is_no_sign = 0

        let tmp_diff = curr_line_number - line_number
        if tmp_diff > 0
            if max_line_number_diff > 0
                if tmp_diff < max_line_number_diff
                    let max_line_number_diff = tmp_diff
                endif
            else
                let max_line_number_diff = tmp_diff
            endif
        endif
    endwhile

    let line_number = curr_line_number - max_line_number_diff
    if is_no_sign != 0 || max_line_number_diff <= 0
        let line_number = max_line_number
    endif

    return line_number
endfunction

" 下一个标记
function! GotoNextSign()
    let curr_line_number = line(".")
    let next_sign_line_number = GetNextSignLine(curr_line_number)
    if next_sign_line_number >= 0
        exe ":" . next_sign_line_number
    endif
endfunction

" 上一个标记
function! GotoPrevSign()
    let curr_line_number = line(".")
    let prev_sign_line_number = GetPrevSignLine(curr_line_number)
    if prev_sign_line_number >= 0
        exe prev_sign_line_number
    endif
endfunction

" 命令映射
map <silent> <unique> mm :call ToggleSign()<CR>
map <silent> <unique> mn :call GotoNextSign()<CR>
map <silent> <unique> mp :call GotoPrevSign()<CR>
map <silent> <unique> mc :call RemoveAllSigns()<CR>
" }}}

" {{{ 打开当前文件所在的文件夹，并且选中
function! OpenCurrentFileLocation()
    let path = expand('%:p')
    if IsWindows()
        call libcall(GetHvLibName(), 'openFileLocationInExplore', expand(path))
    endif
endfunction
" }}}

" {{{ 打开超链接
function! OpenUrl(url)
    if IsWindows()
        call libcall(GetHvLibName(), 'openUrl', a:url)
    endif
endfunction
" }}}

" {{{ 打开邮件
function! OpenEmail(email)
    if IsWindows()
        call libcall(GetHvLibName(), 'openUrl', a:email)
    endif
endfunction
" }}}

" {{{ 打开当前行内容
function! OpenCursorContent()
    let cWORD = expand('<cWORD>')
    " 是否是超链接
    let match = matchstr(cWORD, '\<\w\{3,}://\(\(\S\&[^"]\)*\w\)\+[/?#]\?')
    if match != ''
        " 打开超链接
        call OpenUrl(match)
        return
    endif

    " 是否是邮件地址
    let match = matchstr(cWORD, '\<\w[^@ \t\r<>]*\w@\w[^@ \t\r<>]\+\w\>')
    if match != ''
        call OpenEmail(match)
        return
    endif

    " 打开当前文件夹
    call OpenCurrentFileLocation()
endfunction
command! Occ :call OpenCursorContent()
vnoremap <silent> <C-O> :call OpenCursorContent() <CR>
nnoremap <silent> <C-O> :call OpenCursorContent() <CR>
inoremap <silent> <C-O> :call OpenCursorContent() <CR>
" }}}

" {{{ 文件模糊查找
function! s:CpBuildPrompt()
    let tmp = ['tet--', 'wefrewfe', 'hahahah', 'hahahah', '测试吃-------------']
    cal setline(1, tmp)
    "setlocal noma
    "setlocal cul

    let base = '>>>'
    let [hiactive, hicursor, base] = s:focus
                \ ? ['CtrlPPrtText', 'CtrlPPrtCursor', base]
                \ : ['CtrlPPrtBase', 'CtrlPPrtBase', tr(base, '>', '-')]
    let hibase = 'CtrlPPrtBase'
    redraw
    let prt = copy(s:prompt)
    call map(prt, 'escape(v:val, ''"\'')')
    execute 'echoh' hibase '| echon "'.base.'"
                \ | echoh' hiactive '| echon "'.prt[0].'"
                \ | echoh' hicursor '| echon "'.prt[1].'"
                \ | echoh' hiactive '| echon "'.prt[2].'" | echoh None'
    if empty(prt[1]) && s:focus
        execute 'echoh' hibase '| echon "_" | echoh None'
    endif
endfunction

function! s:CpPrtClear()
    if !s:focus
        return
    endif
    let s:prompt = ['', '', ''];
    call s:CpBuildPrompt()
endfunction

function! s:CpPrtAdd(char)
    let s:prompt[0] .= a:char
    call s:CpBuildPrompt()
endfunction

function! s:CpPrtBS()
    if !s:focus
        return
    endif
    let s:prompt[0] = substitute(s:prompt[0], '.$', '', '')
    call s:CpBuildPrompt()
endfunction

function! s:CpPrtDelete()
    if !s:focus
        return
    endif
    let prt = s:prompt
    let prt[1] = matchstr(prt[2], '^.')
    let prt[2] = substitute(prt[2], '^.', '', '')
    cal s:CpBuildPrompt()
endfunction

function! s:CpPrtFocusMap(char)
    call call('s:CpPrtAdd', [a:char])
endfunction

function! s:CpPrtExit()
    if bufnr('%') == s:bufnr && bufname('%') == 'CtrlP'
        noautocmd call s:CpClose()
        noautocmd wincmd p
    endif
endfunction

function! s:CpMapNormalKeys()
    if exists('s:nmapped') && s:nmapped == s:bufnr
        return
    endif

    let pcmd = "nnoremap \<buffer> \<silent> \<k%s> :\<c-u>cal \<SID>%s(\"%s\")\<cr>"
    let cmd = substitute(pcmd, 'k%s', 'char-%d', '')
    let pfunc = 'CpPrtFocusMap'
    let ranges = [32, 33, 125, 126] + range(35, 91) + range(93, 123)

    " 特殊的可打印字符，需要转义的
    for each in [34, 92, 124]
        execute printf(cmd, each, pfunc, escape(nr2char(each), '"|\'))
    endfor
    " 普通可打印字符
    for each in ranges
        execute printf(cmd, each, pfunc, nr2char(each))
    endfor
    " 数字
    for each in range(0, 9)
        execute printf(pcmd, each, pfunc, each)
    endfo
    " 加减乘除
    for [ke, va] in items(s:kprange)
        execute printf(pcmd, ke, pfunc, va)
    endfor
    let s:nmapped = s:bufnr
endfunction

function! s:CpMapSpecailKeys()
    if !(exists('s:smapped') && s:smapped == s:bufnr)
        if (has('termresponse') && v:termresponse =~ "\<ESC>")
                    \ || &term =~? '\vxterm|<k?vt|gnome|screen|linux|ansi'
            for each in ['\A <up>','\B <down>','\C <right>','\D <left>']
                execute s:lcmap.' <esc>['.each
            endfor
        endif
    endif

    for [ke, va] in items(s:prtmaps)
        for kp in va
            execute s:lcmap kp ':<c-u>cal <SID>'.ke.'<cr>'
        endfor
    endfor
    let s:smapped = s:bufnr
endfunction

function! s:CpSetupEvn()
    " 设置当前buffer，去掉行号等等显示
    setlocal noswapfile
    setlocal nonumber
    setlocal nobuflisted
    setlocal nowrap
    setlocal nolist
    setlocal nospell
    setlocal nocursorcolumn
    setlocal winfixheight
    setlocal norelativenumber
    setlocal noundofile

    setlocal foldcolumn=0
    setlocal foldlevel=99
    setlocal textwidth=0
    setlocal buftype=nofile
    setlocal bufhidden=unload
    setlocal colorcolumn=0
endfunction

function! s:CpInitParams()
    let s:bufnr = bufnr('%')
    let s:focus = 1
    let s:prompt = ['', '', '']
    let s:kprange = {
                \ 'Plus': '+',
                \ 'Minus': '-',
                \ 'Divide': '/',
                \ 'Multiply': '*',
                \ 'Point': '.',
                \ }

    let s:lcmap = 'nnoremap <buffer> <silent>'
    let s:prtmaps = {
                \ 'CpPrtBS()':              ['<bs>'],
                \ 'CpPrtDelete()':          ['<del>'],
                \ 'CpPrtClear()':           ['<c-u>'],
                \ 'CpPrtExit()':            ['<esc>'],
                \ }
endfunction

function! s:CpOpen()
    silent! execute 'keepalt botright 1new CtrlP'
    call s:CpSetupEvn()
    call s:CpInitParams()
    call s:CpMapNormalKeys()
    call s:CpMapSpecailKeys()
endfunction

function! s:CpClose()
    if winnr('$') == 1
        bwipeout!
    else
        try
            bunload!
        catch
            close!
        endtry
    endif
endfunction

map <leader>t :call <SID>CpOpen()<CR>
" }}}

" {{{ 测试代码
"function! HvTest()
"    function! Callback(channel, msg)
"        echom 'callback -------- ' . a:msg . '\n'
"    endfunction
"
"    function! CloseCallback(channel)
"    endfunction
"
"    function! OutCallback(channel, msg)
"        echom 'outcallback -------- ' . a:msg . '\n'
"    endfunction
"
"    function! ErrCallback(channel, msg)
"        echom 'errcallback -------- ' . a:msg . '\n'
"    endfunction
"
"    function! ExitCallback(job, exit_status)
"    endfunction
"
"    let cmd = 'hv'
"    let s:hv_tempfile = fnamemodify(tempname(), ':h') . '\hvtmp.cmd'
"    call writefile(['@echo off', cmd], s:hv_tempfile)
"    let cmd_list = [cmd]
"    let s:hv_job_id = job_start(cmd_list,
"                \ {'callback' : function('Callback'),
"                \ 'close_cb' : function('CloseCallback'),
"                \ 'out_cb' : function('OutCallback'),
"                \ 'err_cb' : function('ErrCallback'),
"                \ 'exit_cb' : function('ExitCallback')})
"    call delete(s:hv_tempfile)
"endfunction
"map <leader>t :call HvTest()<CR>
" }}}
