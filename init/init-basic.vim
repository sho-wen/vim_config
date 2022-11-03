" vim: set ts=4 sw=4 tw=78 noet :

"----------------------------------------------------------------------
" Basic Settings
"----------------------------------------------------------------------

" Disable vi compatibility mode
set nocompatible

" Set Backspace key mode
set bs=eol,start,indent

" auto indent
set autoindent

" Turn on C/C++ language indentation optimization
set cindent

" Windows disables ALT action menus (making ALT usable in Vim)
set winaltkeys=no

" Turn off word wrapping
set nowrap

" Turn on the function key timeout detection (the function key under the terminal is a string starting with ESC)
set ttimeout

" Function key timeout detection 50 ms
set ttimeoutlen=50

" Function key timeout detection 50 ms
set ruler

"----------------------------------------------------------------------
" search settings
"----------------------------------------------------------------------

" Ignore case when searching
set ignorecase

" Intelligent search case judgment, ignore case by default, unless the search content contains uppercase letters
set smartcase

" Highlight search content
set hlsearch

" Dynamically incrementally display the search results when the search is entered
set incsearch


"----------------------------------------------------------------------
" encoding settings
"----------------------------------------------------------------------
if has('multi_byte')
	" Internal working code
	set encoding=utf-8

	" File default encoding
	set fileencoding=utf-8

	" Automatically try the following encodings when opening a file
	set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif


"----------------------------------------------------------------------
" Allow Vim's built-in scripts to automatically set indentation based on file type, etc.
"----------------------------------------------------------------------
if has('autocmd')
	filetype plugin indent on
endif


"----------------------------------------------------------------------
" Syntax highlighting settings
"----------------------------------------------------------------------
if has('syntax')  
	syntax enable 
	syntax on 
endif


"----------------------------------------------------------------------
" other settings
"----------------------------------------------------------------------

" Show matching parentheses
set showmatch

" Show when parentheses match
set matchtime=2

" show last line
set display=lastline

" Allow directory to be displayed below
set wildmenu

" Deferred drawing (improves performance)
set lazyredraw

" wrong format
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m

" Set the delimiter to be visible
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<


" Set tags: the directory where the current file is located searches upwards to the root directory until it encounters the .tags file
" or Vim current directory contains .tags file
set tags=./.tags;,.tags

" In case of text whose Unicode value is greater than 255, it is not necessary to wait for a space before wrapping
set formatoptions+=m

" When merging two lines of Chinese, do not add spaces in the middle
set formatoptions+=B

" file newline, default to use unix newline
set ffs=unix,dos,mac


"----------------------------------------------------------------------
" Set up code folding
"----------------------------------------------------------------------
if has('folding')
	" Allow code folding
	set foldenable

	" Code folding uses indentation by default
	set fdm=indent

	" Turn on all indents by default
	set foldlevel=99
endif


"----------------------------------------------------------------------
" Ignore the following extensions for file search and completion
"----------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android



