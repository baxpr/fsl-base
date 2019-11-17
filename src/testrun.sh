#!/bin/sh
xvfb_wrapper.sh \
	--project TESTPROJ \
	--subject TESTSUBJ \
	--session TESTSESS \
	--scan TESTSCAN \
	--dwi_niigz ../INPUTS/DTI.nii.gz \
	--bval_txt ../INPUTS/DTI.bval \
	--bvec_txt ../INPUTS/DTI.bvec \
	--outdir ../OUTPUTS
