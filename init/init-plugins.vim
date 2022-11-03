" vim: set ts=4 sw=4 tw=78 noet :

"----------------------------------------------------------------------
" The default grouping, which can be overridden in the front
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
	let g:bundle_group += ['grammer','react','nerdcommenter','airline', 'nerdtree', 'ale', 'echodoc']
	let g:bundle_group += ['leaderf']
endif


"----------------------------------------------------------------------
" Calculate the subpath of the current vim-init
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" Install plugins under ~/.vim/bundles
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


"----------------------------------------------------------------------
" default plugin
"----------------------------------------------------------------------

" The full text moves quickly, <leader><leader>f{char} can be triggered
Plug 'easymotion/vim-easymotion'

" file browser, instead of netrw
Plug 'justinmk/vim-dirvish'

" Tabular alignment, use the command Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Diff enhancement to support more scientific diff algorithms such as histogram / patience
Plug 'chrisbra/vim-diff-enhanced'


"----------------------------------------------------------------------
" Dirvish Settings: Automatically sort and hide files while locating related files
" This sort function sorts directories first, files last, and sorts alphabetically
" More friendly than the default pure alphabetical sorting.
"----------------------------------------------------------------------
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	" Get the text of the line where the cursor is located (the currently selected file name)
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	" Sort filenames
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" Navigate to the file at the previous cursor
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" Basic plugin
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	" Show start screen showing recently edited files
	Plug 'mhinz/vim-startify'

	" Install a whole bunch of colorscheme at once
	Plug 'flazz/vim-colorschemes'

	" Support library, function library for other plugins
	Plug 'xolox/vim-misc'

	" Used to display marks in the side symbol bar (the position of the ma-mz record)
	Plug 'kshenoy/vim-signature'

	" diff for showing git/svn in sidebar
	Plug 'mhinz/vim-signify'

	" According to the error information matched in the quickfix, highlight the error line of the corresponding file
	" Use the :RemoveErrorMarkers command or <space>ha to clear errors
	Plug 'mh21/errormarker.vim'

	" Use ALT+e to display numbers such as A/B/C on different windows/tabs, and then jump directly to letters
	Plug 't9md/vim-choosewin'

	" Provide TAGS-based definition preview, function parameter preview, quickfix preview
	Plug 'skywind3000/vim-preview'

	" Git support
	Plug 'tpope/vim-fugitive'

	" Use ALT+E to select windows
	nmap <m-e> <Plug>(choosewin)

	" startify is not displayed by default
	let g:startify_disable_at_vimenter = 1
	let g:startify_session_dir = '~/.vim/session'

	" Use <space>ha to clear errors marked by errormarker
	noremap <silent><space>ha :RemoveErrorMarkers<cr>

	" signify tuning
	let g:signify_vcs_list = ['git', 'svn']
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '~'
	let g:signify_sign_changedelete      = g:signify_sign_change

	" The git repository uses the histogram algorithm for diffing
	let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
endif


"----------------------------------------------------------------------
" Enhanced plugin
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	" After selecting an area with v, ALT_+/- expand/reduce selection by separator
	Plug 'terryma/vim-expand-region'

	" Quick file search
	Plug 'junegunn/fzf'

	" Provide dictionary completion for different languages, triggered by c-x c-k in insert mode
	Plug 'asins/vim-dict'

	" Live grep with the :FlyGrep command
	Plug 'wsdjeg/FlyGrep.vim'

	" Use the :CtrlSF command to do a grep that mimics sublime
	Plug 'dyng/ctrlsf.vim'

	" Paired brackets and quotes autocompletion
	Plug 'Raimondi/delimitMate'

	" Provide gist interface
	Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
	
	" ALT_+/- is used to expand and shrink the v selection by the delimiter
	map <m-=> <Plug>(expand_region_expand)
	map <m--> <Plug>(expand_region_shrink)
endif


