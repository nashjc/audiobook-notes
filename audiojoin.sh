#!/bin/bash
echo "concatenat files from $1"
echo "  to $2"
read -p "Continue?" tmp
mkdir tmpdir
for f in *.m4b; do
ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 tmpdir/"${f%.m4b}.mp3"
done
cat $1 | while read line
do
  echo "file $line" >>t.t
done
read -p "Continue?" tmp
ffmpeg -f concat -i t.t -c copy $2
echo "done!"
