#!/usr/bin/env sh

# if any command inside script returns error, exit and return that error 
set -e

# magic line to ensure that we're always inside the root of our application,
# no matter from which directory we'll run script
# thanks to it we can just enter `./scripts/run-tests.bash`
cd "${0%/*}/.."

echo -n "==> Validating Packer template ubuntu.json ... "
packer validate ubuntu.json
if [ $? -ne 0 ]; then
  echo "[ FAIL ]"
  exit 1
fi

echo "[ SUCCESS ]"
exit 0
