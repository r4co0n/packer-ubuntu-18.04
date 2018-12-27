#!/usr/bin/env sh

echo "Running pre-commit hook"

have_errors = 0

./dev-scripts/validate-preseed.py
if [ $? -ne 0 ]; then
  echo "Preseed file validation must pass before commit."
  have_errors = 1
fi

./dev-scripts/validate-packer-template.sh
if [ $? -ne 0 ]; then
  echo "Packer template validation must pass before commit."
  have_errors = 1
fi

exit $have_errors
