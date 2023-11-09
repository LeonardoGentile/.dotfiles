#!/usr/bin/env bash
brew update
alias BASHRELOAD=". ~/.bash_profile"

#  =========
#  = RBENV =
#  =========
# For different version of ruby
# https://github.com/rbenv/rbenv
# Note: to install the latest stable version of ruby: http://stackoverflow.com/a/30183040/1191416

brew install rbenv
brew install ruby-build         # rbenv plugin that provides an rbenv install
# rbenv init                    # This will install things in my bash_profile: Nope! I do this manually, thanks.

# USAGE
# =======================
# rbenv install --list          # for the list of the available ruby version
rbenv install 2.3.1             # install ruby (globally)
rbenv global 2.3.1              # makes ruby 2.3.1 the default one
rbenv rehash                    # Run this command after you install a new version of Ruby, or install a gem that provides commands.

# NOTE: if error "Ruby Bundle Symbol not found: _SSLv2_client_method" check here:
#   - http://stackoverflow.com/questions/25492787/ruby-bundle-symbol-not-found-sslv2-client-method-loaderror
#   - update ssl:
#       - should be already installed in the system but it may be outdated
#       - To find wich and where openssl is installed => which -a openssl
#       - brew upgrade openssl

BASHRELOAD

# RBENV PLUGINS
# =======================
# rbenv-gemset: for sandboxed collection of gems, for example for a specific project
# SEE: https://github.com/jf/rbenv-gemset
brew install rbenv-gemset



#  =========
#  = PYENV =
#  =========
# multiple versions of python
brew install pyenv

# Note: before the gloabl python was installed with:
# brew install python


# USAGE and INSTALLATION
# =======================
# pyenv install --list      # for the list of the available python version
pyenv install 2.7.10        # install a specific version
pyenv global 2.7.10         # set default global to be used in all shells by writing the version name to the ~/.pyenv/version file.
                            # This version can be overridden by an application-specific .python-version file, or by setting the PYENV_VERSION environment variable.
pyenv rehash                # to rebuild your shim files. Doing this on init makes sure everything is up to date
# pyenv versions            # list installed versions
# pyenv version             # current active version
# pyenv local 2.7.5         # set a python version for the current directory

# If everything is ok 'which python' should be /Users/myuser/.pyenv/shims/python NOT /bin/python
BASHRELOAD

# Update pip (for currently set gloabl)
# ======================================
pip install --upgrade pip
pip install --upgrade setuptools


# PYENV AND VIRTUALENVWRAPPER
# ===========================
pip install virtualenv virtualenvwrapper    # If virtualenvwrapper wont work just uninstall and reinstall virtualenv
brew install pyenv-virtualenvwrapper        # probably not needed


# Usage:
# ======
# For the GLOBAL selected python (that it could also be 'system' or the 'brew' btw):
#   mkvirtualenv env1 -p $(which python)
# Or:
#   mkvirtualenv env1       # should work also with -p

# To create a virtualenv with a SPECIFIC VERSION of python and virtualenvwrapper:
#   mkvirtualenv env2 -p $(which python3.4)
# Or:
#   mkvirtualenv -p /usr/local/bin/python3.2 my_env


# PYENV-VIRTUALENV
# ===========================
# A limitation of virtualenvwrapper is that it install its envs in ~/.virtualenvs
# Within each env the python bin is a link to the real python version isntalled with pyenv
# If you change your machine and leave behind all ypur pyenvs then your virtualenvs will be orphaned
#
# Using pyenv-virtualenv each venv is installed in its proper pyenv dir
# This is not a solution for the problem mentioned above but at least your virtualenvs are co-located with your
# pyenv which makes more sense to me.

brew install pyenv-virtualenv
# Then add this to your .bash_profile
# if [[ $ACTIVATE_PYENV == "true" && -n "$(which pyenv-virtualenv-init > /dev/null)" ]]; then
#     eval "$(pyenv virtualenv-init -)";
# fi
# USAGE:
# pyenv install 3.10.2
# pyenv virtualenv 3.10.2 my-venv
#
# pyenv virtualenvs
# pyenv activate my-venv
#
# .python-version file
# `pyenv local my-venv` or tab -> generates a `.python-version` file with `my-venv``
# Whenever I cd into a dir with this file my-venv is activated automatically
#
# pyenv deactivate




#  =======
#  = NVM =
#  =======
# https://github.com/creationix/nvm

# MANUAL INSTALLATION
# =======================
# Cause the installer write in my .bashrc and I don't want it
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
source ~/.nvm/nvm.sh        # this will be done by default from .bash_profile

# USAGE and INSTALLATION
# ======================
nvm install node            # install latest stable node
nvm alias default node      # set as default (to be used in any new shell)
# nvm use node              # use the just installed node

# To install a new version of Node.js and migrate npm packages from a previous version:
# nvm install node --reinstall-packages-from=node

# Activation by Project: https://github.com/creationix/nvm#nvmrc
#   Create a .nvmrc file in the root folder and just write the node version, ex: '5.9' or 'system'
#   Then when cd into the project folder, just run: `nvm use`

BASHRELOAD

# TODO: double check npm completions (it worked with brew)
# npm completion > $brew_dir/etc/bash_completion.d/npm


