@rem Do not use "echo off" to not affect any child calls.
@rem Please put this file to Git for windows's cmd dir( like C:\Program Files\Git\cmd\curl.cmd )
@rem get lastest curl on http://curl.haxx.se/
@setlocal

@rem Get the abolute path to the parent directory, which is assumed to be the
@rem Git installation root.
@for /F "delims=" %%I in ("%~dp0..") do @set git_install_root=%%~fI
@set PATH=%git_install_root%\bin;%git_install_root%\mingw\bin;%PATH%

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@curl.exe %*
