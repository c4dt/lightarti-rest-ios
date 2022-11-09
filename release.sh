#!/bin/bash
set -e

if [ ! -f semver ]; then
  wget -q https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver
  chmod a+x semver
fi

get_next(){
  local TAG_REST=$1
  local TAG_IOS=$2

  if [ "$( ./semver compare "$TAG_IOS" "$TAG_REST" )" = "-1" ]; then
    echo "$TAG_REST"
  else
    if [ -z "$( ./semver get prerel "$TAG_REST" )" ]; then
      ./semver bump patch "$TAG_IOS"
    else
      ./semver bump prerel "$TAG_REST"
    fi
  fi
}

get_next_tag(){
  local RELEASE=$1
  local TAG
  TAG=$( git tag | tail -n 1 )
  get_next "$( echo "$RELEASE" | jq -r '.tag_name' )" "${TAG:-0.1.0}"
}

# Check if the repo is committed
if [ -n "$( git status --porcelain )" ]; then
	echo "Please commit changes first"
	exit 1
fi

# Get latest release of lightarti rest and update the Package.swift with the
# hash and the url
RELEASE=$( curl -sL https://api.github.com/repos/c4dt/lightarti-rest/releases/latest )
XCFRAMEWORK_URL=$( echo "$RELEASE" | jq -r '.assets[].browser_download_url')
echo "URL is: $XCFRAMEWORK_URL"
CHK=$(curl -s -L "$XCFRAMEWORK_URL" | shasum -a 256 | cut -d' ' -f1)
echo "Checksum is: $CHK"

# Get the next tag
NEWTAG=$( get_next_tag "$RELEASE" )
echo "Tagging release with: $NEWTAG"

if [ "$1" = release ]; then
  sed -e "s=\(\\s*url: \).* \(// XCFramework URL.*\)=\1\"$XCFRAMEWORK_URL\", \2=;
       s=\(\\s*checksum: \).* \(// XCFramework checksum.*\)=\1\"$CHK\" \2=" \
       Package.swift > tmpfile && mv tmpfile Package.swift
  git commit -qam "Tagging $NEWTAG"
  git tag "$NEWTAG"
  echo "Please check everything is OK and then use"
  echo "git push --atomic origin main $NEWTAG"
else
  echo "Run release.sh with 'release' to commit changes"
fi

