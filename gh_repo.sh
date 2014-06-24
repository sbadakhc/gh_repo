#!/bin/bash
#
# Simple script to manage Github forked repositories
#
# Notes on usage targets:
#
# clone   : a regular git clone of the upstream repo
# sync    : syncs a forked repo with upstream repo
# scratch : removes the local maven repo and executes sync target 
# info    : provides repo information for trouble-shooting
# size    : provides repo obejct size information
#
# Notes on workflow:
#
# Copy this script into your desired workspace and execute from there with 
# the clone target to retrive the required repos.  The "scratch" target 
# should be executed when running the script for the first time.  It should
# be sufficient to run the "sync" target afterwards.  The "info" and "size"
# targets are useful for verfication and trouble-shooting.
#
# Warning: 
#
# Running a "scratch" build will delete your local maven repo along with any 
# other nominated repos defined in the $REPO varible so use with care!!!
 
# Environment varibles
REPOS="SomeRepo1 SomeRepo2 SomeRepo3"
UPSTREAM=$(git config -l | grep upstream)
PWD=`pwd`
WORKSPACE=${WORKSPACE:=$HOME/workspace}
USER=$USER # Define GitHub username here.
MAINTAINER=${MAINTAINER:=SomeMaintainer}

# Debugging (comment out if not required)
set -x

# Usage targets
if [ $# -lt 1 ]
then
        echo "Usage : $0 {clone|sync|scratch|info|size}"
        exit
fi

case "$1" in

clone) echo "Cloning repos"
    for repo in ${REPOS}; do 
        git clone https://github.com/${MAINTAINER}/${repo}.git
        cd ${repo}
        git remote set-url origin https://github.com/${USER}/${repo}.git
        git remote add upstream https://github.com/${USER}/${repo}.git
        cd -
    done
    ;;
sync)  echo "Syncing repos"

function sync {
    cd ${repo}
    TAG=$(git describe --abbrev=0 --tags)
    git fetch upstream
    git checkout master
    git merge upstream/master
    git push -f origin master --tags
    cd -
    echo
}   

# Update repos
for repo in ${REPOS}
    do
    if [ -d ${repo} ]; then
        echo -e "Updating ${repo}"
        cd ${repo}
        git config credential.helper store
        git pull
        cd -
        echo
    else
        echo -e "Cloning ${repo}"
        git clone https://github.com/$USER/$repo.git
    fi 
done

# Sync with upstream
    echo -e "Syncronising ${repo}"
    UPSTREAM=`git config -l | grep upstream`
    if [ -z "${UPSTREAM}" ]; then
        echo "Initialising Upstream"
        git remote add upstream https://github.com/${MAINTAINER}/${repo}.git
        sync
    else
        sync
    fi
    ;;
scratch) echo  "Deploying from scratch"
        set -x
    for repo in ${REPOS}
        do rm -rf ${WORKSPACE}/$repo
    done

    rm -rf ~/.m2
    $0 sync
   ;;
info) echo "Retrieving repo info"
    for repo in ${REPOS}; do
        echo -e "Repo info for ${repo}"
        cd ${repo}
        git remote -v
        git branch
        git describe --abbrev=0 --tags
        git rev-parse HEAD
        cd -
    done
;; 
size) echo -e "Retrieving repo size"
    for repo in ${REPOS}; do
        echo -e "Repo size for ${repo}"
        cd ${repo}
        OBJECTS=$(git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head)
        IFS=$'\n';
        OUTPUT="SIZE,PACK,REV,LOCATION"
            for obj in $OBJECTS; do
                # Get the size in bytes
                SIZE=$((`echo $obj | cut -f 5 -d ' '`/1024))
                COMPSIZE=$((`echo $obj | cut -f 6 -d ' '`/1024))
                # Get the revision
                REV=$(echo $obj | cut -f 1 -d ' ')
                LIST=$(git rev-list --all --objects | grep $REV)
                OUTPUT="${OUTPUT}\n${SIZE},${COMPSIZE},${LIST}"
            done
    cd -
    done
    echo -e $OUTPUT | column -t -s ', '
;;
*) echo "Usage : $0 {clone|sync|scratch|info}"
   ;;
esac
