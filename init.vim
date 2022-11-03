" prevent reloading
if get(s:, 'loaded', 0) != 0
	finish
else
	let s:loaded = 1
endif

" Get the directory where this file is located
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Define a command to load the file
command! -nargs=1 LoadScript exec 'so '.s:home.'/'.'<args>'

" Add vim-init directory to runtimepath
exec 'set rtp+='.s:home

" Add the ~/.vim directory to the runtimepath (sometimes vim doesn't automatically add it for you)
set rtp+=~/.vim


"----------------------------------------------------------------------
" module loading
"----------------------------------------------------------------------

" Load basic configuration
LoadScript init/init-basic.vim

" Load extension configuration
LoadScript init/init-config.vim

" set tabsize
LoadScript init/init-tabsize.vim

" Plugin loading
LoadScript init/init-plugins.vim

" interface style
LoadScript init/init-style.vim

" custom button
LoadScript init/init-keymaps.vim
