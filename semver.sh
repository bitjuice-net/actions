#!/bin/bash
set -u

cd "${GITHUB_WORKSPACE}" || exit

git config --global --add safe.directory "${GITHUB_WORKSPACE}"

git fetch --all --tags

current_tag="$(git describe --abbrev=0 --tags)"
message="$(git log -n 1 HEAD --format=%B)"
suffix="$(git rev-parse --short HEAD)"

echo "Current tag: $current_tag"

if [[ $current_tag =~ ^(v?)([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; 
then 
  prefix=${BASH_REMATCH[1]}
  major=${BASH_REMATCH[2]}
  minor=${BASH_REMATCH[3]}
  patch=${BASH_REMATCH[4]}
else 
  echo "Invalid tag: $current_tag"
  exit 1
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

if [[ ${INPUT_PRE_RELEASE} == "true" ]]; then
  new_tag="$prefix$new_version-$suffix"
else
  new_tag="$prefix$new_version"
fi

echo "New tag: $new_tag"

git tag "$new_tag"

if [ $? -eq 0 ]; then
  echo "New tag created"
  echo "tag=$current_tag" >> $GITHUB_OUTPUT
  echo "version=$current_version" >> $GITHUB_OUTPUT
  echo "new_tag=$new_tag" >> $GITHUB_OUTPUT
  echo "new_version=$new_version" >> $GITHUB_OUTPUT
  exit 0
else
  echo "Cannot create new tag"
  exit 10
fi