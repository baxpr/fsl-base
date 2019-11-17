#!/bin/bash
#
# Make useful QA outputs with fsleyes
# https://users.fmrib.ox.ac.uk/~paulmc/fsleyes/userdoc/latest/command_line.html


# Parse inputs
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --project)
        project="$2"
        shift; shift
        ;;
    --subject)
        subject="$2"
        shift; shift
        ;;
    --session)
        session="$2"
        shift; shift
        ;;
    --scan)
        scan="$2"
        shift; shift
        ;;
    --dwi_file)
        dwi_file="$2"
        shift; shift
        ;;
    --bval_file)
        bval_file="$2"
        shift; shift
        ;;
    --bvec_file)
        bvec_file="$2"
        shift; shift
        ;;
    --outdir)
        outdir="$2"
        shift; shift
        ;;
    *)
        shift
        ;;
  esac
done


# 3-pane view
fsleyes render \
  --scene ortho --hideCursor --layout grid \
  --outfile "${outdir}"/ortho.png --size 1000 1000 \
  "${dwi_file}" \
  --interpolation linear


# Convert to PDF
info="dwi_reorder\n${project} ${subject} ${session} ${scan}"
bval=`cut -d " " -f 1-9 "${bval_file}"`
bvec=`cut -d " " -f 1-9 "${bvec_file}"`

convert \
-size 1224x1584 xc:white \
-gravity center \( ortho.png -resize 1000x1000 \) -geometry +0-150 -composite \
-gravity center -pointsize 24 -annotate +0-670 "First volume of output" \
-gravity SouthEast -pointsize 24 -annotate +20+20 "$(date)" \
-gravity NorthWest -pointsize 24 -annotate +20+20 "${info}" \
-gravity SouthWest -pointsize 24 -annotate +20+200 \
"First b values:\n$bval\n\nFirst b vectors:\n$bvec" \
"${outdir}"/dwi_reorder.pdf

# Clean up
rm "${outdir}"/ortho.png
