#!/bin/bash
#
# convm4b
mkdir newfiles
for f in *.m4b; do ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 newfiles/"${f%.m4b}.mp3"; done

