#!/usr/bin/env bash
set -euo pipefail

# Script modified from "https://gist.github.com/rachelss/f0cfb28b5cf290f5ab32"
# Major modification is to use URL that is part of twitter info

WORK_DIR=~/'Pictures/natgeo'
echo "Working directory: ${WORK_DIR}"
echo
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
mkdir -p temp pictures

# Save the site
PAGE_URL="https://www.nationalgeographic.com/photography/photo-of-the-day/"
SITE='temp/page.html'
curl -L $PAGE_URL -o $SITE

# Parsing HTML like this is a sin.
# If it's no longer tagged with "canonical," script will break
IMG_URL=$(grep -o "twitter:image:src.*" $SITE | grep -o 'https.*' | sed -e 's/.*https\(.*\)jpg.*/https\1jpg/')
echo "*** URL for pic of the day:  $IMG_URL ***"
echo

# TITLE=$(grep "twitter:title" ${INITIAL_SITE} | sed -n -e 's/^.*content="//p' | sed -n -e 's/National Geographic.*//p')
# echo "*** Photo title:  ${TITLE} ***"

DATE=$(date +%Y-%m-%d)
# IMG_F="$(PWD)/pictures/${DATE}[${TITLE}].jpg"
IMG_F="$(PWD)/pictures/${DATE}.jpg"
curl $IMG_URL -o "${IMG_F}"
echo "*** Photo saved as:  ${IMG_F} ***"

osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${IMG_F}\""

# open the page in browser
open $PAGE_URL

echo "DONE"
