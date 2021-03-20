# vim-literate

vim-literate is a plugin for evaluating source code blocks inside
markdown files (a.k.a. literate programming). It supports code
written in python, perl, sh & bash. Below, an example in python:

``` python
def doubleMe(val):
    return val * 2

print(doubleMe(5))
```
10


## Installation

With vim-plug:

```vimscript
Plug 'iviarcio/vim-literate
```

Or use your favorite plugin manager.

## Use

If you are familiar with markdown files, just insert the code block 
to be evaluated between ``` <lang> ...  ``` directives. Then, with
cursor in any position inside the block, type :EvalCode<CR> or type
the default key map <leader>e. The result will be printed just below
the code block (see the example above). If you do not want to use the
default mapping, set `eval_map_key = 0` and create your own.

## Contributing

Feel free to submit a pull request to make vim-literate better!
