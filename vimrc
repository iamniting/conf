" .vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command Ws w !sudo tee % > /dev/null

" (useful for handling command error while saving file)
command W w
command Wqa wqa
command Wq wq


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

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

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme default
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Set Column, CursorLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight cursorline line
set cursorline
highlight CursorLine cterm=None ctermbg=darkgrey

" set colorcolumn to 80 and highlight it with grey color
set cc=80
highlight ColorColumn ctermbg=8 guibg=darkgrey


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set textwidth to have 80 columns
" set tw=80

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
" set tabstop=4

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" add plain file stuff
autocmd BufEnter * if &filetype == "" | setlocal ft=sh | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in git etc anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %F\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    if @% == 'controllers/storagecluster/reconcile.go'
        return
    endif
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.go,*.py,*.sh,*.yml,*.yaml,.spec,.vimrc,.bashrc,
                \vimrc,bashrc,* :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

fun! CmdLine(str)
    call feedkeys(":" . a:str)
endfun

fun! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfun


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-Plug Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins will be downloaded under the specified directory.
if version >= 800
    try
        call plug#begin('~/.vim/plugged')

        Plug 'fatih/vim-go'
        Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile', 'tag': 'v0.0.82'}
        "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf'
        Plug 'powerline/powerline',  {'rtp': 'powerline/bindings/vim/'}
        Plug 'morhetz/gruvbox' "color theme
        Plug 'frazrepo/vim-rainbow' "show colour brackets
        Plug 'jiangmiao/auto-pairs' "completes the other bracket itself
        Plug 'airblade/vim-gitgutter' "git wrapper
        Plug 'mbbill/undotree'
        Plug 'voldikss/vim-floaterm'
        "Plug 'tpope/vim-fugitive'
        "Plug 'preservim/nerdtree'
        "Plug 'preservim/nerdcommenter'

        call plug#end()
    catch
    endtry
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => coc.nvim default settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by others.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

fun! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gruvbox plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if version >= 800 && exists(":Plug")
    try
        colorscheme gruvbox

        highlight Normal ctermbg=NONE guibg=NONE
        set notermguicolors
        set termguicolors
    catch
    endtry
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nerdtree plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>e :NERDTreeToggle<CR>

if version >= 800 && exists(":Plug")
    try
        " open a NERDTree when vim starts up and no files were specified
        " autocmd StdinReadPre * let s:std_in=1
        " autocmd VimEnter * if argc() == 0 && !exists("s:std_in")
        "             \ | NERDTree | endif

        " close vim if the only window left open is a NERDTree
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
                    \ && b:NERDTree.isTabTree()) | q | endif

        " NERDTress File highlighting
        function! NERDTreeHighlightFile(extension, guifg)
                exec 'autocmd filetype nerdtree highlight ' . a:extension .
                            \ ' ctermfg='. "NONE" .' ctermbg='. "NONE" .
                            \ ' guifg='. a:guifg .' guibg='. "NONE"
                exec 'autocmd filetype nerdtree syn match ' . a:extension .
                            \ ' #^\s\+.*'. a:extension .'$#'
        endfunction

        call NERDTreeHighlightFile('go', '#3498DB')
        call NERDTreeHighlightFile('py', '#F4D03F')
        call NERDTreeHighlightFile('sh', '#59FF00')
    catch
    endtry
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-rainbow plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-go plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap gi :GoImports<CR>
nmap gf :GoFmt<CR>
nmap gr :GoRun<CR>
nmap gc :GoCallers<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_OPTS='--height 40% --color=bg:236'
nmap <leader>f :FZF<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-gitgutter plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>g :GitGutterToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => coc-python plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> gd <Plug>(coc-definition)
