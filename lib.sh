#!/usr/bin/env bash

function usage(){
  cat <<HELP
tmunix - tmux window manager

Usage:
tmunix [options]
  -w WINDOW_NAME   - windows name (required)
  -n WINDOW_NUMBER - number the window should be on
  -t               - use this window instead of creating new
  -c CONFIG_FILE   - profile file to be used for setting up the window. The
                     file is searched in ~/.tmunix directory and it's an ordinary bash file.
                     If not defined WINDOW_NAME will be used. If the file is not found
                     default profile is used. See README.md for more details.
  -d               - don't attach to the window after initializing
  -h               - show this message
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


function tx-find-window(){
  ACTIVE_WINDOW=`tmux-cmd list-windows | grep "^[0-9]*: $WINDOW" -m1`
  if [ $? -eq 0 ]; then
    CUR_WIN_NUMBER=`echo "$ACTIVE_WINDOW" | awk -F : '{print $1}'`
    return 0;
  else
    return 1;
  fi
}


function tx-init-window(){
  if [ -z "$TMUX" ]; then
    if tmux-cmd has-session -t "$SESSION_NAME"; then
      # we make the target session the current one
      # (so that it's used by default)
      tmux-cmd attach -t "$SESSION_NAME" \; detach
    else
      tmux-cmd start-server \; set-option -g base-index 1 \; new-session -d -s "$SESSION_NAME"
    fi
  fi
  if ! tx-find-window; then
    if [[ "$USE_THIS_WINDOW" -eq 1 ]]; then
      tmux-cmd rename-window "$WINDOW"
    else
      tmux-cmd new-window -n "$WINDOW"
    fi
    FIRST_RUN=true
  else
    tmux-cmd select-window -t $CUR_WIN_NUMBER
  fi

  tx-find-window
  source "$CONFIG_FILE"
}


function tx-attach(){
  if [ -z $TMUX ]; then
    tmux-cmd -u attach-session -t "$SESSION_NAME"
  fi
}


function tx-set-win-number(){
  if ! [ -z $WIN_NUMBER ] && [ $WIN_NUMBER -ne $CUR_WIN_NUMBER ]; then
    tmux-cmd move-window -t $WIN_NUMBER || tmux-cmd swap-window -t $WIN_NUMBER
  fi
  tx-find-window
}

