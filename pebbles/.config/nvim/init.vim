" vim:fdm=marker:fdl=0:fdls=0:

" === Plugin Management {{{1
" switching to plugin manager https://github.com/junegunn/vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $HOME/.config/nvim/init.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/netrw.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'slashmili/alchemist.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/fzf.vim'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-tags'
Plug 'sjl/tslime.vim'
Plug 'embear/vim-foldsearch'
Plug 'Konfekt/FastFold'
Plug 'ElmCast/elm-vim'
Plug 'raichoo/purescript-vim'
Plug 'andyl/vim-textobj-elixir' | Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-markdown-folding'
Plug 'mbbill/undotree'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/limelight.vim'
Plug 'keith/swift.vim'
call plug#end()

" === Settings   {{{1
syntax on
if &t_Co > 2 || has("gui_running")
 syntax on
endif

" colorscheme railscasts

set encoding=utf-8
set noequalalways
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
" set t_Co=256 " needed for -railscasts- colorscheme
set showmatch
set matchtime=2
set hidden
set listchars=tab:⇥\ ,trail:␣,extends:⇉,precedes:⇇,nbsp:·,eol:¬
set undofile
set ignorecase
set smartcase

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
  autocmd Filetype slim setlocal ts=2 sts=2 sw=2
  autocmd FileType erl setlocal ts=8 sw=4 sts=4 noet
  autocmd BufRead,BufNewFile *.slim setfiletype slim
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

" === Key mappings    {{{1
" set undopoint in insert mode before pasting a text {{{2
" https://unix.stackexchange.com/questions/117323/how-do-i-only-undo-pasted-text-in-vim
inoremap <C-R> <C-G>u<C-R>

" \v opens vimrc in a new tab, \s sources it
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>s :source $MYVIMRC<CR>

" 44 instead of <C-^>
nnoremap 44 <C-^>
" 99 instead of <C-w>w
nnoremap 99 <C-w>w

" %% - Open files in their respective folders other than the pwd
cnoremap <expr> %%  getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'

" <Leader>l - change working dir for current window only
nnoremap <Leader>l :lcd %:p:h<CR>:pwd<CR>

" & - synonym for :&& instead of :& (both in Normal and in Visual mode)
nnoremap & :&&<CR>$
xnoremap & :&&<CR>$

" <Space> instead of 'za' (unfold the actual fold)
nnoremap <Space> za

" Like gJ, but always remove spaces
fun! JoinSpaceless()
    execute 'normal gJ'

    " Character under cursor is whitespace?
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        " When remove it!
        execute 'normal dw'
    endif
endfun

nnoremap <Leader>J :call JoinSpaceless()<CR>

" in NORMAL mode CTRL-j splits line at cursor
nnoremap <NL> i<CR><ESC>

" <C-p> and <C-n> instead of <Up>,<Down> on command line
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" {visual}* search
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" & now repeats the last :s with its flags
" the original & repeats the last :s WITHOUT the flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" fzf
nnoremap <leader><C-r> :History:<CR>
nnoremap <leader><C-o> :Files<CR>
nnoremap <leader><C-l> :Lines<CR>
nnoremap <leader><C-i> :BLines<CR>
nnoremap <leader><C-k> :Buffers<CR>
nnoremap <leader><C-j> :Ag<CR>
nnoremap <leader><C-w> :Windows<CR>
nnoremap <leader><C-m> :Marks<CR>
nnoremap <leader><C-v> :BCommits<CR>
nnoremap <leader><C-c> :Commits<CR>
imap <c-x><c-l> <plug>(fzf-complete-line)

" === Plugin configuration   {{{1
" Load matchit.vim, but only if the user hasn't installed a newer version. {{{2
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" deoplete {{{2
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#buffer#require_same_filetype = 0


call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])

" netrw {{{2
let g:netrw_liststyle=3

" easymotion & co {{{2
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and somtimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

" tslime {{{2
let g:tslime_ensure_trailing_newlines = 1

" UndoTree {{{2
let g:undotree_ShortIndicators = 1
let g:undotree_CustomUndotreeCmd = 'vertical 32 new'
let g:undotree_CustomDiffpanelCmd= 'belowright 12 new'

" Seoul256 colorscheme {{{2
let g:seoul256_background = 239
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
