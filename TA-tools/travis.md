```
sudo apt-get install ruby
sudo apt-get install ruby-dev
sudo gem install travis -v 1.8.10 --no-rdoc --no-ri
travis login --com # prompt for github username and password
```

#### Add GRADER_SSH to travis runners to dump to sfu machine

```
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/ass0-git-tutorial-*" --com | xargs -I % travis env set GRADER_SSH "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -r %
```

#### Trigger travis runners

```
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/ass0-git-tutorial-*" --com  | xargs -I % travis restart -r %
```

### Check travis build status

```
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/assignment-1-*" --com | parallel 'travisstate=`travis status -r {}`;echo {}.$travisstate' | grep failed
```

# End-to-End ass testing

```
python3.6 ./git_gud.py set_readonly -o=CMPT-431-SFU assignment-2-
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/assignment-2-*" --com
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/assignment-2-*" --com | xargs -I % travis env set GRADER_SSH "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -r %
travis repos --active --owner CMPT-431-SFU -m "CMPT-431-SFU/assignment-2-*" --com | xargs -I % travis restart -r %
python3.6 ./git_gud.py clone -o=CMPT-431-SFU assignment-2-
python3.6 ./git_gud.py moss -o=CMPT-431-SFU assignment-2-
mv Moss/ ass-2-moss
## MOSS
source ~/perl5/perlbrew/etc/bashrc
perl ./moss.pl -d ../TAScripts/ass-2-moss/*/*
```

ls ass-2 -moss/

## Mossum

```
cd html
python3 -m http.server
mossum -p 10 -l 30 http://0.0.0.0:8000/ # matches if > 10% and number of lines > 30
```

#### SFU Machine with travis logs

Add the following to .ssh/config

```
cp [IDENTITY_FILE] ~/.ssh/
# sshconfig
Host travis-log
HostName 199.60.17.67
IdentityFile [PATH to IDENTITY_FILE]
```

```
ssh travis-log
```

## Travis with path

```
travis repos --active --owner CMPT-295-SFU -m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" --com | xargs -I % travis env set GRADER_SSH "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -r %

travis repos - -active - -owner CMPT-295-SFU - m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" - -com | xargs - I % travis env set ASS_ROOT Example - r %

travis repos - -active - -owner CMPT-295-SFU - m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" - -com | xargs - I % travis restart - r %
```
