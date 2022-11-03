" vim: set ts=4 sw=4 tw=78 noet :

"----------------------------------------------------------------------
" Function key timeout (milliseconds) with and without tmux
"----------------------------------------------------------------------
if $TMUX != ''
	set ttimeoutlen=30
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
	set ttimeoutlen=80
endif


"----------------------------------------------------------------------
" ALT is allowed under the terminal, see: http://www.skywind.me/blog/archives/2021
" Remember to set ttimeout (see init-basic.vim) and ttimeoutlen (above)
"----------------------------------------------------------------------
if has('nvim') == 0 && has('gui_running') == 0
	function! s:metacode(key)
		exec "set <M-".a:key.">=\e".a:key
	endfunc
	for i in range(10)
		call s:metacode(nr2char(char2nr('0') + i))
	endfor
	for i in range(26)
		call s:metacode(nr2char(char2nr('a') + i))
		call s:metacode(nr2char(char2nr('A') + i))
	endfor
	for c in [',', '.', '/', ';', '{', '}']
		call s:metacode(c)
	endfor
	for c in ['?', ':', '-', '_', '+', '=', "'"]
		call s:metacode(c)
	endfor
endif


"----------------------------------------------------------------------
" Function key settings under the terminal
"----------------------------------------------------------------------
function! s:key_escape(name, code)
	if has('nvim') == 0 && has('gui_running') == 0
		exec "set ".a:name."=\e".a:code
	endif
endfunc


"----------------------------------------------------------------------
" Function key terminal code correction
"----------------------------------------------------------------------
call s:key_escape('<F1>', 'OP')
call s:key_escape('<F2>', 'OQ')
call s:key_escape('<F3>', 'OR')
call s:key_escape('<F4>', 'OS')
call s:key_escape('<S-F1>', '[1;2P')
call s:key_escape('<S-F2>', '[1;2Q')
call s:key_escape('<S-F3>', '[1;2R')
call s:key_escape('<S-F4>', '[1;2S')
call s:key_escape('<S-F5>', '[15;2~')
call s:key_escape('<S-F6>', '[17;2~')
call s:key_escape('<S-F7>', '[18;2~')
call s:key_escape('<S-F8>', '[19;2~')
call s:key_escape('<S-F9>', '[20;2~')
call s:key_escape('<S-F10>', '[21;2~')
call s:key_escape('<S-F11>', '[23;2~')
call s:key_escape('<S-F12>', '[24;2~')


"----------------------------------------------------------------------
" Prevent the background color of vim under tmux from displaying abnormally
" Refer: http://sunaku.github.io/vim-256color-bce.html
"----------------------------------------------------------------------
if &term =~ '256color' && $TMUX != ''
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
endif


"----------------------------------------------------------------------
" Backup settings
"----------------------------------------------------------------------

" Allow backup
set backup

" Backup on save
set writebackup

" Backup file address, unified management
set backupdir=~/.vim/tmp

" Backup file extension
set backupext=.bak

" Disable swap file
set noswapfile

" Disable undo files
set noundofile

" Create the directory and ignore possible warnings
silent! call mkdir(expand('~/.vim/tmp'), "p", 0755)


"----------------------------------------------------------------------
" Configuration fine-tuning
"----------------------------------------------------------------------

" Fix ScureCRT/XShell and some terminal garbled problems, the main reason is that some terminals are not supported
" Terminal control commands, such as cursor shaping such as xterm terminal commands that change the shape of the cursor
" It will cause some terminals that do not fully support xterm to parse errors and display them as wrong characters, such as the q character
" If you confirm that your terminal supports and won't run the configuration on some incompatible terminal, you can comment
if has('nvim')
	set guicursor=
elseif (!has('gui_running')) && has('terminal') && has('patch-8.0.1200')
	let g:termcap_guicursor = &guicursor
	let g:termcap_t_RS = &t_RS
	let g:termcap_t_SH = &t_SH
	set guicursor=
	set t_RS=
	set t_SH=
endif

" Restore the last cursor position when opening a file
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\	 exe "normal! g`\"" |
	\ endif

" Define a DiffOrig command to view file changes
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif



"----------------------------------------------------------------------
" File type fine-tuning
"----------------------------------------------------------------------
augroup InitFileTypesGroup

	" Clear the history autocommand of the same group
	au!

	" C/C++ files use // as a comment
	au FileType c,cpp setlocal commentstring=//\ %s

	" markdown allows word wrapping
	au FileType markdown setlocal wrap

	" lisp for fine-tuning
	au FileType lisp setlocal ts=8 sts=2 sw=2 et

	" scala fine-tuning
	au FileType scala setlocal sts=4 sw=4 noet

	" haskell for fine-tuning
	au FileType haskell setlocal et

	" quickfix hide line numbers
	au FileType qf setlocal nonumber

	" Force filetype correction for certain extensions
	au BufNewFile,BufRead *.as setlocal filetype=actionscript
	au BufNewFile,BufRead *.pro setlocal filetype=prolog
	au BufNewFile,BufRead *.es setlocal filetype=erlang
	au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
	au BufNewFile,BufRead *.vl setlocal filetype=verilog

augroup END


