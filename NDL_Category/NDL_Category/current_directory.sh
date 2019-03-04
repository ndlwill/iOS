#!/bin/sh

echo "==============="
echo "$PWD"
commit="git rev-parse --short HEAD"
branch="git rev-parse --abbrev-ref HEAD"
echo "$commit\n$branch"
echo "==============="