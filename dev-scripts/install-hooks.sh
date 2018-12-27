#!/usr/bin/env sh

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-commit script
ln -s ../../dev-scripts/pre-commit.sh $GIT_DIR/hooks/pre-commit
echo "Done!"
