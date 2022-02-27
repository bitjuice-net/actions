#!/bin/bash

version=$(git describe --abbrev=1 --tags)

v=( ${version//./ } )
if [ ${#v[@]} -ne 3 ]
then
  echo "Invalid tag $version"
  exit 1
fi

message=$(git log -n 1 HEAD --format=%B)

if [[ "$message" == *"#major"* ]]; then
  ((v[0]++))
  v[1]=0
  v[2]=0
elif [[ "$message" == *"#minor"* ]]; then
  ((v[1]++))
  v[2]=0
else
  ((v[2]++))
fi

new_version="${v[0]}.${v[1]}.${v[2]}"

git tag $new_version

if [ $? -eq 0 ]; then
  echo "New tag: ${v[0]}.${v[1]}.${v[2]} (previous was $version)"
  echo "::set-output name=new_version::$new_version"
  exit 0
else
  echo "Cannot create new tag"
  exit 1
fi

