# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).
#
# Store the file in ~/.pystartup, and set an environment variable to point
# to it:  "export PYTHONSTARTUP=/home/user/.pystartup" in bash.
#
# Note that PYTHONSTARTUP does *not* expand "~", so you have to put in the
# full path to your home directory.

import atexit
import os
import gnureadline
import rlcompleter

historyPath = os.path.expanduser("~/.dotfiles/data/pyhistory")

def save_history(historyPath=historyPath):
    import gnureadline
    gnureadline.write_history_file(historyPath)

if os.path.exists(historyPath):
    gnureadline.read_history_file(historyPath)

atexit.register(save_history)

# To use tab instead of ESC
# gnureadline.parse_and_bind('tab:complete')

# del os, atexit, gnureadline, rlcompleter, save_history, historyPath