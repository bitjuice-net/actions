#!/bin/bash

old_tag=$(git describe --abbrev=1 --tags)

if [[ $old_tag =~ (v?)([0-9]+)\.([0-9]+)\.([0-9]+) ]]; 
then 
  prefix=${BASH_REMATCH[1]}
  major=${BASH_REMATCH[2]}
  minor=${BASH_REMATCH[3]}
  patch=${BASH_REMATCH[4]}
else 
  echo "Invalid tag $old_tag"
fi

old_version="$major.$minor.$patch"

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

new_tag="$prefix$major.$minor.$patch"
new_version="$major.$minor.$patch"

git tag $new_tag

if [ $? -eq 0 ]; then
  echo "Current tag: $old_tag"
  echo "New tag: $new_tag"
  echo "::set-output name=old_tag::$old_tag"
  echo "::set-output name=old_version::$old_version"
  echo "::set-output name=new_tag::$new_tag"
  echo "::set-output name=new_version::$new_version"
  exit 0
else
  echo "Cannot create new tag: $new_tag"
  exit 1
fi