"----------------------------------------------------------------------
" Automatically generate ctags/gtags and provide automatic indexing function
" For projects not in git/svn, you need to touch an empty .root file in the project root directory
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	" Provide ctags/gtags background database automatic update function
	Plug 'ludovicchabant/vim-gutentags'

	" Provides GscopeFind command and automatically handles gtags database switching
	" Support the cursor to move to the symbol name: <leader>cg to view the definition, <leader>cs to view the reference
	Plug 'skywind3000/gutentags_plus'

	" Set project directory flags: .root files in addition to .git/.svn
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" The data files generated by default are concentrated in ~/.cache/tags to avoid polluting the project directory and easy to clean up
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" Automatic generation is disabled by default
	let g:gutentags_modules = [] 

	" Allows dynamic generation of ctags files if there is a ctags executable
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif

	" Allows dynamic generation of gtags database if there is a gtags executable
	if executable('gtags') && executable('gtags-cscope')
		let g:gutentags_modules += ['gtags_cscope']
	endif

	" Set the parameters of ctags
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" If you use universal-ctags, you need the following line, please uncomment it
	" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" Disable gutentags from automatically linking the gtags database
	let g:gutentags_auto_add_gtags_cscope = 0
endif


"----------------------------------------------------------------------
" Text object: textobj family bucket
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	" Basic plugin: Provides an interface for user-friendly custom text objects
	Plug 'kana/vim-textobj-user'

	" indent text object: ii/ai indicates the current indentation, vii is selected as indentation, cii rewrites the indentation
	Plug 'kana/vim-textobj-indent'

	" Grammar Text Objects: iy/ay grammar based text objects
	Plug 'kana/vim-textobj-syntax'

	" Function text objects: if/af supports c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	" Parameter text object: i,/a, including parameters or list elements
	Plug 'sgur/vim-textobj-parameter'

	" Provide python related text objects, if/af represents functions, ic/ac represents classes
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	" Provides a text object for uri/url, iu/au means
	Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" file type extension
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	" Syntax highlighting for powershell script files
	Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

	" Lua syntax highlighting enhancements
	Plug 'tbastos/vim-lua', { 'for': 'lua' }

	" C++ syntax highlighting enhancements to support 11/14/17 standards
	Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

	" extra grammar file
	Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

	" python syntax file enhancements
	Plug 'vim-python/python-syntax', { 'for': ['python'] }

	" rust syntax enhancements
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }

	" vim org-mode 
	Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_section_b = '%n'
	let g:airline_theme='deus'
	let g:airline#extensions#branch#enabled = 0
	let g:airline#extensions#syntastic#enabled = 0
	let g:airline#extensions#fugitiveline#enabled = 0
	let g:airline#extensions#csv#enabled = 0
	let g:airline#extensions#vimagit#enabled = 0
endif


"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'xuyuanp/nerdtree-git-plugin'
	Plug 'jistr/vim-nerdtree-tabs'
	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeHijackNetrw = 0
	let g:NERDTreeGitStatusIndicatorMapCustom = {
			\ 'Modified'  :'✹',
			\ 'Staged'    :'✚',
			\ 'Untracked' :'✭',
			\ 'Renamed'   :'➜',
			\ 'Unmerged'  :'═',
			\ 'Deleted'   :'✖',
			\ 'Dirty'     :'✗',
			\ 'Ignored'   :'☒',
			\ 'Clean'     :'✔︎',
			\ 'Unknown'   :'?',
			\ }
	noremap <space>nn :NERDTree<cr>
	noremap <space>no :NERDTreeFocus<cr>
	noremap <space>nm :NERDTreeMirror<cr>
	noremap <space>nt :NERDTreeToggle<cr>
endif


