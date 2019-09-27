#!/bin/bash



ffmpeg() {
    ffmpeg-4.1.3-amd64-static/ffmpeg -hide_banner -loglevel panic $@
}

# $1 = distored image, $2 = reference image, $3 subfolder for report
vmaf() {
    mkdir -p vmaf/"$3"
    extt=${1##*.}
    bnn=$(basename $1 .$extt)
    ffmpeg -i "$1" -i "$2" -lavfi libvmaf="psnr=1:log_fmt=json:model_path=$(pwd)/ffmpeg-4.1.3-amd64-static/model/vmaf_4k_v0.6.1.pkl:log_path=vmaf/$3/$bnn.json:ssim=1" -f null -
}

mkdir -p ref


ext=${1##*.}
bn=$(basename $1 .$ext)

check=$(cat imgs_done | grep "$bn" | wc -l)
if [[ "$check" != "0" ]]; then
    echo "$bn image was already processed"
    exit 0
fi

# convert raw image to a "video" consisting of 1 frame
ffmpeg -y -r 1 -start_number 0  -i "$1" \
    -c:v ffvhuff -r 1 -vframes 1 \
    -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" ref/"$bn".mkv

ref=ref/"$bn".mkv

av1_encoding() {
    for ((crf=0;crf<=63;crf++)); do
        dis="av1/$bn"_av1_"$crf.mkv"
        ffmpeg -y -i "$ref" -strict -2 \
            -c:v libaom-av1 \
            -crf "$crf" -b:v 0 \
            -cpu-used 1 \
            "$dis"

        vmaf "$dis" "$ref" "av1"
    done
}

h265_encoding() {
    for ((crf=0;crf<=51;crf++)); do
        dis="h265/$bn"_h265_"$crf.mkv"
        ffmpeg -y -i "$ref" -strict -2 \
            -c:v libx265 \
            -crf "$crf" \
            -preset veryslow \
            "$dis"

        vmaf "$dis" "$ref" "h265"
    done
}

h264_encoding() {
    for ((crf=0;crf<=51;crf++)); do
        dis="h264/$bn"_h264_"$crf.mkv"
        ffmpeg -y -i "$ref" -strict -2 \
            -c:v libx264 \
            -crf "$crf" \
            -preset veryslow \
            "$dis"

        vmaf "$dis" "$ref" "h264"
    done
}

vp9_encoding() {
    for ((crf=0;crf<=63;crf++)); do
        dis="vp9/$bn"_vp9_"$crf.mkv"
        ffmpeg -y -i "$ref" -strict -2 \
            -c:v libvpx-vp9 \
            -crf "$crf" -b:v 0 \
            -cpu-used 1 \
            "$dis"

        vmaf "$dis" "$ref" "vp9"
    done
}


jpg_encoding() {
    mkdir -p png_ref
    mkdir -p jpg_mkv
    ffmpeg -y -i "$ref" -vframes 1 png_ref/"$bn".png
    for ((ql=1;ql<=100;ql++)); do
        dis="jpg/$bn"_jpg_"$ql.jpg"

        convert "png_ref/$bn.png" -quality "$ql"% "$dis"
        dis_2="jpg_mkv/$bn"_jpg_"$ql.mkv"
        ffmpeg -y -r 1 -start_number 0  -i "$dis" \
            -c:v ffvhuff -r 1 -vframes 1 \
            -pix_fmt yuv420p "$dis_2"

        vmaf "$dis_2" "$ref" "jpg"
        rm -rf "$dis_2"
    done
}

echo "encode av1"
mkdir -p av1
av1_encoding

echo "encode h265"
mkdir -p h265
h265_encoding


echo "encode h264"
mkdir -p h264
h264_encoding


echo "encode vp9"
mkdir -p vp9
vp9_encoding

echo "encode jpg"
mkdir -p jpg
jpg_encoding


rm -rf ref/"$bn".mkv

echo "$bn" >> imgs_done
