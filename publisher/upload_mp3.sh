#!/bin/bash

currdir=`dirname $0`
cd ${currdir}
echo "current dir=$currdir"

export LANG="en_US.UTF-8"
fname=`basename $1`

lftp="/usr/local/bin/lftp"
notif="/usr/local/bin/terminal-notifier"

episode=`echo $1 | sed -n 's/.*rt_podcast\(.*\)\.mp3/\1/p'`
image="../hugo/static/images/covers/cover.png"
${notif} -title PodPrc -message "Radio-T detected #${episode}"
utils/eyeD3.exec -v --remove-all --set-encoding=utf8 --album="Радио-Т" --add-image=${image}:FRONT_COVER: --artist="Umputun, Bobuk, Gray, Ksenks" --track=${episode} --title="Радио-Т ${episode}" --year=$(date +%Y)  --genre="Podcast" $1
${notif} -title PodPrc -message "Radio-T tagged"

cd ..

echo "upload to radio-t.com"
${notif} -title PodPrc -message "upload started"
scp $1 umputun@master.radio-t.com:/srv/master-node/var/media/${fname}

echo "remove old media files"
ssh master.radio-t.com "find /srv/master-node/var/media -type f -mtime +60 -mtime -1200 -exec rm -vf '{}' ';'"

echo "run ansible tasks"
ssh master.radio-t.com "docker exec -i ansible /srv/deploy_radiot.sh $episode"

echo "copy to hp-usrv archives"
${notif} -title PodPrc -message "copy to hp-usrv (local) archives"
scp -P 2222 $1 umputun@archives.umputun.com:/data/archive.rucast.net/radio-t/media/

echo "upload to archive site"
scp $1 umputun@master.radio-t.com:/data/archive/radio-t/media/${fname}

echo "all done for $fname"
${notif} -title PodPrc -message "all done for $fname"
