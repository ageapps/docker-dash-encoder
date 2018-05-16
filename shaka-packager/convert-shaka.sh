#!/bin/bash          

inputpath=""
option=""
if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi
if [ $# -eq 2 ]
  then
    option=$1
    inputpath=$2
  else
    inputpath=$1
fi
inputfile=$(basename "$inputpath")
filename=${inputfile%.*}
outdir="/media/out/$filename"

# QUALITIES=( "240" "360" "480" "720" "1080")
# RATES=( "240" "600" "1000" "3000" "6000")
# LEVELS=( "3.0" "3.0" "3.1" "4.0" "4.1")
QUALITIES=( "120" "240" "360" "480" )
RATES=( "100" "240" "600" "1000" )
LEVELS=( "3.0" "3.0" "3.0" "3.1" )

mp4streams=""

echo "Input File: $inputfile"

for i in "${!QUALITIES[@]}"
do
    quality=${QUALITIES[$i]}
    rate=${RATES[$i]}
    level=${LEVELS[$i]}

    echo "Creating folder for $filename"
    mkdir -p $outdir
    echo "Enconding $filename into MPEG4 Q:$quality R:$rate L:$level"
    outfile="$outdir/h264_baseline_${quality}p_${rate}.mp4"
    mp4streams+=" in=h264_baseline_${quality}p_${rate}.mp4,stream=video,init_segment=h264_${quality}p/init.mp4,segment_template=h264_${quality}p/\$Number\$.m4s"
    if [ -z "$option" ]
      then 
        ffmpeg -i $inputpath -c:a copy \
            -vf "scale=-2:$quality" \
            -c:v libx264 -profile:v baseline -level:v $level \
            -x264opts scenecut=0:open_gop=0:min-keyint=72:keyint=72 \
            -minrate ${rate}k -maxrate ${rate}k -bufsize ${rate}k -b:v ${rate}k \
            -y $outfile
    fi
done

    audioInput="in=h264_baseline_${QUALITIES[0]}p_${RATES[0]}.mp4,stream=audio,init_segment=audio/init.mp4,segment_template=audio/\$Number\$.m4s"
    cd $outdir
    packager \
        ${audioInput} \
        ${mp4streams} \
        --generate_static_mpd --mpd_output h264.mpd
