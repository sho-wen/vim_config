# install

Clone the project into a directory of your liking：

```
cd ~/.vim
git clone git@github.com:showen-ctrl/vim-config.git
```

Create `~/.vimrc` file，Add the following command inside：

```
source ~/.vim/vim-init/init.vim
```

Add the following command into the `~/.bash_profile11` file

```
alias ctags='/opt/homebrew/bin/ctags'
```

Test

```
source .vimrc
```


Start Vim to Run `:PlugInstall` on the vim command line to install dependent plugins.

# configuration structure

This configuration consists of the following main modules in order:

- `init.vim`: Configure the entry, set the runtimepath to detect the script path, and load other scripts.
- `init-basic.vim`: Basic configuration everyone can agree on, removes any key and style definitions, guaranteed to work in `tiny` mode (without `+eval`).
- `init-config.vim`: Support for non-tiny configurations with +eval, initialize ALT key support, function key keycodes, backup, terminal compatibility.
- `init-tabsize.vim`: Tab width, whether to expand spaces, etc., because individual differences are too large, a separate file is easy to change.
- `init-plugin.vim`: Plug-ins, use vim-plug, and configure them according to the set plug-in groups.
- `init-style.vim`: Color themes, highlight optimization, status bar, more compact tab bar text, etc. and display related stuff.
- `init-keymaps.vim`: Shortcut key definition.
