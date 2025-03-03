# MICCAI-2025-anonymous submission paper code
This is an anonymous code repository for our paper submission in MICCAI 2025.
## Requirements
This project is mainly is mainly implemented through MATLAB2020A, and the versions you are using should be compatible with it. Except basic MATLAB environment, 2 packages need installing into MATLAB toolbox:

[SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/): Statistical Parametric Mapping refers to the construction and assessment of spatially extended statistical processes used to test hypotheses about functional imaging data.

[NIfTI](https://ww2.mathworks.cn/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image): Load, save, make, reslice, view (and edit) both NIfTI and ANALYZE data on any platform.


## Running
All the direct experimental results shown in our paper can be obtained by running the MATLAB Live Script ExperimentalResults.mlx step by step.

Otherwise, if you want to run the data preprocessing , fALFF computation and fALFF Similarity Construction, you have to download the [MSC dataset](https://openneuro.org/datasets/ds000224/versions/1.0.4) as ds000224 and put it in main directory of the project firstly. Then you can run the Scripts/DataPreprocessing.m, Scripts/fALFFImagesComputation.m and Scripts/fALFFSimilarityMatrixConstruction.m in order.


## Organization
```
│  ExperimentalResults.mlx
│  README.md
│
├─ds000224
├─Experimental_Results
│  │  FC_ICBM_WM_08HZ.mat
│  │  LabelLookupTable.txt
│  │  TPM_GM_08HZ.mat
│  │  TPM_WMandGM_08HZ.mat
│  │  TPM_WM_08HZ.mat
│  │
│  └─ICBM_DTI_81_ROIS
│          idiff_arr.mat
│
├─Materials
│      rICBM_WMPM.nii
│      TPM.nii
│      WholeGM.nii
│      WholeWM.nii
│      WholeWM_GM.nii
│
├─Scripts
│      DataPreprocessing.m
│      fALFFImagesComputation.m
│      fALFFSimilarityMatrixConstruction.m
│      get_falff_amp_only.m
│      Idiff_cal_undigonal.m
│      MaskConbination.m
│
└─WM_Relative_Distances
        ICBM__relative_1_depth.mat
        ICBM__relative_2_depth.mat
                ......
        ICBM__relative_50_depth.mat
```
