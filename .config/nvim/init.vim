" General configs
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set relativenumber
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
filetype plugin on
set ttyfast                 " Speed up scrolling in Vim
set noswapfile            " disable creating swap file
set scrolloff=5

" Plugins
call plug#begin(stdpath('data') . '/plugged')
    " Appearance
    Plug 'overcache/NeoSolarized'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'thaerkh/vim-indentguides'
    " Utilities
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'preservim/tagbar'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on':  'NERDTreeToggle' }
    Plug 'chrisbra/csv.vim'
    " gaip=
    Plug 'junegunn/vim-easy-align'
    " Choose completion between ddc, ycm and asyncomplete
    " Dev
    Plug 'dense-analysis/ale' " linting engine
    Plug 'cespare/vim-toml' " toml syntax
    Plug 'neovim/nvim-lspconfig' " autocomplete lsp
    Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
    " Deno
    Plug 'vim-denops/denops.vim'
    Plug 'Shougo/ddc.vim'
    Plug 'Shougo/pum.vim'
    Plug 'Shougo/ddc-around'
    Plug 'LumaKernel/ddc-file'
    Plug 'Shougo/ddc-nvim-lsp'
    Plug 'Shougo/ddc-matcher_head'
    Plug 'Shougo/ddc-matcher_length'
    Plug 'Shougo/ddc-sorter_rank'
    Plug 'Shougo/ddc-converter_remove_overlap'
    Plug 'matsui54/ddc-nvim-lsp-doc'
call plug#end()

" Bindings
vnoremap < <gv
vnoremap > >gv
nnoremap 0 ^
nnoremap ^ 0
noremap <C-l> :noh<CR> " Clear highlights
" buffer magic
set hidden
nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>
nnoremap <A-Down> :e#<CR>
nnoremap <A-1> :1b<CR>
nnoremap <A-2> :2b<CR>
nnoremap <A-3> :3b<CR>
nnoremap <A-4> :4b<CR>
nnoremap <A-5> :5b<CR>
nnoremap <A-6> :6b<CR>
nnoremap <A-7> :7b<CR>
nnoremap <A-8> :8b<CR>
nnoremap <A-9> :9b<CR>
nnoremap <A-0> :10b<CR>
" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" TagBar
nnoremap <C-t> :TagbarToggle<CR>

" Colorscheme
let g:neosolarized_contrast = "low"
au ColorScheme * hi Normal ctermbg=none guibg=none
colorscheme NeoSolarized
hi CursorLineNr    term=bold cterm=bold ctermfg=012 gui=bold
" airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline_theme="solarized"
let g:airline_solarized_bg="dark"
" indent
let g:indentguides_specialkey_color = get(g:, 'indentguides_specialkey_color',  'ctermfg=238 ctermbg=NONE guifg=Grey27 guibg=NONE')
execute "highlight NonText " . g:indentguides_specialkey_color

" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Coding utilities
function Hl_too_long(...)
    highlight ColorColumn ctermbg=red
    call matchadd('ColorColumn', '\%81v', -1)
endfunction
au FileType cpp,python,rust call Hl_too_long()
set undodir=$HOME/.local/share/nvim/undo
set undofile

" DDC Config
call ddc#custom#patch_global('sources', ['nvim-lsp', 'around', 'file'])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
    \     'matchers': ['matcher_head', 'matcher_length'],
    \     'sorters': ['sorter_rank'],
    \     'converters': ['converter_remove_overlap']},
    \ 'nvim-lsp': {
    \     'mark': 'LSP',
    \     'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
    \ 'around': { 'mark': 'A'},
    \ })
call ddc#custom#patch_global('completionMenu', 'pum.vim')

call ddc#custom#patch_global('sourceParams', {
    \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
    \ })

call ddc#custom#patch_global('sourceOptions', {
    \ 'file': {
    \   'mark': 'F',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \ }})
call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\\\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'os',
    \   },
    \ }})

inoremap <silent><expr> <Down>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Down>'
inoremap <silent><expr> <Up>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<Up>'
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <silent><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#manual_complete()
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>

" inoremap <silent><expr> <TAB>
" \ ddc#map#pum_visible() ? '<C-n>' :
" \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
" \ '<TAB>' : ddc#map#manual_complete()
" 
" " <S-TAB>: completion back.
" inoremap <silent><expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

"inoremap <silent><expr> <TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'
"km('i', '<tab>', 'v:lua.tab_complete()' ,{expr = true, silent = true, noremap = true})
    "km('i', '<s-tab>', '<C-R>=v:lua.s_tab_complete()<CR>' ,{silent = true, noremap = true})
    "km('i', '<enter>', 'v:lua.enter_key()' ,{expr = true, noremap = false})
    "fn['ddc#enable']()
call ddc#enable()
call ddc_nvim_lsp_doc#enable()

" Dark magic
lua << EOF
lspconfig = require("lspconfig")
lspconfig.vimls.setup{}
lspconfig.sumneko_lua.setup {}
lspconfig.pyright.setup{
    handlers = {
        ['textDocument/publishDiagnostics'] = function(...) end
    }
}
lspconfig.clangd.setup{}
EOF
