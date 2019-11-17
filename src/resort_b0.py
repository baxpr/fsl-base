#!/usr/bin/python3
#
# Move b=0 frames to the beginning of a DWI NIFTI/BVAL/BVEC set to permit topup in dtiQA_v6

import argparse
import nibabel
import pandas

parser = argparse.ArgumentParser('resort_b0.py')
parser.add_argument('--dwi_niigz',required=True,
                    help='Filename of .nii.gz with DWI images')
parser.add_argument('--bval_txt',required=True,
                    help='Text file of b values')
parser.add_argument('--bvec_txt',required=True,
                    help='Text file of b vectors')
parser.add_argument('--out_pfx',required=True,
                    help='Prefix for output .nii.gz, .bval, .bvec files. Can include path')
args = parser.parse_args()
dwi_niigz = args.dwi_niigz
bval_txt = args.bval_txt
bvec_txt = args.bvec_txt
out_pfx = args.out_pfx

dwi_outfile = out_pfx + '.nii.gz'
bval_outfile = out_pfx + '.bval'
bvec_outfile = out_pfx + '.bvec'

dwi_img = nibabel.load(dwi_niigz)
dwi_data = dwi_img.get_fdata()
bval_data = pandas.read_csv(bval_txt,header=None,delim_whitespace=True).T
bvec_data = pandas.read_csv(bvec_txt,header=None,delim_whitespace=True).T

# To move just one frame to the beginning:
#idx_first_zero = bval_data[0][bval_data[0]==0].index[0]
#idx_others = bval_data[0].index.tolist()
#idx_others.remove(idx_first_zero)

# Move all b=0 frames to the beginning:
idx_zeroes = bval_data[0][bval_data[0]==0].index
idx_others = bval_data[0].index.difference(idx_zeroes)


# Re-sort and write bval/bvec to file
# I don't understand why different ways of indexing are needed here:
#      bval_data.T[idx_out]
#      bvec_data.T.iloc[:,idx_out]
idx_out = idx_zeroes.append(idx_others)
bval_data.T[idx_out].to_csv(bval_outfile,sep=' ',header=False,index=False,
                            float_format='%0.1f')
bvec_data.T.iloc[:,idx_out].to_csv(bvec_outfile,sep=' ',header=False,index=False,
                                   float_format='%0.6f')

resort_img = nibabel.Nifti1Image(dwi_data[:,:,:,idx_out],dwi_img.affine,dwi_img.header)
nibabel.save(resort_img,dwi_outfile)

