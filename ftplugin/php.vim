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
  vnoremap \em :call ExtractMethod()<CR>
  nnoremap \ev :call ExtractVariable()<CR>
  nnoremap \ep :call ExtractClassProperty()<CR>
  nnoremap \ei :call ExtractInterface()<CR>
  nnoremap \rlv :call RenameLocalVariable()<CR>
  nnoremap \rcv :call RenameClassVariable()<CR>
  nnoremap \iaf :call ImplementAbstractFunctions()<CR>
endif

function! ExtractMethod() range
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
function! ExtractVariable()
  let name = inputdialog("Name of new variable:")
  exec "normal ci,$" . name . "\<Esc>"
  exec "normal! ko$" . name . " = \<Esc>"
  normal! pa;
endfunction

" caW$this->tmp ^[/^class^Mjoprivate ^[pi;^[:w^Ml
function! ExtractClassProperty()
  normal! mr
  normal! ^l"ryW
  let name = substitute(@r, "^\\s\\+\\|\\s\\+$", "", "g")
  exec "normal! ^cW$this->" . name . "\<Esc>"
  /^class
  exec "normal! joprivate $" . name . ";"
  normal! `r
endfunction

function! ExtractInterface()
  let name = inputdialog("Name of new interface:")
  exec "normal! Gointerface " . name . "\<CR>{"
  g/const/normal! yyGp
  g/public \$/normal! yyGp
  g/public function/normal! yyGp$a;
  normal! Go}
endfunction

function! RenameLocalVariable()
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

function! RenameClassVariable()
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

function! ImplementAbstractFunctions()
  if (getline(line('.')) =~# 'function.*;$')
    g/function.*;$/normal! o{
    g/function.*;$/normal! jothrow new \RuntimeException('Not implemented yet.');
    g/function.*;$/normal! jjo}
    g/function.*;$/s/abstract /public /
    g/function.*;$/s/;$//
  endif
endfunction
