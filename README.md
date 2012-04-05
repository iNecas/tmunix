# tmux + unix = tmunix

Tool for managing predefined tmux sessions and windows with using only
basic unix commands.

### Installation

TBD

### Usage

Place your window definitions into `~/.tmunix`. Every window definition
is just a bash script with some predefined functions to make your life
easier. Your first file might look like this:

``` bash
#!/bin/env bash

default-path "`pwd`"

split
split
split
split
split
split
```
