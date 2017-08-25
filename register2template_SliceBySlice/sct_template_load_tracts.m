function Tract = sct_template_load_tracts(TractIndex,atlasFolder)
% Tract = sct_template_load_tracts(TractIndex,atlasFolder)
% Example:
%     CSF = 31;
%     TractIndex=CSF;
%     atlasFolder = [sct_dir '/data/atlas'];
%     Tract = sct_template_load_tracts(TractIndex,atlasFolder);
%     imagesc(sum(Tract(:,:,1,:),4))

for it=1:length(TractIndex)
    numT=j_numbering(1,2,TractIndex(it));
    Tract(:,:,:,it)=load_nii_data([atlasFolder '/WMtract__' num2str(numT{1}) '.nii.gz']);
end
