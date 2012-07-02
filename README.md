# tmux + unix = tmunix

Manage tmux windows with power of unix tools.

### Motivation

There are already other tools that let you manage your tmux sessions
based on config files. The problem is you can configure only what this
tools provide. With `tmunix` the config files are pure bash scripts
letting you do whatever you want when setting up the tmux.  `tmunix` is
implemented in bash leaving all the complex tools behind.

### Installation

Clone this repository.

### Configuration

First prepare some configuration files in `~/.tmunix` directory. The
config file is just an ordinary bash script with some predefined
functions (read further for details). Here is an example:

``` bash
#!/bin/env bash

# this path will be used in all the panes of this window
default-path /path/to/my_project

# it will be always placed to number 1
window-number 1

# there will be 4 panes
pane
pane
pane
pane
# root will be logged in on the last pane
cmd ssh root@localhost
```

If the config file for the window is not found `~/.tmunix/default` file
will be used.

You can copy sample config files to get things up and running:

``` bash
cp -r ./sample_config ~/.tmunix
```

### Usage

``` bash
# open `my_project` and set window number to 2.
tmunix -w my_project -n 2

# set the current window using `2panes` config file.
tmunix -w temporary -c 2panes -t
```

See `tmunix -h` for more options

You can also define functions or alises in your `~/.bashrc` to predefine
often used commands. Such as:

``` bash
TMUNIX_CMD=~/Projects/tmunix/tmunix
function tx(){
  if [ -z $2 ]; then
    $TMUNIX_CMD -w $1
  else
    $TMUNIX_CMD -w $1 -n $2
  fi
}
```

### Predefined config functions

tmunix provides some commands you can use in the config files:

* `default-path path/to/your/project` - always open panes in this window on this path
* `pane` - open a pane
* `cmd command args` - run a command in the last opened pane
* `tiled-layout` - set tiled layout
* `horizontal-layout` - set horizontal layout
* `vertical-layout` - set vertical layout

### License

MIT
http://www.opensource.org/licenses/MIT