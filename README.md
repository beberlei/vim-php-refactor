# PHP Refactoring for VIM

Some very simple refactorings for PHP code using VIM:

* Extract Method
* Extract Variable
* Extract Interface
* Extract Class Property
* Rename Local Variable
* Rename Class Variable

## Requirements

* Comma Object (austintayler/vim-commaobject)

## Mappings

Default key mappings defined:

    vmap \em :call ExtractMethod()<CR>
    nnoremap \ev :call ExtractVariable()<CR>
    nnoremap \ep :call ExtractClassProperty()<CR>
    nnoremap \ei :call ExtractInterface()<CR>
    nnoremap \rlv :call RenameLocalVariable()<CR>
    nnoremap \rcv :call RenameClassVariable()<CR>

If you want avoid them being set put the following in your vimrc:

    let g:no_php_maps = 1

## Documentation

### Extract Method

Extracts the current visual selection into a private method.
The code will be pasted inline at the current location
and has to be moved around. 

### Extract Variable

Extract the current argument under the cursor into a variable
right above the method call.

### Extract Interface

Create an interface of all constants, public functions and
properties of the current class (the current file actually).
The interface is created below the class and can then moved
around.

### Extract Class Property

Turn a local variable into a class property.

### Rename local variable

Renames variable under cursor inside a function/method to a new name.

## Rename class variable

Renames variable under cursor inside the whole class. No renaming of getter/setter or checking for breaks in related classes takes place.
