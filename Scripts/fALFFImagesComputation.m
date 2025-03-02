main();
% main_task();


function main()
disp('FALFF process with coordinate information.');

%paremeters set 1,compute fALFF of all voxels in WM and GM to make it convenient to analyze them separately.
mask_path='../Materials/WholeWM_GM.nii';
prefix='fALFF-WMGM-08HZ';

MSC_RS_fALFF(mask_path,prefix);
end



function MSC_RS_fALFF(mask_path,prefix)
% Compute fALFF images of MSC resting-state fMRI data.
ID={'01','02','03','04','05','06','07','08','09','10'};
[cx,cy,cz]=mask2coordinate(mask_path);
    for i=1:10
        for j=1:10
            fmri_path=['../ds000224/derivatives/volume_pipeline/sub-MSC' ID{i} '/processed_restingstate_timecourses/ses-func' ID{j} '/talaraich/wrasub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold_talaraich.nii'];
            falff_image_path=['../ds000224/derivatives/volume_pipeline/sub-MSC' ID{i} '/processed_restingstate_timecourses/ses-func' ID{j} '/talaraich/' prefix '-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
            data_3d=fALFF_compute_3d(fmri_path,cx,cy,cz);
            niifile=make_nii(data_3d);
            save_nii(niifile,falff_image_path);
            disp(['>>>>>>> ' num2str((i-1)*10+j) '/100 finished <<<<<<<']);
        end
    end
end



function [x,y,z]=mask2coordinate(mask)
    % Get the coordinates of voxels tagged in mask.  
    % mask: nii file of mask.
    mask=load_nii(whitemask).img;
    [x,y,z]=ind2sub(size(mask),find(mask>0));
end


function [data_3d] = fALFF_compute_3d(fmri_path,x,y,z)
    % The concrete process of computiong a fALFF image.
    % fmri_path: path of fMRI data.
    % [x y z]: voxels' coordinates in 3 dimensions.
    disp('Loading nifti file...');
    tic
    fmri_data=load_nii(fmri_path).img;
    toc
    TR=2.2;f0=0.01;fc=0.08;%TR settings and low frequency range.
%     TR=2.2;f0=0.01;fc=0.15;
    voxnum=size(x,1);
    dims=size(fmri_data);
    data_3d=zeros(dims(1),dims(2),dims(3));
    disp('Computing fALFF...');
    tic
    for i=1:voxnum
        timeseries=squeeze(fmri_data(x(i),y(i),z(i),:));
        timeseries=timeseries(~isnan(timeseries));%Remove NaN.
        [falff_amp] = get_falff_amp_only(timeseries,TR,f0,fc);
        data_3d(x(i),y(i),z(i))=falff_amp;
    end
    toc
end


