# BASH COMPLETIONS
https://github.com/scop/bash-completion

Bash completions@2 is installed

⚠️ Warning: it requires bash > 4!
Set your bash version in iTerm/profiles/Command/Custom shell -> `/usr/local/bin/bash` <- Brew version

`echo ${BASH_VERSION}` should be > 4

## Custom user completions
As stated in their page we should put them in the `completions` subdir of `$BASH_COMPLETION_USER_DIR` (defaults to $XDG_DATA_HOME/bash-completion or ~/.local/share/bash-completion if $XDG_DATA_HOME is not set) to have them loaded automatically on demand when the respective command is being completed. 

 - In Mac Os: `$BASH_COMPLETION_USER_DIR` is unset
 - So by default I have to create 2 sub folders `bash-completion/completions` in `~/.local/share` and put my completions file there

 ## TODO:
 Automatically link this folder form dotfile dir
