#!/bin/bash

set -e

rm -rf ./docs
hugo -s ./hugo
echo "logjson.com" > ./docs/CNAME