#!/bin/zsh

set -eET # (-e) abort | (-E) show errtrace | (-T) show functrace
source ~/.zshrc

local totaltime

TRANSLATIONS_DIR=$(realpath $(dirname "$0"))
PROJECT_DIR=$(realpath $TRANSLATIONS_DIR/..)
PROJECT_NAME=$(basename $PROJECT_DIR)

echo_bold "env:"
echo_vars TRANSLATIONS_DIR \
		  PROJECT_DIR 	   \
		  PROJECT_NAME

cd $PROJECT_DIR

echo_bold "Fetch TS from Crowdin"
echo_exec crowdin download

echo_bold "Generate QM from TS"
echo_exec lrelease *.pro

echo_bold "\nExecution time: $(seconds_to_time totaltime)"
