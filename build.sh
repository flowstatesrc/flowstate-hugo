#!/bin/bash

set -e

rm -rf ./docs
hugo -s ./hugo
echo "flowstate.dev" > ./docs/CNAME
