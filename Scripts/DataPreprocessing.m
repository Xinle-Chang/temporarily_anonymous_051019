% disp('test.');
main()


function main()
disp('MSC resting-state fMRI data Preprocessing...')
ID={'01','02','03','04','05','06','07','08','09','10'};
for i=1:10
    t1img=['../ds000224/sub-MSC' ID{i} '/ses-struct01/anat/sub-MSC' ID{i} '_ses-struct01_run-01_T1w.nii'];
    gunzip([t1img '.gz']);
    for j=1:10
        disp(['>>>>>>> Processing : Sub ' ID{i} '-Ses ' ID{j} ' <<<<<<<'])
        fimg=['../ds000224/derivatives/volume_pipeline/sub-MSC' ID{i} '/processed_restingstate_timecourses/ses-func' ID{j} '/talaraich/sub-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold_talaraich.nii'];
        gunzip([fimg '.gz']);
        %Slice timing, motion correction, and spatial coregistration adn
        %normalization
        matlabbatch=fwra_pro(fimg,t1img);
        spm_jobman('run',matlabbatch);
        %To compute fALFF, bandpass filtering step is not adapted.
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
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {'../Materials/TPM.nii'};
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
