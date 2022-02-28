#!/bin/bash

current_tag=$(git describe --abbrev=0 --tags)
message=$(git log -n 1 HEAD --format=%B)
suffix=$(git rev-parse --short HEAD)

if [[ $current_tag =~ ^(v?)([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; 
then 
  prefix=${BASH_REMATCH[1]}
  major=${BASH_REMATCH[2]}
  minor=${BASH_REMATCH[3]}
  patch=${BASH_REMATCH[4]}
else 
  echo "Invalid tag: $current_tag"
fi

current_version="$major.$minor.$patch"

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

new_version="$major.$minor.$patch"

if [[ $INPUT_PRE_RELEASE == "true" ]]; then
  new_tag="$prefix$new_version-$suffix"
else
  new_tag="$prefix$new_version"
fi

git tag $new_tag

if [ $? -eq 0 ]; then
  echo "Current tag: $current_tag"
  echo "New tag: $new_tag"
  echo "::set-output name=tag::$current_tag"
  echo "::set-output name=version::$current_version"
  echo "::set-output name=new_tag::$new_tag"
  echo "::set-output name=new_version::$new_version"
  exit 0
else
  echo "Cannot create new tag: $new_tag"
  exit 1
fi

