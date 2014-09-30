dotfiles
========
things worth considering...:

zsh
---
[This](http://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) is a very nice article 
about the sequence order in which config files are read by various shells. It also suggests
an adaptive files structure for the involved files. For instance, the directory `.zsh`
contains different files for different jobs at different stages of the shell's lifecycle,
sharing a generic shell configuration with other shells (`bash`):

  .shell/
    env
    interactive
    login
    logout
  .zsh/
    env
    interactive
    login
    logout

Look, here's the whole thing in source: [swoosh!](http://hg.flowblok.id.au/shell-startup/src/c418137d51fc?at=default)
