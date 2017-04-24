# CheckSplunk.py
Meant to assist in completing initial splunk validations in new or existing environments based on puppet yaml, and the splunk puppetfile module

### Prerequesites

* Need to pip install gitpython
* Need to be on python version 2.7.13 (what I developed this in, not that it won't work in others)
* Must have a viper_puppet and viper_puppetfile repo cloned, and recent (this project will ensure it is recent, but it must be cloned first)
* Must have access to the hosts provided

Usage
------------------------------------

```
usage: checkSplunk.py [-h] -k PUPPET -p PUPPETFILE [-l LIST] [-n NODE]
                      [-m MEAT] -e ENVIRONMENT [-v] [-t]

Splunk validations for new and existing environments

optional arguments:
  -h, --help            show this help message and exit
  -k PUPPET, --puppet PUPPET
                        Pointer to environment yaml in local viper-puppet git
                        repo
  -p PUPPETFILE, --puppetfile PUPPETFILE
                        Pointer to puppetfile repo
  -l LIST, --list LIST  Pointer to file with list of hosts
  -n NODE, --node NODE  Check a single node
  -m MEAT, --meat MEAT  Supply list of arguments for a meat query for a list
                        of hosts to validate. ie: filter=ashb.*cmcsa.*vex
                        omit=burp
  -e ENVIRONMENT, --environment ENVIRONMENT
                        Name of environment as it is shown in viper-puppet
                        yaml
  -v, --verbose         Include some kind of verbosity to the output
  -t, --test            Only print out hosts in a meat query. Only should be
                        used with -m --meat options, otherwise this does
                        nothing
```                        

### NOTE
The way I'm currently checking the puppetfile is via a static commit variable defined in the code that should match the one in puppetfile.  If this ever changes in the environment we check, it needs to be changed here for accuracy.  If it ever changes to a tag, the check will need to be modified.  
