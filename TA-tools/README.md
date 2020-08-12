# GIT GUD CLI Tool

## Usage

- Change key in config.py to the API key you got from Github
- Add owners in config.py if you want to use the set read_only functionality
- [Notes](#notes)

# Dependencies

Python 3.6+
pygithub

http://ubuntuhandbook.org/index.php/2017/07/install-python-3-6-1-in-ubuntu-16-04-lts/

```
 sudo apt install python3.6
 sudo add-apt-repository ppa:jonathonf/python-3.6
 sudo apt-get update
 sudo apt-get install python3.6
 curl https://bootstrap.pypa.io/get-pip.py | sudo -H python3.6
```

If you get apt-pkg error

```
 https://stackoverflow.com/questions/13708180/python-dev-installation-error-importerror-no-module-named-apt-pkg
```

# git token

Generate token on github and fill config.ini (see config.ini)

## Examples

\*\* The following examplpes assume the organization is SFU-CMPT-431 and assignment repos have the following prefix sfu431-ass0..

## Author

## Requirements

- A GitHub Personal Access Token
- Python3
- GitHub library for Python3

## Steps for TA

Type 1 assignment (no local run on cloud required)

1. Proceed to batch comments using a markdown document

Type 2 assignment (local run required)

1. Proceed to run-local
2. Inspect log files in each repo
3. Fill coursys scores.

## Features

- [GIT GUD CLI Tool](#git-gud-cli-tool)
  - [Usage](#usage)
- [Dependencies](#dependencies)
  - [Examples](#examples)
  - [Author](#author)
  - [Requirements](#requirements)
  - [Features](#features)
    - [Repository Search](#repository-search)
    - [Mass Clone](#mass-clone)
    - [Set Student Access Read Only](#set-student-access-read-only)
    - [Interactive PASS/FAIL grading without comment](#interactive-passfail-grading-without-comment)
    - [Interactive grading with comment](#interactive-grading-with-comment)
    - [Automatic grading using a Markdown document](#Batch comments using a Markdown document)
  - [Notes:](#notes)

### Repository Search (ls)

```
python3.6 ./git_gud.py ls -o=SFU-CMPT-431 sfu431-ass0-git-tutorial
```

- Fuzzy matching on repository names
- Ability to specify a GitHub organization if you have multiple assignments that are named the same, but in different organizations and you don’t want both
- Is very practical to use before cloning to make sure you do not clone repositories that should not be cloned

### Mass Clone (clone)

- Fuzzy matching on repository names
- Ability to specify a GitHub organization if you have multiple assignments that are named the same, but in different organizations and you don’t want both
- Clones all matching repositories into a directory matching the search string used when specifying which repositories to clone

```
python3.6 ./git_gud.py clone -o=CMPT-431-SFU ass0-git-tutorial
```

### Set Student Access Read Only or Write (set_readonly or set_write)

- This feature is from before the GitHub Classroom deadline feature
- Fuzzy matching on repository names
- Ability to specify a GitHub organization, which is required because it is only possible in those types of repositories

```bash
python3.6 ./git_gud.py set_readonly -o=CMPT-431-SFU ass0-git-tutorial
python3.6 ./git_gud.py set_write -o=CMPT-431-SFU ass0-git-tutorial
```

### Interactive PASS/FAIL grading without comment (push-pass-fail)

- Uses the local directory of previously mass cloned repositories
- It will go through all student repositories and prompt you for PASS or FAIL, with PASS being default
- After specifying whether the submission is PASSED or FAILED, it will automatically add, commit and push the grading file to remote (probably GitHub Classroom)

```bash
python3.7 ./git_gud.py ls -o=CMPT-431-SFU  ass0-git-tutorial-
python3.7 ./git_gud.py clone -o=CMPT-431-SFU  ass0-git-tutorial-
# Check travis files on travis log
# Create grading.md
python3.7 ./git_gud.py push-pass-fail -o=CMPT-431-SFU ass0-git-tutorial-
```

### Interactive comments (push-comment)

- Uses the local directory of previously mass cloned repositories
- It will go through all student repositories and prompt you for the feedback that should be provided, writing to the grading file until EOF is intered, allowing for multi-line feedback.
- After providing feedback to the student, it will automatically add, commit and push the grading file to remote (probably GitHub Classroom)

```bash
python3.7 ./git_gud.py ls -o=CMPT-431-SFU  ass0-git-tutorial-
python3.7 ./git_gud.py clone -o=CMPT-431-SFU  ass0-git-tutorial-
python3.7 ./git_gud.py push-comment -o=CMPT-431-SFU  ass0-git-tutorial-
```

### Batch comments using a Markdown document (push-grade-sheet)

- Uses the local directory of previously mass cloned repositories as well as your feedback to all students in a Markdown document
- It will parse the markdown file, matching students with their feedback, and then match it with the repositories in the directory.
- The matched feedback is added to the student repository, committed and pushed to remote (probably GitHub Classroom)

Comment file

```
 ### student-github-name
    - comments
    - more comments
    - comments can be any markdown (NO ### tags)
 ### Another student github-name
```

** STEP 1 : To generate a templated comment file AND FILL IT **

```
#  Copy files from SFU's mirror of travis log files
# scp -r travis-log@~/CS431/ASS0 .
python3 log2gradingtemplate.py ./ASS0 ass0-git-tutorial- Students-Spring-2020.csv
# First parameter . Relative path to current directory assignment log files copied from travis-log
# Second parameter - prefix used to name the assignment in github. Student repos will be of type prefix+githubid. The "-" at the end of the prefix is important
Student CSV file from Github reponse sheet.
```

This will create two files: PASS.md and FAIL.md. PASS.md contains template for all students that passed. FAIL.md is the template for all students that failed Fill these as you read the log files.

** STEP 2 : PUSH GRADING SHEETS INTO REPO (Fill coursys json entry as you do this) **

```
python3.7 ./git_gud.py ls -o=CMPT-431-SFU ass0-git-tutorial-
python3.7 ./git_gud.py clone -o=CMPT-431-SFU ass0-git-tutorial-
# For Pass.md. Fill comments in Pass.md. Every entry is student who passed. Includes both SFUID and GITHUB ID. Use SFU ID to access report from coursys. Assign scores for code and report.
# This will push GRADING.md
python3.7 ./git_gud.py push-grade-sheet -o=CMPT-431-SFU ass0-git-tutorial-
# Fill comments in faild.md. Includes both SFUID and GITHUB ID. Use GITHUB ID to access log file in $ASS/FAIL. Use SFU ID to access report from coursys. Assign scores for code and report.
mv FAIL.md GRADING.md
python3.7 ./git_gud.py push-grade-sheet -o=CMPT-431-SFU ass0-git-tutorial-
```

### Set up Moss (moss)

- Uses the local directory of previously mass cloned repositories
- It will go through all student repositories and pick up files specified in
  MOSS_FILES in config.ini (e.g., MOSS_FILES = overview.txt,PASS)
  
  ```
  python3.6 ./git_gud.py clone -o=CMPT-431-SFU assignment-1-
  python3.6 ./git_gud.py moss -o=CMPT-431-SFU assignment-1-
  # Follow directions in moss repo.
  ```

### run-local (requires scipts/run.sh in the repository)

- Uses the local directory of previously mass cloned repositories
- It will go through all student repositories and invoke scripts/run.sh using the repository as the current working directory
- generates a repo-name.success.log or repo-name.fail.log

**_ Dependencies ( repo/scripts/run.sh has to exist) _**

```bash
python3.7 ./git_gud.py clone -o=CMPT-431-SFU AssX-Graph- # all repos AssX-Graph*
python3.7 ./git_gud.py run -o=CMPT-431-SFU AssX-Graph- # Assumes AssX-Graph/ folder exists with repos in it
python3.7 ./git_gud.py add-commit-push -o=CMPT-431-SFU AssX-Graph- #  Pushes everything in that repo
python3.7 ./git_gud.py add-commit-push -o=CMPT-431-SFU AssX-Graph-
```

Each repo/ under AssX-Graph- will contain either a repo.log.success or repo.log.failed.files.
Lookover these files and then fill scores for coursys.

### add-commit-push

- Uses the local directory of previously mass cloned repositories
- Typically used after a run when logs have been generated

e.g., see above

## Update from template or fork

- Uses the local directory of previously mass cloned repositories
- Updates these repos with changes from PARENT_REPO

```
PARENT_REPO="[The release repo)]" python3.6 ./git_gud.py update-from-fork -o=CMPT-431-SFU ass0-git-tutorial
PARENT_REPO="[The release repo (has to be a template)]" python3.6 ./git_gud.py update-from-template -o=CMPT-431-SFU ass0-git-tutorial
```

## Notes:

- If a student has not been graded in the Markdown document, you will simply be notified that the student has not been provided any feedback in the Markdown document, and if you have graded students that are not cloned, their feedback will simply be ignored.
- The only rule for writing the feedback document is that heading the feedback for student “John Doe”, you must write the username of the student like so: “### JohnDoe” (assuming John Doe uses JohnDoe as is GitHub username).

---

# Git Student Tracker

## Dependencies

Student list from google form.

```
python3 git_student_tracker.py track-commits -o=CMPT-431-SFU assignment-1- Students-Spring-2020.csv
```

## Original Tool

**_ Derived Nikolai Magnussen _**
