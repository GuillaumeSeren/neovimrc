neovimrc
=====
This is my NeoVim configuration,
I use it for my daily usage coding / mail / irc / blog.

Terminal
========
I use NeoVim in a unicode terminal here is my configuration.
https://github.com/GuillaumeSeren/urxvt-config

Plugins
=======
As I use vim-plug to manage the plugins, there is two categories:
* Defaults plugins (always loaded).
* Specifics plugins (lazy loaded on some case).

Dictionnaries
=============
Aside as the plugins the dictionnaries are not installed by vim-plug,
vim might be able to get them for you, if not you will have to download
them yourself and put them in '~/.vim/spell',
you can find them, here (by default I use french & english):
http://wordlist.aspell.net/

Install
=======
```
# Clone this repos
$ git clone https://github.com/GuillaumeSeren/neovimrc ~/.config/nvim
# Launch nvim and install plugins with ':PlugInstall'.
```

## Participate !
If you find it useful, and would like to add your tips and tricks in it,
feel free to fork this project and fill a __Pull Request__.

## Licence
The project is GPLv3.
