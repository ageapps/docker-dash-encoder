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
outdir="/media/out/_$filename"

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

    # outdir="./out/${srt_dim}_$filename"
    echo "Creating folder for $filename"
    mkdir -p $outdir
    echo "Enconding $filename into MPEG4 Q:$quality R:$rate L:$level"
    outfile="$outdir/h264_baseline_${quality}p_${rate}.mp4"
    mp4streams+=" $outfile#video:id=h264_${quality}" 
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
    MP4Box -dash 4000 -rap -bs-switching no -profile live -out $outdir/manifest.mpd "$outdir/h264_baseline_${QUALITIES[0]}p_${RATES[0]}.mp4#audio" $mp4streams



