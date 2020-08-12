#!/usr//bin/python3
#
# driver.py - The driver tests the correctness
import glob
import json
import shutil
import argparse
import os
import re
import subprocess
import sys
import github2sfuid.github2sfuid as gs
#
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


contents = []

parser = argparse.ArgumentParser()

parser.add_argument("-C", dest="sfuid",
                    help="CSV file containing map from github id to sfuid", required=True)


parser.add_argument("-D", dest="output",
                    help="Folder with Json Grades", required=True)

opts = parser.parse_args()
json_folder = opts.output
id_file = opts.sfuid
gs.fillmap(id_file)


file_list = glob.glob(os.path.join(json_folder, '*.json'))
for file in file_list:
    with open(file, 'r') as fi:
        gradedict = json.load(fi)
        githubid = gradedict["userid"].replace("GithubID:", "")
        print("Processing git :"+re.sub('assignment-\d*-*', '', githubid))
        sfuid = gs.getsfuid(re.sub('assignment-\d*-*', '', githubid))
        if sfuid is not None:
            gradedict["userid"] = sfuid
        else:
            print(bcolors.WARNING + gradedict["userid"] + " not found. Coursys will ignore entry" + bcolors.ENDC, file=sys.stderr)

        contents.append(gradedict)

marks = {}
marks["marks"] = contents
marks_json = json.dumps(marks)
print(marks_json)


# travis repos --active --owner CMPT-295-SFU -m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" --com | xargs -I % travis env set GRADER_SSH "https://drive.google.com/uc?export=download&id=162VYNkMEBuKrc7GqEnToDpJMhUjOedBR" -r %

# travis repos - -active - -owner CMPT-295-SFU - m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" - -com | xargs - I % travis env set ASS_ROOT Example - r %

# travis repos - -active - -owner CMPT-295-SFU - m "CMPT-295-SFU/Ass-RISCV-Emu*Solution*" - -com | xargs - I % travis restart - r %
