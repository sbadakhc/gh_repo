gh_repo
=======

GitHub forked repository management script.

This script is used to syncronise forked GitHub repositories with their upsteam counterparts.  It makes sure your GitHub
forks are aligned with the upstream repositories you are following.  The script also provides options to build and deploy
application for use with Maven Java builds.


Installation Prerequisites
---------------------------

gh_repo has been successfully installed and tested on Fedora 18.  It should run on any *NIX running BASH.

Installation Instructions
------------------------

1.  Checkout the contents of the gh_repo git repository to your workspace.
2.  Copy the gh_repo.sh script to your workspace directory.
3.  Edit the environment varibles with your repo names and GitHub user details.
4.  Execute the script with the "scratch" argument when running for the first time

Configuration Notes
-------------------

The key environemnt varibles that need to be passed are $REPO and $MAINTAINER respectively.  The build option can also be
configured as required to allow for extra build time Maven options.

Known Issues
------------

Fixed (140913) - Currently the script makes use of the $USER environment varibles which makes the assumption that the *NIX user is the same
as the GitHub user.
