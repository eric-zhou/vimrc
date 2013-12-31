set nocompatible

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if &sh =~ '\<cmd'
    silent execute '!""C:\Program Files\Vim\vim73\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . '"'
  else
    silent execute '!C:\Program" Files\Vim\vim73\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  endif
endfunction

"zhoub add 2009-04-05
function! MySys()
    if has("win32")
        let g:iswindows = 0
        return "win32"
    elseif has("unix")
        return "unix"
    else
        return "mac"
    endif
endfunction

syntax on
filetype on
filetype indent on
filetype plugin on

set mouse=a
au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl,*.cc setf cpp
set hlsearch		

" => Text, tab and indent related
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4 
set shiftwidth=4 
au FileType Makefile set noexpandtab

set lbr
set tw=80

set ruler
set wrap            "Wrap lines

set smartindent     "Smart indet
set autoindent		" auto indentation
set incsearch		" incremental search
set nobackup		" no *~ backup files
"set copyindent		" copy the previous indentation on autoindenting
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab		" insert tabs on the start of a line according to context


" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"Don't redraw while executing macros 
set nolazyredraw 
"Set magic on, for regular expressions
set magic 

set autoread		" auto read when file is changed from outside
set number

if has("gui_running")	" GUI color and font settings
  set guifont=Osaka-Mono:h20
  set background=dark 
  set t_Co=256          " 256 color mode
  set cursorline        " highlight current line
  colors moria
else
" terminal color settings
  colors vgod
endif

let mapleader = ","
let g:mapleader = ","

"Fast reloading of the .vimrc
map <silent> <leader>s :source ~/.vimrc<cr>
"Fast editing of .vimrc
map <silent> <leader>e :e ~/.vimrc<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
nmap <leader>w :w!<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>
" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

" status line {
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction
"}


" C/C++ specific settings
"autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30


"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>

" cscope setting
if has("cscope")
"  set csprg=C:\WINDOWS\system32\cscope.exe
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

"my used key bind
nmap <F7> :tag <C-R>=expand("<cword>")<CR><CR>
nmap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
	
" Tag list (ctags)
if MySys() == "windows"                
    let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"              
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif

"NERDTree
let g:NERDTreeWinPos = "right" 
nmap <silent> <leader>nt :NERDTree<cr>

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

" Tag list (ctags)
if MySys() == "windows"                
    let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"              
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
let Tlist_Show_One_File = 1            
let Tlist_Exit_OnlyWindow = 1          
let Tlist_Use_Right_Window = 1         
map <silent> <leader>tl :TlistToggle<cr>

" map <F12> :call Do_CsTag()<CR>
map <F12> :call Do_CsTag()<CR>
function! Do_CsTag()
    echo "do cstag"
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif

    if(executable('findwin'))
        if(g:iswindows!=1)
            silent execute "!echo \"\\!_TAG_FILE_SORTED	2	/2=foldcase/\" > ./filenametags"
            silent execute "!findwin . -name *.[ch] -type f  -printf \"\\%f\\t\\%p\\t1\\n\"  >> ./filenametags"
        endif
    endif
endfunction 

" Enable omni completion. (Ctrl-X Ctrl-O)
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete

"VAM
set runtimepath+=$HOME/.vim/vim-addons/vim-addons/vim_addon_manager
"call vam#ActivateAddons(["snipmate-snippets", "supertab", "omnicppcomplete"], {'auto_install' : 0})
"call vam#ActivateAddons(["supertab", "omnicppcomplete"], {'auto_install' : 0})

fun! EnsureVamIsOnDisk(vam_install_path)
    let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
    if eval(is_installed_c)
        return 1
    else
        if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
            " I'm sorry having to add this reminder. Eventually it'll pay off.
            call confirm("Remind yourself that most plugins ship with ".
                        \"documentation (README*, doc/*.txt). It is your ".
                        \"first source of knowledge. If you can't find ".
                        \"the info you're looking for in reasonable ".
                        \"time ask maintainers to improve documentation")
            call mkdir(a:vam_install_path, 'p')
            execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
            " VAM runs helptags automatically when you install or update 
            " plugins
            exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
        endif
        return eval(is_installed_c)
    endif
endf

fun! SetupVAM()
    " Set advanced options like this:
    " let g:vim_addon_manager = {}
    " let g:vim_addon_manager['key'] = value

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
    " let g:vim_addon_manager.debug_activation = 1

    " VAM install location:
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    if !EnsureVamIsOnDisk(vam_install_path)
        echohl ErrorMsg
        echomsg "No VAM found!"
        echohl NONE
        return
    endif
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

    " Tell VAM which plugins to fetch & load:
    call vam#ActivateAddons(["better-snipmate-snippet", "Supertab", "OmniCppComplete", 
                \"The_NERD_tree", "The_NERD_Commenter", "Conque_Shell"], {'auto_install' : 0})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

    " Addons are put into vam_install_path/plugin-name directory
    " unless those directories exist. Then they are activated.
    " Activating means adding addon dirs to rtp and do some additional
    " magic

    " How to find addon names?
    " - look up source from pool
    " - (<c-x><c-p> complete plugin names):
    " You can use name rewritings to point to sources:
    "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
    "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
    " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()


