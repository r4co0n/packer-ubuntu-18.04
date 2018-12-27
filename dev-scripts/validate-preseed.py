#!/usr/bin/env python3
"""
Validate a preseed file using debconf-set-selections.

Note that this does not check whether the key you are setting will
actually do anything anywhere, it only tests syntactic validity of the
debconf selections you have set in the preseed file.
"""

import subprocess
import argparse
import os
import sys

ignored_lines = [
  """debconf: DbDriver "passwords" warning: could not open /var/cache/debconf/passwords.dat: Permission denied""",
]

preseed_file = "http/preseed.cfg"
# Project root, relative to this file's location
project_root = "../"

check_command = [
    "debconf-set-selections",
    "--checkonly",
    preseed_file
]

def check_preseed_file(preseed_file, ignore_lines=True):
  
  print("==> Validating {preseed_file} ...".format( preseed_file = preseed_file ))

  # Change into project root directory
  owd = os.getcwd()
  os.chdir(
    "{scriptdir}/{project_root}".format(
      scriptdir = os.path.dirname( __file__ ),
      project_root = project_root
    )
  )

  # Run check command
  check_process = subprocess.run(
    check_command,
    capture_output = True,
    text = True
  )

  bad_lines = False
  if ignore_lines:
    # Check if output contains lines not in ignored_lines and print them
    for line in check_process.stderr.split(os.linesep):
      if line.strip() and line not in ignored_lines:
        bad_lines = True
        print(line)
  else:
    if check_process.stdout:
      bad_lines = True

  return not bad_lines

def _get_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('--preseed-file', default=preseed_file, help="The location of the preseed file, relative to this project's root")
  parser.add_argument('--no-ignored-lines', default=False, help="Don't ignore any check output")

  return parser.parse_args()

def main():
  args = _get_args()
  if not check_preseed_file(args.preseed_file, not args.no_ignored_lines):
    print("[ FAIL ]")
    sys.exit(1)
  print("[ SUCCESS ]")

if __name__ == '__main__':
  main()
