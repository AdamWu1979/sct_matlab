function data = dicm2nii_multicoil(strpattern, outputfolder)
% data = dicm2nii_multicoil(strpattern, outputfolder)
% EXAMPLE: dicm2nii_multicoil('20160325_mtv_test-CH', 'nii'); 
%               --> coil 1: 20160325_mtv_test-CH1*
%               --> coil 2: 20160325_mtv_test-CH2*
%               --> coil 3: 20160325_mtv_test-CH3*


mkdir(outputfolder)
i=1;

while ~isempty(dir([strpattern num2str(i) '*.dcm']))
    tmp_folder=sct_tempdir;
	dicm2nii([strpattern num2str(i) '*.dcm'],tmp_folder,0)
    file = sct_tools_ls([tmp_folder filesep '*.nii'],1);
    datanii = load_nii_data(file{1});
    if i==1,  data = datanii; else data(:,:,:,:,i) = datanii; end
    sct_unix(['mv ' tmp_folder filesep '*.nii ' outputfolder filesep  sct_tool_remove_extension(file{1},0) '_coil' num2str(i) '.nii']);
    sct_unix(['rm -rf ' tmp_folder]);
    i=i+1;
end
nbcoils = i-1;
%save_nii_v2(data,[outputfolder filesep sct_tool_remove_extension(file{1},0) '.nii.gz'],[outputfolder filesep  sct_tool_remove_extension(file{1},0) '_coil' num2str(nbcoils) '.nii']);
save([outputfolder filesep  sct_tool_remove_extension(file{1},0) '.mat'],'data');