# My Neovim Setup

Here it is - my somewhat simpler Neovim setup, thanks to the [CoC.nvim](https://github.com/neoclide/coc.nvim) plugin. I decided to install and configure it for its LSP features, and discovered it has a whole lot of other capabilities. Using selected extensions, I was able to get rid of a lot of other plugins, including (sadly 🙁) ones that I authored or maintain. It will be sad to see them go, but you can't stand in the way of progress.

CoC.nvim extensions are replacing the following well-worn plugins for me:
- [coc-explorer](https://github.com/weirongxu/coc-explorer) replaces [NERDTree](https://github.com/scrooloose/nerdtree), [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin), [vim-devicons](https://github.com/ryanoasis/vim-devicons), [nerdtree-buffer-ops](https://github.com/PhilRunninger/nerdtree-buffer-ops.git), [nerdtree-visual-selection](https://github.com/PhilRunninger/nerdtree-visual-selection.git), [MinTree](https://github.com/PhilRunninger/mintree.git), and [BufSelect](https://github.com/PhilRunninger/bufselect.vim.git)
- [coc-json](https://github.com/neoclide/coc-json) replaces [vim-jdaddy](https://github.com/tpope/vim-jdaddy) and [vim-json](https://github.com/elzr/vim-json)
- various LSP extensions replace [NeoComplete](https://github.com/Shougo/neocomplete.vim)

## Installation
1. Clone the repository.
1. Initialize and update the submodules.
1. Start neovim. If your system is setup correctly with Node.js, a CoC prerequisite, its extensions will be installed the first time `init.vim` runs.

### Linux or Mac
```
cd ~/.config
git clone git@github.com:PhilRunninger/nvim_config.git nvim
git submodule update --init
nvim
```

### Windows
```
cd ~/AppData/Local/
git clone git@github.com:PhilRunninger/nvim_config.git nvim
git submodule update --init
nvim
```
