" vim: set ts=4 sw=4 tw=78 noet :

"----------------------------------------------------------------------
" Default indentation mode (can be overridden later)
"----------------------------------------------------------------------

" set indent width
set sw=4

" Set TAB width
set ts=4

" Disable tab expansion (noexpandtab)
set noet

" If expandtab is set later, how many characters are the expanded tabs?
set softtabstop=4


augroup PythonTab
	au!
	" If you need to use tab in python, then uncomment the following line, otherwise vim will open the py file
	" is automatically set to indent with spaces.
	"au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END


