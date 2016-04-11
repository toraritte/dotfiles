" vim:fdm=marker:fdl=0:fdls=0:
" pathogen plugin by tim pope
execute pathogen#infect()

syntax on
if &t_Co > 2 || has("gui_running")
 syntax on
endif

colorscheme railscasts

" === Settings   {{{1
set foldtext=substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')
set foldlevelstart=0
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
set t_Co=256 " needed for -railscasts- colorscheme
set showmatch
set matchtime=2
set hidden
set listchars=tab:⇥\ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·,eol:¬

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
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

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
  autocmd FileType html setlocal et ts=2 sw=2 tw=0
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noet
  autocmd Filetype slim setlocal ts=2 sts=2 sw=2
  autocmd FileType erl setlocal ts=8 sw=4 sts=4 noet
  autocmd BufRead,BufNewFile *.slim setfiletype slim
  autocmd FileType gitcommit setlocal textwidth=72
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

" === Key mappings    {{{1
" \v opens vimrc in a new tab, \s sources it
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>s :source $MYVIMRC<CR>

" 44 instead of <C-^>
nnoremap 44 <C-^>
" 99 instead of <C-w>w
nnoremap 99 <C-w>w

" ,, in INSERT mode to trigger <C-X><C-i>
imap ,, <C-x><C-i>

" %% - Open files in their respective folders other than the pwd {{{2
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'

" map ' to ` {{{2
map ' `

" <Leader>l - change working dir for current window only {{{2
nnoremap <Leader>l :lcd %:p:h<CR>:pwd<CR>

" & - synonym for :&& instead of :& (both in Normal and in Visual mode) {{{2
nnoremap & :&&<CR>$
xnoremap & :&&<CR>$

" <Space> instead of 'za' (unfold the actual fold) {{{2
nnoremap <Space> za

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

" <CR> starts a new change in INSERT mode {{{2
" and abbreviations are expanded
:inoremap <CR> <C-]><C-G>u<CR>

" " === Abbreviations   {{{1
" iab mod module end<C-O>2Te
" iab cla class end<C-O>Ts
" iab def def end<C-O>Tf

" === Plugin configuration   {{{1
" txtfmt: some color fix {{{2
let g:txtfmtColor{1} = '^\\%(k\\|bla\\%[ck]\\)$,c:Black,g:#000000'
let g:txtfmtColor{2} = '^b\\%[lue]$,c:DarkBlue,g:#2aa58f'
let g:txtfmtColor{3} = '^g\\%[reen]$,c:DarkGreen,g:#00b000'
let g:txtfmtColor{4} = '^t\\%[urquoise]$,c:LightGreen,g:#00FFFF'
let g:txtfmtColor{5} = '^r\\%[ed]$,c:DarkRed,g:#ff2727'
let g:txtfmtColor{6} = '^v\\%[iolet]$,c:DarkMagenta,g:#FF00FF'
let g:txtfmtColor{7} = '^y\\%[ellow]$,c:DarkYellow,g:#ffd700'
let g:txtfmtColor{8} = '^w\\%[hite]$,c:White,g:#FFFFFF'
"------------------------------------------------------------------------
" VOom options {{{2
let g:voom_tree_width = 57
" Voom quickstart
nnoremap <LocalLeader><LocalLeader><CR> :Voom<CR>
"------------------------------------------------------------------------
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

" command-t {{{2
nnoremap <silent> <Leader>j :CommandTJump<CR>
let g:CommandTMaxFiles=700000
let g:CommandTMaxDepth=27
let g:CommandTFileScanner='watchman'
let g:CommandTScanDotDirectories=1
let g:CommandTInputDebounce=200
let g:CommandTMaxCachedDirectories=10
let g:CommandTAlwaysShowDotFiles=1

" Vim-ruby {{{2
let ruby_fold=1