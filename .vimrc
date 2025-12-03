"
" to debug unexpected settings, use 
"  :verbose [option]?
" so to find out eg why spell is always activated even though there's a set nospell in here, run
"  :verbose set spell?
" and it tells you where that option is set.
"
"
" what are setting scopes?
"
"  :help internal-variables
" 
"                 (nothing) In a function: local to a function; otherwise: global 
" buffer-variable    b:     Local to the current buffer.                          
" window-variable    w:     Local to the current window.                          
" tabpage-variable   t:     Local to the current tab page.                        
" global-variable    g:     Global.                                               
" local-variable     l:     Local to a function.                                  
" script-variable    s:     Local to a :source'ed Vim script.                     
" function-argument  a:     Function argument (only inside a function).           
" vim-variable       v:     Global, predefined by Vim.
"
"
" more on variables: http://learnvimscriptthehardway.stevelosh.com/chapters/19.html
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: 
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version: 
"       5.0 - 29/05/12 15:43:36
"
" Blog_post: 
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Syntax_highlighted:
"       http://amix.dk/vim/vimrc.html
"
" Raw_version: 
"       http://amix.dk/vim/vimrc.txt
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"NeoBundle Scripts-----------------------------
if has('vim_starting')
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'dense-analysis/ale'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
" jump between diffs: [c and ]c
" show/stage/undo diff: ;hp and ;hs and ;hu
" toggle highlighting: :GitGutterLineHighlightsToggle
NeoBundle 'airblade/vim-gitgutter'
" a tig-like commit viewer extension for fugitive:
"NeoBundle 'int3/vim-extradite'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'ap/vim-css-color'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

"NeoBundle 'ywjno/vim-tomorrow-theme'
NeoBundle 'squarefrog/tomorrow-night.vim'

" airline
" NeoBundle 'bling/vim-airline'
NeoBundle 'itchyny/lightline.vim'

" syntastic
" NeoBundle 'scrooloose/syntastic'
"NeoBundle 'andviro/flake8-vim'

" Unite
NeoBundle 'Shougo/unite.vim'

" Scala
"NeoBundle 'derekwyatt/vim-scala'

" JS indent
NeoBundle 'pangloss/vim-javascript'

" Pandoc
" NeoBundle 'vim-pandoc/vim-pandoc'
"NeoBundle 'vim-pandoc/vim-pandoc-syntax'

" Markdown
NeoBundle 'plasticboy/vim-markdown'

" vimtex
NeoBundle 'lervag/vimtex'

" TOML syntax
NeoBundle 'cespare/vim-toml'

NeoBundle 'NoahTheDuke/vim-just'

NeoBundle 'fladson/vim-kitty'

" nerdtree
" NeoBundle 'scrooloose/nerdtree'

" Required:
call neobundle#end()

" Required:
"filetype plugin off

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" to uninstall disabled plugins, however, `NeoBundleClean` needs to be run.
"End NeoBundle Scripts-------------------------


"Pathogen -------------------------------------
execute pathogen#infect()
"----------------------------------------------

set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
"filetype plugin on
filetype plugin indent on

" Set to auto read when a file is changed from the outside
"set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ";"
let g:mapleader = ";"

" Fast saving (<cr>: carriage return)
nmap <leader>w :w!<cr>

" after compiling vim with support for +xterm_clipboard, we can directly copy to both of 
" the clipboard available to X11, by putting them into the "* and "+ registers.
" Yanking to the outside world should be even more comfortable than that:
" (to check if vim was compiled with xterm_clipboard option, look at :version or :echo has('xterm_clipboard')
vnoremap <leader>y "*y
" same goes for pasting from outside into vim
nnoremap <leader>p "*p
nnoremap <leader>P "*P

"vmap <C-c> "+y

" toggle PASTE mode (pasting from clipboard in PASTE mode prevents indentation from being all fucked up)
" map to <Ctrl-Shift-j>
set pastetoggle=<C-J>

" enable modeline processing even though it is somehow enabled anyway, just to be sure
set modeline

" show max line length ruler according to current textwidth
set colorcolumn=-0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" support mouse [in normal mode]
set mouse=n

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler
set number
set relativenumber

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" lower updatetime (instead of default 4s, good for gitgutter)
set updatetime=100

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" for highlighting tabs in set list mode
set listchars=eol:¬,tab:->,trail:~,extends:>,precedes:<,space:␣

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

"colorscheme torte
" /usr/share/vim/vim73/colors

colorscheme happy_hacking
set background=dark
"colorscheme tomorrow-night

" General colors
" Set extra options when running in GUI mode
if has('gui_running') || has('nvim') 
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
    hi Normal 		guifg=#f6f3e8 guibg=#201c1f
else
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
		" IMPORTANT FOR KITTY!!!
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#201c1f\007"
    let &t_te = &t_te . "\033]110\007\033]11;#201c1f\007"
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Linting:
" code pythonicalness checking using pylint for :make command
au FileType python setlocal makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
au FileType python setlocal errorformat=%f:%l:\ %m
au FileType python setlocal expandtab
au FileType python setlocal tabstop=4

