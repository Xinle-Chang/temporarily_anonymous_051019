main();


function main()
disp('fALFF similarity matrix and idiff.');
Global_SimiMat();
Regional_SimiMat();
end


%-----------------------------------------Global Analysis---------------------------------------------------------------------------------

function Global_SimiMat()
    %Global similarity matrix construction
    %Parameters series-1,resting-state data.
    wm_mask_path='../Materials/WholeWM.nii';
    gm_mask_path='../Materials/WholeGM.nii';
    wm_gm_mask_path='../Materials/WholeWM_GM.nii';
    prefix='fALFF-WMGM-08HZ';
    
    simimat=SimiMat_maskvoxels(wm_mask_path,prefix);
    save('../Experimental_Results/TPM_WM_08HZ','simimat');
    
    simimat=SimiMat_maskvoxels(gm_mask_path,prefix);
    save('../Experimental_Results/TPM_GM_08HZ','simimat');
    
    simimat=SimiMat_maskvoxels(wm_gm_mask_path,prefix);
    save('../Experimental_Results/TPM_WMandGM_08HZ','simimat');
end

function [simimat]=SimiMat_maskvoxels(mask_path,prefix)
    ID={'01','02','03','04','05','06','07','08','09','10'};
    mask=load_nii(mask_path).img;
    [x,y,z]=ind2sub(size(mask),find(mask>0));
    voxnum=size(x,1);
    fALFF_arr=zeros(100,voxnum);
    cnt=1;
    tic
    for i=1:10
        for j=1:10
            fALFF_sub=zeros(1,voxnum);
            falff_image_path=['../ds000224/derivatives/volume_pipeline/sub-MSC' ID{i} '/processed_restingstate_timecourses/ses-func' ID{j} '/talaraich/' prefix '-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
            if exist(falff_image_path,'file')==2 %Check the existence of fALFF image file.
                fALFF_coor=load_nii(falff_image_path).img;
                for k=1:voxnum
                    fALFF_sub(k)=fALFF_coor(x(k),y(k),z(k));
                end
                fALFF_arr(cnt,:)=fALFF_sub;
            end
            cnt=cnt+1;
        end
    end
    disp('fALFF data loaded successfully.');
    toc
    simimat=zeros(100,100);
    cnt=0;
    for i=1:100
        simimat(i,i)=1;
        for j=i+1:100
            arr1=fALFF_arr(i,:);
            idx1=~isnan(arr1);
            arr1(isnan(arr1))=mean(arr1(idx1));
            arr2=fALFF_arr(j,:);
            idx2=~isnan(arr2);
            arr2(isnan(arr2))=mean(arr2(idx2));
            simimat(i,j)=corr2(arr1,arr2);
            simimat(j,i)=simimat(i,j);
            cnt=cnt+1;
            disp(['>>>>>>> ' num2str(cnt) '/4950 finished <<<<<<<']);
        end
    end
end



% ------------------------------------ROI_Analysis---------------------------------------
function Regional_SimiMat()
    %rsfmri-ICBM
    atlas_path='../Materials/rICBM_WMPM.nii';
    prefix='fALFF-ICBM-08HZ';
    save_folder='../Experimental_Results/ICBM_DTI_81_ROIS';
    roi_num=50;
    SimiMat_roiprogress_parameters(atlas_path,prefix,save_folder,roi_num);
end

function SimiMat_roiprogress_parameters(atlas_path,prefix,save_folder,roi_num)
    for i=1:roi_num
        simimat=SimiMat_atlasrois(atlas_path,prefix,i);
        save([save_folder '\ROI_' num2str(i) '.mat'],'simimat');
        disp(['>>>>>>> ROI ' num2str(i) ' finished <<<<<<<']);
    end
end

function [simimat]=SimiMat_atlasrois(atlas_path,prefix,roinum)
ID={'01','02','03','04','05','06','07','08','09','10'};
    atlas=load_nii(atlas_path).img;
    [x,y,z]=ind2sub(size(atlas),find(atlas==roinum));
    voxnum=size(x,1);
    fALFF_arr=zeros(100,voxnum);
    cnt=1;
    tic
    for i=1:10
        for j=1:10
            fALFF_sub=zeros(1,voxnum);
            falff_image_path=['../ds000224/derivatives/volume_pipeline/sub-MSC' ID{i} '/processed_restingstate_timecourses/ses-func' ID{j} '/talaraich/' prefix '-MSC' ID{i} '_ses-func' ID{j} '_task-rest_bold.nii'];
            if exist(falff_image_path,'file')==2
                fALFF_coor=load_nii(falff_image_path).img;
                for k=1:voxnum
                    fALFF_sub(k)=fALFF_coor(x(k),y(k),z(k));
                end
                fALFF_arr(cnt,:)=fALFF_sub;
%             else
%                 disp(falff_image_path);
            end
            cnt=cnt+1;
        end
    end
    disp('fALFF data loaded successfully.');
    toc
    simimat=zeros(100,100);
    cnt=0;
    for i=1:100
        simimat(i,i)=1;
        for j=i+1:100
            arr1=fALFF_arr(i,:);
            idx1=~isnan(arr1);
            arr1(isnan(arr1))=mean(arr1(idx1));
            arr2=fALFF_arr(j,:);
            idx2=~isnan(arr2);
            arr2(isnan(arr2))=mean(arr2(idx2));
            simimat(i,j)=corr2(arr1,arr2);
            simimat(j,i)=simimat(i,j);
            cnt=cnt+1;
%             disp(['>>>>>>> ' num2str(cnt) '/4950 finished <<<<<<<']);
        end
    end
end