"----------------------------------------------------------------------
" react
"----------------------------------------------------------------------
if index(g:bundle_group, 'react') >= 0
	Plug 'mxw/vim-jsx'
	Plug 'mattn/emmet-vim'
	Plug 'hail2u/vim-css3-syntax'
	Plug 'leafgarland/typescript-vim'
	Plug 'pangloss/vim-javascript'
	Plug 'prettier/vim-prettier', {
	\ 'do': 'yarn install',
	\ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
	" vim-jsx
	let g:jsx_ext_required = 0
	" prettier 末尾使用分号
	let g:prettier#config#semi = 'true'                                                                       
	" prettier 字符串使用单引号
	let g:prettier#config#single_quote = 'false'
	" prettier 尾逗号
	let g:prettier#config#trailing_comma = 'none'
	" emmet-vim
	let g:user_emmet_leader_key='<C-Z>'
	let g:user_emmet_settings = {
	\  'javascript' : {
	\      'extends' : 'jsx',
	\  },
	\}
	" vim-javascript
	let g:javascript_plugin_jsdoc = 1
	let g:javascript_plugin_ngdoc = 1
	let g:javascript_plugin_flow = 1
	set foldmethod=syntax
	let g:javascript_conceal_function             = "ƒ"
	let g:javascript_conceal_null                 = "ø"
	let g:javascript_conceal_this                 = "@"
	let g:javascript_conceal_return               = "⇚"
	let g:javascript_conceal_undefined            = "¿"
	let g:javascript_conceal_NaN                  = "ℕ"
	let g:javascript_conceal_prototype            = "¶"
	let g:javascript_conceal_static               = "•"
	let g:javascript_conceal_super                = "Ω"
	let g:javascript_conceal_arrow_function       = "⇒"
	let g:javascript_conceal_noarg_arrow_function = "?"
	let g:javascript_conceal_underscore_arrow_function = "?"
	set conceallevel=1
endif


"----------------------------------------------------------------------
" nerdcommenter code comments
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdcommenter') >= 0
	Plug 'preservim/nerdcommenter'
	let g:NERDSpaceDelims = 1
	let g:NERDCompactSexyComs = 1
	let g:NERDDefaultAlign = 'left'
	let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
	let g:NERDAltDelims_javascript = 1
	let g:NERDDefaultNesting = 0
endif


"----------------------------------------------------------------------
" LanguageTool grammar check
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：Dynamic syntax checking
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	" Set delays and reminder messages
	let g:ale_completion_delay = 500
	let g:ale_echo_delay = 20
	let g:ale_lint_delay = 500
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'

	" Set the timing of detection: normal mode text change, or leave insert mode
	" Disable the setting that changing the text in the default INSERT mode also triggers the setting, which is too frequent, and also makes the completion window flicker
	let g:ale_lint_on_text_changed = 'normal'
	let g:ale_lint_on_insert_leave = 1

	" Lower the process priority of the grammar checker under linux/mac (don't get stuck in the foreground process)
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		let g:ale_command_wrapper = 'nice -n5'
	endif

	" Allow airline integration
	let g:airline#extensions#ale#enabled = 1

	" Syntax checker needed for editing different file types
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'], 
				\ 'cpp': ['gcc', 'cppcheck'], 
				\ 'python': ['flake8', 'pylint'], 
				\ 'lua': ['luac'], 
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'], 
				\ 'css': ['stylelint'],
				\ }


	" Get pylint, flake8 configuration files, under vim-init/tools/conf
	function s:lintcfg(name)
		let conf = s:path('tools/conf/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	" Set parameters for flake8/pylint
	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	" If only clang without gcc (FreeBSD)
	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif


"----------------------------------------------------------------------
" echodoc: display function parameters at the bottom with YCM/deoplete
"----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
	Plug 'Shougo/echodoc.vim'
	set noshowmode
	let g:echodoc#enable_at_startup = 1
endif


"----------------------------------------------------------------------
" LeaderF: super replacement for CtrlP / FZF, fuzzy file matching, tags/function name selection
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	" Enable Leaderf if vim supports python
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF'

		" CTRL+p open file fuzzy matching
		let g:Lf_ShortcutF = '<c-p>'

		" ALT+n open buffer fuzzy matching
		let g:Lf_ShortcutB = '<m-n>'

		" CTRL+n Open recently used file MRU for fuzzy matching
		noremap <c-n> :LeaderfMru<cr>

		" ALT+p to open the function list, press i to enter fuzzy matching, ESC to exit
		noremap <m-p> :LeaderfFunction!<cr>

		" ALT+SHIFT+p to open the tag list, i to enter fuzzy matching, ESC to exit
		noremap <m-P> :LeaderfBufTag!<cr>

		" ALT+n open buffer list for fuzzy matching
		noremap <m-n> :LeaderfBuffer<cr>

		" ALT+m global tags fuzzy matching
		noremap <m-m> :LeaderfTag<cr>

		" The largest history file saves 2048
		let g:Lf_MruMaxFiles = 2048

		" ui customization
		let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		" How to identify the project directory, recursively from the current file directory to the parent directory until the following file/directory is encountered
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_WindowHeight = 0.30
		let g:Lf_CacheDirectory = expand('~/.vim/cache')

		" show absolute path
		let g:Lf_ShowRelativePath = 0

		" hide help
		let g:Lf_HideHelp = 1

		" Fuzzy matching ignores extension
		let g:Lf_WildIgnore = {
					\ 'dir': ['.svn','.git','.hg'],
					\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
					\ }

		" MRU files ignore extensions
		let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		let g:Lf_StlColorscheme = 'powerline'

		" Disable the preview function of function/buftag, you can manually preview it with p
		let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

		" Use the ESC key to exit the leaderf's normal mode directly
		let g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }

	else
		" python is not supported, use CtrlP instead
		Plug 'ctrlpvim/ctrlp.vim'

		" Extensions that display a list of functions
		Plug 'tacahiroy/ctrlp-funky'

		" Ignore default keys
		let g:ctrlp_map = ''

		" Fuzzy match ignored
		let g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		" project logo
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p open file fuzzy matching
		noremap <c-p> :CtrlP<cr>

		" CTRL+n open matching of recently accessed files
		noremap <c-n> :CtrlPMRUFiles<cr>

		" ALT+p display the function list of the current file
		noremap <m-p> :CtrlPFunky<cr>

		" ALT+n matches buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif


