disp('test.');
% main()
% main_task('glasslexical_run-01');
% main_task('glasslexical_run-02');
% main_task('memoryfaces');
% main_task('memoryscenes');
% main_task('memorywords');



function main()
disp('Preprocessing...')
ID={'01','02','03','04','05','06','07','08','09','10'};
for i=1:10
    t1img=['../raw_T1_image/sub-MSC' ID{i} '/ses-struct01/sub-MSC' ID{i} '_ses-struct01_run-01_T1w.nii'];
    for j=1:10
        disp(['>>>>>>> Processing : Sub ' ID{i} '-Ses ' ID{j} ' <<<<<<<'])
        fimg=['../raw_restingstate_timecourses/sub-MSC' ID{i} '/ses-func' ID{j} '/sub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
        matlabbatch=fwra_pro(fimg,t1img);
        spm_jobman('run',matlabbatch);
%         mnipath=['../raw_restingstate_timecourses/sub-MSC' ID{i} '/ses-func' ID{j} '/wrasub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
%         savepath=['../raw_restingstate_timecourses/sub-MSC' ID{i} '/ses-func' ID{j} '/fwrasub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
%         filtering_batch(mnipath,savepath)
%         disp(fimg)
    end
end
end


function main_task(tasktype)
disp('Preprocessing...')
ID={'01','02','03','04','05','06','07','08','09','10'};
for i=1:10
    t1img=['../raw_T1_image/sub-MSC' ID{i} '/ses-struct01/sub-MSC' ID{i} '_ses-struct01_run-01_T1w.nii'];
    for j=1:10
        disp(['>>>>>>> Processing : ' tasktype ' Sub ' ID{i} '-Ses ' ID{j} ' <<<<<<<'])
        fimg=['../Task_image_copy/' tasktype '/sub-MSC' ID{i} '/ses-func' ID{j} '/sub-MSC' ID{i} '_ses-func' ID{j} '_task-' tasktype '_bold.nii'];
        if exist(fimg,'file')==2
            matlabbatch=fwra_pro(fimg,t1img);
            spm_jobman('run',matlabbatch);
        else
            disp(['No such file:' fimg])
        end
%         mnipath=['../raw_restingstate_timecourses/sub-MSC' ID{i} '/ses-func' ID{j} '/wrasub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
%         savepath=['../raw_restingstate_timecourses/sub-MSC' ID{i} '/ses-func' ID{j} '/fwrasub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
%         filtering_batch(mnipath,savepath)
%         disp(fimg)
    end
end
end


function matlabbatch=fwra_pro(fimg,t1img)
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw_data';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                     {fimg}
                                                                     {t1img}
                                                                     }';
matlabbatch{2}.spm.temporal.st.scans{1}(1) = cfg_dep('Named File Selector: raw_data(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.spm.temporal.st.nslices = 36;
matlabbatch{2}.spm.temporal.st.tr = 2.2;
matlabbatch{2}.spm.temporal.st.ta = 2.2-2.2/36;
matlabbatch{2}.spm.temporal.st.so = [1.105 0 1.165 0.06 1.2275 0.1225 1.2875 0.185 1.35 0.245 1.41 0.3075 1.4725 0.3675 1.5325 0.43 1.595 0.49 1.655 0.5525 1.7175 0.6125 1.78 0.675 1.84 0.735 1.9025 0.7975 1.9625 0.8575 2.025 0.92 2.085 0.9825 2.1475 1.0425];
matlabbatch{2}.spm.temporal.st.refslice = 0.49;
matlabbatch{2}.spm.temporal.st.prefix = 'a';
matlabbatch{3}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{3}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{3}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{3}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{3}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{4}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Named File Selector: raw_data(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
matlabbatch{4}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{4}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.vol(1) = cfg_dep('Named File Selector: raw_data(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {'D:\matlab2020\toolbox\spm12\tpm\TPM.nii'};
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.bb = [-90 -126 -72
                                                             90 90 108];
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
end

function filtering_batch(mni_path, savepath)
    % Filter to extract signals of 0.01-0.08Hz.
    func_matrix = spm_read_vols(spm_vol(mni_path)); %Read 4D fMRI data by spm.
 
    % filtering parameters
    TR = 2.2;
    T = 818;
    low_pass_f = 0.01;
    high_pass_f = 0.08;
    if rem(T, 2) == 1
        X = func_matrix(:,:,:,2:T); % throw the first frame
        L = T - 1;
    else
        X = func_matrix;
        L= T;
    end
    disp('1');
    % filtering
    tic
    filtered_X = filtering_4D_MRI(X, TR, L, low_pass_f, high_pass_f);
    toc
    
%     % test - drawing
%     voxel = squeeze(X(35,35,35,:));
%     voxel_1 = squeeze(filtered_X(35,35,35,:));
%     x=1:size(voxel_1,1);
%     figure(1)
%     plot(x, voxel)
%     figure(2)
%     plot(x, voxel_1)

    % Saving the images using DPABI's y_Write function
    % func_image_1 = './processed_restingstate_timecourses/sub-MSC01/ses-func01/mni_sub-MSC01_ses-func01_task-rest_bold_talaraich.nii';
    y_Write(filtered_X, spm_vol([mni_path ',1']), fullfile(savepath));
end


function filtered_X = filtering_4D_MRI(X, TR, L, low_pass_f, high_pass_f)
    % Input:
    % 	X            -   4D data matrix - [dx, dy, dz, L]
    % 	TR           -   Sample period, E.g., TRTR - float
    %   L            -   Sample points - int
    %   low_pass_f   -   low pass filtering frequency - float
    %   high_pass_f  -   high pass filtering frequency - float
    % Output:
    %	filtered_X   -   The data after filtering - [dx, dy, dz, L]
    %-----------------------------------------------------------
    % Written by Yueran Li in May 9, 2023.

    dx = size(X,1); dy = size(X,2); dz = size(X,3);
    
    frequency = 1/TR * (0:L/2)/L;
    idx = find(frequency >= low_pass_f & frequency <= high_pass_f);

    Y = fft(X, [], 4);
    filtered_Y = complex(zeros(dx,dy,dz,L), zeros(dx,dy,dz,L));
    filtered_Y(:,:,:,idx) = Y(:,:,:,idx);

    filtered_X = ifft(filtered_Y, [], 4);
    filtered_X = real(filtered_X);

end