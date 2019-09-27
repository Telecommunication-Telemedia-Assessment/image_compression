#!/bin/bash

if [[ ! -f ffmpeg-4.1.3-amd64-static/ffmpeg ]]; then
    echo "no local ffmpeg found, extract it"
    tar xf ffmpeg_4.1.3.tar.gz
fi

sudo apt install imagemagick