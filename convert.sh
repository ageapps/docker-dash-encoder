#!/bin/bash          

inputpath=$1
inputfile=$(basename "$inputpath")
filename=${inputfile%.*}
outdir="./out/$filename"
QUALITIES=( "360" "480" "720" "1080" )
RATES=( "600" "1000" "3000" "6000" )
LEVELS=( "3.0" "3.1" "4.0" "4.2" )

mp4streams=""

echo "Input File: $inputfile"

for i in "${!QUALITIES[@]}"
do
    quality=${QUALITIES[$i]}
    rate=${RATES[$i]}
    level=${LEVELS[$i]}

    # outdir="./out/${srt_dim}_$filename"
    echo "Creating folder for $filename"
    mkdir -p $outdir
    echo "Enconding $filename into MPEG4 Q:$quality R:$rate L:$level"
    outfile="$outdir/h264_baseline_${quality}p_${rate}.mp4"
    mp4streams+=" $outfile#video" 
    ffmpeg -i $inputpath -c:a copy \
        -vf "scale=-2:$quality" \
        -c:v libx264 -profile:v baseline -level:v $level \
        -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
        -minrate ${rate}k -maxrate ${rate}k -bufsize ${rate}k -b:v ${rate}k \
        -y $outfile
done
    MP4Box -dash 4000 -rap -bs-switching no -profile live -out $outdir/manifest.mpd $mp4streams
