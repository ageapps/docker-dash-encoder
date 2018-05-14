#!/bin/bash          

inputpath=$1
inputfile=$(basename "$inputpath")
filename=${inputfile%.*}
outdir="./out/$filename"
QUALITIES=( "1920:1080" "1280:720" "640:360" )

echo "Input File: $inputfile"

printf "%s\n" "${QUALITIES[@]}"

for i in "${QUALITIES[@]}"
do
    quality=$i
    dimensions=(${quality//:/ })
    srt_dim=${dimensions[0]}x${dimensions[1]}
    outdir="./out/${srt_dim}_$filename"
    echo "Creating folder for $filename"
    mkdir -p $outdir
    echo "Enconding $filename into MPEG4 $srt_dim"
    ffmpeg -i $inputpath -f mp4 -vf scale=$i -vcodec libx264 -preset veryfast -profile:v main -acodec aac $outdir/$filename.mp4 -hide_banner
    echo "Creating segments from $outpath.mp4"
    MP4Box -dash 4000 -frag 4000 -rap -segment-name segment_ $outdir/$filename.mp4 -out $outdir/$filename.mpd
done
