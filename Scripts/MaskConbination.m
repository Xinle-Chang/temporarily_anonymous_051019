main();

function main()
disp('Mask mixing progress.');
WMmaskpath='../Materials/WholeWM.nii';
GMmaskpath='../Materials/WholeGM.nii';
Mixpath='../Materials/templete_segment\WholeWM_GM.nii';
data=MaskMix(WMmaskpath,GMmaskpath);
niifile=make_nii(data);
save_nii(niifile,Mixpath);
end

function [mixed_data]=MaskMix(mask1,mask2)
    data1=load_nii(mask1).img;
    data2=load_nii(mask2).img;
    mixed_data=zeros(size(data1,1),size(data1,2),size(data1,3));
    ind=data1>0 | data2>0;
    mixed_data(ind)=1;
end