#/bin/zsh
source ~/.zshrc

git config --local core.hooksPath .githooks
echo_bold core-hooksPath=$(git config --local core.hooksPath)
