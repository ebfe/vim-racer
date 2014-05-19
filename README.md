vim-racer
=========

Rust code completion in vim via [racer](https://github.com/phildawes/racer)

## Installation

When using [vim-pathogen](https://github.com/tpope/vim-pathogen) simply clone
this repository to ~/vim/bundle

	git clone https://github.com/ebfe/vim-racer ~/.vim/bundle

Otherwise copy ```autoload``` and ```ftplugin``` to ~/.vim.

## Setup
- vim-racer expects to find the ```racer``` binary in ```$PATH```.
- For racer to work correctly ```$RUST_SRC_PATH``` needs to be set. See [racer
  installation] (https://github.com/phildawes/racer#installation) for more
  information.

## Usage
- ```CTRL-X CTRL-O``` in insert mode triggers code completion.
- ```gd``` Jumps to the definition of the symbol under the cursor.
