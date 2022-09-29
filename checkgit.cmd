@echo off
echo checkgit
echo "%1%"
pushd %1
git status | grep "Untracked files:" | wc -l
