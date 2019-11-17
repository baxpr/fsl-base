#!/bin/bash
make_pdf.sh \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN \
--dwi_file /OUTPUTS/DTI_resort.nii.gz \
--bval_file /OUTPUTS/DTI_resort.bval \
--bvec_file /OUTPUTS/DTI_resort.bvec \
--outdir /OUTPUTS

