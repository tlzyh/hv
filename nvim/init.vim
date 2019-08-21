" vim configuration
" Last Change: 2019/08/16
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
    if has('nvim')
        return exists('g:GuiLoaded')
    else
        return has('gui_running')
    endif
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
    echohl WarningMsg
    echomsg a:msg
    echohl None
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

if IsWindows()
    let g:PLUGIN_HOME = expand('~/AppData/Local/nvim/plugged')
else
    let g:PLUGIN_HOME=expand('~/.config/nvim/plugged')
endif

call plug#begin(g:PLUGIN_HOME)
" color scheme
Plug 'tlzyh/vim-colors'

" 搜索
if IsWindows()
    Plug 'junegunn/fzf', { 'dir': g:PLUGIN_HOME . '/fzf' }
else
    " 非windows系统使用脚本安装
    Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
end
Plug 'junegunn/fzf.vim'
" Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'skywind3000/asyncrun.vim'

"Plug 'w0rp/ale'
"Plug 'python-mode/python-mode'

"Plug 'davidhalter/jedi-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

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
        set guifont=Courier\ New\ Regular:h14
    elseif IsWindows()
        if has('nvim')
            " set guifont=Courier\ New\ Regular:h12
            " nvim gui版本的字体设置放到 ginit.vim
        else
            set guifont=Courier_New:h11,Andale_Mono:h11,Menlo:h10,Consolas:h10
        endif
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256
    endif
endif
"}}}

" vimrc编辑 {{{
function! EditGuiInitVim()
endfunction
"noremap <leader>m :call SwitchMenu()<CR>
nnoremap <leader>ev :tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
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
function! ExecuteGrep(str)
    if strlen(a:str) > 0
        echom a:str
        execute('Rg ' . a:str)
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

" 文件内容的搜索使用fzf的Rg，需要安装ripgrep程序
if executable('rg') && isdirectory(expand(g:PLUGIN_HOME . "/fzf")) && isdirectory(expand(g:PLUGIN_HOME . "/fzf.vim"))
    vnoremap <silent><C-S> :call SearchInFiles() <CR>
    nnoremap <silent><C-S> :call SearchInFiles() <CR>
    " \ 输入搜索内容
    nnoremap \ :Rg<SPACE>
endif
" }}}

" tab---{{{
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
if isdirectory(expand(g:PLUGIN_HOME . "/vim-airline"))
    if isdirectory(expand(g:PLUGIN_HOME . "/vim-airline-themes"))
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
let g:file_float_window = 0
" 主动关闭存在一些问题，fzf接收不到esc，关闭了浮动窗，但是fzf没有关闭，
" 会导致重复打开失败, 这里还需要看看fzf有没有主动退出的方法
"function! CloseFileFloatWin()
"    if g:file_float_window > 0
"        if nvim_win_is_valid(g:file_float_window)
"            call nvim_win_close(g:file_float_window, v:true)
"        end
"        let g:file_float_window = 0
"    end
"endfunction
function! GetFileFloatWinOpts()
  let win_height = (&lines * 2) / 5
  let win_width = &columns / 3
  let row = 0
  let col = (&columns - win_width) / 2
  let opts = {
        \ 'relative': 'editor',
        \ 'row': float2nr(row),
        \ 'col': float2nr(col),
        \ 'width': float2nr(win_width),
        \ 'height': float2nr(win_height)
        \ }
  return opts
endfunction

function! OpenFileFloatWin()
    " call CloseFileFloatWin()
    if g:file_float_window > 0 && nvim_win_is_valid(g:file_float_window)
        return
    end
    let opts = GetFileFloatWinOpts()
    let buf = nvim_create_buf(v:false, v:true)
    let g:file_float_window= nvim_open_win(buf, v:true, opts)
    " 设置浮动窗口高亮
    call setwinvar(g:file_float_window, '&winhl', 'Normal:Pmenu')
    setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction

function! UpdateFileFloatWin()
    if g:file_float_window > 0 && nvim_win_is_valid(g:file_float_window)
        let opts = GetFileFloatWinOpts()
        call nvim_win_set_config(g:file_float_window, opts)
    end
