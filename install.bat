REM hv installer on Windows
REM Last Change: 2016 Dec 30
REM Author: YangHui <tlz.yh@outlook.com>
REM Maintainer: YangHui <tlz.yh@outlook.com>
REM License: his file is placed in the public domain.

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

IF NOT EXIST "%APP_PATH%\.vim\bundle" (
    call mkdir "%APP_PATH%\.vim\bundle"
)

IF NOT EXIST "%HOME%/.vim/bundle/vundle" (
    call git clone https://github.com/gmarik/vundle.git "%HOME%/.vim/bundle/vundle"
) ELSE (
  call cd "%HOME%/.vim/bundle/vundle"
  call git pull
  call cd %HOME%
)

call vim -u "%APP_PATH%/.vimrc" +BundleInstall! +BundleClean +qall

