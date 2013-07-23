# PHP Refactoring for VIM

Some very simple refactorings for PHP code using VIM:

* Extract Method
* Extract Variable
* Extract Interface
* Extract Class Property
* Rename Local Variable
* Rename Class Variable
* Implement all abstract functions

## Requirements

* VIM Comma Object ([austintaylor/vim-commaobject](http://github.com/austintaylor/vim-commaobject))

## Mappings

Default key mappings defined:

    xmap <buffer> <unique> <LocalLeader>em <Plug>ExtractMethod
    nmap <buffer> <unique> <LocalLeader>ev <Plug>ExtractVariable
    nmap <buffer> <unique> <LocalLeader>ep <Plug>ExtractClassProperty
    nmap <buffer> <unique> <LocalLeader>ei <Plug>ExtractInterface
    nmap <buffer> <unique> <LocalLeader>rlv <Plug>RenameLocalVariable
    nmap <buffer> <unique> <LocalLeader>rcv <Plug>RenameClassVariable
    nmap <buffer> <unique> <LocalLeader>iaf <Plug>ImplementAbstractFunctions

If you want avoid them being set put the following in your vimrc:

    let g:no_php_maps = 1

Alternatively, you create your own maps, which will prevent the default ones
from being set.

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

### Rename class variable

Renames variable under cursor inside the whole class. No renaming of
getter/setter or checking for breaks in related classes takes place.

### Implement all abstract functions

If you copy the body of abstract class or interface into a concrete implementation class,
and then execute this refactoring. It will turn all abstract methods into empty body
methods throwing a runtime exception.
