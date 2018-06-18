" vim:fdm=marker:fdl=0:fdls=0:

" === Plugin Management {{{1
" switching to plugin manager https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'francoiscabrol/ranger.vim'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/neocomplete.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
" TODO: These are probably redundant. Clear it up.
Plug 'slashmili/alchemist.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'andyl/vim-textobj-elixir' | Plug 'kana/vim-textobj-user'
" ---
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/fzf.vim'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-tags'
Plug 'sukima/xmledit'
Plug 'raichoo/purescript-vim'
Plug 'nelstrom/vim-markdown-folding'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/limelight.vim'
call plug#end()

" === Settings   {{{1
syntax on
if &t_Co > 2 || has("gui_running")
 syntax on
endif

" colorscheme railscasts

set encoding=utf-8
set noequalalways
set foldlevelstart=99
set modeline
set autoindent expandtab smarttab
set shiftround
set nocompatible
set cursorline
set list
set number
set incsearch hlsearch
set showcmd
set laststatus=2
set backspace=indent,eol,start
set wildmenu
set autoread
set history=5000
set noswapfile
set fillchars="vert:|,fold: "
" set t_Co=256 " needed for -railscasts- colorscheme
set showmatch
set matchtime=2
set hidden
set listchars=tab:⇥\ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·,eol:¬
set undofile

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=[%-6{fugitive#head()}]
set statusline+=%t\                          " file name
set statusline+=[%2{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%2{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%2{&fileformat}]              " file format
set statusline+=[%L\,r%l,c%c]            " [total lines,row,column]
set statusline+=[b%n,                      " buffer number
" window number, alternate file in which window (-1 = not visible)
set statusline+=w%{winnr()}]
set statusline+=%h%m%r%w                     " flags
set rtp+=~/.fzf
set foldtext=substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')
set ignorecase
set smartcase

" === Scripts   {{{1
" _$ - Strip trailing whitespace {{{2
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Allow color schemes to do bright colors without forcing bold. {{{2
" if &t_Co == 8 && $TERM !~# '^linux'
"   set t_Co=16
" endif

" if vim has been compiled with +autocmd then do all below {{{2
if has("autocmd")
 " Enable filetype detection
 filetype plugin indent on
 " Restore cursor position
 autocmd BufReadPost *
   \ if line("'\"") > 1 && line("'\"") <= line("$") |
   \   exe "normal! g`\"" |
   \ endif
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t
  autocmd FileType ruby setlocal et ts=2 sw=2 tw=0
  autocmd FileType html setlocal et ts=2 sw=2 tw=0 fdm=syntax
  autocmd FileType xml setlocal et ts=2 sw=2 tw=0 fdm=syntax
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noet
  autocmd BufRead,BufNewFile *.elm setfiletype elm
  autocmd Filetype elm setlocal et ts=2 sts=2 sw=2
  autocmd FileType erl setlocal ts=8 sw=4 sts=4 noet
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType elixir setlocal fdm=syntax
  autocmd FileType haskell setlocal fdm=syntax
  au BufEnter *.erl :set shiftwidth=4
endif

" TFiles - Drew Neil's TagFiles altered to print 'path' too {{{2
command! TFiles :call EchoTags()
function! EchoTags()
  echo join(split(&tags, ","), "\n")
  echo &path
endfunction

" TAdd <dir/containing/tags>  Add tagfile to 'tags' and add the dir to path {{{2
" plays nice with Tim Pope's plugins
command! -nargs=1 TAdd :call TagAddLocallyToBundlerDefaults(<args>)
function! TagAddLocallyToBundlerDefaults(tagdir)
	let s:newPath = ',' . a:tagdir . 'lib'
	let s:newTag  = ',' . a:tagdir . 'tags'
	let &l:tags .= s:newTag
	let &l:path .= s:newPath
endfunction

" REDIR.VIM - https://gist.github.com/intuited/362802 {{{2
" Called with a command and a redirection target
"   (see `:help redir` for info on redirection targets)
" Note that since this is executed in function context,
"   in order to target a global variable for redirection you must prefix it with `g:`.
" EG call Redir('ls', '=>g:buffer_list')
funct! Redir(command, to)
  exec 'redir '.a:to
  exec a:command
  redir END
endfunct
" The last non-space substring is passed as the redirection target.
" EG
"   :R ls @">
"   " stores the buffer list in the 'unnamed buffer'
" Redirections to variables or files will work,
"   but there must not be a space between the redirection operator and the variable name.
" Also note that in order to redirect to a global variable you have to preface it with `g:`.
"   EG
"     :R ls =>g:buffer_list
"     :R ls >buffer_list.txt
command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))

" Qargs - populates the args list with the files in the quickfix list. 'quickfixdo' {{{2
" basically this is a 'quickfixdo':
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
	let buffer_numbers = {}
	for quickfix_item in getqflist()
		let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
	endfor
	return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" PrettyXML {{{2
function! DoPrettyXML()
  silent %!xmllint --format -
endfunction
command! PrettyXML call DoPrettyXML()

" MakeDirsAndSaveFile (:M) {{{2

" Created to be able to save a file opened with :edit where the path
" contains directories that do not exist yet. This script will create
" them and if they exist, `mkdir` will run without throwing an error.

command! M :call MakeDirsAndSaveFile()
" https://stackoverflow.com/questions/12625091/how-to-understand-this-vim-script
" or
" :h eval.txt
" :h :fu
function! MakeDirsAndSaveFile()
  " https://vi.stackexchange.com/questions/1942/how-to-execute-shell-commands-silently
  :silent !mkdir -p %:h
  :redraw!
  " ----------------------------------------------------------------------------------
  :write
endfunction

" === Key mappings    {{{1
" set undopoint in insert mode before pasting a text {{{2
" https://unix.stackexchange.com/questions/117323/how-do-i-only-undo-pasted-text-in-vim
inoremap <C-R> <C-G>u<C-R>

" \yy - copy entire buffer to system clipboard {{{2

nmap <leader>yy :%yank +<CR>

" \v opens vimrc in a new tab, \s sources it {{{2
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>s :source $MYVIMRC<CR>

" 44 instead of <C-^> {{{2
nnoremap 44 <C-^>
" 99 instead of <C-w>w {{{2
nnoremap 99 <C-w>w

" %% - Open files in their respective folders other than the pwd {{{2
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'

" get current working directory to save new files {{{2
cnoremap <expr> %p getcwd()

" <Leader>l - change working dir for current window only {{{2
nnoremap <Leader>l :lcd %:p:h<CR>:pwd<CR>

" & - synonym for :&& instead of :& (both in Normal and in Visual mode) {{{2
nnoremap & :&&<CR>$
xnoremap & :&&<CR>$

" <Space> instead of 'za' (unfold the actual fold) {{{2
nnoremap <Space> za

" Like gJ, but always remove spaces {{{2
fun! JoinSpaceless()
    execute 'normal gJ'

    " Character under cursor is whitespace?
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        " When remove it!
        execute 'normal dw'
    endif
endfun

nnoremap <Leader>J :call JoinSpaceless()<CR>

" in NORMAL mode CTRL-j splits line at cursor {{{2
nnoremap <NL> i<CR><ESC>

" <C-p> and <C-n> instead of <Up>,<Down> on command line {{{2
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" {visual}* search {{{2
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" & now repeats the last :s with its flags {{{2
" the original & repeats the last :s WITHOUT the flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" fzf {{{2
nnoremap <leader><C-r> :History:<CR>
nnoremap <leader><C-o> :Files<CR>
nnoremap <leader><C-l> :Lines<CR>
nnoremap <leader><C-i> :BLines<CR>
nnoremap <leader><C-k> :Buffers<CR>
nnoremap <leader><C-j> :Ag<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

" === Plugin configuration   {{{1
" Load matchit.vim, but only if the user hasn't installed a newer version. {{{2
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" NeoComplete {{{2
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
	\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd BufRead /tmp/mutt-* set tw=72

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" UndoTree {{{2
let g:undotree_ShortIndicators = 1
let g:undotree_CustomUndotreeCmd = 'vertical 32 new'
let g:undotree_CustomDiffpanelCmd= 'belowright 12 new'

" Seoul256 colorscheme {{{2
let g:seoul256_background = 235
colorscheme seoul256

" Goyo {{{2

let g:goyo_width = 104

function! s:goyo_enter()
  Limelight0.4
  UndotreeToggle
  " ...
endfunction

function! s:goyo_leave()
  Limelight!
  UndotreeToggle
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" ranger.vim {{{2
let g:ranger_map_keys = 0
nmap - :Ranger<CR>
