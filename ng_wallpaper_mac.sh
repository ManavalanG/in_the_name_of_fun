#!/usr/bin/env bash
 
# Script modified from "https://gist.github.com/rachelss/f0cfb28b5cf290f5ab32"
# Major modification is to use URL that is part of twitter info

WORK_DIR=~/'Pictures/natgeo'
echo "Working directory: ${WORK_DIR}"
echo
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
mkdir -p temp pictures

# Find Site to redirect to.
INITIAL_SITE='temp/initial_site.html'
curl "https://www.nationalgeographic.com/photography/photo-of-the-day/"  -o ${INITIAL_SITE}


# Parsing HTML like this is a sin.
# If it's no longer tagged with "canonical," script will break
IMG_HTML=`grep "canonical" ${INITIAL_SITE} | sed -e "s/.*href=\"//" -e "s/\".*//"`
echo "*** Redirect to:  $IMG_HTML ***"
echo

REDIRECTED_SITE="temp/redirected_site.html"
curl $IMG_HTML -o ${REDIRECTED_SITE}
open $IMG_HTML

# Another hacky bit that will fail when Nat Geo changes their image naming conventions
IMG_URL=`grep "twitter:image:src" ${REDIRECTED_SITE}  | grep -o 'http.*' | sed 's/..$//'`
echo "*** URL for pic of the day:  $IMG_URL ***"
echo

TITLE=`grep "twitter:title" ${REDIRECTED_SITE}  | sed -n -e 's/^.*content="//p' | sed -n -e 's/National Geographic.*//p'`
echo "*** Photo title:  ${TITLE} ***"

DATE=`date +%Y-%m-%d`
IMG_F="$(PWD)/pictures/${DATE}[${TITLE}].jpg"
curl $IMG_URL -o "${IMG_F}"
echo "*** Photo saved as:  ${IMG_F} ***"


sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '${IMG_F}'";
killall Dock;

echo "DONE"