endfunction

if isdirectory(expand(g:PLUGIN_HOME . "/fzf"))
    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }
    " 让输入上方，搜索列表在下方
    let $FZF_DEFAULT_OPTS = '--layout=reverse'
    " 打开 fzf 的方式选择 floating window
    let g:fzf_layout = { 'window': 'call OpenFileFloatWin()' }
    let g:fzf_history_dir = '~/.local/share/fzf-history'
    vnoremap <silent> <C-P> <Esc>:FZF<CR>
    nnoremap <silent> <C-P> <Esc>:FZF<CR>
end
" }}}

" VimResized autocmd {{{
function! OnVimResized()
    " 更新浮动框大小位置
    " call UpdateFileFloatWin()
endfunction
augroup vim_resized
    autocmd!
    autocmd VimResized * call OnVimResized()
augroup END
" }}}

" 自动补全 {{{
if isdirectory(expand(g:PLUGIN_HOME . "/deoplete.nvim"))
    " Wheter to enable deoplete automatically after start nvim
    let g:deoplete#enable_at_startup = 1

    " Maximum candidate window width
    call deoplete#custom#source('_', 'max_menu_width', 80)

    " Minimum character length needed to activate auto-completion,
    " see https://goo.gl/QP9am2
    call deoplete#custom#source('_', 'min_pattern_length', 1)

    " Whether to disable completion for certain syntax
    " call deoplete#custom#source('_', {
    "     \ 'filetype': ['vim'],
    "     \ 'disabled_syntaxes': ['String']
    "     \ })
    call deoplete#custom#source('_', {
                \ 'filetype': ['python'],
                \ 'disabled_syntaxes': ['Comment']
                \ })

    " Ignore certain sources, because they only cause nosie most of the time
    call deoplete#custom#option('ignore_sources', {
                \ '_': ['around', 'buffer', 'tag']
                \ })

    " Candidate list item number limit
    call deoplete#custom#option('max_list', 30)

    " The number of processes used for the deoplete parallel feature.
    call deoplete#custom#option('num_processes', 16)

    " The delay for completion after input, measured in milliseconds.
    call deoplete#custom#option('auto_complete_delay', 100)

    " Enable deoplete auto-completion
    call deoplete#custom#option('auto_complete', v:true)
endif
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
if isdirectory(expand(g:PLUGIN_HOME . "/asyncrun.vim"))
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
    if IsWindows()
        let dir = expand('~/AppData/Local/nvim')
    else
        let dir =expand('~/.config/nvim')
    endif

    let parent = dir . '/.vimtmpdir/'

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
if filereadable(expand(g:PLUGIN_HOME . "/vim-colors/colors/molokai.vim"))
    colorscheme molokai
endif
" }}}

" Lua 语法检测 {{{
function! CheckLuaSyntax()
    if !executable('luac')
        echo "ERROR: Can not find luac executable file"
        return
    endif
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
python << EOF
# -*- coding: utf-8 -*-
import vim
import platform
def open_file_location(file_path):
    os_name = platform.system()
    if os_name == 'Windows':
        import win32api
        win32api.ShellExecute(0, 'open', 'explorer.exe', "/select, " + file_path, '', 1)
    elif(osName == 'Darwin'):
        raise Exception("not support yet")
    else:
        raise Exception("not support yet")

def open_url(url):
    os_name = platform.system()
    if os_name == 'Windows':
        import win32api
        win32api.ShellExecute(0, 'open', url, '', '', 1)
    elif(osName == 'Darwin'):
        raise Exception("not support yet")
    else:
        raise Exception("not support yet")
EOF

function! OpenCurrentFileLocation()
    let path = expand('%:p')
    if IsWindows()
        python open_file_location(vim.eval("path"))
    else
        echo 'not support yet on this platform'
    endif
endfunction
" }}}

" {{{ 打开超链接
function! OpenUrl(url)
    if IsWindows()
        python open_url(vim.eval("a:url"))
    endif
endfunction
" }}}

" {{{ 打开邮件
function! OpenEmail(email)
    if IsWindows()
        python open_url(vim.eval("a:email"))
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