"""""""""""
" Syntastic
"
"let g:syntastic_python_pylint_args='-d C0302,F0401,E0611,R0912,C0103,R0914 -f parseable -r n'
let g:Syntastic_java_checkers=[]
" always populate location list so we can navigate with :lnext and :lprev (or :ll if there is only 1 result)
let g:syntastic_always_populate_loc_list = 1

" flake8
"
let g:PyFlakeOnWrite = 1


" recognize markdown files
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown


""""""""""""
" vimtex
"
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:vimtex_complete_recursive_bib = 1
let g:tex_flavor = 'latex'

map <C-c> <C-x><C-o>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" learn more about these options at http://tedlogan.com/techblog3.html

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" this is how many characters wide tabs are displayed in vim
set tabstop=2
" this is by how many characters text gets indented when using the > command
set shiftwidth=2
" this is how by how many characters the cursor advances when <Tab> is hit in insert mode
set softtabstop=2

" set default max line length to a large value so that vim doesn't automatically insert
" EOLs after 80 characters
set tw=500
" tip: use modeline in files where line length is preferred to be limited to 80 chars:
" /* vim: tw=80 */
"
" auto indent:
" Copy indent from current line when starting a new line (typing <CR>
" in Insert mode or when using the "o" or "O" command).  If you do not
" type anything on the new line except <BS> or CTRL-D and then type
" <Esc>, CTRL-O or <CR>, the indent is deleted again.
set ai

" smart indent
" helps with indentation based on input, e.g. when typing a '}', indentation is
" aligned to the matching '{'.
" inserts an extra indent after lines ending with keywords or trigger characters like
" {, if, while and such. They can be displayed by calling :set cinwords?
set si

" in insert mode:
" don't remove indentation when typing '#' (annoying when writing python)
inoremap # X#

" dont wrap lines longer than the window width for display
set nowrap
" note: if wrap were enabled, you could define where and how to wrap lines for display
" by setting lbr, which will make vim wrap lines at characters that can be shown with
" :set breakat?

""" some filetype-sensitive settings:

"" defining external tools to be used as handlers for the = command
" XML formatting using libxml
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
" JSON formatting using python json module
au FileType json setlocal equalprg=python\ -mjson.tool\ 2>/dev/null

" Note: filetype-specifig local settings like the ones above can also be put in
" their own files to keep .vimrc clean.
" python settings would go into ~/.vim/ftplugin/python.vim and hence overwrite
" python settings in .vimrc, but can themselves be overwritten by
" ~/.vim/after/ftplugin/python.vim
" [http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean]


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
"map <space> /
"map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>d :Bclose<cr>
" Navigate buffers
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


"
" airline
" http://makandracards.com/jan0sch/18283-enable-powerline-fonts-with-rxvt-unicode-and-vim-airline
""""""""""""""
let g:airline_powerline_fonts = 1

" buffer bar
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" more tips on effective buffer use:
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
"

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" show partial command
set showcmd

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ \ \ %=Pos:\ %l,%v\ \%r%P


" for syntastic
" https://medium.com/@hpux/vim-and-eslint-16fa08cc580f

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" linting for javascript
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint %'

" language linters
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8', 'pylint', 'mypy'],
\   'yaml': ['yamllint'],
\   'groovy': ['npm-groovy-lint']
\}
let g:ale_linters_explicit = 1
let g:ale_groovy_npmgroovylint_options = '-j /usr/lib/jvm/default/bin/java'
"   'java': ['javac']
let g:ale_java_javac_options = '-processor lombok'
let g:ale_python_mypy_options = '--check-untyped-defs --strict'

let g:ctrlp_types = ['mru', 'fil', 'buf']
let g:ctrlp_extensions = ['autoignore']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>N
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>N :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ;ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

set nospell
" to prevent pandoc plugin to enable spell checking anyway, remove module "spell" from
" g:pandoc#modules#enabled list in ~/.vim/bundle/vim-pandoc/plugin/pandoc.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldlevel=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


" Search for the ... arguments separated with whitespace (if no '!'),
" " or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
	if a:0 > 0
	  let sep = (a:bang) ? '\_W\+' : '\_s\+'
		let @/ = join(a:000, sep)
	endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>


" Append modeline after last line in buffer,
" containing current settings like tabs/indentation, filetype
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set ft=%s :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no',
				\ &filetype)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
" from http://vim.wikia.com/wiki/Modeline_magic
" to run this, type <leader>ml
" note: commentstring is /*%s*/ by default, which might not the ideal thing to put into
" files we want to be read by e.g. vim or the python interpreter, so...
au FileType vim setlocal commentstring=\"%s
au FileType python setlocal commentstring=#%s
au FileType tex setlocal commentstring=\%%s
au FileType sh setlocal commentstring=#%s
au FileType markdown setlocal commentstring=<!---%s\ -->


" CTAGS
"

set tags=./tags;,tags;


" for tmux options -g xterm-keys on
" https://ericdevries.dev/post/vim-ctrl-arrow-deletes-lines/
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" vim: set ts=2 sw=2 tw=500 noet ft=vim :
