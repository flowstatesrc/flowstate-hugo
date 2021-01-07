#!/bin/bash

set -e

git diff-index --quiet HEAD -- || { echo "uncomitted files in git repo"; exit 1; }

source ./build.sh
git add docs
git commit -m "build hugo site"
git push