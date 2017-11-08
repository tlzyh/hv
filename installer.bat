REM hv installer on Windows
REM Last Change: 2017/11/02
REM Author: YangHui <tlz.yh@outlook.com>
REM Maintainer: YangHui <tlz.yh@outlook.com>
REM License: This file is placed in the public domain.

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%HOME%\.hv
if not exist "%APP_PATH%" (
    call git clone -b master git@github.com:tlzyh/hv.git "%APP_PATH%"
) else (
    @set ORIGINAL_DIR=%CD%
    echo updating hv...
    chdir /d "%APP_PATH%"
    call git pull
    chdir /d "%ORIGINAL_DIR%"
    call cd "%APP_PATH%"
)

REM create vim file link
call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\_vimrc" "%APP_PATH%\.vimrc"
call mklink /J "%HOME%\.vim" "%APP_PATH%\.vim"

REM create plugin directory
if not exist "%APP_PATH%\.vim\plugin" (
    call mkdir "%APP_PATH%\.vim\plugin"
)

if not exist "%HOME%\.vim\plugin\vim-plug" (
    call git clone https://github.com/junegunn/vim-plug.git "%HOME%\.vim\plugin\vim-plug"
) else (
  call cd "%HOME%\.vim\plugin\vim-plug"
  call git pull
  call cd %HOME%
)

REM copy plug.vim to autoload directory
if not exist "%HOME%\vimfiles\autoload" (
    call mkdir "%HOME%\vimfiles\autoload"
)
REM copy plug.vim to autoload directory
xcopy /Y /Q "%HOME%\.vim\plugin\vim-plug\plug.vim" "%HOME%\vimfiles\autoload"

call gvim -u "%APP_PATH%\.vimrc" +PlugInstall
