#!/bin/sh
# WARNING: this rewrite the git history
# Instruction here: https://help.github.com/articles/changing-author-info/

git filter-branch --env-filter '
OLD_EMAIL="wrong@old.mail.com"
CORRECT_NAME="Your Correct Name Here"
CORRECT_EMAIL="your@mail.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags