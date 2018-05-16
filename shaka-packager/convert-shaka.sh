#!/bin/bash          

inputpath=$1
inputfile=$(basename "$inputpath")
filename=${inputfile%.*}
outdir="/media/out/$filename"
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
    cd $outdir
    packager \
        'in=h264_baseline_360p_600.mp4,stream=audio,init_segment=audio/init.mp4,segment_template=audio/$Number$.m4s' \
        'in=h264_baseline_360p_600.mp4,stream=video,init_segment=h264_360p/init.mp4,segment_template=h264_360p/$Number$.m4s' \
        'in=h264_baseline_480p_1000.mp4,stream=video,init_segment=h264_480p/init.mp4,segment_template=h264_480p/$Number$.m4s' \
        'in=h264_baseline_720p_3000.mp4,stream=video,init_segment=h264_720p/init.mp4,segment_template=h264_720p/$Number$.m4s' \
        'in=h264_baseline_1080p_6000.mp4,stream=video,init_segment=h264_1080p/init.mp4,segment_template=h264_1080p/$Number$.m4s' \
        --generate_static_mpd --mpd_output h264.mpd
