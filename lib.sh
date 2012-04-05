#!/bin/env bash

function usage(){
  cat <<HELP
tmunix - tmux manager
HELP
}

# Runs the tmux command at every run of the config file
function tmux-cmd(){
  tmux "$@"
}

# Runs the tmux command only if the window is being prepared
# for the first time.
function tmux-cmd-onload(){
  if [[ $FIRST_RUN = "true" ]]; then
    tmux "$@"
  fi
}

function default-path(){
  DEFAULT_PATH="$1"
  tmux-cmd set-option default-path "$1"
}

function window-number(){
  if [ -z $WIN_NUMBER ]; then
    WIN_NUMBER=$1
  fi
}

function split(){
  if [ -z $PANE ]; then
    cmd cd \"$DEFAULT_PATH\"
    PANE=1;
  else
    tmux-cmd-onload splitw
    tmux-cmd-onload select-layout "tiled"
  fi
}

function cmd(){
  tmux-cmd-onload send-keys "$*" C-m
}

