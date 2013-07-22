" PHP Refactoring Functions for VIM
"
" Maintainer: Benjamin Eberlei <kontakt@beberlei.de>
" License: MIT
" Language: PHP 5
"
" =======================================================================
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions
" are met:
"
"  1. Redistributions of source code must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"
"  2. Redistributions in binary form must reproduce the above
"       copyright notice, this list of conditions and the following
"       disclaimer in the documentation and/or other materials provided
"       with the distribution.
"
"  3. The name of the author may not be used to endorse or promote
"       products derived from this software without specific prior
"       written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
" OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
" ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
" GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
" INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
" WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
" NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if !exists("no_plugin_maps") && !exists("no_php_maps")
  if !hasmapto('<Plug>ExtractMethod')
    xmap <buffer> <unique> <LocalLeader>em <Plug>ExtractMethod
  endif
  if !hasmapto('<Plug>ExtractVariable')
    nmap <buffer> <unique> <LocalLeader>ev <Plug>ExtractVariable
  endif
  if !hasmapto('<Plug>ExtractClassProperty')
    nmap <buffer> <unique> <LocalLeader>ep <Plug>ExtractClassProperty
  endif
  if !hasmapto('<Plug>ExtractInterface')
    nmap <buffer> <unique> <LocalLeader>ei <Plug>ExtractInterface
  endif
  if !hasmapto('<Plug>RenameLocalVariable')
    nmap <buffer> <unique> <LocalLeader>rlv <Plug>RenameLocalVariable
  endif
  if !hasmapto('<Plug>RenameClassVariable')
    nmap <buffer> <unique> <LocalLeader>rcv <Plug>RenameClassVariable
  endif
  if !hasmapto('<Plug>ImplementAbstractFunctions')
    nmap <buffer> <unique> <LocalLeader>iaf <Plug>ImplementAbstractFunctions
  endif
endif

noremap <buffer> <unique> <Plug>ExtractMethod              :call <SID>ExtractMethod()<CR>
noremap <buffer> <unique> <Plug>ExtractVariable            :call <SID>ExtractVariable()<CR>
noremap <buffer> <unique> <Plug>ExtractClassProperty       :call <SID>ExtractClassProperty()<CR>
noremap <buffer> <unique> <Plug>ExtractInterface           :call <SID>ExtractInterface()<CR>
noremap <buffer> <unique> <Plug>RenameLocalVariable        :call <SID>RenameLocalVariable()<CR>
noremap <buffer> <unique> <Plug>RenameClassVariable        :call <SID>RenameClassVariable()<CR>
noremap <buffer> <unique> <Plug>ImplementAbstractFunctions :call <SID>ImplementAbstractFunctions()<CR>

function! s:ExtractMethod() range
  let name = inputdialog("Name of new method:")
  '<
  exec "normal! O\<BS>private function " . name . "()\<CR>{\<Esc>"
  '>
  exec "normal! oreturn ;\<CR>}\<Esc>k"
  s/return/\/\/ return/ge
  normal! j%
  normal! kf(
  exec "normal! yyPi// = \<Esc>wdwA;\<Esc>"
  normal! ==
  normal! j0w
endfunction

" ci,$tmp^[ko$tmp = ^[pa;^[
function! s:ExtractVariable()
  let name = inputdialog("Name of new variable:")
  exec "normal ci,$" . name . "\<Esc>"
  exec "normal! ko$" . name . " = \<Esc>"
  normal! pa;
endfunction

" caW$this->tmp ^[/^class^Mjoprivate ^[pi;^[:w^Ml
function! s:ExtractClassProperty()
  normal! mr
  normal! ^l"ryW
  let name = substitute(@r, "^\\s\\+\\|\\s\\+$", "", "g")
  exec "normal! ^cW$this->" . name . "\<Esc>"
  /^class
  exec "normal! joprivate $" . name . ";"
  normal! `r
endfunction

function! s:ExtractInterface()
  let name = inputdialog("Name of new interface:")
  exec "normal! Gointerface " . name . "\<CR>{"
  g/const/normal! yyGp
  g/public \$/normal! yyGp
  g/public function/normal! yyGp$a;
  normal! Go}
endfunction

function! s:RenameLocalVariable()
  normal! "zyaw
  let oldName = substitute(@z, "^\\s\\+\\|\\s\\+$", "", "g")
  let newName = inputdialog("Rename " . oldName . " to:")
  call search('function', 'bW')
  call search('{', 'W')
  normal! [[
  let startLine = line('.')
  normal! %
  let stopLine = line('.')
  exec startLine . ',' . stopLine . ':s/\<' . oldName . '\>/' . newName . '/g'
endfunction

function! s:RenameClassVariable()
  normal "zyaw
  let oldName = substitute(@z, "^\\s\\+\\|\\s\\+$", "", "g")
  let newName = inputdialog("Rename " . oldName . " to:")
  call search('class ', 'bW')
  call search('{', 'w')
  let startLine = line('.')
  normal! %
  let stopLine = line('.')
  exec startLine . ',' . stopLine . ':s/public $' . oldName . '/public $'. newName .'/ge'
  exec startLine . ',' . stopLine . ':s/protected $' . oldName . '/protected $'. newName .'/ge'
  exec startLine . ',' . stopLine . ':s/private $' . oldName . '/private '. newName .'/ge'
  exec startLine . ',' . stopLine . ':s/$this->' . oldName . '/$this->'. newName .'/ge'
  exec "vimgrep /" . newName . "/ %"
  copen
endfunction

function! s:ImplementAbstractFunctions()
  if (getline(line('.')) =~# 'function.*;$')
    g/function.*;$/normal! o{
    g/function.*;$/normal! jothrow new \RuntimeException('Not implemented yet.');
    g/function.*;$/normal! jjo}
    g/function.*;$/s/abstract /public /
    g/function.*;$/s/;$//
  endif
endfunction
