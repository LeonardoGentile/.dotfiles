Multiple SSH Keys settings for different github account
=================================================================


create different public key
---------------------------------

create ssh key according the article [Set-Up Git](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

    $ ssh-keygen -t ed25519 -C "your_email@example.com"
	$ ssh-keygen -t ed25519 -C "work@email.com" -f ~/.ssh/id_ed25519_work
  
  *** -f filename ***

Please refer to [github ssh issues](http://help.github.com/ssh-issues/) for common problems.

for example, 2 keys created at:

	~/.ssh/id_ed25519
	~/.ssh/id_ed25519_work

then, add these two keys as following

	$ ssh-add ~/.ssh/id_ed25519
	$ ssh-add ~/.ssh/id_ed25519_work

you can delete all cached keys before

	$ ssh-add -D

finally, you can check your saved keys

	$ ssh-add -l
  
Add ssh to Github
---------------------------------

Reference: FYI [Adding a new SSH key to your GitHub account](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account)

Modify the ssh config
---------------------------------

	$ cd ~/.ssh/
	$ touch config
	$ vi config

* create `config` if not existed

Then added

```
# Personal account
Host github.com
        HostName github.com
        User git
        PreferredAuthentications publickey
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_rsa
# Work account
Host work.github.com
        HostName github.com
        User git
        PreferredAuthentications publickey
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_rsa_work
````

Testing SSH both
---------------------------------

	$ ssh -T git@github.com
	$ ssh -T git@work.github.com

Clone you repo and modify your Git config
---------------------------------------------

Uses **standard** SSH key
`git clone git@github.com:rails/rails.git`

Uses **work** SSH key
`git clone git@work.github.com:rails/rails.git`

cd rails and modify git config(for display author with work email)
 
	$ git config user.name "work"
	$ git config user.email "work@email.com" 

then use normal flow to push your code

	$ git add .
	$ git commit -m "your comments"
	$ git push

Bonus
---------------------------------------------

Setting `./gitconfig`

`vi ~/.gitconfig`

Add this block to bottom line

```
[includeIf "gitdir:~/work/"]
  [user]
    name = "work"
    email = work@email.com"
  [core]
    sshCommand = "ssh -i ~/.ssh/id_rsa_work"
```

To select git work account we have clone repo under `~/work` directory.

That's it! :tada:
