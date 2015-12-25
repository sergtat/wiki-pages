# Zsh & Bash startup files.
## Bash
![](/images/Linux/Shell/bashstartupfiles1.png)

|                  |Interactive login|Interactive non-login|Script|
|:-----------------|:---------------:|:-------------------:|:----:|
|`/etc/profile`    |   A             |                     |      |
|`/etc/bash.bashrc`|                 |    A                |      |
|`~/.bashrc`       |                 |    B                |      |
|`~/.bash_profile` |   B1            |                     |      |
|`~/.bash_login`   |   B2            |                     |      |
|`~/.profile`      |   B3            |                     |      |
|`BASH_ENV`        |                 |                     |  A   |
|`~/.bash_logout`  |   C             |                     |      |

```
# Bash customisation file

#General configuration starts: stuff that you always want executed

#General configuration ends

if [[ -n $PS1 ]]; then
    : # These are executed only for interactive shells
    echo "interactive"
else
    : # Only for NON-interactive shells
fi

if shopt -q login_shell ; then
    : # These are executed only when it is a login shell
    echo "login"
else
    : # Only when it is NOT a login shell
    echo "nonlogin"
fi
```

## Zsh

> Note: zsh читает ~/.profile если нет ~/.zshrc

|                |Interactive login|Interactive non-login|Script|
|:---------------|:---------------:|:-------------------:|:----:|
|`/etc/zshenv`   |    A            |    A                |  A   |
|`~/.zshenv`     |    B            |    B                |  B   |
|`/etc/zprofile` |    C            |                     |      |
|`~/.zprofile`   |    D            |                     |      |
|`/etc/zshrc`    |    E            |    C                |      |
|`~/.zshrc`      |    F            |    D                |      |
|`/etc/zlogin`   |    G            |                     |      |
|`~/.zlogin`     |    H            |                     |      |
|`~/.zlogout`    |    I            |                     |      |
|`/etc/zlogout`  |    J            |                     |      |

## My startup.
```bash
=== bash login ===
/etc/profile
/etc/bash/bashrc (Gentoo source from /etc/profile)
~/.bash_profile || ~/.bash_login || ~/.profile
...
~/.bash_logout
/etc/bash/bash_logout

=== bash nologin ===
/etc/bash/bashrc
~/.bashrc

=== bash non-interactive ===
$BASH_ENV

=== zsh login ===
/etc/zsh/zshenv
~/.zshenv
/etc/zsh/zprofile
~/.zprofile
/etc/zsh/zshrc
~/.zshrc
/etc/zsh/zlogin
~/.zlogin
...
~/.zlogout
/etc/zsh/zlogout

=== zsh nologin ===
/etc/zsh/zshenv
~/.zshenv
/etc/zsh/zshrc
~/.zshrc

=== zsh non-interactive ===
/etc/zsh/zshenv
~/.zshenv
```
