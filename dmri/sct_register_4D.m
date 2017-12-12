function sct_register_4D(data1,data2)
% sct_register_4D(data14D,data24D)

[data1_basename,~,ext]=sct_tool_remove_extension(data1,1);

tmp_folder=sct_tempdir;

sct_gunzip(data1,tmp_folder, 'data_1.nii');
sct_gunzip(data2,tmp_folder, 'data_2.nii');

cd(tmp_folder)
sct_unix('fslmaths data_1.nii -Tmean data_1_1')
sct_unix('fslmaths data_2.nii -Tmean data_2_1')
% sct_dmri_splitin2('data_1',1,1);
% sct_dmri_splitin2('data_2',1,1);


if size(load_nii_data('data_1_1.nii.gz'),3)<2
    cmd=(['sct_register_multimodal -i data_2_1.nii.gz -d data_1_1.nii.gz -param step=1,type=im,algo=translation']);
else
    cmd=(['sct_register_multimodal -i data_2_1.nii.gz -d data_1_1.nii.gz -param step=1,type=im,algo=slicereg']);
end
sct_unix(cmd)

% 
% cmd=(['sct_apply_transfo -i data_1.nii -d data_2_1.nii.gz -w warp_data_1_12data_2_1.nii.gz -o data_1_reg.nii']);
% sct_unix(cmd)


files = sct_splitTandrename('data_1.nii');
for ifile = 1:length(files)
cmd=(['sct_apply_transfo -i ' files{ifile} ' -d data_2_1.nii.gz -w ' pwd filesep 'warp_data_1_12data_2_1.nii.gz -o ' sct_tool_remove_extension(files{ifile},0) '_reg' ext]);
sct_unix(cmd)
end
cd ../

sct_merge_nii(cellfun(@(xx) fullfile(tmp_folder,strrep(xx,'.nii.gz','_reg.nii.gz')),files,'UniformOutput',false),[data1_basename '_reg' ext])

unix(['rm -rf ' tmp_folder]);


