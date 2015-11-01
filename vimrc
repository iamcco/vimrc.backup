" 检测环境 {

    " 检测系统 {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " 设置vim的插件文件夹位置 {
        if WINDOWS()
          " 首先载入gvim自己生成的gvimrc配置
          if filereadable(expand("$HOME/.vim/gvimrc"))
              source $HOME/.vim/gvimrc
          endif
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

" }

" 使用bundle管理插件 {
    if filereadable(expand("$HOME/.vim/vimrc.bundles"))
        source $HOME/.vim/vimrc.bundles
    endif
" }

" 常用配置 {
    " 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
    syntax on                                                               " Syntax highlighting
    filetype on
    filetype plugin on
    filetype plugin indent on                                               " Automatically detect file types.
    scriptencoding utf-8
    set encoding=utf-8                                                      " 设置gvim内部编码
    if WINDOWS()
        source $VIMRUNTIME/delmenu.vim                                      " 仅在windows的Gvim使用 解决菜单和右键乱码
        source $VIMRUNTIME/menu.vim                                         " 仅在windows的Gvim使用 解决菜单和右键乱码
    endif
    set fileencoding=utf-8                                                  " 设置当前文件编码
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 " 设置支持打开的文件的编码
    set fileformat=unix                                                     " 设置新文件的<EOL>格式
    set fileformats=unix,dos,mac                                            " 给出文件的<EOL>格式类型
    set formatoptions+=m                                                    " 如遇Unicode值大于255的文本，不必等到空格再折行。
    set formatoptions+=B                                                    " 合并两行中文时，不在中间加空格：
    set guifont=Powerline_Consolas:h14
    set background=dark                                                     " Assume a dark background
    set nowrap                                                              " Do not wrap long lines
    set synmaxcol=200                                                       " highlight最大的列数为200，200后的代码将没有高亮，防止处理含有特别长的行的时候，拖慢vim
    set autoindent                                                          " Indent at the same level of the previous line
    set smartindent
    set shiftwidth=4                                                        " Use indents of 4 spaces
    set expandtab                                                           " Tabs are spaces, not tabs
    set tabstop=4                                                           " An indentation every four columns
    set softtabstop=4                                                       " Let backspace delete indent
    set nojoinspaces                                                        " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                                                          " Puts new vsplit windows to the right of the current
    set splitbelow                                                          " Puts new split windows to the bottom of the current
    set matchpairs+=<:>                                                     " Match, to be used with %
    set pastetoggle=<F12>                                                   " pastetoggle (sane indentation on pastes)
    set mouse+=a                                                            " Automatically enable mouse usage
    set mousehide                                                           " Hide the mouse cursor while typing
    set autoread                                                            " 文件在外部修改自动读取
    set shortmess+=filmnrxoOtT                                              " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash                         " Better Unix / Windows compatibility
    set virtualedit=onemore                                                 " Allow for cursor beyond last character
    set history=1000                                                        " Store a ton of history (default is 20)
    set hidden                                                              " Allow buffer switching without saving
    set completeopt=longest,menu                                            " 让vim的补全菜单行为与一般ide一致(参考vimtip1228)
    set wildmenu                                                            " 增强模式中的命令行自动完成操作
    set wildmode=list:longest,full                                          " Command <Tab> completion, list matches, then longest common part, then all.
    set wildignore=*.o,*~,*.pyc,*.class                                     " ignore compiled files
    set relativenumber number                                               " 相对行号，行号变成相对，可以用 nj，nk，进行跳转 5j，5k，上下跳5行
    set tabpagemax=15                                                       " Only show 15 tabs
    set showmode                                                            " Display the current mode
    set cursorline                                                          " Highlight current line
    set backspace=indent,eol,start                                          " Backspace for dummies
    set linespace=0                                                         " No extra spaces between rows
    set nu                                                                  " Line numbers on
    set showmatch                                                           " Show matching brackets/parenthesis
    set incsearch                                                           " Find as you type search
    set hlsearch                                                            " Highlight search terms
    set winminheight=0                                                      " Windows can be 0 line high
    set ignorecase                                                          " Case insensitive search
    set smartcase                                                           " Case sensitive when uc present
    set whichwrap=b,s,h,l,<,>,[,]                                           " Backspace and cursor keys wrap too
    set scrolljump=5                                                        " Lines to scroll when cursor leaves screen
    set scrolloff=3                                                         " Minimum lines to keep above and below cursor
    set foldenable                                                          " Auto fold code
    set foldmethod=indent nofoldenable
    set list
    set listchars=tab:›\ ,trail:-,extends:#,nbsp:.                          " Highlight problematic whitespace

    "切换到编辑文档所在目录
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    "在编辑git提交文档的时候光标移到第一行
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    "保存光标位置在前一个session中
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction
    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " 设置备份文件夹 {
        set backup                  " 设置备份
        if has('persistent_undo')
            set undofile                " 把undo操作保存到文件当中
            set undolevels=1000         " 设置undo操作的最大上限
            set undoreload=10000        " 一个buffer载入时的最大undo行数
        endif

        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    " }

" }

" Vim UI {

    "colorscheme molokai
    colorscheme solarized

    " 插入模式下用绝对行号, 普通模式下用相对 {
        au FocusLost * :set norelativenumber number
        au FocusGained * :set relativenumber
        autocmd InsertEnter * :set norelativenumber number
        autocmd InsertLeave * :set relativenumber
        function! NumberToggle()
            if(&relativenumber == 1)
                set norelativenumber number
            else
                set relativenumber
            endif
        endfunc
        nnoremap <C-n> :call NumberToggle()<cr>
    " }

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "设置标记一列的背景颜色和数字一行颜色一致
    hi! link SignColumn   LineNr
    hi! link ShowMarksHLl DiffAdd
    hi! link ShowMarksHLu DiffChange

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2
        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif



    " terminal or gui {
        "终端主题
        if !has('gui_running')
            color Monokai
        else
            "窗口设置
            winpos 2 0            " 指定窗口出现的位置，坐标原点在屏幕左上角
            set lines=38 columns=160 " 指定窗口大小，lines为高度，columns为宽度

            " 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
            set guioptions-=m
            set guioptions-=T
            set guioptions-=r
            set guioptions-=L
            map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
                \set guioptions-=m <Bar>
                \set guioptions-=T <Bar>
                \set guioptions-=r <Bar>
                \set guioptions-=L <Bar>
            \else <Bar>
                \set guioptions+=m <Bar>
                \set guioptions+=T <Bar>
                \set guioptions+=r <Bar>
                \set guioptions+=L <Bar>
            \endif<CR>
        endif
    " }

" }


" 键位绑定 {

    "设置leader建为逗号
    let mapleader = ','
    let g:mapleader = ','
    let maplocalleader = '_'

    " 浏览器打开文件快捷键
    noremap <leader>go :call ViewFile()<CR>
    let g:browsers = {}
    let g:browsers['chrome'] = "c:/Program\ Files\ (x86)/Google/Chrome/Application/chrome.exe"
    function! ViewFile()
        exec "silent !start " . g:browsers['chrome'] . " %:p"
    endfunction

    "j/k统一为上一相对行和下一相对行，而不是绝对行
    noremap j gj
    noremap k gk

    "容易按错的键位修正
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif
    cmap Tabe tabe

    "复制到行尾，行为向C和D
    nnoremap Y y$

    "代码折叠配置
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "取消高亮
    nmap <silent> <leader>/ :nohlsearch<CR>

    "找到git合并中冲突的地方
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    "进入文件的当前工作文件夹
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    "移动完自后在此选择移动块
    vnoremap < <gv
    vnoremap > >gv

    "选中状态能使用重复操作
    vnoremap . :normal .<CR>

    "在需要sudo权限的代码时候使用
    cmap w!! w !sudo tee % >/dev/null

    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    "列出所有光标所在单词的行，并可以选择相应数字跳到该行
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    "一行中水平移动，用在很长的行中
    map zl zL
    map zh zH

    " 窗口透明、置顶、最大化
    " 需要vimtweak工具
    if WINDOWS()
        nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
        let g:Current_Alpha = 255
        let g:Top_Most = 0
        func! Alpha_add()
            let g:Current_Alpha = g:Current_Alpha + 10
            if g:Current_Alpha > 255
                let g:Current_Alpha = 255
            endif
            call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
        endfunc
        func! Alpha_sub()
            let g:Current_Alpha = g:Current_Alpha - 10
            if g:Current_Alpha < 155
                let g:Current_Alpha = 155
            endif
            call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
        endfunc
        func! Top_window()
            if  g:Top_Most == 0
                call libcallnr("vimtweak.dll","EnableTopMost",1)
                let g:Top_Most = 1
            else
                call libcallnr("vimtweak.dll","EnableTopMost",0)
                let g:Top_Most = 0
            endif
        endfunc

        "快捷键设置
        nmap <c-up> :call Alpha_add()<CR>
        nmap <c-down> :call Alpha_sub()<CR>
        nmap <leader>t :call Top_window()<CR>
    endif

    "分屏窗口移动
    map <C-j> <C-W>j
    map <C-k> <C-W>k
    map <C-h> <C-W>h
    map <C-l> <C-W>l

    " buffer键快速移动
    nnoremap <C-S-tab> :bp<CR>
    nnoremap <C-tab>   :bn<CR>

    " normal模式下切换到确切的tab
    noremap <leader>1 :b1<cr>
    noremap <leader>2 :b2<cr>
    noremap <leader>3 :b3<cr>
    noremap <leader>4 :b4<cr>
    noremap <leader>5 :b5<cr>
    noremap <leader>6 :b6<cr>
    noremap <leader>7 :b7<cr>
    noremap <leader>8 :b8<cr>
    noremap <leader>9 :b9<cr>
    noremap <leader>0 :blast<cr>

    "选择全部
    map <Leader>sa ggVG

" }

" plugins {

    "solarized主题 {
        let g:colors_name='solarized'
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast='normal'
        let g:solarized_visibility='normal'
    " }

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        "补全菜单颜色
        hi Pmenu  guifg=#1c1c1c guibg=#F1F1F1 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        "自动关闭补全预览菜单
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,longest
    " }

    " neocomplcache {
        let g:acp_enableAtStartup = 0             " Disable AutoComplPop.
        let g:neocomplcache_enable_at_startup = 1 " Use neocomplcache.
        let g:neocomplcache_enable_smart_case = 1 " Use smartcase.
        let g:neocomplcache_min_syntax_length = 3 " Set minimum syntax keyword length.
        let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions',
                    \ 'javascript' : $HOME.'/.vim/bundle/vim-dict/dict/javascript.dic',
                    \ 'coffee' : $HOME.'/.vim/bundle/vim-dict/dict/javascript.dic',
                    \ 'css' : $HOME.'/.vim/bundle/vim-dict/dict/css.dic',
                    \ 'php' : $HOME.'/.vim/bundle/vim-dict/dict/php.dic'
                    \ }
        " Define keyword.
        if !exists('g:neocomplcache_keyword_patterns')
            let g:neocomplcache_keyword_patterns = {}
        endif
        let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

        " 插件快捷键配置 {
            "tab键补全选择
            inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

            " <CR>: close popup and save indent.
            inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
            function! s:my_cr_function()
                "return neocomplcache#smart_close_popup() . "\<CR>"
                "For no inserting <CR> key.
                return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
            endfunction
        " }

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown,String,string setlocal omnifunc=htmlcomplete#CompleteTags
        "autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType java set omnifunc=javacomplete#Complete

        " Enable heavy omni completion.
        if !exists('g:neocomplcache_force_omni_patterns')
            let g:neocomplcache_force_omni_patterns = {}
        endif
        let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

        " For perlomni.vim setting.
        " https://github.com/c9s/perlomni.vim
        let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    "}

    " closetag 自动补全html/xml标签 {

        let g:closetag_html_style=1
        autocmd BufRead,BufNewFile *.{String,string} set filetype=html

    " }

    " syntastic {
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_mode_map = {
                    \ "mode": "passive",
                    \ "active_filetypes": [],
                    \ "passive_filetypes": [] }
    " }


    " vim-javascript {

        "let g:html_indent_inctags = 'html,body,head,tbody'
        "let g:html_indent_script1 = 'inc'
        "let g:html_indent_style1 = 'inc'
        let g:jsdoc_default_mapping = '0'
        map <leader>sf :call JsBeautify()<cr>
        autocmd FileType javascript noremap <buffer>  <leader>sf :call JsBeautify()<cr>
        autocmd FileType html noremap <buffer> <leader>sf :call HtmlBeautify()<cr>
        autocmd FileType css noremap <buffer> <leader>sf :call CSSBeautify()<cr>
        " 可视化模式
        autocmd FileType javascript vnoremap <buffer> <leader>sf :call RangeJsBeautify()<cr>
        autocmd FileType html vnoremap <buffer> <leader>sf :call RangeHtmlBeautify()<cr>
        autocmd FileType css vnoremap <buffer> <leader>sf :call RangeCSSBeautify()<cr>

    " }

    " coffee-script {
        " coffee-script的缩进为2个空格
        autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 tabstop=2 softtabstop=2 expandtab
        autocmd FileType coffee noremap <buffer> <leader>r :CoffeeRun<cr>
        autocmd FileType coffee noremap <buffer> <leader>w :CoffeeWatch<cr>
    " }

    " JSON {

        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0

    " }

    " markdown {

        autocmd BufRead,BufNewFile *.{md,mkd,markdown,mdown,mkdn,mdwn} set filetype=markdown

    " }

    " markdown-preview {
