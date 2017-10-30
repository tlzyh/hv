REM hv installer on Windows
REM Last Change: 2017/10/30
REM Author: YangHui <tlz.yh@outlook.com>
REM Maintainer: YangHui <tlz.yh@outlook.com>
REM License: This file is placed in the public domain.

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%HOME%\.hv
IF NOT EXIST "%APP_PATH%" (
    call git clone -b master https://github.com/tlzyh/hv.git "%APP_PATH%"
) ELSE (
    @set ORIGINAL_DIR=%CD%
    echo updating hv...
    chdir /d "%APP_PATH%"
    call git pull
    chdir /d "%ORIGINAL_DIR%"
    call cd "%APP_PATH%"
)

call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\_vimrc" "%APP_PATH%\.vimrc"
call mklink /J "%HOME%\.vim" "%APP_PATH%\.vim"

IF NOT EXIST "%APP_PATH%\.vim\plugin" (
    call mkdir "%APP_PATH%\.vim\plugin"
)

IF NOT EXIST "%HOME%/.vim/plugin/vim-plug" (
    call git clone https://github.com/junegunn/vim-plug.git "%HOME%/.vim/plugin/vim-plug"
) ELSE (
  call cd "%HOME%/.vim/plugin/vim-plug"
  call git pull
  call cd %HOME%
)

REM copy plug.vim to autoload directory
IF NOT EXIST "%APP_PATH%\vimfiles\autoload" (
    call mkdir "%APP_PATH%\vimfiles\autoload"
)
xcopy /Y /Q "%HOME%\.vim\plug\vim-plug\plug.vim" "%HOME%\vimfiles\autoload"

call vim -u "%APP_PATH%/.vimrc" +PlugInstall +qall
