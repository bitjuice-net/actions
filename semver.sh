#!/bin/bash

version=$(git describe --abbrev=1 --tags)

if [[ $version =~ (v?)([0-9]+)\.([0-9]+)\.([0-9]+) ]]; 
then 
  prefix=${BASH_REMATCH[1]}
  major=${BASH_REMATCH[2]}
  minor=${BASH_REMATCH[3]}
  patch=${BASH_REMATCH[4]}
else 
  echo "Invalid tag $version"
fi

echo "Current tag: $version"

message=$(git log -n 1 HEAD --format=%B)

if [[ "$message" == *"#major"* ]]; then
  ((major++))
  minor=0
  patch=0
elif [[ "$message" == *"#minor"* ]]; then
  ((minor++))
  patch=0
else
  ((patch++))
fi

new_version="$prefix$major.$minor.$patch"

git tag $new_version

if [ $? -eq 0 ]; then
  echo "New tag: $new_version"
  echo "::set-output name=new_version::$new_version"
  exit 0
else
  echo "Cannot create new tag: $new_version"
  exit 1
fi

