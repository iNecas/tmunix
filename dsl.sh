#!/bin/env bash

function default-path(){
  DEFAULT_PATH="$1"
  tmux-cmd set-option default-path "$1"
}


function window-number(){
  if [ -z $WIN_NUMBER ]; then
    WIN_NUMBER=$1
  fi
}


function pane(){
  if [ -z $PANE ]; then
    cmd cd \"$DEFAULT_PATH\"
    PANE=1;
  else
    tmux-cmd-onload splitw
    tiled-layout
  fi
}


function tiled-layout(){
  tmux-cmd-onload select-layout "tiled"
}


function horizontal-layout(){
  tmux-cmd-onload select-layout "even-horizontal"
}


function vertical-layout(){
  tmux-cmd-onload select-layout "even-vertical"
}


function cmd(){
  tmux-cmd-onload send-keys "$*" C-m
}

