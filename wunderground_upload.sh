#!/usr/bin/env bash
# HOST= 
# USER=
# PASSWD=
# FILE=
# Load the above variables from the config.sh file, instead of hard coded here
cd "$(dirname "$0")";

source config.sh

# need to have wget installed
# OSX: brew install wget
# OSX: brew install lftp
# Other flavs: sudo apt-get install wget lftp

FILEDT="`date '+%Y%m%d%H%M%S'`" 

# same as image.jpg, as that is what wunderground needs
wget -O image.jpg $CAM_URL

FILENEW="${IMAGEPREFIX}_${FILEDT}.jpg"
echo $FILENEW

# lftp -c "open -u $USER,$PASSWD $HOST; put -O / image.jpg"
lftp -c "open -u $WG_USER,$WG_PASSWD $WG_HOST; put image.jpg"

# rename file to dated
mv image.jpg $FILENEW

# add file to tar for the day
tar -rf $DATED_FILENAME $FILENEW

# reap yesterdays files, but keep todays as we use them for timelapse offline sometimes
# YEST_FILENAME=${IMAGEPREFIX}_$(date -v-1d '+%Y%m%d')*.jpg
# echo "Removing images from yesterday: rm -f " ${YEST_FILENAME}
# rm -f ${YEST_FILENAME}

# remove the image we just uploaded
rm -f $FILENEW

curl -d "stat=wundercam_upload&email=${STATHAT_KEY}&value=1" http://api.stathat.com/ez

exit 0