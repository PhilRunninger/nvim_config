# My Neovim Setup

## Installation
1. Clone the repository.
1. Initialize and update the submodules.
1. Start neovim. If your system is setup correctly with Node.js, a CoC prerequisite, running `:InstallCocExtensions` wil install CoC's extensions.
1. CoC has its own set of instructions to installing or upgrading it.

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
