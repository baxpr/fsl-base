#!/bin/bash

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
    --dwi_niigz)
        dwi_niigz="$2"
        shift; shift
        ;;
    --bval_txt)
        bval_txt="$2"
        shift; shift
        ;;
    --bvec_txt)
        bvec_txt="$2"
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

echo "$project" "$subject" "$session" "$scan"
echo "$dwi_niigz"
echo "$bval_txt"
echo "$bvec_txt"

# Reorder volumes
resort_b0.py \
	--dwi_niigz "${dwi_niigz}" --bval_txt "${bval_txt}" \
	--bvec_txt "${bvec_txt}" --out_pfx "${outdir}"/DTI_resort

# Generate PDF
make_pdf.sh \
	--project "${project}" --subject "${subject}" \
	--session "${session}" --scan "${scan}" \
	--dwi_file "${outdir}"/DTI_resort.nii.gz \
	--bval_file "${outdir}"/DTI_resort.bval \
	--bvec_file "${outdir}"/DTI_resort.bvec \
	--outdir "${outdir}"

