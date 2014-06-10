gh_repo
=======

GitHub forked repository management script.

This script is used to syncronise forked GitHub repositories with their upsteam counterparts.  It makes sure your GitHub
forks are aligned with the upstream repositories you are following.

Installation Prerequisites
---------------------------

gh_repo has been successfully installed and tested on Fedora 18.  It should run on any *NIX running BASH.

Installation Instructions
------------------------

1.  Checkout the contents of the gh_repo git repository to your workspace.
```
cd ~/workspace
git clone https://github.com/sbadakhc/gh_repo.git
```
2.  Copy the gh_repo.sh script to your workspace directory.
```
cp gh_repo/rh_repo.sh .
```
3.  Edit the environment varibles with your repo names and GitHub user details and rename the script to match your maintainer.
```
mv gh_repo.sh JohnDoe-repos
```
4.  Execute the script with the "scratch" argument when running for the first time
```
./JohnDoe-repos
```

Configuration Notes
-------------------

The key environment varibles that need to be passed are $REPOS and $MAINTAINER respectively.  The build option can also be
configured as required to allow for extra build time Maven options.

Known Issues
------------

https://github.com/sbadakhc/gh_repo/issues
