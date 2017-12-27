REM hv installer on Windows
REM Last Change: 2017/12/26
REM Author: YangHui <tlz.yh@outlook.com>
REM Maintainer: YangHui <tlz.yh@outlook.com>
REM License: This file is placed in the public domain.
REM Note: Please run this script as Administrator

@echo off

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%
@set APP_PATH=%HOME%\.hv

REM @set VIM_BIN_TMP_DIR=%HOME%\.hv_vim_bin_tmp
REM @set VIM_BIN_DIR_NAME="vim-8.0.1240-x64"
REM 
REM if exist "%PROGRAMFILES%" (
REM     @set VIM_INSTALL_DIR=%PROGRAMFILES%
REM     if not exist "%VIM_INSTALL_DIR%" (
REM         @set VIM_INSTALL_DIR=%PROGRAMFILES(X86)%
REM     )
REM )
REM if not exist "%VIM_INSTALL_DIR%" (
REM     echo "Not found install directory"
REM     pause
REM     exit
REM )
REM 
REM if not exist "%VIM_INSTALL_DIR%\%VIM_BIN_DIR_NAME%" (
REM     REM get from github
REM     if not exist "%VIM_BIN_TMP_DIR%" (
REM         call git clone -b master git@github.com:tlzyh/vim-bin.git "%VIM_BIN_TMP_DIR%"
REM     ) else (
REM         @set ORIGINAL_DIR=%CD%
REM         echo updating vim-bin...
REM         chdir /d "%VIM_BIN_TMP_DIR%"
REM         call git pull
REM         chdir /d "%ORIGINAL_DIR%"
REM         call cd "%VIM_BIN_TMP_DIR%"
REM     )
REM     REM copy into install directory
REM     xcopy "%VIM_BIN_TMP_DIR%\Windows" "%VIM_INSTALL_DIR%" /Y /Q /E /S
REM     REM run install.exe
REM ) else (
REM     echo installed vim...
REM )


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

if exist "%HOME%\.vimrc" (
    del "%HOME%\.vimrc"
)
if exist "%HOME%\_vimrc" (
    del "%HOME%\_vimrc"
)
if exist "%HOME%\.vim" (
    del "%HOME%\.vim"
)

REM create vim file link
call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\_vimrc" "%APP_PATH%\.vimrc"
call mklink /J "%HOME%\.vim" "%APP_PATH%\.vim"

REM create plugin directory
if not exist "%APP_PATH%\.vim\plugins" (
    call mkdir "%APP_PATH%\.vim\plugins"
)

if not exist "%HOME%\.vim\plugin\vim-plug" (
    call git clone https://github.com/junegunn/vim-plug.git "%HOME%\.vim\plugins\vim-plug"
) else (
  call cd "%HOME%\.vim\plugins\vim-plug"
  call git pull
  call cd %HOME%
)

REM copy plug.vim to autoload directory
if not exist "%HOME%\vimfiles\autoload" (
    call mkdir "%HOME%\vimfiles\autoload"
)
REM copy plug.vim to autoload directory
xcopy "%HOME%\.vim\plugin\vim-plug\plug.vim" "%HOME%\vimfiles\autoload" /Y /Q

call gvim -u "%APP_PATH%\.vimrc" +PlugInstall
