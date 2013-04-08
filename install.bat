@echo off
set INSTALLDIR=%~dp0
pushd "%USERPROFILE%"
mklink /H _gvimrc "%INSTALLDIR%.gvimrc"
mklink /H _vimrc "%INSTALLDIR%.vimrc"