"
        let g:mkdp_path_to_chrome = "c:/Program\ Files\ (x86)/Google/Chrome/Application/chrome.exe"

    " }

    " PyMode python-syntax {

        " Disable if python support not present
        let g:pymode_lint_checkers = ['pyflakes']
        let g:pymode_trim_whitespaces = 0
        let g:pymode_options = 0
        let g:pymode_rope = 0
    " }

    " ctrlsf.vim {

        "依赖ag sudo apt-get install silversearcher-ag
        let g:ctrlsf_position = 'bottom'
        nmap <leader>f <Plug>CtrlSFPrompt
        nmap <leader>fw <Plug>CtrlSFCwordPath

    " }

    " ctrlp.vim {

        let g:ctrlp_map = '<leader>p'
        let g:ctrlp_cmd = 'CtrlP'
        map <leader>b :CtrlPMRU<CR>
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux"
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
            \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
            \ }
        "\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
        let g:ctrlp_working_path_mode=0
        let g:ctrlp_match_window_bottom=1
        let g:ctrlp_max_height=15
        let g:ctrlp_match_window_reversed=0
        let g:ctrlp_mruf_max=500
        let g:ctrlp_follow_symlinks=1

    " }

    " ctrlp-funky {

        nnoremap <Leader>fu :CtrlPFunky<Cr>
        " narrow the list down with a word under cursor
        nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
        let g:ctrlp_funky_syntax_highlight = 1
        let g:ctrlp_extensions = ['funky']

    " }

    " vim-fugitive {

        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>

    " }

    " vim-gitgutter {

        let g:gitgutter_map_keys = 0
        let g:gitgutter_enabled = 0
        let g:gitgutter_highlight_lines = 1
        nnoremap <leader>gss :GitGutterToggle<CR>

    " }

    " vim-trailing-whitespace {

        map <leader><space> :FixWhitespace<cr>

    " }

    " vim-multiple-cursors {

        let g:multi_cursor_next_key='<C-m>'
        let g:multi_cursor_prev_key='<C-p>'
        let g:multi_cursor_skip_key='<C-x>'
        let g:multi_cursor_quit_key='<Esc>'

    " }

    " textobj-user {

        call textobj#user#plugin('html', {
        \   'keyVal': {
        \     'pattern': ' *[0-9a-zA-Z_-]\+ *= *"[0-9a-zA-Z_-]\+"',
        \     'select': ['ak', 'ik'],
        \   },
        \ })

    " }

    " vim-expand-region {

        map + <Plug>(expand_region_expand)
        map _ <Plug>(expand_region_shrink)

    " }

    " vim-autoclose {

        let g:AutoClosePairs_del= "{}"

    " }

    " pyflakes-vim {

        let g:pyflakes_use_quickfix = 0

    " }

    " vim-airline {

        "let g:airline_theme='molokai'
        "let g:airline_theme='luna'
        "let g:airline_powerline_fonts=1
        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
        let g:airline#extensions#tabline#enabled = 1

    " }

    " NerdTree {

        map <leader>e :NERDTreeToggle<CR>
        "autocmd VimEnter * NERDTree
        "wincmd w
        "autocmd VimEnter * wincmd w

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=2
        let NERDTreeQuitOnOpen=0
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end

    " }

    " gundo.vim {

        nnoremap <leader>h :GundoToggle<CR>

    " }

    " Tabularize {

            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /=<CR>
            vmap <Leader>a= :Tabularize /=<CR>
            nmap <Leader>a" :Tabularize /"<CR>
            vmap <Leader>a" :Tabularize /"<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

    " }

" }


" Functions {

    " 初始化文件夹 {

        function! InitializeDirectories()
            let parent = $HOME
            let prefix = 'vim'
            let dir_list = {
                        \ 'backup': 'backupdir',
                        \ 'views': 'viewdir',
                        \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            let common_dir = parent . '/.' . prefix

            for [dirname, settingname] in items(dir_list)
                let directory = common_dir . dirname . '/'
                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif
                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()

    " }

" }