"----------------------------------------------------------------------
" End plugin installation
"----------------------------------------------------------------------
call plug#end()



"----------------------------------------------------------------------
" YouCompleteMe default setting: YCM requires you to compile and install manually
"----------------------------------------------------------------------

" Disable preview function: disturbing audiovisual
let g:ycm_add_preview_to_completeopt = 0

" Disable diagnostics: we replace it with the better-used ALE
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone,noselect

" noremap <c-z> <NOP>

" Two characters automatically trigger semantic completion
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }


"----------------------------------------------------------------------
" Ycm whitelist (non-list files do not enable YCM), avoid opening a 1MB txt analysis for half a day
"----------------------------------------------------------------------
let g:ycm_filetype_whitelist = { 
			\ "c":1,
			\ "cpp":1, 
			\ "objc":1,
			\ "objcpp":1,
			\ "python":1,
			\ "java":1,
			\ "javascript":1,
			\ "coffee":1,
			\ "vim":1, 
			\ "go":1,
			\ "cs":1,
			\ "lua":1,
			\ "perl":1,
			\ "perl6":1,
			\ "php":1,
			\ "ruby":1,
			\ "rust":1,
			\ "erlang":1,
			\ "asm":1,
			\ "nasm":1,
			\ "masm":1,
			\ "tasm":1,
			\ "asm68k":1,
			\ "asmh8300":1,
			\ "asciidoc":1,
			\ "basic":1,
			\ "vb":1,
			\ "make":1,
			\ "cmake":1,
			\ "html":1,
			\ "css":1,
			\ "less":1,
			\ "json":1,
			\ "cson":1,
			\ "typedscript":1,
			\ "haskell":1,
			\ "lhaskell":1,
			\ "lisp":1,
			\ "scheme":1,
			\ "sdl":1,
			\ "sh":1,
			\ "zsh":1,
			\ "bash":1,
			\ "man":1,
			\ "markdown":1,
			\ "matlab":1,
			\ "maxima":1,
			\ "dosini":1,
			\ "conf":1,
			\ "config":1,
			\ "zimbu":1,
			\ "ps1":1,
			\ }


