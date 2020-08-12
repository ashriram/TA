#!/bin/bash
yellow="\e[33m"
NC='\033[0m' # No Color

PYTHON=python3.6
echo -e "Organization (github org e.g., CMPT-295-SFU): $yellow$ORG$NC"
echo -e "ASS (github prefix e.g., assignment-1): $yellow$ASS$NC"
echo -e "ASS_ROOT (where logs will be stored locally e.g., ASS1): $yellow$ASS_ROOT$NC"
echo -e "TA_Tools (absolute path to TA tools): $yellow$TA_TOOLS$NC"

verify="NO"

echo "Are you sure the above pararameters are correct? (YES/NO):"  
read verify

if [ verify != "YES" ]; then
    echo "Update parameters and restart script"
    return
fi

## Setting repos to be read-only
cd $TA_TOOLS
echo -e "$yellow Setting repos to read-only $NC"
$PYTHON ./git_gud.py set_readonly -o=$ORG $ASS

## Setting up ssh for travis-log machine
wget "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -O ~/.ssh/travislog_rsa
chmod 600 ~/.ssh/travislog_rsa
ssh root@199.60.17.67 -i ~/.ssh/travislog_rsa "rm -rf $ASS_ROOT/PASS/*
&& rm -rf $ASS_ROOT/FAIL/* && ls $ASS_ROOT/PASS && ls $ASS_ROOT/FAIL"
cd ~/.ssh/


# Set GRADER_SSH (enables travis machines to connect to 199.60.17.67)
echo -e "$yellow Set up travis environment variables $NC"

echo -e "$yellow GRADER_SSH $NC"
travis repos --active --owner $ORG -m $ORG/$ASS"*" --com | xargs -I % travis env set GRADER_SSH "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -r %

# Set assignment root folder to gradebox
echo -e "$yellow ASS_ROOT $NC"
travis repos --active --owner $ORG -m $ORG/$ASS"*" --com | xargs -I % travis env set ASS_ROOT $ASS_ROOT -r %


# If password needs to be set. Required only for assignment 4
if [ ASS_PASSWORD == "" ]; then
    travis repos --active --owner $ORG -m $ORG/$ASS"*" --com | xargs -I % travis env set PASSWORD "c@che1ab" -r %
fi

# Restart graders.
travis repos --active --owner $ORG -m $ORG/$ASS"*" --com | xargs -I % travis restart -r %